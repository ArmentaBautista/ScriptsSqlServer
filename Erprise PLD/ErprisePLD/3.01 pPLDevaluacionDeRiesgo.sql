
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDevaluacionDeRiesgo')
BEGIN
	DROP PROC pPLDevaluacionDeRiesgo
	SELECT 'pPLDevaluacionDeRiesgo BORRADO' AS info
END
GO

CREATE PROC pPLDevaluacionDeRiesgo
@pIdSocio INT=0,
@pNoSocio VARCHAR(24)='',
@pEvaluacionMasiva BIT=0,
@pFechaTrabajo DATE='19000101',
@pDEBUG AS BIT=0
AS
BEGIN
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--							VARIABLES				
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	IF @pDEBUG IS NULL SET @pDEBUG=0

	DECLARE @fechaTrabajo AS DATE = IIF(@pFechaTrabajo IS NULL OR @pFechaTrabajo='19000101',CURRENT_TIMESTAMP,@pFechaTrabajo) 
	DECLARE @fecha6MesesAntes AS DATE = DATEADD(dd,-180,@fechaTrabajo)
	DECLARE @fechaInicioMes AS DATE = DATEADD(dd,-(DAY(@fechaTrabajo)-1),@fechaTrabajo)
	DECLARE @IdPeriodo AS INT
	SELECT @IdPeriodo=IdPeriodo FROM dbo.tCTLperiodos p WHERE p.EsAjuste=0 AND  @fechaTrabajo BETWEEN p.Inicio AND p.Fin
	
	/*
                  __ _                            _                       
                 / _(_)                          (_)                      
  ___ ___  _ __ | |_ _  __ _ _   _ _ __ __ _  ___ _  ___  _ __   ___  ___ 
 / __/ _ \| '_ \|  _| |/ _` | | | | '__/ _` |/ __| |/ _ \| '_ \ / _ \/ __|
| (_| (_) | | | | | | | (_| | |_| | | | (_| | (__| | (_) | | | |  __/\__ \
 \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\___|_|\___/|_| |_|\___||___/
                        __/ |                                             
                       |___/                                              	
	*/
	
	/* @^..^@   JCA.01/02/2024.06:30 p. m. Nota: LIMITES SUPERIORES DE LOS NIVELES DE RIESGO   */
	DECLARE @LimiteSuperiorMenores NUMERIC(8,2) = (SELECT MAX(Valor2) FROM dbo.tPLDmatrizConfiguracionNivelesRiesgo WHERE Tipo=1)
	DECLARE @LimiteSuperiorMayores NUMERIC(8,2) = (SELECT MAX(Valor2) FROM dbo.tPLDmatrizConfiguracionNivelesRiesgo WHERE Tipo=2)
	DECLARE @LimiteSuperiorMorales NUMERIC(8,2) = (SELECT MAX(Valor2) FROM dbo.tPLDmatrizConfiguracionNivelesRiesgo WHERE Tipo=3)
	/********  JCA.13/8/2024.14:23 Info: Elementos habilitados  ********/
	DECLARE @elementos TABLE(IdElemento INT PRIMARY KEY, IdFactor INT)
	INSERT INTO @elementos
	SELECT f.idelemento, f.idfactor FROM dbo.tPLDmatrizConfiguracionFactoresParaNivelRiesgo f  WITH(NOLOCK) WHERE f.idestatus=1


	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--							VARIABLES				
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	IF @pDEBUG=1 SELECT @IdPeriodo AS IdPeriodo

	DECLARE @idSocio AS INT = @pIdSocio;
	DECLARE @noSocio AS VARCHAR(24) = @pNoSocio;
	DECLARE @EvaluacionMasiva AS BIT=@pEvaluacionMasiva;
	DECLARE @idPersona AS INT = 0 
	
	IF @pDEBUG=1 SELECT @idSocio AS idSocio, @noSocio AS noSocio, @idPersona AS idPersona

	IF @idSocio=0 AND @noSocio<>''
	BEGIN
		SELECT TOP 1 @idSocio=sc.IdSocio FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.Codigo=@noSocio
    END
    
	SET @idPersona = (SELECT sc.idpersona FROM tscssocios sc  WITH(NOLOCK) WHERE sc.idsocio=@idSocio)

	IF @EvaluacionMasiva=1
	BEGIN
		SET @idSocio=0;
		SET @noSocio='';
		SET @idPersona=0;
	END

	IF @pDEBUG=1 select @idSocio AS idSocio, @noSocio AS noSocio, @idPersona AS idPersona

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
		IdPaisNacimiento	INT,
		EsExtranjero		BIT,

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
		BloqueadoPldSistema bit,
		IdSocioeconomico	INT,
		NoSocio				VARCHAR(24) DEFAULT '',
		Nombre				VARCHAR(250) DEFAULT '',
		IdPaisNacimiento	INT,
		EsExtranjero		BIT,
		TieneEvaluacion		BIT DEFAULT 0,
		INDEX Ix_IdPersona(IdPersona),
		INDEX Ix_Edad(Edad),
		INDEX Ix_IdSocieconomico(IdSocioeconomico)
	)

	DECLARE @calificaciones AS TABLE(
		IdPersona INT NOT NULL,
		IdSocio INT NOT NULL,
		IdFactor INT NOT NULL,
		Factor VARCHAR(64) NOT NULL,
		Elemento VARCHAR(128) NOT NULL,
		Valor VARCHAR(21) NOT NULL,
		ValorDescripcion VARCHAR(256) NULL,
		Puntos INT DEFAULT 0,
		INDEX IxIdpersona(IdPersona),
		INDEX IxIdSocio(IdSocio),
		INDEX IxFactor(IdFactor)
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
		Nombre,
		IdPaisNacimiento,
		EsExtranjero
	)
	SELECT sc.IdSocio,	p.IdPersona, IIF(pf.IdPersonaFisica IS NOT NULL,pf.FechaNacimiento,pm.FechaConstitucion) AS Fecha,
	IIF(pf.IdPersonaFisica IS NOT NULL, DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo),IIF(pm.IdPersonaMoral IS NOT NULL,DATEDIFF(YEAR,pm.FechaConstitucion,@fechaTrabajo),0)) AS Edad,
	pf.IdPersonaFisica,	sc.ExentaIVA,	pm.IdPersonaMoral,	sc.EsSocioValido,	pf.Sexo,	pf.IdEstadoNacimiento,	p.IdRelDomicilios,	sc.IdSucursal,	pf.IdListaDOcupacion, sc.BloqueadoSistema, p.IdSocioeconomico
	,sc.Codigo, p.Nombre, pf.IdPaisNacimiento,p.EsExtranjero
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
	LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
	WHERE sc.IdSocio<>0 and sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF @pDEBUG=1 SELECT 'Socios General', * FROM @sociosGeneral
	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) FROM @sociosGeneral t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/*  (???)    JCA.08/08/2023.11:53 a. m. Nota:Insert de Menores                */
	INSERT INTO @socios
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero
	, sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	, IIF(sg.Edad<18,1,0), 0,0
	, 1, sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre, sg.IdPaisNacimiento,sg.EsExtranjero,0
	FROM @sociosGeneral sg
	WHERE sg.EsSocioValido=0 AND sg.Edad<18

	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) AS ConteoDuplicadosMenores FROM @socios t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/* ?^•?•^?   JCA.08/08/2023.11:55 a. m. Nota:Insert de Socios Mayores y con Actividad Empresarial                */
	INSERT INTO @socios
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero
	, sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	, 0, 1,0
	, CASE
		WHEN NOT sg.IdPersonaFisica IS NULL AND sg.ExentaIVA=1 THEN 4
		WHEN sg.Edad>17 THEN 2
	END, sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre, sg.IdPaisNacimiento,sg.EsExtranjero,0
	FROM @sociosGeneral sg
	WHERE sg.Edad>=18 AND sg.IdPersonaMoral IS NULL --AND sg.EsSocioValido=1

	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) AS ConteooDuplicadosMayores FROM @socios t GROUP BY t.IdPersona HAVING COUNT(1)>1

	/*  (???)    JCA.08/08/2023.11:56 a. m. Nota:Insert de Socios personas Morales                */
	INSERT INTO @socios
	SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero
	, sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
	, 0, 0,1
	, 3, sg.BloqueadoPldSistema, sg.IdSocioeconomico
	,NoSocio,Nombre,sg.IdPaisNacimiento,sg.EsExtranjero,0
	FROM @sociosGeneral sg
	WHERE NOT sg.IdPersonaMoral IS NULL  AND sg.EsSocioValido=1

	/********  JCA.14/8/2024.04:30 Info: Se Marcan los evaluados si el parámetro de exclusión de transaccionalidad declarada está activo  ********/
	IF EXISTS(SELECT 1 FROM dbo.tPLDconfiguracion cf  WITH(NOLOCK) WHERE cf.IdParametro=8 AND cf.Valor='1')
	BEGIN
		UPDATE s SET s.TieneEvaluacion=1
		FROM @socios s
		INNER JOIN dbo.ifPLDsociosYaEvaluados() e
			ON e.idsocio=s.IdSocio
    END


	IF @pDEBUG=1 SELECT t.IdPersona, COUNT(1) AS ConteooDuplicadosMorales FROM @socios t GROUP BY t.IdPersona HAVING COUNT(1)>1
	
	IF @pDEBUG=1 SELECT 'Socios', * FROM @socios

	/* INFO (⊙_☉) JCA.20/09/2023.08:21 p. m. 
	Nota: TABLA DE ESTATUS ACTUAL DE DOMICILIOS
	*/
	DECLARE @EstatusDomicilios TABLE(
		IdEstatusActual		INT,
		IdEstatus			INT,

		INDEX IxIdEstatusActual(IdEstatusActual),
		INDEX IxIdEstatus   (IdEstatus)
	)

	-- Llenado
	INSERT INTO @EstatusDomicilios (IdEstatusActual,IdEstatus)
	SELECT ea.IdEstatusActual, ea.IdEstatus FROM dbo.tCTLestatusActual ea  WITH(NOLOCK) WHERE ea.IdTipoDDominio=201 AND ea.IdEstatus=1


