
USE iERP_DRA_TEST
go

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--							VARIABLES				
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */

DECLARE @fechaTrabajo AS DATE = '20220131' -- CURRENT_TIMESTAMP;
DECLARE @fechaInicioMes AS DATE = DATEADD(dd,-(DAY(@fechaTrabajo)-1),@fechaTrabajo)
DECLARE @IdPeriodo AS INT
SELECT @IdPeriodo=IdPeriodo FROM dbo.tCTLperiodos p WHERE p.EsAjuste=0 AND  @fechaTrabajo BETWEEN p.Inicio AND p.Fin
PRINT @IdPeriodo

DECLARE @idSocio AS INT = 16888;
DECLARE @idPersona AS INT = 0 
SET @idPersona = (SELECT sc.idpersona FROM tscssocios sc  WITH(NOLOCK) WHERE sc.idsocio=@idSocio)

DECLARE @socios AS TABLE(
	IdSocio				INT,
	IdPersona			INT,
	Edad				INT,
	IdPersonaFisica		INT,
	ExentaIVA			BIT,
	IdPersonaMoral		INT,
	EsSocioValido		BIT,
	Genero				CHAR(1),
	IdEstadoNacimiento	INT,
	IdRelDomicilios		INT,
	IdSucursal			INT,
	IdListaDOcupacion	INT,
	EsMenor				BIT null,
	EsMayor				BIT null,
	EsMoral				BIT null
)

/* Tabla intermedia para determinar si hay resultados y en caso contrario generar un defuault*/

DECLARE @calificaciones AS TABLE(
	IdPersona INT NOT NULL,
	IdSocio INT NOT NULL,
	IdFactor INT NOT NULL,
	Factor VARCHAR(64) NOT NULL,
	Elemento VARCHAR(128) NOT NULL,
	Valor VARCHAR(10) NOT NULL,
	ValorDescripcion VARCHAR(256) NULL,
	Puntos INT DEFAULT 0
)

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- LLENADO DE SOCIOS
--SELECT sc.IdSocio,	p.IdPersona,	--Edad,
--IIF(pf.IdPersonaFisica IS NOT NULL, DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo),IIF(pm.IdPersonaMoral IS NOT NULL,DATEPART(YEAR,pm.FechaConstitucion,@fechaTrabajo),0)) AS Edad,
--pf.IdPersonaFisica,	sc.ExentaIVA,	pm.IdPersonaMoral,	sc.EsSocioValido,	pf.Sexo,	pf.IdEstadoNacimiento,	p.IdRelDomicilios,	sc.IdSucursal,	pf.IdListaDOcupacion
----EsMenor,	EsMayor,	EsMoral 
--FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
--INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
--LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
--LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
--WHERE sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--							EVALUACIONES				
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */


/*  |-------------------------------------------------------------|
							SOCIO
	|-------------------------------------------------------------|*/

/* SOCIO - EDAD */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,Puntos)
SELECT sc.idpersona, sc.IdSocio,1,'Socio','Edad', sc.Edad, sc.puntos FROM dbo.fnPLDmatrizEvaluacionEdades(@fechaTrabajo,@idSocio) sc
--SELECT sc.idpersona, sc.IdSocio,1,'Socio','Edad', sc.Edad, cfg.puntos FROM @socios sc	
INNER JOIN dbo.tPLDmatrizConfiguracionEdades cfg ON cfg.Edad = sc.Edad

/* SOCIO - TIPO PERSONA */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,Puntos)
			SELECT socios.IdPersona, socios.IdSocio,1, socios.Factor,socios.Elemento,tp.tipopersona, tp.puntos
			FROM(
					SELECT p.IdPersona, sc.IdSocio, 'Socio' AS Factor,'TipoPersona' AS Elemento,
							CASE 
							WHEN NOT pf.IdPersonaFisica IS NULL AND sc.ExentaIVA=0 THEN 1
							WHEN NOT pf.IdPersonaFisica IS NULL AND sc.ExentaIVA=1 THEN 2 -- PF ACT EMP
							WHEN NOT pm.IdPersonaMoral IS NULL THEN 3
							ELSE 0
							END AS Tipo
					FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
					INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
					LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
					LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
					WHERE sc.IdEstatus=1 AND sc.EsSocioValido=1
					AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))
			) socios
			INNER JOIN tPLDmatrizConfiguracionTipoPersona tp ON tp.TipoPersona	= socios.Tipo

