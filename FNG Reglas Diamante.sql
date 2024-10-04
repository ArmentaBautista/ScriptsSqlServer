


DECLARE @pEvaluacionMasiva BIT=0
DECLARE @pIdSocio INT=134917
DECLARE @pIdProducto INT=14
DECLARE @pMontoSolicitado NUMERIC(13,2)=200000
DECLARE @pDEBUG AS BIT=1
DECLARE @pFechaTrabajo AS DATE




	/* =^..^=   =^..^=   =^..^=    PARÁMETROS    =^..^=    =^..^=    =^..^= */
	DECLARE @MesesEvaluar AS INT=6

	/* =^..^=   =^..^=   =^..^=    VARIABLES    =^..^=    =^..^=    =^..^= */
	DECLARE @EvaluacionMasiva BIT= @pEvaluacionMasiva
	DECLARE @producto AS VARCHAR(16)=(SELECT pf.IdProductoFinanciero FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) WHERE pf.IdProductoFinanciero=@pIdProducto)
	DECLARE @idSocio AS INT = @pIdSocio;
	DECLARE @idPersona AS INT = 0
	DECLARE @fechaTrabajo AS DATE = IIF(@pFechaTrabajo IS NULL OR @pFechaTrabajo='19000101',CURRENT_TIMESTAMP,@pFechaTrabajo) 
	DECLARE @fechaInicio AS DATE = DATEADD(MONTH,-@MesesEvaluar,@fechaTrabajo)

	IF @pDEBUG IS NULL SET @pDEBUG=0
	
	IF @EvaluacionMasiva=1
	BEGIN
		SET @idSocio=0;
		SET @idPersona=0;
	END
	ELSE
	BEGIN
		SET @idPersona = (SELECT sc.IdPersona FROM tscssocios sc  WITH(NOLOCK) WHERE sc.IdSocio=@idSocio)
	END

	--IF @pDEBUG=1 select @idSocio AS idSocio, @idPersona AS idPersona

	/* =^..^=   =^..^=   =^..^=  TABLAS  =^..^=    =^..^=    =^..^= */
	
	/*** DATOS SOCIOECONÓMICOS ***/
	DECLARE @tipos AS TABLE(
		Padre VARCHAR(250),
		IdTipoD INT,
		Descripcion VARCHAR(250)
	)

	INSERT @tipos
	SELECT 
	dp.Descripcion, d.IdTipoD, d.Descripcion
	FROM dbo.tCTLtiposD d  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLtiposD dp  WITH(NOLOCK) 
		ON dp.IdTipoD = d.IdTipoDPadre
	WHERE d.IdTipoE = 76 
		AND d.IdTipoDPadre>0

	--IF @pDEBUG=1 SELECT * FROM @tipos

	/************************************* DATOS SOCIOECONÓMICOS *************************************/
	DECLARE @socios AS TABLE(
		IdSocio	INT PRIMARY KEY,
		IdPersona INT,
		NoSocio VARchar(20),
		Nombre Varchar(250),
		IdAnalisisCrediticio INT,
		IdTipoDresidencia INT,
		Residencia VARCHAR(250),
		IdTipoDmorocidadUltimoCredito INT,
		MoraUltCredito  VARCHAR(250),
		IdTipoDnumeroMesesMoraMaxima INT,
		MesesMora  VARCHAR(250),
		IdTipoDburoCredito INT,
		Buro  VARCHAR(250),
		IdTipoDreferenciasCrediticias INT,
		ReferenciasCred  VARCHAR(250)
	)

	INSERT INTO @socios
	SELECT 
	  sc.IdSocio
	, sc.IdPersona
	, sc.Codigo
	, p.Nombre
	, ac.IdAnalisisCrediticio
	, ac.IdTipoDresidencia
	, tres.Descripcion
	, ac.IdTipoDmorocidadUltimoCredito
	, tUltCred.Descripcion
	, ac.IdTipoDnumeroMesesMoraMaxima
	, tMora.Descripcion
	, ac.IdTipoDburoCredito
	, tBuro.Descripcion
	, ac.IdTipoDreferenciasCrediticias
	, tref.Descripcion
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) 
		ON ac.IdPersona = p.IdPersona
	INNER JOIN @tipos tRes
		ON tRes.IdTipoD=ac.IdTipoDresidencia
	INNER JOIN @tipos tUltCred
		ON tUltCred.IdTipoD=ac.IdTipoDmorocidadUltimoCredito
	INNER JOIN @tipos tMora
		ON tMora.IdTipoD=ac.IdTipoDnumeroMesesMoraMaxima
	INNER JOIN @tipos tBuro
		ON tBuro.IdTipoD=ac.IdTipoDburoCredito
	INNER JOIN @tipos tRef
		ON tRef.IdTipoD = ac.IdTipoDreferenciasCrediticias
	WHERE ((@idSocio=0) OR (sc.IdSocio= @idSocio))

	IF @pDEBUG=1 SELECT s.* FROM @socios s ORDER BY s.Nombre

	/**** EVALUACIÓN ****/
	DECLARE @valoresEval AS TABLE(
		IdProducto INT,
		Producto VARCHAR(32),
		MontoMenor NUMERIC(13,2),
		MontoMayor NUMERIC(13,2),
		IdTipoDresidencia INT,
		IdTipoDmorocidadUltimoCredito INT,
		IdTipoDnumeroMesesMoraMaxima INT,
		IdTipoDburoCredito INT,
		IdTipoDreferenciasCrediticias INT,
		Avales	SMALLINT,
		Garantia NUMERIC(3,2)
	)
	/*
		Productos
		IdProductoFinanciero	Codigo	Descripcion
		14						PD		PRÉSTAMO DIAMANTE
		26						PJ		PRÉSTAMO JUBILADO DIAMANTE
		24						SE		PRÉSTAMO SOCIO EXCELENTE

		IdTipoD	Codigo	Descripcion
		644		TPRES1	PROPIA
		645		TPRES2	RENTADA
		646		TPRES3	FAMILIAR
		647		TPRES4	OTROS
		2279	TPRES6	PRESTADA
		2280	TPRES5	EN PROCESO DE PAGO

		TIPO NÚMERO DE MESES DE MORA MÁXIMA	2284	DE 0 DÍAS
		TIPO NÚMERO DE MESES DE MORA MÁXIMA	2285	DE 1 A 30 DÍAS
		TIPO NÚMERO DE MESES DE MORA MÁXIMA	2286	DE 31 A 60 DÍAS
		TIPO NÚMERO DE MESES DE MORA MÁXIMA	2287	DE 61 A 90 DÍAS
		TIPO NÚMERO DE MESES DE MORA MÁXIMA	2288	MÁS DE 90 DÍAS

		TIPO DE BURÓ DE CRÉDITO	2289	0 Y 1
		TIPO DE BURÓ DE CRÉDITO	2290	2 Y 3
		TIPO DE BURÓ DE CRÉDITO	2291	4 Y 5
		TIPO DE BURÓ DE CRÉDITO	2292	6 Y 7
		TIPO DE BURÓ DE CRÉDITO	2293	96 Y 97
		TIPO DE BURÓ DE CRÉDITO	2294	99
		
	*/

	INSERT INTO @valoresEval (IdProducto,Producto,MontoMenor,MontoMayor,IdTipoDresidencia,IdTipoDmorocidadUltimoCredito
	,IdTipoDnumeroMesesMoraMaxima,IdTipoDburoCredito,IdTipoDreferenciasCrediticias,Avales,Garantia)
	VALUES 
	(14,'PD',1000,200000,644,0,2284,2289,0,0,1),
	(14,'PD',1000,200000,644,0,2285,2290,0,0,1),
	(14,'PD',1000,200000,644,0,2286,2291,0,1,1),
	(14,'PD',1000,200000,644,0,2287,2292,0,1,1),

	(14,'PD',1000,200000,644,0,2288,2293,0,1,1),
	(14,'PD',1000,200000,644,0,2288,2294,0,-1,-1),
	(14,'PD',1000,200000,644,0,2288,2293,0,1,1),
	(14,'PD',1000,200000,644,0,2288,2294,0,-1,-1)

	--IF @pDEBUG=1 SELECT * FROM @valoresEval
	
	SELECT 
	--sc.IdSocio,sc.IdPersona
	 sc.NoSocio
	,sc.Nombre
	,sc.Residencia
	,sc.MoraUltCredito
	,sc.MesesMora
	,sc.Buro
	,sc.ReferenciasCred
	,@pMontoSolicitado AS MontoSolicitado
	,eval.MontoMenor,
     eval.MontoMayor,
     eval.Avales,
     eval.Garantia
	FROM @socios sc
	INNER JOIN @valoresEval eval
		ON eval.Producto='PD'
			AND @pMontoSolicitado BETWEEN eval.MontoMenor AND eval.MontoMayor
				AND eval.IdTipoDburoCredito = sc.IdTipoDburoCredito
					AND eval.IdTipoDnumeroMesesMoraMaxima = sc.IdTipoDnumeroMesesMoraMaxima

					-- 
					 
				