/*
 ▒█████  ▄▄▄██▀▀▒█████  
▒██▒  ██▒  ▒██ ▒██▒  ██▒
▒██░  ██▒  ░██ ▒██░  ██▒
▒██   ██▓██▄██▓▒██   ██░
░ ████▓▒░▓███▒ ░ ████▓▒░
*/	
	/* Tablas de Datos Transaccionales declarados en el Ingreso */	
	DECLARE @transaccionalidadDeclarada TABLE(
			IdPersona				INT PRIMARY KEY,
			MontoDepIdTipoE			INT DEFAULT 0,
			MontoDepIdListaD		INT DEFAULT 0,
			MontoDepDescripcion		VARCHAR(250) DEFAULT '',
			MontoDepValor			NUMERIC(18,2) DEFAULT 0,
			MontoRetIdTipoE			INT DEFAULT 0,
			MontoRetIdListaD		INT DEFAULT 0,
			MontoRetDescripcion		VARCHAR(250) DEFAULT '',
			MontoRetValor			NUMERIC(18,2) DEFAULT 0,
			NumDepIdTipoE			INT DEFAULT 0,
			NumDepIdListaD			INT DEFAULT 0,
			NumDepDescripcion		VARCHAR(250) DEFAULT '',
			NumDepValor				NUMERIC(18,2) DEFAULT 0,
			NumRetIdTipoE			INT DEFAULT 0,
			NumRetIdListaD			INT DEFAULT 0,
			NumRetDescripcion		VARCHAR(250) DEFAULT '',
			NumRetValor				NUMERIC(18,2) DEFAULT 0,
			
			INDEX IxPersona(IdPersona)
	)

			/* LLENADO DE DATOS TRANSACCIONALES BASADOS EN CAJAS DE TEXTO */
			INSERT INTO	@transaccionalidadDeclarada
			(
				IdPersona,
				NumDepDescripcion,
				NumDepValor,
				NumRetDescripcion,
				NumRetValor,
				MontoDepDescripcion,
				MontoDepValor,
				MontoRetDescripcion,
				MontoRetValor
			)
			SELECT 
			p.IdPersona,
			CAST(eco.NumeroDepositos AS VARCHAR),
			eco.NumeroDepositos,
			CAST(eco.NumeroRetiros AS VARCHAR),
			eco.NumeroRetiros,
			CAST(eco.MontoDepositos AS VARCHAR),
			eco.MontoDepositos,
			CAST(eco.MontoRetiros AS VARCHAR),
			eco.MontoRetiros
			FROM @socios p   
			INNER JOIN dbo.tSCSpersonasSocioeconomicos eco  WITH(NOLOCK) 
				ON eco.IdSocioeconomico = p.IdSocioeconomico
			WHERE p.EsSocioValido=1
				AND ((@idPersona = 0) OR (p.IdPersona = @idPersona));

			
	IF @pDEBUG=1 SELECT 'LLENADO DE DATOS TRANSACCIONALES BASADOS EN CAJAS DE TEXTO'
	
	IF @pDEBUG=1 SELECT * FROM @transaccionalidadDeclarada 

	/************************************** CUENTAS Y TRANSACCIONES **************************************/

	/* TABLA DE CUENTAS ACTIVAS, SE USARA PARA BUSCAR SU MOVIMIENTOS EN FINANCIERAS Y DESPUES ENLAZAR CON LOS TIPOS DE SOCIOS */
	DECLARE @cuentas TABLE(
		IdCuenta INT NOT NULL PRIMARY KEY,
		IdSocio INT NOT NULL,
		IdProducto INT NOT NULL,
		IdTipoDproducto INT NOT NULL,
		Producto VARCHAR(128) NOT NULL,
		NoCuenta VARCHAR(32) NOT NULL,
		IdPersona INT NOT NULL,
		IdApertura	INT NULL,
		TienePagoAnticipados BIT DEFAULT 0,
		Monto	NUMERIC(13,2),

		INDEX IxIdSocio(IdSocio),
		INDEX IxIdProducto(IdProducto)
	)

	INSERT INTO @cuentas (IdCuenta,IdSocio,IdProducto,IdTipoDproducto,Producto,NoCuenta,IdPersona,IdApertura,TienePagoAnticipados,Monto)
	SELECT c.IdCuenta, c.IdSocio, c.IdProductoFinanciero, c.IdTipoDProducto, pf.Descripcion , c.Codigo, sc.IdPersona, c.IdApertura,0,c.Monto
	from dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN @socios sc 
		ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	WHERE c.IdEstatus=1 AND ((@idSocio=0) OR (C.IdSocio= @idSocio))

	IF @pDEBUG=1 
		SELECT 'Cuentas' as Info, * FROM @cuentas

	/********  JCA.1/4/2024.09:55 Info: Obtener cuentas que han tenido pagos anticipados o adelantados  ********/
	DECLARE @tSDOtransaccionFinancieraPagoAdelantadoAnticipado AS TABLE(
		id int,
		IdOperacion int,
		EsPagoAdelantado bit,
		EsPagoAnticipado bit,
		IdTipoDpagoAnticipado int,
		IdTransacccionFinanciera int,
		IdCuenta int
	)

	INSERT INTO @tSDOtransaccionFinancieraPagoAdelantadoAnticipado (id,IdOperacion,EsPagoAdelantado,EsPagoAnticipado,IdTipoDpagoAnticipado,IdTransacccionFinanciera,IdCuenta)
	SELECT aa.id,aa.IdOperacion,aa.EsPagoAdelantado,aa.EsPagoAnticipado,aa.IdTipoDpagoAnticipado,aa.IdTransacccionFinanciera,aa.IdCuenta 
	FROM dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa  WITH(NOLOCK) 
		
	IF @pDEBUG=1 
		SELECT 'tSDOtransaccionFinancieraPagoAdelantadoAnticipado' as Info, * FROM @tSDOtransaccionFinancieraPagoAdelantadoAnticipado

	/* JCA:31/3/2024.20:14 Insertar cuentas que esten en la tabla de pagos anticipados y adelantados  */
	INSERT INTO @cuentas (IdCuenta,IdSocio,IdProducto,IdTipoDproducto,Producto,NoCuenta,IdPersona,IdApertura,TienePagoAnticipados,Monto)
	SELECT c.IdCuenta, c.IdSocio, c.IdProductoFinanciero, c.IdTipoDProducto, pf.Descripcion , c.Codigo, sc.IdPersona, c.IdApertura,1,c.Monto
	from dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
		ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN @socios sc 
		ON sc.IdSocio = c.IdSocio
			AND ((@idSocio=0) OR (C.IdSocio= @idSocio))	
	RIGHT JOIN (
				SELECT aa.IdCuenta 
				FROM @tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa 
				GROUP BY aa.IdCuenta
				) ctasAA ON ctasAA.IdCuenta = c.IdCuenta
	WHERE ctasAA.IdCuenta IS NULL

	UPDATE c SET c.TienePagoAnticipados=1
    FROM @cuentas c 
	INNER JOIN @tSDOtransaccionFinancieraPagoAdelantadoAnticipado paa
		ON paa.IdCuenta = c.IdCuenta
			AND c.TienePagoAnticipados=0
	
	IF @pDEBUG=1 
		SELECT 'Cuentas Insertadas por Pagos Anticipados' as Info, c.* 
		FROM @cuentas c 
		WHERE c.TienePagoAnticipados=1

	/* TABLA DE FINANCIERAS */
	DECLARE @financieras TABLE(
		IdTransaccionFinanciera INT NOT NULL PRIMARY KEY,
		IdOperacion INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Fecha DATE NOT NULL,
		MontoSubOperacion NUMERIC(11,2) NULL DEFAULT 0,
		IdSaldoDestino INT NOT NULL,
		IdCuenta INT NOT NULL,
		IdSucursal INT NOT NULL,
		IdSocio	INT NOT NULL,
		IdPersona INT NOT NULL,

		INDEX IxIdOperacion(IdOperacion),
		INDEX IxIdTipoSubOperacion(IdTipoSubOperacion),
		INDEX IxIdSaldoDestino(IdSaldoDestino),
		INDEX IxIdIdCuenta(IdCuenta),
		INDEX IxIdIdSucursal(IdSucursal)
	)

	IF @pDEBUG=1 
		SELECT 'Inicia inserción de financieras' + CAST(GETDATE() AS VARCHAR(32))

	INSERT @financieras (IdTransaccionFinanciera,IdOperacion,IdTipoSubOperacion,Fecha,MontoSubOperacion,IdSaldoDestino,IdCuenta,IdSucursal,IdSocio,IdPersona)
	SELECT tf.IdTransaccion,tf.IdOperacion,tf.IdTipoSubOperacion,tf.Fecha,tf.MontoSubOperacion,tf.IdSaldoDestino,c.IdCuenta, tf.IdSucursal,c.IdSocio, c.IdPersona
	from @cuentas c 
	INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		ON tf.IdCuenta = c.IdCuenta 
			AND tf.IdEstatus=1 
				AND tf.IdOperacion<>0 
					AND tf.IdTipoSubOperacion IN (500,501)
						AND (
							-- Rango de fechas
							(tf.Fecha BETWEEN @fecha6MesesAntes AND @fechaTrabajo)
								OR
								-- TienePagoAnticipado = 1
								(c.TienePagoAnticipados = 1)
									OR
									-- Ambas condiciones
									(tf.Fecha BETWEEN @fecha6MesesAntes AND @fechaTrabajo)
										AND (c.TienePagoAnticipados = 1))
						
	IF @pDEBUG=1 
		SELECT 'Termina inserción de financieras' + CAST(GETDATE() AS VARCHAR(32))
	
	IF @pDEBUG=1 
		SELECT 'Financieras' AS Info, f.IdTransaccionFinanciera,f.IdOperacion,f.IdTipoSubOperacion,f.Fecha,f.MontoSubOperacion,f.IdSaldoDestino,f.IdCuenta,f.IdSucursal,c.IdSocio, f.IdPersona 
		FROM @financieras f 
		INNER JOIN @cuentas c 
			ON c.IdCuenta = f.IdCuenta

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

	IF @pDEBUG=1 
		SELECT 'TransaccionesD' AS Info, * FROM @transaccionesD

	/*	OPERACIONES */
	DECLARE @tiposOperaciones AS TABLE(
		IdSocio				INT,
		IdTipoOperacion		INT
	)

	INSERT INTO @tiposOperaciones
	SELECT f.IdSocio,op.IdTipoOperacion
	FROM @financieras f
	INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
		ON op.IdOperacion = f.IdOperacion
	INNER JOIN dbo.tPLDmatrizConfiguracionInstrumentosCanales can  WITH(NOLOCK) 
		ON can.IdValor1=op.IdTipoOperacion
			AND can.Tipo=2
	GROUP BY f.IdSocio,op.IdTipoOperacion

	IF @pDEBUG=1 
		SELECT 'Tipo Operaciones' AS Info, * FROM @tiposOperaciones

	/********  JCA.1/4/2024.11:06 Info: Obtener Pagos Anticipados  ********/
	DECLARE @pagosAnticipados AS TABLE(
		IdPersona	INT,
		IdSocio	INT,
		IdCuenta	INT,
		Monto	NUMERIC(15,2),
		TotalAnticipado	NUMERIC(15,2),
		PorcentajeAnticipado AS (TotalAnticipado/Monto)*100
	)

	INSERT INTO @pagosAnticipados (IdPersona,IdSocio,IdCuenta,Monto,TotalAnticipado)
	SELECT 
	t.IdPersona,t.IdSocio, t.IdCuenta,monto,SUM(t.TotalAnticipado)
	FROM (
			SELECT
			 c.IdPersona
			,c.IdSocio
			,c.IdCuenta
			,c.IdApertura
			,par.IdParcialidad
			,par.NumeroParcialidad
			,c.Monto
			,[TotalAnticipado] = par.CapitalPagado - par.Capital
			FROM dbo.tAYCparcialidades par  WITH(NOLOCK) 
			INNER JOIN @cuentas c
				ON c.IdCuenta = par.IdCuenta
					AND c.IdApertura=par.IdApertura
			INNER JOIN @tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa 
				ON aa.IdCuenta = c.IdCuenta
			WHERE par.CapitalPagado > par.Capital
				AND par.IdEstatus=1
					AND par.EstaPagada=1
			GROUP BY c.IdPersona,c.IdSocio, c.IdCuenta, c.IdApertura, par.IdParcialidad, par.NumeroParcialidad,c.Monto,(par.CapitalPagado - par.Capital)
	) t
	GROUP BY t.IdPersona, t.IdSocio, t.IdCuenta,t.Monto

	IF @pDEBUG=1 
		SELECT 'Pagos Anticipados' AS Info, pa.* from @pagosAnticipados pa
	
	/********  JCA.7/4/2024.02:37 Info: LIQUIDACIONES ANTICIPADAS  ********/
	DECLARE @ctasCerradas AS TABLE(
	IdCuenta	INT,
	IdApertura INT,
	IdSocio	INT,
	NoCuenta VARCHAR(30),

	INDEX IX_IdCuenta (IdCuenta)
	)

	INSERT INTO @ctasCerradas
	SELECT 
	c.IdCuenta, c.IdApertura,c.IdSocio, c.Codigo
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasEstadisticas CE  WITH(NOLOCK) 
		ON CE.IdCuenta = c.IdCuenta
			AND CE.FechaBaja>'19000101'
	WHERE c.IdEstatus=7 
		AND c.IdTipoDProducto=143
			and ce.FechaBaja<c.Vencimiento	
				AND ((@idSocio=0) OR (c.IdSocio= @idSocio))

	IF @pDEBUG=1 SELECT * FROM @ctasCerradas

	DECLARE @TotalesCuentas AS TABLE(
		IdCuenta	INT,
		TotalEstimado	NUMERIC(13,2),
		TotalPagado		NUMERIC(13,2),
		PorcentajePagado AS (TotalPagado/TotalEstimado)*100
	)

	INSERT INTO @TotalesCuentas
	SELECT 
	p.IdCuenta
	,SUM(p.TotalSinAhorro)
	,SUM(p.CapitalPagado + p.InteresOrdinarioPagado)
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	INNER JOIN @ctasCerradas c
		ON c.IdCuenta = p.IdCuenta
			AND c.IdApertura=p.IdApertura
				AND p.IdEstatus=1
	GROUP BY p.IdCuenta
	HAVING SUM(p.TotalSinAhorro)>0

	IF @pDEBUG=1
		SELECT *
		FROM @TotalesCuentas t  
		WHERE t.PorcentajePagado<86