/* SOCIO - GÉNERO */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,Puntos)			
SELECT pf.IdPersona, sc.IdSocio,1,'Socio','Género', g.genero, g.puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionGenero g ON g.genero = pf.Sexo
WHERE sc.IdEstatus=1 AND sc.EsSocioValido=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/*  |-------------------------------------------------------------|
							GEOGRAFÍA
	|-------------------------------------------------------------|*/

/* GEOGRAFÍA - ENTIDAD DE NACIMIENTO */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,2,'Geografía','Entidad Nacimiento',mc.IdUbicacion,mc.Descripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=4 AND mc.IdUbicacion=p.IdEstadoNacimiento
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* GEOGRAFÍA - MUNICIPIO DE RESIDENCIA */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,2,'Geografía','Municipio Residencia',mc.IdUbicacion,mc.Descripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdRel=p.IdRelDomicilios AND dom.IdTipoD=11
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK)  ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdUbicacion=dom.IdMunicipio
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* GEOGRAFÍA - MUNICIPIO SUCURSAL */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,2,'Geografía','Municipio Sucursal',mc.IdUbicacion,mc.Descripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = sc.IdSucursal
INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdTipoD=11 AND dom.IdDomicilio= suc.IdDomicilio
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK)  ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdUbicacion=dom.IdMunicipio
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/*  |-------------------------------------------------------------|
							LISTAS Y TERCEROS
	|-------------------------------------------------------------|*/

/* LISTAS Y TERCEROS - PROPIETARIO REAL */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,3,'Listas y Terceros','Propietario Real',mc.IdValor,mc.ValorDescripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=1 AND mc.IdValor=t.EsPropietarioReal
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

IF (@@ROWCOUNT=0)
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT 0,@idSocio,3,'Listas y Terceros','Propietario Real',0,'',0



/* LISTAS Y TERCEROS - PROVEEDOR DE RECURSOS */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,3,'Listas y Terceros','Proveedor de Recursos',mc.IdValor,mc.ValorDescripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=2 AND mc.IdValor=t.EsProveedorRecursos
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* LISTAS Y TERCEROS - PEP */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,3,'Listas y Terceros','PEP',mc.IdValor,mc.ValorDescripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tPLDppe pep  WITH(NOLOCK) ON pep.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdValor=pep.IdEstatus
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* LISTAS Y TERCEROS - LISTA BLOQUEADA */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,3,'Listas y Terceros','Lista Bloqueada',mc.IdValor,mc.ValorDescripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=6 AND mc.IdValor=sc.BloqueadoSistema
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))


/*  |-------------------------------------------------------------|
							INGRESOS
	|-------------------------------------------------------------|*/

/* INGRESOS - SUELDO RANGO PF */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT 
sc.IdPersona,sc.IdSocio,4,'Ingresos','Rango Ingresos PF',ie.Sueldo,CONCAT(mc.ValorDescripcion,': ',mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) ON ac.IdPersona = sc.IdPersona
INNER JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=2 AND ie.Sueldo BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* INGRESOS - SUELDO RANGO PM */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,4,'Ingresos','Rango Ingresos PM',(ie.UtilidadNegocio + ie.VentasComercializacion),CONCAT(mc.ValorDescripcion,': ',mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = sc.IdPersona AND pm.IdPersona<>0
INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) ON ac.IdPersona = sc.IdPersona
INNER JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=3 AND (ie.UtilidadNegocio + ie.VentasComercializacion) BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/* INGRESOS - OCUPACION */
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,4,'Ingresos','Ocupación',mc.IdValor1 ,mc.ValorDescripcion,mc.Puntos
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=1 AND pf.IdListaDOcupacion=mc.IdValor1
WHERE sc.IdSocio<>0 and sc.IdEstatus=1
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/*  |-------------------------------------------------------------|
							TRANSACCIONALIDAD
	|-------------------------------------------------------------|*/

