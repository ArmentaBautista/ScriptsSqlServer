
BEGIN

DECLARE @pDEBUG BIT	=1
DECLARE @pIdSocio INT=0
DECLARE @pNoSocio VARCHAR(24)=''
DECLARE @pEvaluacionMasiva BIT=1
DECLARE @pFechaTrabajo DATE='20230807'

	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--							VARIABLES				
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */

	DECLARE @fechaTrabajo AS DATE = IIF(@pFechaTrabajo IS NULL OR @pFechaTrabajo='19000101',CURRENT_TIMESTAMP,@pFechaTrabajo) 
	DECLARE @fechaInicioMes AS DATE = DATEADD(dd,-(DAY(@fechaTrabajo)-1),@fechaTrabajo)
	DECLARE @IdPeriodo AS INT
	SELECT @IdPeriodo=IdPeriodo FROM dbo.tCTLperiodos p WHERE p.EsAjuste=0 AND  @fechaTrabajo BETWEEN p.Inicio AND p.Fin
	
	IF @pDEBUG=1 SELECT @IdPeriodo AS IdPeriodo

	DECLARE @idSocio AS INT = @pIdSocio;
	DECLARE @noSocio AS VARCHAR(24) = @pNoSocio;
	DECLARE @EvaluacionMasiva AS BIT=@pEvaluacionMasiva;
	DECLARE @idPersona AS INT = 0 
	
	IF @pDEBUG=1 select @idSocio AS idSocio, @noSocio AS noSocio, @idPersona AS idPersona

	IF @idSocio=0 AND @noSocio<>''
	BEGIN
		SELECT TOP 1 @idSocio=sc.IdSocio FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.Codigo=@NoSocio
    END

	SET @idPersona = (SELECT sc.idpersona FROM tscssocios sc  WITH(NOLOCK) WHERE sc.idsocio=@idSocio)

	IF @EvaluacionMasiva=1
	BEGIN
		SET @idSocio=0;
		SET @noSocio='';
		SET @idPersona=0;
	END

	IF @pDEBUG=1 select @idSocio AS idSocio, @noSocio AS noSocio, @idPersona AS idPersona

	--RETURN

	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--								TABLAS
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */


	/************************************* SOCIOS *************************************/

	DECLARE @sociosGeneral AS TABLE(
		IdSocio				INT PRIMARY KEY,
		IdPersona			INT,
		Fecha				DATE,
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
		BloqueadoPldSistema BIT,
		IdSocioeconomico	INT,
		NoSocio				VARCHAR(24) DEFAULT '',
		Nombre				VARCHAR(250) DEFAULT '',
		INDEX IX_IdPersona(IdPersona),
		INDEX IX_Edad(Edad)
	)

	DECLARE @socios AS TABLE(
		IdSocio				INT PRIMARY KEY,
		IdPersona			INT,
		Fecha				DATE,
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
		EsMenor				BIT DEFAULT 0,
		EsMayor				BIT DEFAULT 0,
		EsMoral				BIT DEFAULT 0,
		TipoSocio			SMALLINT CHECK (TipoSocio IN (1,2,3,4)),
		BloqueadoPldSistema BIT,
		IdSocioeconomico	INT,
		NoSocio				VARCHAR(24) DEFAULT '',
		Nombre				VARCHAR(250) DEFAULT ''
	)

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

	/* LLENADO DE SOCIOS */
	INSERT INTO @sociosGeneral
	(
		IdSocio,
		IdPersona,
		Fecha,
		Edad,
		IdPersonaFisica,
		ExentaIVA,
		IdPersonaMoral,
		EsSocioValido,
		Genero,
		IdEstadoNacimiento,
		IdRelDomicilios,
		IdSucursal,
		IdListaDOcupacion,
		BloqueadoPldSistema,
		IdSocioeconomico,
		NoSocio,
		Nombre
	)
	SELECT sc.IdSocio,	p.IdPersona, IIF(pf.IdPersonaFisica IS NOT NULL,pf.FechaNacimiento,pm.FechaConstitucion) AS Fecha,
	IIF(pf.IdPersonaFisica IS NOT NULL, DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo),IIF(pm.IdPersonaMoral IS NOT NULL,DATEDIFF(YEAR,pm.FechaConstitucion,@fechaTrabajo),0)) AS Edad,
	pf.IdPersonaFisica,	sc.ExentaIVA,	pm.IdPersonaMoral,	sc.EsSocioValido,	pf.Sexo,	pf.IdEstadoNacimiento,	p.IdRelDomicilios,	sc.IdSucursal,	pf.IdListaDOcupacion, sc.BloqueadoSistema, p.IdSocioeconomico
	,sc.Codigo, p.Nombre
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
	LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
	WHERE sc.IdSocio<>0 and sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF @pDEBUG=1 SELECT 'Socios General', * FROM @sociosGeneral
	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) FROM @sociosGeneral t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/* Insert de Menores*/
	INSERT INTO @socios
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero
	, sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	, IIF(sg.Edad<18,1,0), 0,0
	, 1, sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre
	FROM @sociosGeneral sg
	WHERE sg.EsSocioValido=0 AND sg.Edad<18

	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) AS ConteoDuplicadosMenores FROM @socios t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/* Insert de socios mayores*/
	INSERT INTO @socios
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero
	, sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	, 0, 1,0
	, CASE
		WHEN NOT sg.IdPersonaFisica IS NULL AND sg.ExentaIVA=1 THEN 4
		WHEN sg.Edad>17 THEN 2
	END, sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre
	FROM @sociosGeneral sg
	WHERE sg.Edad>=18 AND sg.IdPersonaMoral IS NULL AND sg.EsSocioValido=1

	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) AS ConteooDuplicadosMayores FROM @socios t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/* Insert de socios Morales*/
	INSERT INTO @socios
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero
	, sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	, 0, 0,1
	, 3, sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre
	FROM @sociosGeneral sg
	WHERE NOT sg.IdPersonaMoral IS NULL  AND sg.EsSocioValido=1

	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) AS ConteooDuplicadosMorales FROM @socios t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/* INFO (?_?) 
	Consulta original de inserción, se cambia, implementando 3 inserciones para considerar solo los menores y socios válidos,
	Esto se debe a que detecte que si se insertan los aspirantes puede haber duplicados, donde hayan registrado 2 veces a la misma persona
	
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero,sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	,IIF(sg.Edad<18,1,0), IIF(sg.Edad>17,1,0),IIF(sg.IdPersonaMoral IS NULL,0,1),
	CASE
		WHEN sg.Edad<18 THEN 1
		WHEN sg.Edad>17 THEN 2
		WHEN sg.IdPersonaMoral IS NULL THEN 3
		WHEN NOT sg.IdPersonaFisica IS NULL AND sg.ExentaIVA=1 THEN 4
	END,
	sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre
	FROM @sociosGeneral sg
	*/
	
	IF @pDEBUG=1 SELECT 'Socios', * FROM @socios

	/* Tabla de Datos Transaccionales declarados en el Ingreso */
	DECLARE @transaccionalidadDeclarada TABLE(
			IdPersona				INT PRIMARY KEY,
			MontoDepIdTipoE			INT,
			MontoDepIdListaD		INT,
			MontoDepDescripcion		VARCHAR(250),
			MontoDepValor			NUMERIC(18,2),
			MontoRetIdTipoE			INT,
			MontoRetIdListaD		INT,
			MontoRetDescripcion		VARCHAR(250),
			MontoRetValor			NUMERIC(18,2),
			NumDepIdTipoE			INT,
			NumDepIdListaD			INT,
			NumDepDescripcion		VARCHAR(250),
			NumDepValor				NUMERIC(18,2),
			NumRetIdTipoE			INT,
			NumRetIdListaD			INT,
			NumRetDescripcion		VARCHAR(250),
			NumRetValor				NUMERIC(18,2)
	)

	IF @pDEBUG=1 SELECT 'Previo a insertar la transaccionalidad declarada' 

	/* LLENADO DE DATOS TRANSACCIONALES */
	INSERT INTO	@transaccionalidadDeclarada
	(
		IdPersona,
		MontoDepIdTipoE,
		MontoDepIdListaD,
		MontoDepDescripcion,
		MontoDepValor,
		MontoRetIdTipoE,
		MontoRetIdListaD,
		MontoRetDescripcion,
		MontoRetValor,
		NumDepIdTipoE,
		NumDepIdListaD,
		NumDepDescripcion,
		NumDepValor,
		NumRetIdTipoE,
		NumRetIdListaD,
		NumRetDescripcion,
		NumRetValor
	)
	SELECT p.IdPersona
	,montoD.IdTipoE,montoD.IdListaD,montoD.Descripcion,montoD.Valor
	,montoR.IdTipoE,montoR.IdListaD,montoR.Descripcion,montoR.Valor
	,numD.IdTipoE,numD.IdListaD,numD.Descripcion,numD.Valor
	,numR.IdTipoE,numR.IdListaD,numR.Descripcion,numR.Valor
	FROM @socios p 
		INNER JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) ON se.IdSocioeconomico = p.IdSocioeconomico
		INNER JOIN dbo.tCTLestatusActual ea WITH (NOLOCK) 
			ON ea.IdEstatusActual = se.IdEstatusActual 
				AND ea.IdEstatus = 1
		INNER JOIN dbo.tCATlistasD montoD WITH (NOLOCK) 
			ON montoD.IdListaD = se.IdListaDmontoDepositos
		INNER JOIN dbo.tCTLestatusActual emontoD WITH (NOLOCK) 
			ON emontoD.IdEstatusActual = montoD.IdEstatusActual 
				AND emontoD.IdEstatus = 1
		INNER JOIN dbo.tCATlistasD montoR WITH (NOLOCK) 
			ON montoR.IdListaD = se.IdListaDmontoRetiros
		INNER JOIN dbo.tCTLestatusActual emontoR WITH (NOLOCK) 
			ON emontoR.IdEstatusActual = montoR.IdEstatusActual 
				AND emontoR.IdEstatus = 1
		INNER JOIN dbo.tCATlistasD numD WITH (NOLOCK) 
			ON numD.IdListaD = se.IdListaDnumeroDepositos
		INNER JOIN dbo.tCTLestatusActual enumD WITH (NOLOCK) 
			ON enumD.IdEstatusActual = numD.IdEstatusActual 
				AND enumD.IdEstatus = 1
		INNER JOIN dbo.tCATlistasD numR WITH (NOLOCK) 
			ON numR.IdListaD = se.IdListaDnumeroRetiros
		INNER JOIN dbo.tCTLestatusActual enumR WITH (NOLOCK) 
			ON enumR.IdEstatusActual = numR.IdEstatusActual 
				AND enumR.IdEstatus = 1
	WHERE ((@idPersona = 0) OR (p.IdPersona = @idPersona));

	IF @pDEBUG=1 SELECT * FROM @transaccionalidadDeclarada 

	IF @pDEBUG=1 SELECT tdd.IdPersona, COUNT(1) FROM @transaccionalidadDeclarada tdd GROUP BY tdd.IdPersona HAVING COUNT(1)>1


	--IF @pDEBUG=1 GOTO HELL
	
	/************************************** CUENTAS Y TRANSACCIONES **************************************/

	/* TABLA DE CUENTAS ACTIVAS, SE USARA PARA BUSCAR SU MOVIMIENTOS EN FINANCIERAS Y DESPUES ENLAZAR CON LOS TIPOS DE SOCIOS */
	DECLARE @cuentas TABLE(
		IdCuenta INT NOT NULL PRIMARY KEY,
		IdSocio INT NOT NULL,
		IdProducto INT NOT NULL,
		IdTipoDproducto INT NOT NULL,
		Producto VARCHAR(128) NOT NULL,
		NoCuenta VARCHAR(32) NOT NULL,
		INDEX IxIdSocio(IdSocio),
		INDEX IxIdProducto(IdProducto)
	)

	INSERT INTO @cuentas (IdCuenta,IdSocio,IdProducto,IdTipoDproducto,Producto,NoCuenta)
	SELECT c.IdCuenta, c.IdSocio, c.IdProductoFinanciero, c.IdTipoDProducto, pf.Descripcion , c.Codigo
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	WHERE c.IdEstatus=1 AND ((@idSocio=0) OR (C.IdSocio= @idSocio))

	/* TABLA DE FINANCIERAS */
	DECLARE @financieras TABLE(
		IdTransaccionFinanciera INT NOT NULL PRIMARY KEY,
		IdOperacion INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Fecha DATE NOT NULL,
		MontoSubOperacion NUMERIC(11,2) NULL DEFAULT 0,
		IdSaldoDestino INT NOT NULL,
		IdCuenta INT NOT NULL,
		INDEX IxIdOperacion(IdOperacion),
		INDEX IxIdTipoSubOperacion(IdTipoSubOperacion),
		INDEX IxIdSaldoDestino(IdSaldoDestino),
		INDEX IxIdIdCuenta(IdCuenta)
	)

	INSERT @financieras (IdTransaccionFinanciera,IdOperacion,IdTipoSubOperacion,Fecha,MontoSubOperacion,IdSaldoDestino,IdCuenta)
	SELECT tf.IdTransaccion,tf.IdOperacion,tf.IdTipoSubOperacion,tf.Fecha,tf.MontoSubOperacion,tf.IdSaldoDestino,c.IdCuenta
	from @cuentas c 
	INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta = c.IdCuenta AND tf.IdEstatus=1 
	AND tf.IdOperacion<>0 AND tf.IdTipoSubOperacion IN (500,501) AND tf.Fecha BETWEEN @fechaInicioMes AND @fechaTrabajo

	/*  TRANSACCIONES D */
	DECLARE @transaccionesD TABLE(
		IdTransaccionD INT NOT NULL PRIMARY KEY,
		IdOperacion INT NOT NULL,
		IdMetodoPago INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Monto NUMERIC(11,2) NOT NULL DEFAULT 0,
		INDEX IxIdOperacion(IdOperacion),
		INDEX IxIdMetodoPago(IdMetodoPago),
		INDEX IxIdTipoSubOperacion(IdTipoSubOperacion)
	)

	INSERT @transaccionesD (IdTransaccionD,IdOperacion,IdMetodoPago,IdTipoSubOperacion,Monto)
	SELECT td.IdTransaccionD, td.IdOperacion, td.IdMetodoPago, td.IdTipoSubOperacion, td.Monto 
	FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = td.IdEstatusActual AND ea.IdEstatus=1
	INNER JOIN (
				SELECT IdOperacion FROM @financieras GROUP BY IdOperacion
				) f ON f.IdOperacion = td.IdOperacion
	WHERE td.EsCambio=0


	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--							EVALUACIONES				
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	DECLARE @idFactor INT=0;
	DECLARE @factor VARCHAR(128)='';

	/*  |-------------------------------------------------------------|
								SOCIO
		|-------------------------------------------------------------|*/
	SET @idFactor=1; SET @factor='Socio'

	/* SOCIO - EDAD */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.idpersona, sc.IdSocio,@idFactor,@factor,'Edad', sc.Edad,sc.Edad, cfg.puntos FROM @socios sc	
	INNER JOIN dbo.tPLDmatrizConfiguracionEdades cfg  WITH(NOLOCK) ON cfg.Edad = sc.Edad
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* SOCIO - TIPO SOCIO */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'TipoSocio',cfg.tipoSocio,cfg.descripcion, cfg.puntos FROM @socios sc
	INNER JOIN tPLDmatrizConfiguracionTipoSocio cfg  WITH(NOLOCK) ON cfg.TipoSocio = sc.TipoSocio
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* SOCIO - GÉNERO */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)			
	SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'Género', cfg.genero, cfg.Descripcion, cfg.puntos
	FROM @socios sc
	INNER JOIN dbo.tPLDmatrizConfiguracionGenero cfg ON cfg.genero = sc.Genero
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/*  |-------------------------------------------------------------|
								GEOGRAFÍA
		|-------------------------------------------------------------|*/
	SET @idFactor=2; SET @factor='Geografía'

	/* GEOGRAFÍA - SUCURSAL DEL SOCIO*/
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT  sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Sucursal del Socio',mc.IdValor,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc
	INNER JOIN tPLDmatrizConfiguracionSucursales mc WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor=sc.IdSucursal
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* GEOGRAFÍA - ENTIDAD DE NACIMIENTO */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Entidad Nacimiento',mc.IdUbicacion,mc.Descripcion,mc.Puntos
	FROM @socios sc
	INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=4 AND mc.IdUbicacion=sc.IdEstadoNacimiento
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* GEOGRAFÍA - MUNICIPIO DE RESIDENCIA */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Municipio Residencia',mc.IdUbicacion,mc.Descripcion,mc.Puntos
	FROM @socios sc
	INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdRel=sc.IdRelDomicilios AND dom.IdTipoD=11
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK)  ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
	INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdUbicacion=dom.IdMunicipio
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* GEOGRAFÍA - MUNICIPIO SUCURSAL */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Municipio Sucursal',mc.IdUbicacion,mc.Descripcion,mc.Puntos
	FROM @socios sc
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = sc.IdSucursal
	INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdTipoD=11 AND dom.IdDomicilio= suc.IdDomicilio
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK)  ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
	INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdUbicacion=dom.IdMunicipio
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/*  |-------------------------------------------------------------|
								LISTAS Y TERCEROS
		|-------------------------------------------------------------|*/
	SET @idFactor=3; SET @factor='Listas y Terceros'

	/* LISTAS Y TERCEROS - PROPIETARIO REAL */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Propietario Real',mc.IdValor,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc  
	INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
	INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=1 AND mc.IdValor=t.EsPropietarioReal
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF (@@ROWCOUNT=0)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Propietario Real',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* LISTAS Y TERCEROS - PROVEEDOR DE RECURSOS */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Proveedor de Recursos',mc.IdValor,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc   
	INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
	INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=2 AND mc.IdValor=t.EsProveedorRecursos
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF (@@ROWCOUNT=0)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Proveedor de Recursos',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* LISTAS Y TERCEROS - PEP */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'PEP',mc.IdValor,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc    
	INNER JOIN dbo.tPLDppe pep  WITH(NOLOCK) ON pep.IdPersona = sc.IdPersona
	INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdValor=pep.IdEstatus
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF (@@ROWCOUNT=0)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'PEP',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* LISTAS Y TERCEROS - LISTA BLOQUEADA */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Lista Bloqueada',mc.IdValor,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc  
	INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=6 AND mc.IdValor=sc.BloqueadoPldSistema -- TODO Cambiar por la existencia en la lista de riesgo
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF (@@ROWCOUNT=0)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Lista Bloqueada',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/*  |-------------------------------------------------------------|
								INGRESOS
		|-------------------------------------------------------------|*/
	SET @idFactor=4; SET @factor='Ingresos'

	/* INGRESOS - SUELDO RANGO PF */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Rango Ingresos PF',ie.Sueldo,CONCAT(mc.ValorDescripcion,': ',mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
	FROM @socios sc   
	INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) ON ac.IdPersona = sc.IdPersona
	INNER JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
	INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=2 AND ie.Sueldo BETWEEN mc.IdValor1 AND mc.IdValor2
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio)) AND sc.TipoSocio<>3

	/* INGRESOS - SUELDO RANGO PM */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Rango Ingresos PM',(ie.UtilidadNegocio + ie.VentasComercializacion),CONCAT(mc.ValorDescripcion,': ',mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
	FROM @socios sc   
	INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) ON ac.IdPersona = sc.IdPersona
	INNER JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
	INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=3 AND (ie.UtilidadNegocio + ie.VentasComercializacion) BETWEEN mc.IdValor1 AND mc.IdValor2
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio)) AND sc.TipoSocio=3

	/* INGRESOS - OCUPACION */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Ocupación',mc.IdValor ,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc  
	INNER JOIN dbo.tPLDmatrizConfiguracionOcupaciones mc  WITH(NOLOCK) ON mc.Tipo=1 AND sc.IdListaDOcupacion=mc.IdValor
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* INGRESOS - ACTIVIDAD */
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Actividad',mc.IdValor ,mc.ValorDescripcion,mc.Puntos
	FROM @socios sc  
	INNER JOIN tCTLlaborales labo  WITH(NOLOCK) ON labo.IdPersona = sc.IdPersona
	INNER JOIN dbo.tPLDmatrizConfiguracionActividad mc  WITH(NOLOCK) ON mc.Tipo=1 AND labo.IdListaDactividadEmpresa=mc.IdValor
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))


	/*  |-------------------------------------------------------------|
								TRANSACCIONALIDAD DECLARADA
		|-------------------------------------------------------------|*/
		SET @idFactor=5; SET @factor='Transaccionalidad'

		/* DEPOSITOS DECLARADOS DE MENORES */
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos Declarados - Soc. Menores',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc
		INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=1 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMenor=1

		/* RETIROS DECLARADOS DE MENORES */ 
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros Declarados - Soc. Menores',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc
		INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=2 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMenor=1

		/* DEPOSITOS DECLARADOS DE MAYORES */
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos Declarados - Soc. Mayores',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc
		INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=3 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMayor=1

		/* RETIROS DECLARADOS DE MAYORES */ 
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros Declarados - Soc. Mayores',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc
		INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=4 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMayor=1

		/* DEPOSITOS DECLARADOS DE MORALES */
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos Declarados - Soc. Morales',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc
		INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=5 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMoral=1

		/* RETIROS DECLARADOS DE MORALES */ 
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros Declarados - Soc. Morales',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc
		INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=6 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMoral=1



	/*  |-------------------------------------------------------------|
								TRANSACCIONALIDAD
		|-------------------------------------------------------------|*/
			SET @idFactor=5; SET @factor='Transaccionalidad'

		/* DEPOSITOS DE MENORES */
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos - Soc. Menores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc 
		INNER JOIN ( SELECT c.IdSocio, SUM(tf.MontoSubOperacion) AS MontoAcumulado 
					 FROM @financieras tf 
					 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
					 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=1 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMenor=1

		/* RETIROS DE MENORES */ 
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros - Soc. Menores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc 
		INNER JOIN ( SELECT c.IdSocio, SUM(tf.MontoSubOperacion) AS MontoAcumulado 
					 FROM @financieras tf 
					 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
					 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=2 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMenor=1

		/* DEPOSITOS DE MAYORES */
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos - Soc. Mayores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc 
		INNER JOIN ( SELECT c.IdSocio, SUM(tf.MontoSubOperacion) AS MontoAcumulado 
					 FROM @financieras tf 
					 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
					 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=3 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMayor=1

		/* RETIROS DE MAYORES */ 
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros - Soc. Mayores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc 
		INNER JOIN ( SELECT c.IdSocio, SUM(tf.MontoSubOperacion) AS MontoAcumulado 
					 FROM @financieras tf 
					 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
					 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=4 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMayor=1

		/* DEPOSITOS DE MORALES */
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos - Soc. Morales',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc 
		INNER JOIN ( SELECT c.IdSocio, SUM(tf.MontoSubOperacion) AS MontoAcumulado 
					 FROM @financieras tf 
					 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
					 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=5 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMoral=1

		/* RETIROS DE MORALES */ 
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros - Soc. Morales',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc 
		INNER JOIN ( SELECT c.IdSocio, SUM(tf.MontoSubOperacion) AS MontoAcumulado 
					 FROM @financieras tf 
					 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
					 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=6 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE sc.EsMoral=1

	/*  |-------------------------------------------------------------|
								PRODUCTOS Y SERVICIOS
		|-------------------------------------------------------------|*/
			SET @idFactor=6; SET @factor='Productos y Servicios'

	/* SERVICIOS */ 
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT CASE WHEN sc.IdPersona IS NULL OR sc.IdPersona=0 THEN -17 ELSE sc.IdPersona END AS IdPersona, ISNULL(sc.IdSocio,0) AS IdSocio,@idFactor,@factor,'Servicios',t.IdAuxiliar,mc.ValorDescripcion,mc.Puntos 
	FROM tCOMconfiguracionPagoServicios cps WITH (NOLOCK)
	INNER JOIN dbo.tSDOtransacciones t  WITH(NOLOCK) ON t.IdAuxiliar = cps.IdAuxiliar
	INNER JOIN  dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion = t.IdOperacion
														AND op.IdEstatus=1
														AND op.IdPeriodo=@IdPeriodo
	LEFT JOIN @socios sc ON sc.IdPersona=op.IdPersonaMovimiento
	INNER JOIN dbo.tPLDmatrizConfiguracionProductosServicios mc  WITH(NOLOCK) ON mc.tipo=2 AND mc.IdValor1 = t.IdAuxiliar
	WHERE cps.IdEstatus=1
	AND ((@idPersona=0) OR (op.IdPersonaMovimiento = @idPersona))

	/* PRODUCTOS */ 
	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'Productos',c.IdProducto,CONCAT(c.NoCuenta,' - ',mc.ValorDescripcion),mc.Puntos 
	FROM @socios sc  
	INNER JOIN @cuentas c ON c.IdSocio = sc.IdSocio
	INNER JOIN dbo.tPLDmatrizConfiguracionProductosServicios mc  WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor1 = c.IdProducto
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))


	/*  |-------------------------------------------------------------|
								CANALES DE DISTRIBUCIÓN
		|-------------------------------------------------------------| */
			SET @idFactor=7; SET @factor='Canales de Distribución'

	INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
	SELECT 
	td.IdPersona, td.IdSocio,@idFactor,@factor,'Instrumentos',td.IdMetodoPago,mc.ValorDescripcion,mc.Puntos 
	FROM (
			SELECT sc.IdPersona, sc.IdSocio,td.IdMetodoPago
			FROM @transaccionesD td
			INNER JOIN  @financieras f ON f.IdOperacion = td.IdOperacion
			INNER JOIN @cuentas c  ON c.IdCuenta = f.IdCuenta
			INNER JOIN @socios sc ON sc.IdSocio = c.IdSocio
			GROUP BY sc.IdPersona, sc.IdSocio,td.IdMetodoPago
			) td
	INNER JOIN dbo.tPLDmatrizConfiguracionInstrumentosCanales mc  WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor1 = td.IdMetodoPago
	WHERE ((@idSocio=0) OR (td.IdSocio = @idSocio))


	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--							CÁLCULO DE RESULTADOS				

	DECLARE @fechaEjecucion AS DATE=GETDATE();
	DECLARE @fechaHoraEjecucion AS DATETIME=GETDATE();
			DECLARE @agrupador AS VARCHAR(25)='';
			SET @agrupador=CONCAT(DATEPART(YEAR,@fechaHoraEjecucion)
								 ,FORMAT(DATEPART(MONTH,@fechaHoraEjecucion),'00')
								 ,FORMAT(DATEPART(DAY,@fechaHoraEjecucion),'00')
								 ,'.'
								 ,FORMAT(DATEPART(HOUR,@fechaHoraEjecucion),'00')
								 ,FORMAT(DATEPART(MINUTE,@fechaHoraEjecucion),'00')
								 ,'.A')

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

	IF @pDEBUG=1 SELECT * FROM @calificaciones
	IF @pDEBUG=1 SELECT * FROM @calificacionesAgrupadas
	IF @pDEBUG=1 SELECT * FROM @calificacionesFinales


	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--					GRABADO DE RESULTADOS

	-- Determinar si la evaluación fue para uno o todos los socios
	DECLARE @individual BIT, @masiva BIT, @idEvaluacionRiesgo INT;
	
	IF @EvaluacionMasiva=1
	BEGIN
		SET @individual=0; SET @masiva=1
	END
	ELSE	
	BEGIN
		SET @individual=1; SET @masiva=0
	END
	
	IF @pDEBUG=1 GOTO HELL

	/*
	 INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgo(Fecha,Agrupador,Individual,Masiva,IdEstatus) VALUES (@fechaEjecucion, @agrupador,@individual,@masiva,1)
	 SET @idEvaluacionRiesgo= SCOPE_IDENTITY();

		INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones (IdEvaluacionRiesgo,IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos,IdEstatus)
		SELECT @idEvaluacionRiesgo,cal.IdPersona, cal.IdSocio, cal.IdFactor, cal.Factor, cal.Elemento, cal.Valor, cal.ValorDescripcion, cal.Puntos,1 
		FROM @calificaciones cal ORDER BY cal.IdSocio, cal.IdFactor, cal.Elemento

		INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas (IdEvaluacionRiesgo,IdSocio,IdFactor,Factor,SumaFactor,PonderacionFactor,PuntajeFactor,IdEstatus)
		SELECT @idEvaluacionRiesgo, cal.IdSocio, cal.IdFactor, cal.Factor, cal.SumaFactor, cal.PonderacionFactor, cal.PuntajeFactor,1 FROM @calificacionesAgrupadas cal ORDER BY cal.IdSocio

		INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales (IdEvaluacionRiesgo,IdSocio,Calificacion,NivelDeRiesgo,NivelDeRiesgoDescripcion,IdEstatus)
		SELECT @idEvaluacionRiesgo, c.IdSocio, c.Calificacion, n.NivelRiesgo , n.NivelRiesgoDescripcion, 1 
		FROM @calificacionesFinales c  
		INNER JOIN @socios sc ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionNivelesRiesgo n ON c.Calificacion BETWEEN n.Valor1 AND n.Valor2 AND n.Tipo= sc.TipoSocio

	SELECT 
	@fechaEjecucion AS Fecha
	,@idEvaluacionRiesgo AS Folio
	,@agrupador AS Referencia
	,CAST(IIF(@EvaluacionMasiva=0,1,0) AS BIT) AS Individual
	,CAST(IIF(@EvaluacionMasiva=0,0,1) AS BIT) AS Masiva
	,sc.NoSocio
	,sc.Nombre AS Socio
	,c.Calificacion
	,CAST(n.NivelRiesgo AS SMALLINT) AS NivelDeRiesgo
	,n.NivelRiesgoDescripcion AS Descripcion
	FROM @calificacionesFinales c  
	INNER JOIN @socios sc ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tPLDmatrizConfiguracionNivelesRiesgo n ON c.Calificacion BETWEEN n.Valor1 AND n.Valor2 AND n.Tipo= sc.TipoSocio
*/	

HELL:
END