/*
███████ ██    ██  █████  ██      ██    ██  █████   ██████ ██  ██████  ███    ██ ███████ ███████ 
██      ██    ██ ██   ██ ██      ██    ██ ██   ██ ██      ██ ██    ██ ████   ██ ██      ██      
█████   ██    ██ ███████ ██      ██    ██ ███████ ██      ██ ██    ██ ██ ██  ██ █████   ███████ 
██       ██  ██  ██   ██ ██      ██    ██ ██   ██ ██      ██ ██    ██ ██  ██ ██ ██           ██ 
███████   ████   ██   ██ ███████  ██████  ██   ██  ██████ ██  ██████  ██   ████ ███████ ███████ 
*/


/*
███████  ██████   ██████ ██  ██████  
██      ██    ██ ██      ██ ██    ██ 
███████ ██    ██ ██      ██ ██    ██ 
     ██ ██    ██ ██      ██ ██    ██ 
███████  ██████   ██████ ██  ██████  
*/

	DECLARE @idFactor INT=0;
	DECLARE @factor VARCHAR(128)='';
	/*  |-------------------------------------------------------------|
								SOCIO
		|-------------------------------------------------------------|*/
	SET @idFactor=1; SET @factor='Socio'
	
	/* SOCIO - EDAD */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=1)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.idpersona, sc.IdSocio,@idFactor,@factor,'Edad', sc.Edad,sc.Edad, cfg.puntos 
		FROM @socios sc	
		INNER JOIN dbo.tPLDmatrizConfiguracionEdades cfg  WITH(NOLOCK) ON cfg.Edad = sc.Edad AND cfg.Tipo=IIF(sc.EsMoral=1,2,1)
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* SOCIO - TIPO SOCIO */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=2)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'TipoSocio',cfg.tipoSocio,cfg.descripcion, cfg.puntos 
		FROM @socios sc
		INNER JOIN tPLDmatrizConfiguracionTipoSocio cfg  WITH(NOLOCK) ON cfg.TipoSocio = sc.TipoSocio
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	/* SOCIO - GÉNERO */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=3)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)			
		SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'Género', cfg.genero, cfg.Descripcion, cfg.puntos
		FROM @socios sc
		INNER JOIN dbo.tPLDmatrizConfiguracionGenero cfg ON cfg.genero = sc.Genero
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