-- Tabla para Socios

-- TABLA DE SOCIOS PARA IDENTIFICAR MENORES, MAYORES Y MORALES
DECLARE @socios2 TABLE(
	IdPersona INT NOT NULL,
	IdSocio INT NOT NULL,
	EsMenor BIT null,
	EsMayor BIT null,
	EsMoral BIT null
)

INSERT INTO @socios (IdPersona,IdSocio,EsMenor,EsMayor,EsMoral)
SELECT pf.IdPersona, sc.IdSocio, 1, 0,0
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona AND DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo)<18
WHERE sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

INSERT INTO @socios (IdPersona,IdSocio,EsMenor,EsMayor,EsMoral)
SELECT pf.IdPersona, sc.IdSocio, 0, 1,0
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona AND DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo)>=18
WHERE sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

INSERT INTO @socios (IdPersona,IdSocio,EsMenor,EsMayor,EsMoral)
SELECT pf.IdPersona, sc.IdSocio, 0, 0,1
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasMorales pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
WHERE sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

-- TABLA DE CUENTAS ACTIVAS, SE USARA PARA BUSCAR SU MOVIMIENTOS EN FINANCIERAS Y DESPUES ENLAZAR CON LOS TIPOS DE SOCIOS
DECLARE @cuentas TABLE(
	IdCuenta INT NOT NULL,
	IdSocio INT NOT NULL,
	IdProducto INT NOT NULL,
	IdTipoDproducto INT NOT NULL,
	Producto VARCHAR(128) NOT NULL,
	NoCuenta VARCHAR(32) NOT NULL
)

INSERT INTO @cuentas (IdCuenta,IdSocio,IdProducto,IdTipoDproducto,Producto,NoCuenta)
SELECT c.IdCuenta, c.IdSocio, c.IdProductoFinanciero, c.IdTipoDProducto, pf.Descripcion , c.Codigo
from dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
WHERE c.IdEstatus=1 AND ((@idSocio=0) OR (C.IdSocio= @idSocio))

-- TABLA DE FINANCIERAS
DECLARE @financieras TABLE(
	IdTransaccionFinanciera INT NOT NULL,
	IdOperacion INT NOT NULL,
	IdTipoSubOperacion INT NOT NULL,
	Fecha DATE NOT NULL,
	MontoSubOperacion NUMERIC(11,2) NOT NULL DEFAULT 0,
	IdSaldoDestino INT NOT NULL,
	IdCuenta INT NOT NULL
)

INSERT @financieras
(IdTransaccionFinanciera,IdOperacion,IdTipoSubOperacion,Fecha,MontoSubOperacion,IdSaldoDestino,IdCuenta)
SELECT tf.IdTransaccion,tf.IdOperacion,tf.IdTipoSubOperacion,tf.Fecha,tf.MontoSubOperacion,tf.IdSaldoDestino,c.IdCuenta
from @cuentas c 
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta = c.IdCuenta AND tf.IdEstatus=1 
AND tf.IdOperacion<>0 AND tf.IdTipoSubOperacion IN (500,501) AND tf.Fecha BETWEEN @fechaInicioMes AND @fechaTrabajo


--  TRANSACCIONES D
DECLARE @transaccionesD TABLE(
	IdTransaccionD INT NOT NULL,
	IdOperacion INT NOT NULL,
	IdMetodoPago INT NOT NULL,
	IdTipoSubOperacion INT NOT NULL,
	Monto NUMERIC(11,2) NOT NULL DEFAULT 0
)

INSERT @transaccionesD (IdTransaccionD,IdOperacion,IdMetodoPago,IdTipoSubOperacion,Monto)
SELECT td.IdTransaccionD, td.IdOperacion, td.IdMetodoPago, td.IdTipoSubOperacion, td.Monto 
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = td.IdEstatusActual AND ea.IdEstatus=1
INNER JOIN (
			SELECT IdOperacion FROM @financieras GROUP BY IdOperacion
			) f ON f.IdOperacion = td.IdOperacion