/*
 ██████  ███████  ██████   ██████  ██████   █████  ███████ ██  █████  
██       ██      ██    ██ ██       ██   ██ ██   ██ ██      ██ ██   ██ 
██   ███ █████   ██    ██ ██   ███ ██████  ███████ █████   ██ ███████ 
██    ██ ██      ██    ██ ██    ██ ██   ██ ██   ██ ██      ██ ██   ██ 
 ██████  ███████  ██████   ██████  ██   ██ ██   ██ ██      ██ ██   ██ 
*/

	/*  |-------------------------------------------------------------|
								GEOGRAFÍA
		|-------------------------------------------------------------|*/
	SET @idFactor=2; SET @factor='Geografía'

	/* GEOGRAFÍA - SUCURSAL DEL SOCIO*/
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=4)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT  sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Sucursal del Socio',mc.IdValor,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN tPLDmatrizConfiguracionSucursales mc WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor=sc.IdSucursal
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		/* GEOGRAFÍA - ENTIDAD DE NACIMIENTO */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=5)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Entidad Nacimiento',mc.IdUbicacion,mc.Descripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=4 AND mc.IdUbicacion=sc.IdEstadoNacimiento
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		/* GEOGRAFÍA - MUNICIPIO DE RESIDENCIA */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=6)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Municipio Residencia',mc.IdUbicacion,mc.Descripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdRel=sc.IdRelDomicilios AND dom.IdTipoD=11
		INNER JOIN @EstatusDomicilios ea ON ea.IdEstatusActual = dom.IdEstatusActual 
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdUbicacion=dom.IdMunicipio
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		/* GEOGRAFÍA - MUNICIPIO SUCURSAL */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=7)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Municipio Sucursal',mc.IdUbicacion,mc.Descripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = sc.IdSucursal
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdTipoD=11 AND dom.IdDomicilio= suc.IdDomicilio
		INNER JOIN  @EstatusDomicilios ea ON ea.IdEstatusActual = dom.IdEstatusActual 
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdUbicacion=dom.IdMunicipio
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

			/* GEOGRAFÍA - ESTADO SUCURSAL */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=8)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Estado Sucursal',mc.IdUbicacion,mc.Descripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = sc.IdSucursal
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdTipoD=11 AND dom.IdDomicilio= suc.IdDomicilio
		INNER JOIN  @EstatusDomicilios ea ON ea.IdEstatusActual = dom.IdEstatusActual 
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=4 AND mc.IdUbicacion=dom.IdEstado
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		/* GEOGRAFÍA - PAÍS DE NACIMIENTO */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=9)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'País Nacimiento',mc.IdUbicacion,mc.Descripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=5 AND mc.IdUbicacion=sc.IdPaisNacimiento
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		/* GEOGRAFÍA - NACIONALIDAD */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=10)
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Nacionalidad',mc.IdUbicacion,mc.Descripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN (
					SELECT nac.IdPersona,nac.IdNacionalidad,n.Descripcion
					FROM dbo.tGRLnacionalidadesPersona nac  WITH(NOLOCK) 
					INNER JOIN dbo.tCTLnacionalidades n  WITH(NOLOCK) 
						ON n.IdNacionalidad = nac.IdNacionalidad
							--AND n.ExclusionGAFI=1
					WHERE nac.IdEstatus=1
					) ns
			ON ns.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) ON mc.Tipo=6 AND mc.IdUbicacion=ns.IdNacionalidad
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))



	/* GEOGRAFÍA - MUNICIPIO DE DEPÓSITOS "ORIGEN" */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=11)
	BEGIN
		DECLARE @origenDep TABLE(
			Id			INT,
			IdPersona	INT,
			IdSocio		INT,
			IdSucursal	INT,
			IdMunicipio INT,
			Municipio	VARCHAR(256),
			Puntos		NUMERIC(5,2)
		)

		INSERT INTO @origenDep
		SELECT 
		ROW_NUMBER() OVER(PARTITION BY sc.IdSocio ORDER BY mc.Puntos DESC) AS "Row Number",
		sc.IdPersona,sc.IdSocio, f.IdSucursal, mc.IdUbicacion,mc.Descripcion, mc.Puntos
		FROM @socios sc 
		INNER JOIN (SELECT c.IdSocio, tf.IdSucursal 
					FROM @financieras tf 
					INNER JOIN @cuentas c 
						ON c.IdCuenta = tf.IdCuenta
					WHERE tf.IdTipoSubOperacion=500 
						AND ((@idSocio=0) OR (c.IdSocio= @idSocio))
					GROUP BY c.IdSocio, tf.IdSucursal) f 
			ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON suc.IdSucursal = f.IdSucursal
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) 
			ON dom.IdDomicilio = suc.IdDomicilio
				AND dom.IdTipoD=11
		INNER JOIN  @EstatusDomicilios ea 
			ON ea.IdEstatusActual = dom.IdEstatusActual 
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) 
			ON mc.Tipo=3 
				AND mc.IdUbicacion=dom.IdMunicipio
		ORDER BY mc.Puntos DESC

		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT o.IdPersona, o.IdSocio, @idFactor, @factor, 'Municipio Origen Depósitos', o.IdMunicipio,o.Municipio, o.Puntos
		FROM @origenDep o
		WHERE o.Id=1
	END

	/* GEOGRAFÍA - MUNICIPIO DE OPERACIONES "DESTINO"  RETIROS*/
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=12)
	BEGIN
		DECLARE @origenRet TABLE(
			Id			INT,
			IdPersona	INT,
			IdSocio		INT,
			IdSucursal	INT,
			IdMunicipio INT,
			Municipio	VARCHAR(256),
			Puntos		NUMERIC(5,2)
		)

		INSERT INTO @origenRet
		SELECT 
		ROW_NUMBER() OVER(PARTITION BY sc.IdSocio ORDER BY mc.Puntos DESC) AS "Row Number",
		sc.IdPersona,sc.IdSocio, f.IdSucursal, mc.IdUbicacion,mc.Descripcion, mc.Puntos
		FROM @socios sc 
		INNER JOIN (SELECT c.IdSocio, tf.IdSucursal 
					FROM @financieras tf 
					INNER JOIN @cuentas c 
						ON c.IdCuenta = tf.IdCuenta
					WHERE tf.IdTipoSubOperacion=501
						AND ((@idSocio=0) OR (c.IdSocio= @idSocio))
					GROUP BY c.IdSocio, tf.IdSucursal) f 
			ON f.IdSocio = sc.IdSocio
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON suc.IdSucursal = f.IdSucursal
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) 
			ON dom.IdDomicilio = suc.IdDomicilio
				AND dom.IdTipoD=11
		INNER JOIN  @EstatusDomicilios ea 
			ON ea.IdEstatusActual = dom.IdEstatusActual 
		INNER JOIN dbo.tPLDmatrizConfiguracionGeografia mc  WITH(NOLOCK) 
			ON mc.Tipo=3 
				AND mc.IdUbicacion=dom.IdMunicipio
		ORDER BY mc.Puntos DESC

		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT o.IdPersona, o.IdSocio, @idFactor, @factor, 'Municipio Destino Retiros', o.IdMunicipio,o.Municipio, o.Puntos
		FROM @origenDep o
		WHERE o.Id=1
	END

/*
██      ██ ███████ ████████  █████  ███████     ██    ██          
██      ██ ██         ██    ██   ██ ██           ██  ██           
██      ██ ███████    ██    ███████ ███████       ████            
██      ██      ██    ██    ██   ██      ██        ██             
███████ ██ ███████    ██    ██   ██ ███████        ██             
                                                                  
                                                                  
████████ ███████ ██████   ██████ ███████ ██████   ██████  ███████ 
   ██    ██      ██   ██ ██      ██      ██   ██ ██    ██ ██      
   ██    █████   ██████  ██      █████   ██████  ██    ██ ███████ 
   ██    ██      ██   ██ ██      ██      ██   ██ ██    ██      ██ 
   ██    ███████ ██   ██  ██████ ███████ ██   ██  ██████  ███████ 
*/	

	/*  |-------------------------------------------------------------|
								LISTAS Y TERCEROS
		|-------------------------------------------------------------|*/
	SET @idFactor=3; SET @factor='Listas y Terceros'

	/* LISTAS Y TERCEROS - PROPIETARIO REAL */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=13)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Propietario Real',mc.IdValor,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc  
		INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
		INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=1 AND mc.IdValor=t.EsPropietarioReal
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		IF (@@ROWCOUNT=0)
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Propietario Real',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

		/* LISTAS Y TERCEROS - PROVEEDOR DE RECURSOS */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=14)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Proveedor de Recursos',mc.IdValor,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc   
		INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
		INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=2 AND mc.IdValor=t.EsProveedorRecursos
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		IF @pDEBUG=1
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Proveedor de Recursos',mc.IdValor,mc.ValorDescripcion,mc.Puntos
			,t.*,ea.*
			FROM @socios sc   
			INNER JOIN dbo.tPLDsocioTerceros t  WITH(NOLOCK) ON t.IdPersonaSocio = sc.IdPersona 
			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
			INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=2 AND mc.IdValor=t.EsProveedorRecursos
			WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		IF (@@ROWCOUNT=0)
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Proveedor de Recursos',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

		/* LISTAS Y TERCEROS - PEP */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=15)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'PEP',mc.IdValor,mc.ValorDescripcion,
			CASE
				WHEN sc.EsMenor=1 AND sc.EsExtranjero=1 THEN @LimiteSuperiorMenores 
				WHEN sc.EsMayor=1 AND sc.EsExtranjero=1 THEN @LimiteSuperiorMayores
				WHEN sc.EsMoral=1 AND sc.EsExtranjero=1 THEN @LimiteSuperiorMorales
				WHEN pep.Id IS NULL						THEN 0
				ELSE mc.Puntos
			END AS Puntos
		FROM @socios sc    
		LEFT JOIN dbo.tPLDppe pep  WITH(NOLOCK) ON pep.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=3 AND mc.IdValor=pep.IdEstatus
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		IF (@@ROWCOUNT=0)
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'PEP',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	
	END

		/* LISTAS Y TERCEROS - LISTA BLOQUEADA */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=16)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Lista Bloqueada',mc.IdValor,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc  
		INNER JOIN dbo.tPLDmatrizConfiguracionListas mc  WITH(NOLOCK) ON mc.Tipo=6 AND mc.IdValor=sc.BloqueadoPldSistema -- TODO Cambiar por la existencia en la lista de riesgo
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

		IF (@@ROWCOUNT=0)
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Lista Bloqueada',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