WHERE td.EsCambio=0

-- FIN INSERCIONES


-- DEP MENORES
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,5,'Transaccionalidad','Depositos - Soc. Menores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @cuentas c  
INNER JOIN @socios sc ON c.IdSocio = sc.IdSocio AND sc.EsMenor=1
INNER JOIN ( SELECT tf.IdCuenta, SUM(tf.MontoSubOperacion) AS MontoAcumulado FROM @financieras tf where tf.IdTipoSubOperacion=500 GROUP BY tf.IdCuenta) f ON f.IdCuenta = c.IdCuenta
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=1 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2

-- RET MENORES
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,5,'Transaccionalidad','Retiros - Soc. Menores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @cuentas c  
INNER JOIN @socios sc ON c.IdSocio = sc.IdSocio AND sc.EsMenor=1
INNER JOIN ( SELECT tf.IdCuenta, SUM(tf.MontoSubOperacion) AS MontoAcumulado FROM @financieras tf where tf.IdTipoSubOperacion=501 GROUP BY tf.IdCuenta) f ON f.IdCuenta = c.IdCuenta
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=2 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2

-- DEP MAYORES
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,5,'Transaccionalidad','Depositos - Soc. Mayores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @cuentas c  
INNER JOIN @socios sc ON c.IdSocio = sc.IdSocio AND sc.EsMayor=1
INNER JOIN ( SELECT tf.IdCuenta, SUM(tf.MontoSubOperacion) AS MontoAcumulado FROM @financieras tf where tf.IdTipoSubOperacion=500 GROUP BY tf.IdCuenta) f ON f.IdCuenta = c.IdCuenta
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=3 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2

-- RET MAYORES
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,5,'Transaccionalidad','Retiros - Soc. Mayores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @cuentas c  
INNER JOIN @socios sc ON c.IdSocio = sc.IdSocio AND sc.EsMayor=1
INNER JOIN ( SELECT tf.IdCuenta, SUM(tf.MontoSubOperacion) AS MontoAcumulado FROM @financieras tf where tf.IdTipoSubOperacion=501 GROUP BY tf.IdCuenta) f ON f.IdCuenta = c.IdCuenta
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=4 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2

-- DEP MORALES
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,5,'Transaccionalidad','Depositos - Soc. Morales',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @cuentas c  
INNER JOIN @socios sc ON c.IdSocio = sc.IdSocio AND sc.EsMoral=1
INNER JOIN ( SELECT tf.IdCuenta, SUM(tf.MontoSubOperacion) AS MontoAcumulado FROM @financieras tf where tf.IdTipoSubOperacion=500 GROUP BY tf.IdCuenta) f ON f.IdCuenta = c.IdCuenta
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=5 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2

-- RET MORALES
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona,sc.IdSocio,5,'Transaccionalidad','Retiros - Soc. Morales',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @cuentas c  
INNER JOIN @socios sc ON c.IdSocio = sc.IdSocio AND sc.EsMoral=1
INNER JOIN ( SELECT tf.IdCuenta, SUM(tf.MontoSubOperacion) AS MontoAcumulado FROM @financieras tf where tf.IdTipoSubOperacion=501 GROUP BY tf.IdCuenta) f ON f.IdCuenta = c.IdCuenta
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=6 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2

/*  |-------------------------------------------------------------|
							PRODUCTOS Y SERVICIOS
	|-------------------------------------------------------------|*/

-- SERVICIOS
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT CASE WHEN p.IdPersona IS NULL OR p.IdPersona=0 THEN -17 ELSE p.IdPersona END AS IdPersona, ISNULL(sc.IdSocio,0) AS IdSocio,6, 'PRODUCTOS Y SERVICIOS','Servicios',t.IdAuxiliar,mc.ValorDescripcion,mc.Puntos 
FROM tCOMconfiguracionPagoServicios cps WITH (NOLOCK)
INNER JOIN dbo.tSDOtransacciones t  WITH(NOLOCK) ON t.IdAuxiliar = cps.IdAuxiliar
INNER JOIN  dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion = t.IdOperacion
													AND op.IdEstatus=1
													AND op.IdPeriodo=@IdPeriodo