/*
██████  ███████  ██████ ██    ██ ██████  ███████  ██████  ███████ 
██   ██ ██      ██      ██    ██ ██   ██ ██      ██    ██ ██      
██████  █████   ██      ██    ██ ██████  ███████ ██    ██ ███████ 
██   ██ ██      ██      ██    ██ ██   ██      ██ ██    ██      ██ 
██   ██ ███████  ██████  ██████  ██   ██ ███████  ██████  ███████ 
*/

	/*  |-------------------------------------------------------------|
								RECURSOS
		|-------------------------------------------------------------|*/
	SET @idFactor=4; SET @factor='Recursos'

	/* RECURSOS - SUELDO RANGO PF */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=17)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Rango Ingresos PF',ie.Sueldo,CONCAT(mc.ValorDescripcion,': ',mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc   
		INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) ON ac.IdPersona = sc.IdPersona
		INNER JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
		INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=2 AND ie.Sueldo BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio)) AND sc.TipoSocio<>3
	END

	/* RECURSOS - SUELDO RANGO PM */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=18)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Rango Ingresos PM',(ie.UtilidadNegocio + ie.VentasComercializacion),CONCAT(mc.ValorDescripcion,': ',mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
		FROM @socios sc   
		INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) ON ac.IdPersona = sc.IdPersona
		INNER JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
		INNER JOIN dbo.tPLDmatrizConfiguracionIngresos mc  WITH(NOLOCK) ON mc.Tipo=3 AND (ie.UtilidadNegocio + ie.VentasComercializacion) BETWEEN mc.IdValor1 AND mc.IdValor2
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio)) AND sc.TipoSocio=3
	END

	/* RECURSOS - OCUPACION */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=19)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Ocupación',mc.IdValor ,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc  
		INNER JOIN dbo.tPLDmatrizConfiguracionOcupaciones mc  WITH(NOLOCK) ON mc.Tipo=1 AND sc.IdListaDOcupacion=mc.IdValor
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

	/* RECURSOS - ACTIVIDAD */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=20)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Actividad',mc.IdValor ,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc  
		INNER JOIN dbo.tCTLlaborales labo  WITH(NOLOCK) ON labo.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionActividad mc  WITH(NOLOCK) ON mc.Tipo=1 AND labo.IdListaDactividadEmpresa=mc.IdValor
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

	/* RECURSOS - ORIGEN DE LOS RECURSOS */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=21)
	BEGIN
		IF @pDEBUG=1 SELECT 'Origen del Recurso '

		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Origen Recursos',o.Monto,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.fnPLDorigenesRecursosSocios(@idPersona) o
			ON o.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionOrigenDestinoRecursos mc  WITH(NOLOCK) ON mc.Tipo=1 AND mc.ValorDescripcion=o.OrigenDetino
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

	/* RECURSOS - DESTINO DE LOS RECURSOS */	
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=22)
	BEGIN
		IF @pDEBUG=1 SELECT 'Destino del Recurso '

		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Destino Recursos',o.Monto,mc.ValorDescripcion,mc.Puntos
		FROM @socios sc
		INNER JOIN dbo.fnPLDdestinosRecursosSocios(@idPersona)  AS o
			ON o.IdPersona = sc.IdPersona
		INNER JOIN dbo.tPLDmatrizConfiguracionOrigenDestinoRecursos mc  WITH(NOLOCK) ON mc.Tipo=2 AND mc.ValorDescripcion=o.OrigenDetino
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END
/*
████████ ██████   █████  ███    ██ ███████  █████   ██████  ██████ ██  ██████  ███    ██  █████  ██      ██ ██████   █████  ██████  
   ██    ██   ██ ██   ██ ████   ██ ██      ██   ██ ██      ██      ██ ██    ██ ████   ██ ██   ██ ██      ██ ██   ██ ██   ██ ██   ██ 
   ██    ██████  ███████ ██ ██  ██ ███████ ███████ ██      ██      ██ ██    ██ ██ ██  ██ ███████ ██      ██ ██   ██ ███████ ██   ██ 
   ██    ██   ██ ██   ██ ██  ██ ██      ██ ██   ██ ██      ██      ██ ██    ██ ██  ██ ██ ██   ██ ██      ██ ██   ██ ██   ██ ██   ██ 
   ██    ██   ██ ██   ██ ██   ████ ███████ ██   ██  ██████  ██████ ██  ██████  ██   ████ ██   ██ ███████ ██ ██████  ██   ██ ██████  
                                                                                                                                    
                                                                                                                                    
██████  ███████  ██████ ██       █████  ██████   █████  ██████   █████                                                              
██   ██ ██      ██      ██      ██   ██ ██   ██ ██   ██ ██   ██ ██   ██                                                             
██   ██ █████   ██      ██      ███████ ██████  ███████ ██   ██ ███████                                                             
██   ██ ██      ██      ██      ██   ██ ██   ██ ██   ██ ██   ██ ██   ██                                                             
██████  ███████  ██████ ███████ ██   ██ ██   ██ ██   ██ ██████  ██   ██                                                                                                                                      
*/

	/*  |-------------------------------------------------------------|
								TRANSACCIONALIDAD DECLARADA
		|-------------------------------------------------------------|*/

	/********  JCA.5/3/2024.00:54 Info: MONTOS DECLARADOS  ********/
	SET @idFactor=5; SET @factor='Transaccionalidad'

	/* DEPOSITOS DECLARADOS DE MENORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=23)
	BEGIN
			IF @pDEBUG=1 SELECT 'MONTO DEPOSITOS DECLARADOS DE MENORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Depositos Declarados - Soc. Menores',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=1 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1 AND sc.TieneEvaluacion=0
	END

	/* RETIROS DECLARADOS DE MENORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=24)
	BEGIN
			IF @pDEBUG=1 SELECT 'MONTO RETIROS DECLARADOS DE MENORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Retiros Declarados - Soc. Menores',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=2 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1 AND sc.TieneEvaluacion=0
	END

	/* DEPOSITOS DECLARADOS DE MAYORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=25)
	BEGIN
			IF @pDEBUG=1 SELECT 'MONTO DEPOSITOS DECLARADOS DE MAYORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Depositos Declarados - Soc. Mayores',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=3 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1 AND sc.TieneEvaluacion=0
	END

	/* RETIROS DECLARADOS DE MAYORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=26)
	BEGIN
			IF @pDEBUG=1 SELECT 'RETIROS DECLARADOS DE MAYORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Retiros Declarados - Soc. Mayores',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=4 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1 AND sc.TieneEvaluacion=0
	END

	/* DEPOSITOS DECLARADOS DE MORALES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=27)
	BEGIN
			IF @pDEBUG=1 SELECT 'DEPOSITOS DECLARADOS DE MORALES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Depositos Declarados - Soc. Morales',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=5 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1 AND sc.TieneEvaluacion=0
	END

	/* RETIROS DECLARADOS DE MORALES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=28)
	BEGIN
			IF @pDEBUG=1 SELECT 'RETIROS DECLARADOS DE MORALES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Retiros Declarados - Soc. Morales',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=6 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1 AND sc.TieneEvaluacion=0
	END

	/********  JCA.5/3/2024.00:54 Info: NÚMEROS DE OPERACIONES DECLARADOS  ********/

	/* NÚMERO DEPOSITOS DECLARADOS DE MENORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=29)
	BEGIN
			IF @pDEBUG=1 SELECT 'NÚMERO DEPOSITOS DECLARADOS DE MENORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Depositos Declarados - Soc. Menores',t.NumDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=1 AND t.NumDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1 AND sc.TieneEvaluacion=0
	END

	/* NÚMERO RETIROS DECLARADOS DE MENORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=30)
	BEGIN
			IF @pDEBUG=1 SELECT 'NÚMERO RETIROS DECLARADOS DE MENORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Retiros Declarados - Soc. Menores',t.NumRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=2 AND t.NumRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1 AND sc.TieneEvaluacion=0
	END

	/* NÚMERO DEPOSITOS DECLARADOS DE MAYORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=31)
	BEGIN
			IF @pDEBUG=1 SELECT 'NÚMERO DEPOSITOS DECLARADOS DE MAYORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Depositos Declarados - Soc. Mayores',t.NumDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=3 AND t.NumDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1 AND sc.TieneEvaluacion=0
	END

	/* NÚMERO RETIROS DECLARADOS DE MAYORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=32)
	BEGIN
			IF @pDEBUG=1 SELECT 'NÚMERO RETIROS DECLARADOS DE MAYORES'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Retiros Declarados - Soc. Mayores',t.NumRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=4 AND t.NumRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1 AND sc.TieneEvaluacion=0
	END

	/* NÚMERO DEPOSITOS DECLARADOS DE PM */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=33)
	BEGIN
			IF @pDEBUG=1 SELECT 'NÚMERO DEPOSITOS DECLARADOS DE PM'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Depositos Declarados - Soc. PM',t.NumDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=5 AND t.NumDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1 AND sc.TieneEvaluacion=0
	END

	/* NÚMERO RETIROS DECLARADOS DE PM */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=34)
	BEGIN
			IF @pDEBUG=1 SELECT 'NÚMERO RETIROS DECLARADOS DE PM'

			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Retiros Declarados - Soc. PM',t.NumRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc
			INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=6 AND t.NumRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1 AND sc.TieneEvaluacion=0
	END

/*
████████ ██████   █████  ███    ██ ███████  █████   ██████  ██████ ██  ██████  ███    ██  █████  ██      ██ ██████   █████  ██████      
   ██    ██   ██ ██   ██ ████   ██ ██      ██   ██ ██      ██      ██ ██    ██ ████   ██ ██   ██ ██      ██ ██   ██ ██   ██ ██   ██     
   ██    ██████  ███████ ██ ██  ██ ███████ ███████ ██      ██      ██ ██    ██ ██ ██  ██ ███████ ██      ██ ██   ██ ███████ ██   ██     
   ██    ██   ██ ██   ██ ██  ██ ██      ██ ██   ██ ██      ██      ██ ██    ██ ██  ██ ██ ██   ██ ██      ██ ██   ██ ██   ██ ██   ██     
   ██    ██   ██ ██   ██ ██   ████ ███████ ██   ██  ██████  ██████ ██  ██████  ██   ████ ██   ██ ███████ ██ ██████  ██   ██ ██████      
                                                                                                                                        
                                                                                                                                        
 ██████  ██████  ███████ ██████   █████   ██████ ██  ██████  ███    ██                                                                  
██    ██ ██   ██ ██      ██   ██ ██   ██ ██      ██ ██    ██ ████   ██                                                                  
██    ██ ██████  █████   ██████  ███████ ██      ██ ██    ██ ██ ██  ██                                                                  
██    ██ ██      ██      ██   ██ ██   ██ ██      ██ ██    ██ ██  ██ ██                                                                  
 ██████  ██      ███████ ██   ██ ██   ██  ██████ ██  ██████  ██   ████                                                                         
*/

	/*  |-------------------------------------------------------------|
					        TRANSACCIONALIDAD (OPERACIÓN)
		|-------------------------------------------------------------|*/
			SET @idFactor=5; SET @factor='Transaccionalidad'

	/* ฅ^•ﻌ•^ฅ   JCA.20/09/2023.06:00 p. m. Nota: MONTO DE OPERACIONES   */

	/* DEPOSITOS DE MENORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=35)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Depositos Operados - Soc. Menores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, AVG(tf.MontoSubOperacion) AS MontoAcumulado 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=1 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1
	END

	/* RETIROS DE MENORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=36)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Retiros Operados - Soc. Menores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, AVG(tf.MontoSubOperacion) AS MontoAcumulado 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=2 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1
	END

	/* DEPOSITOS DE MAYORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=37)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Depositos Operados - Soc. Mayores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, AVG(tf.MontoSubOperacion) AS MontoAcumulado 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=3 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1
	END

	/* RETIROS DE MAYORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=38)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Retiros Operados - Soc. Mayores',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, AVG(tf.MontoSubOperacion) AS MontoAcumulado 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=4 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1
	END

	/* DEPOSITOS DE MORALES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=39)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Depositos Operados - Soc. Morales',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, AVG(tf.MontoSubOperacion) AS MontoAcumulado 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=5 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1
	END

	/* RETIROS DE MORALES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=40)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Monto Retiros Operados - Soc. Morales',f.MontoAcumulado,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, AVG(tf.MontoSubOperacion) AS MontoAcumulado 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=6 AND f.MontoAcumulado BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1
	END

	/* ฅ^•ﻌ•^ฅ   JCA.20/09/2023.06:00 p. m. Nota: NÚMERO DE OPERACIONES   */

	/* NÚMERO DEPOSITOS DE MENORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=41)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Depositos Operados - Soc. Menores',f.NumeroOperaciones,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, COUNT(1) AS NumeroOperaciones 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=1 AND f.NumeroOperaciones BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1
	END

	/* NÚMERO RETIROS DE MENORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=42)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Retiros Operados - Soc. Menores',f.NumeroOperaciones,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, COUNT(1) AS NumeroOperaciones 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=2 AND f.NumeroOperaciones BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMenor=1
	END

	/* NÚMERO DEPOSITOS DE MAYORES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=43)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Depositos Operados - Soc. Mayores',f.NumeroOperaciones,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, COUNT(1) AS NumeroOperaciones 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=3 AND f.NumeroOperaciones BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1
	END

	/* NÚMERO RETIROS DE MAYORES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=44)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Retiros Operados - Soc. Mayores',f.NumeroOperaciones,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, COUNT(1) AS NumeroOperaciones 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=4 AND f.NumeroOperaciones BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMayor=1
	END

	/* NÚMERO DEPOSITOS DE MORALES */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=45)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Depositos Operados - Soc. Morales',f.NumeroOperaciones,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, COUNT(1) AS NumeroOperaciones 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=500 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=5 AND f.NumeroOperaciones BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1
	END

	/* NÚMERO RETIROS DE MORALES */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=46)
	BEGIN
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Número Retiros Operados - Soc. Morales',f.NumeroOperaciones,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
			FROM @socios sc 
			INNER JOIN ( SELECT c.IdSocio, COUNT(1) AS NumeroOperaciones 
						 FROM @financieras tf 
						 INNER JOIN @cuentas c ON c.IdCuenta = tf.IdCuenta
						 WHERE tf.IdTipoSubOperacion=501 GROUP BY c.IdSocio) f ON f.IdSocio = sc.IdSocio
			INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones mc  WITH(NOLOCK) ON mc.tipo=6 AND f.NumeroOperaciones BETWEEN mc.IdValor1 AND mc.IdValor2
			WHERE sc.EsMoral=1
	END

/*
██████   █████   ██████   ██████  ███████     ██    ██     ██      ██  ██████  ██    ██ ██ ██████   █████   ██████ ██  ██████  ███    ██ ███████ ███████ 
██   ██ ██   ██ ██       ██    ██ ██           ██  ██      ██      ██ ██    ██ ██    ██ ██ ██   ██ ██   ██ ██      ██ ██    ██ ████   ██ ██      ██      
██████  ███████ ██   ███ ██    ██ ███████       ████       ██      ██ ██    ██ ██    ██ ██ ██   ██ ███████ ██      ██ ██    ██ ██ ██  ██ █████   ███████ 
██      ██   ██ ██    ██ ██    ██      ██        ██        ██      ██ ██ ▄▄ ██ ██    ██ ██ ██   ██ ██   ██ ██      ██ ██    ██ ██  ██ ██ ██           ██ 
██      ██   ██  ██████   ██████  ███████        ██        ███████ ██  ██████   ██████  ██ ██████  ██   ██  ██████ ██  ██████  ██   ████ ███████ ███████ 
                                                                          ▀▀                                                                             
                                                                                                                                                         
 █████  ███    ██ ████████ ██  ██████ ██ ██████   █████  ██████   █████  ███████                                                                         
██   ██ ████   ██    ██    ██ ██      ██ ██   ██ ██   ██ ██   ██ ██   ██ ██                                                                              
███████ ██ ██  ██    ██    ██ ██      ██ ██████  ███████ ██   ██ ███████ ███████                                                                         
██   ██ ██  ██ ██    ██    ██ ██      ██ ██      ██   ██ ██   ██ ██   ██      ██                                                                         
██   ██ ██   ████    ██    ██  ██████ ██ ██      ██   ██ ██████  ██   ██ ███████                                                                         
*/

	SET @idFactor=5; SET @factor='Transaccionalidad'
	
	/*  |-------------------------------------------------------------|
								PAGOS
		|-------------------------------------------------------------|*/
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=47)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT paa.IdPersona, paa.IdSocio,@idFactor,@factor,'Abonos Anticipados (% del Crédito)',paa.PorcentajeAnticipado,CONCAT(paa.TotalAnticipado,'/',paa.Monto,' | Rango ',mc.IdValor1,'-',mc.IdValor2),mc.Puntos 
		FROM @pagosAnticipados paa
		INNER JOIN dbo.tPLDmatrizConfiguracionPagoAnticipado mc  WITH(NOLOCK) 
			ON mc.tipo=1 
				AND paa.PorcentajeAnticipado BETWEEN mc.IdValor1 AND mc.IdValor2

		IF (@@ROWCOUNT=0)
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Abonos Anticipados (% del Crédito)',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	END

	/*  |-------------------------------------------------------------|
								LIQUIDACIÓN
		|-------------------------------------------------------------|*/
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=48)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'Liquidación Anticipada (% Monto Total)',tc.PorcentajePagado,CONCAT('Cuenta:',cc.NoCuenta,' ',tc.TotalPagado,'/',tc.TotalEstimado,' | Rango ',mc.IdValor1,'-',mc.IdValor2),mc.Puntos 
		FROM @TotalesCuentas tc
		INNER JOIN @ctasCerradas cc
			ON cc.IdCuenta = tc.IdCuenta
		INNER JOIN @socios sc
			ON sc.IdSocio = cc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionPagoAnticipado mc  WITH(NOLOCK) 
			ON mc.tipo=2 
				AND tc.PorcentajePagado BETWEEN mc.IdValor1 AND mc.IdValor2	
		WHERE tc.PorcentajePagado<86

		IF (@@ROWCOUNT=0)
			INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
			SELECT sc.IdPersona,sc.idSocio,@idFactor,@factor,'Liquidación Anticipada (% Monto Total)',0,'',0 FROM @socios sc WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	END

/*
██████  ██████   ██████  ██████  ██    ██  ██████ ████████  ██████  ███████ 
██   ██ ██   ██ ██    ██ ██   ██ ██    ██ ██         ██    ██    ██ ██      
██████  ██████  ██    ██ ██   ██ ██    ██ ██         ██    ██    ██ ███████ 
██      ██   ██ ██    ██ ██   ██ ██    ██ ██         ██    ██    ██      ██ 
██      ██   ██  ██████  ██████   ██████   ██████    ██     ██████  ███████ 
                                                                            
                                                                            
███████ ███████ ██████  ██    ██ ██  ██████ ██  ██████  ███████             
██      ██      ██   ██ ██    ██ ██ ██      ██ ██    ██ ██                  
███████ █████   ██████  ██    ██ ██ ██      ██ ██    ██ ███████             
     ██ ██      ██   ██  ██  ██  ██ ██      ██ ██    ██      ██             
███████ ███████ ██   ██   ████   ██  ██████ ██  ██████  ███████                                                                                                                                                         
*/

	/*  |-------------------------------------------------------------|
								PRODUCTOS Y SERVICIOS
		|-------------------------------------------------------------|*/
			SET @idFactor=6; SET @factor='Productos y Servicios'

	/* SERVICIOS */ 
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=49)
	BEGIN
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT CASE WHEN sc.IdPersona IS NULL OR sc.IdPersona=0 THEN -17 ELSE sc.IdPersona END AS IdPersona, ISNULL(sc.IdSocio,0) AS IdSocio,@idFactor,@factor,'Servicios',t.IdAuxiliar,mc.ValorDescripcion,mc.Puntos 
		FROM tCOMconfiguracionPagoServicios cps WITH (NOLOCK)
		INNER JOIN dbo.tSDOtransacciones t  WITH(NOLOCK) ON t.IdAuxiliar = cps.IdAuxiliar
		INNER JOIN  dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion = t.IdOperacion
															AND op.IdEstatus=1
															AND op.IdPersonaMovimiento>0
															AND op.IdPeriodo=@IdPeriodo
		LEFT JOIN @socios sc 
			ON sc.IdPersona=op.IdPersonaMovimiento
		INNER JOIN dbo.tPLDmatrizConfiguracionProductosServicios mc  WITH(NOLOCK) ON mc.tipo=2 AND mc.IdValor1 = t.IdAuxiliar
		WHERE cps.IdEstatus=1
		AND ((@idPersona=0) OR (op.IdPersonaMovimiento = @idPersona))
	END

	/* PRODUCTOS */
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=50)
	BEGIN	
		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT sc.IdPersona, sc.IdSocio,@idFactor,@factor,'Productos',c.IdProducto,CONCAT(c.NoCuenta,' - ',mc.ValorDescripcion),mc.Puntos 
		FROM @socios sc  
		INNER JOIN @cuentas c ON c.IdSocio = sc.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionProductosServicios mc  WITH(NOLOCK) ON mc.tipo=1 AND mc.IdValor1 = c.IdProducto
		WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))
	END