LEFT  JOIN dbo.tGRLpersonas p WITH(nolock) ON p.IdPersona = op.IdPersonaMovimiento
LEFT JOIN dbo.tSCSsocios sc WITH (NOLOCK) ON sc.IdPersona = p.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionProductosServicios mc  WITH(NOLOCK) ON mc.tipo=2 AND mc.IdValor1 = t.IdAuxiliar
WHERE cps.IdEstatus=1
AND ((@idPersona=0) OR (op.IdPersonaMovimiento = @idPersona))

-- PRODUCTOS
INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona, sc.IdSocio,6, 'PRODUCTOS Y SERVICIOS','Productos',c.IdProducto,CONCAT(c.NoCuenta,' - ',mc.ValorDescripcion),mc.Puntos 
FROM @socios sc  
INNER JOIN @cuentas c ON c.IdSocio = sc.IdSocio
INNER JOIN dbo.tPLDmatrizConfiguracionProductosServicios mc  WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor1 = c.IdProducto
AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))


/*  |-------------------------------------------------------------|
							CANALES DE DISTRIBUCIÓN
	|-------------------------------------------------------------| */

INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
SELECT sc.IdPersona, sc.IdSocio,7, 'CANALES DE DISTRIBUCIÓN','Instrumentos',td.IdMetodoPago,mc.ValorDescripcion,mc.Puntos 
FROM @transaccionesD td
INNER JOIN  @financieras f ON f.IdOperacion = td.IdOperacion
INNER JOIN @cuentas c  ON c.IdCuenta = f.IdCuenta
INNER JOIN @socios sc ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tPLDmatrizConfiguracionInstrumentosCanales mc  WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor1 = td.IdMetodoPago
WHERE ((@idSocio=0) OR (sc.IdSocio = @idSocio))

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--							RESULTADOS				
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */

DECLARE @calificacionesAgrupadas TABLE (IdSocio INT, IdFactor INT, Factor VARCHAR(64), SumaFactor INT, PonderacionFactor NUMERIC(4,3),PuntajeFactor NUMERIC(10,2))

DECLARE @calificacionesFinales TABLE (IdSocio INT, Calificacion NUMERIC(10,2))

INSERT INTO @calificacionesAgrupadas(IdSocio,IdFactor,Factor,SumaFactor,PonderacionFactor,PuntajeFactor)
SELECT cal.IdSocio,p.IdFactor, cal.Factor, SUM(cal.Puntos) AS SumaFactor , p.PonderacionFactor, SUM(cal.Puntos) * p.PonderacionFactor AS PuntajeFactor
FROM @calificaciones cal 
INNER JOIN dbo.tPLDmatrizConfiguracionPonderaciones p  WITH(NOLOCK) ON p.IdFactor = cal.IdFactor
GROUP BY cal.IdSocio,p.IdFactor, cal.Factor, p.PonderacionFactor

INSERT INTO @calificacionesFinales (IdSocio,Calificacion)
SELECT cal.IdSocio,SUM(cal.PuntajeFactor) AS Calificacion 
FROM @calificacionesAgrupadas cal 
GROUP BY cal.IdSocio

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- Resultados Finales para el Usuario, TODO: Crear tablas físicas que sirvan para consultar y como bitacora de las evaluciones

SELECT * FROM @calificaciones cal ORDER BY cal.IdSocio, cal.IdFactor, cal.Elemento

SELECT * FROM @calificacionesAgrupadas cal ORDER BY cal.IdSocio

SELECT c.IdSocio, c.Calificacion , n.NivelRiesgoDescripcion
FROM @calificacionesFinales c  
INNER JOIN dbo.tPLDmatrizConfiguracionNivelesRiesgo n ON c.Calificacion BETWEEN n.Valor1 AND n.Valor2 AND n.Tipo=1