/*
██ ███    ██ ███████ ████████ ██████  ██    ██ ███    ███ ███████ ███    ██ ████████  ██████  ███████ 
██ ████   ██ ██         ██    ██   ██ ██    ██ ████  ████ ██      ████   ██    ██    ██    ██ ██      
██ ██ ██  ██ ███████    ██    ██████  ██    ██ ██ ████ ██ █████   ██ ██  ██    ██    ██    ██ ███████ 
██ ██  ██ ██      ██    ██    ██   ██ ██    ██ ██  ██  ██ ██      ██  ██ ██    ██    ██    ██      ██ 
██ ██   ████ ███████    ██    ██   ██  ██████  ██      ██ ███████ ██   ████    ██     ██████  ███████ 
                                                                                                      
                                                                                                      
 ██████  █████  ███    ██  █████  ██      ███████ ███████                                             
██      ██   ██ ████   ██ ██   ██ ██      ██      ██                                                  
██      ███████ ██ ██  ██ ███████ ██      █████   ███████                                             
██      ██   ██ ██  ██ ██ ██   ██ ██      ██           ██                                             
 ██████ ██   ██ ██   ████ ██   ██ ███████ ███████ ███████                                                                                                                                                                                                              
*/
	/*  |-------------------------------------------------------------|
						INSTRUMENTOS Y CANALES DE DISTRIBUCIÓN
		|-------------------------------------------------------------| */
	SET @idFactor=7; SET @factor='Canales e Instrumentos'

	/*	INSTRUMENTOS	*/
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=51)
	BEGIN
		IF @pDEBUG=1 SELECT 'Instrumentos'

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
	END

	/*	CANALES DE DISTRIBUCIÓN		*/
	IF EXISTS(SELECT 1 FROM @elementos e WHERE e.IdElemento=52)
	BEGIN
		IF @pDEBUG=1 SELECT 'Canales'

		INSERT @calificaciones(IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos)
		SELECT 
		sc.IdPersona, sc.IdSocio,@idFactor,@factor,'Canales',mc.IdValor1,mc.ValorDescripcion,mc.Puntos 
		FROM @tiposOperaciones o
		INNER JOIN @socios sc
			ON sc.IdSocio = o.IdSocio
		INNER JOIN dbo.tPLDmatrizConfiguracionInstrumentosCanales mc  WITH(NOLOCK) ON mc.tipo=2 AND mc.IdValor1 = o.IdTipoOperacion
		WHERE ((@idSocio=0) OR (sc.IdSocio = @idSocio))
	END

/*
 ██████  █████  ██      ██ ███████ ██  ██████  █████   ██████ ██  ██████  ███    ██ 
██      ██   ██ ██      ██ ██      ██ ██      ██   ██ ██      ██ ██    ██ ████   ██ 
██      ███████ ██      ██ █████   ██ ██      ███████ ██      ██ ██    ██ ██ ██  ██ 
██      ██   ██ ██      ██ ██      ██ ██      ██   ██ ██      ██ ██    ██ ██  ██ ██ 
 ██████ ██   ██ ███████ ██ ██      ██  ██████ ██   ██  ██████ ██  ██████  ██   ████    
*/

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
	
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--					GRABADO DE RESULTADOS

	-- Determinar si la evaluación fue para uno o todos los socios
	DECLARE @individual bit, @masiva BIT, @idEvaluacionRiesgo INT;
	
	IF @EvaluacionMasiva=1
	BEGIN
		SET @individual=0; SET @masiva=1
	END
	ELSE	
	BEGIN
		SET @individual=1; SET @masiva=0
	END
	

	DECLARE @NumCalificaciones AS INT=(SELECT COUNT(1) FROM @calificaciones)
	DECLARE @NumCalificacionesAgrupadas AS INT=(SELECT COUNT(1) FROM @calificacionesAgrupadas)
	DECLARE @NumCalificacionesFinales AS INT=(SELECT COUNT(1) FROM @calificacionesFinales)
	DECLARE @Calificacion AS NUMERIC(13,2)
	


	--SET @pDEBUG=1
	IF @pDEBUG<>1
	BEGIN
		/* ฅ^•ﻌ•^ฅ   JCA.21/09/2023.06:28 p. m. Nota: Se agrega validación de existencia de valores en variables de tabla, ya que se estaban generando encabezados si algunos detalles   */
		IF (@NumCalificaciones>0
			AND @NumCalificacionesAgrupadas>0
				AND @NumCalificacionesFinales>0
					AND (SELECT COUNT(1) FROM @calificacionesFinales c  
							INNER JOIN @socios sc ON sc.IdSocio = c.IdSocio
							INNER JOIN dbo.tPLDmatrizConfiguracionNivelesRiesgo n 
								ON c.Calificacion BETWEEN n.Valor1 AND n.Valor2 
									AND n.Tipo=IIF(sc.TipoSocio=4,2,sc.TipoSocio))>0
									)
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION;
 					 INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgo(Fecha,Agrupador,Individual,Masiva,IdEstatus) VALUES (@fechaEjecucion, @agrupador,@individual,@masiva,1)
					 SET @idEvaluacionRiesgo= SCOPE_IDENTITY();

					INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones (IdEvaluacionRiesgo,IdPersona,IdSocio,IdFactor,Factor,Elemento,Valor,ValorDescripcion,Puntos,IdEstatus)
					SELECT @idEvaluacionRiesgo,cal.IdPersona, cal.IdSocio, cal.IdFactor, cal.Factor, cal.Elemento, cal.Valor, cal.ValorDescripcion, cal.Puntos,1 
					FROM @calificaciones cal 
					--ORDER BY cal.IdSocio, cal.IdFactor, cal.Elemento

					INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas (IdEvaluacionRiesgo,IdSocio,IdFactor,Factor,SumaFactor,PonderacionFactor,PuntajeFactor,IdEstatus)
					SELECT @idEvaluacionRiesgo, cal.IdSocio, cal.IdFactor, cal.Factor, cal.SumaFactor, cal.PonderacionFactor, cal.PuntajeFactor,1 
					FROM @calificacionesAgrupadas cal 
					--ORDER BY cal.IdSocio

					INSERT INTO dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales (IdEvaluacionRiesgo,IdSocio,Calificacion,NivelDeRiesgo,NivelDeRiesgoDescripcion,IdEstatus)
					SELECT @idEvaluacionRiesgo, c.IdSocio, c.Calificacion, n.NivelRiesgo , n.NivelRiesgoDescripcion, 1 
					FROM @calificacionesFinales c  
					INNER JOIN @socios sc ON sc.IdSocio = c.IdSocio
					INNER JOIN dbo.tPLDmatrizConfiguracionNivelesRiesgo n ON c.Calificacion BETWEEN n.Valor1 AND n.Valor2 AND n.Tipo= sc.TipoSocio  			   		
				
				COMMIT TRANSACTION;	
				
				PRINT 'Calificaciones insertadas'

			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION;
				THROW 50005, N'>.< Algo ha ido mal con el grabado de los resultados!', 1;
			END CATCH;
		END	
		ELSE
			THROW 50005, N'>.< No hay resultados en las evaluaciones para grabar, informe al proveedor.', 1;
	END

	

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
	INNER JOIN dbo.tPLDmatrizConfiguracionNivelesRiesgo n ON c.Calificacion BETWEEN n.Valor1 AND n.Valor2 AND n.Tipo=IIF(sc.TipoSocio=4,2,sc.TipoSocio)
	

END
GO

SELECT 'pPLDevaluacionDeRiesgo CREADO' AS info
GO


