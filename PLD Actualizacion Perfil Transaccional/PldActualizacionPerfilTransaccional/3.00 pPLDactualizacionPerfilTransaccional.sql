

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDactualizacionPerfilTransaccional')
BEGIN
	DROP PROC dbo.pPLDactualizacionPerfilTransaccional
	SELECT 'pPLDactualizacionPerfilTransaccional BORRADO' AS info
END
GO

CREATE PROC dbo.pPLDactualizacionPerfilTransaccional
@pEvaluacionMasiva BIT=1,
@pIdPersona INT=0,
@pDEBUG AS BIT=0,
@pFechaTrabajo AS DATE
AS
BEGIN

	/* =^..^=   =^..^=   =^..^=    PARÁMETROS    =^..^=    =^..^=    =^..^= */
	DECLARE @PorcentajeVariacion AS NUMERIC(3,2)=3.0
	DECLARE @MesesEvaluar AS INT=6

	/* =^..^=   =^..^=   =^..^=    VARIABLES    =^..^=    =^..^=    =^..^= */
	DECLARE @EvaluacionMasiva BIT= @pEvaluacionMasiva

	IF @pDEBUG IS NULL SET @pDEBUG=0

	DECLARE @fechaTrabajo AS DATE = IIF(@pFechaTrabajo IS NULL OR @pFechaTrabajo='19000101',CURRENT_TIMESTAMP,@pFechaTrabajo) 
	DECLARE @fechaInicio AS DATE = DATEADD(MONTH,-@MesesEvaluar,@fechaTrabajo)
	
	
	DECLARE @idSocio AS INT = 0;
	DECLARE @idPersona AS INT = @pIdPersona 
	
	IF @EvaluacionMasiva=1
	BEGIN
		SET @idSocio=0;
		SET @idPersona=0;
	END
	ELSE
	BEGIN
		SET @idSocio = (SELECT sc.IdSocio FROM tscssocios sc  WITH(NOLOCK) WHERE sc.IdPersona=@idPersona)
	END

	IF @pDEBUG=1 SELECT 'Parámetros' AS Info, @idSocio AS idSocio, @idPersona AS idPersona

	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	--								TABLAS
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */

	/************************************* TRANSACCIONES DE LOS ÚLTIMOS SEIS MESES *************************************/
	DECLARE @financieras TABLE(
		IdTransaccion INT NOT NULL PRIMARY KEY,
		IdOperacion INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Fecha DATE NOT NULL,
		MontoSubOperacion NUMERIC(11,2) NULL DEFAULT 0,
		IdCuenta INT NOT NULL,
		IdTipoOperacion	INT,
		
		INDEX IxIdTipoSubOperacion(IdTipoSubOperacion),
		INDEX IxIdIdCuenta(IdCuenta)
	)

	IF @pDEBUG=1 
		SELECT 'Inicia inserción de financieras' + CAST(GETDATE() AS VARCHAR(32))

	INSERT @financieras (IdTransaccion,IdOperacion,IdTipoSubOperacion,Fecha,MontoSubOperacion,IdCuenta,IdTipoOperacion)
	SELECT tf.IdTransaccion,tf.IdOperacion,tf.IdTipoSubOperacion,tf.Fecha,tf.MontoSubOperacion,tf.IdCuenta,op.IdTipoOperacion
	from dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
	INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
		ON op.IdOperacion = tf.IdOperacion
			AND op.IdTipoOperacion IN (1,10,32) -- ticket, mov bancario, spei
	WHERE tf.IdEstatus=1 
		AND tf.IdOperacion<>0 
			AND tf.IdTipoSubOperacion IN (500,501) 
				AND tf.Fecha BETWEEN @fechaInicio AND @fechaTrabajo

	IF @pDEBUG=1 
		SELECT 'Termina inserción de financieras' + CAST(GETDATE() AS VARCHAR(32))
	
	IF @pDEBUG=1 
		SELECT 'Financieras' AS Info, f.IdTransaccion,f.IdOperacion,f.IdTipoSubOperacion,f.Fecha,f.MontoSubOperacion,f.IdCuenta FROM @financieras f 

	/************************************** CUENTAS  **************************************/
	DECLARE @cuentas TABLE(
		IdCuenta INT NOT NULL PRIMARY KEY,
		IdSocio INT NOT NULL

		INDEX IxIdSocio(IdSocio)
	)

	INSERT INTO @cuentas (IdCuenta,IdSocio)
	SELECT c.IdCuenta, c.IdSocio
	from dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN (
				SELECT idcuenta 
				FROM @financieras 
				GROUP BY IdCuenta
				) AS f
		ON f.IdCuenta=c.IdCuenta
	WHERE ((@idSocio=0) OR (C.IdSocio= @idSocio))

	IF @pDEBUG=1 
		SELECT 'Cuentas' AS Info, * FROM @cuentas

	/************************************* SOCIOS  Y DATOS TRANSACCIONALES *************************************/
	DECLARE @socios AS TABLE(
		IdSocio	INT PRIMARY KEY,
		IdPersona INT,
		IdSocioeconomico INT,
		NumeroDepositos INT,
		NumeroRetiros	INT,
		MontoDepositos	NUMERIC(13,2),
		MontoRetiros	NUMERIC(13,2)	
	)

	INSERT INTO @socios
	SELECT sc.IdSocio, sc.IdPersona, eco.IdSocioeconomico,eco.NumeroDepositos,eco.NumeroRetiros, eco.MontoDepositos,eco.MontoRetiros
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN (
				SELECT cta.idsocio 
				FROM @cuentas cta 
				GROUP BY cta.IdSocio
				) c
		ON c.IdSocio = sc.IdSocio
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdPersona = sc.IdPersona
			AND p.IdSocioeconomico<>0
	INNER JOIN dbo.tSCSpersonasSocioeconomicos eco  WITH(NOLOCK) 
		ON eco.IdSocioeconomico = p.IdSocioeconomico
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = eco.IdEstatusActual
			AND ea.IdEstatus=1	
	WHERE sc.IdEstatus=1
	AND NOT EXISTS (
					SELECT d.IdSocio
					FROM dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
					WHERE d.IdSocio=sc.IdSocio
						AND d.Fecha BETWEEN @fechaInicio AND @fechaTrabajo
					)
		
	IF @pDEBUG=1 SELECT 'Socios' AS Info, * FROM @socios

	/************************************* TRANSACCIONES DE SOCIOS FILTRADOS *************************************/
	DECLARE @tf TABLE(
		IdTransaccion INT NOT NULL PRIMARY KEY,
		IdOperacion INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Fecha DATE NOT NULL,
		MontoSubOperacion NUMERIC(11,2) NULL DEFAULT 0,
		IdCuenta INT NOT NULL,
		IdTipoOperacion	INT,
		IdSocio	INT,
		IdPersona	INT,
		
		INDEX IxIdTipoSubOperacion(IdTipoSubOperacion),
		INDEX IxIdIdCuenta(IdCuenta)
	)

	INSERT @tf (IdTransaccion,IdOperacion,IdTipoSubOperacion,Fecha,MontoSubOperacion,IdCuenta,IdTipoOperacion,IdSocio,IdPersona)
	SELECT tf.IdTransaccion,tf.IdOperacion,tf.IdTipoSubOperacion,tf.Fecha,tf.MontoSubOperacion,tf.IdCuenta,tf.IdTipoOperacion,sc.IdSocio, sc.IdPersona
	from @financieras tf 
	INNER JOIN @cuentas c
		ON c.IdCuenta = tf.IdCuenta
	INNER JOIN @socios sc 
		ON sc.IdSocio = c.IdSocio
	
	--DELETE FROM	@financieras

	IF @pDEBUG=1 
		SELECT 'TF' AS Info, f.IdTransaccion,f.IdOperacion,f.IdTipoSubOperacion,f.Fecha,f.MontoSubOperacion,f.IdCuenta,IdTipoOperacion,IdSocio,IdPersona FROM @tf f 

	/************************************* COMPARACIÓN MONTOS DECLARADOS Y TRANSACCIONADOS *************************************/

	-- Tabla totales operaciones
	DECLARE @totales AS TABLE(
		IdSocio				INT,
		AvgNumDepositos		NUMERIC(13,2),
		AvgNumRetiros		NUMERIC(13,2),
		AvgMontoDepositos	NUMERIC(13,2),
		AvgMontoRetiros		NUMERIC(13,2)
	)

	INSERT @totales
	SELECT 
	tf.IdSocio,
	SUM(IIF(tf.IdTipoSubOperacion=500,1,0))/@MesesEvaluar,
	SUM(IIF(tf.IdTipoSubOperacion=501,1,0))/@MesesEvaluar,
	SUM(IIF(tf.IdTipoSubOperacion=500,tf.MontoSubOperacion,0))/@MesesEvaluar,
	SUM(IIF(tf.IdTipoSubOperacion=501,tf.MontoSubOperacion,0))/@MesesEvaluar
	FROM @tf tf  
	GROUP BY tf.IdSocio	

	IF @pDEBUG=1 SELECT 'Totales' AS Info, * FROM @totales
	
	

	BEGIN TRY
		BEGIN TRANSACTION;
	   
		INSERT INTO dbo.tPLDactualizacionesPerfilTransaccionalE (PorcentajeVariacion,MesesEvaluados,Inicio,Fin)
		SELECT @PorcentajeVariacion,@MesesEvaluar,@fechaInicio,@fechaTrabajo
	
		DECLARE @Id AS INT=SCOPE_IDENTITY()
		
		INSERT INTO dbo.tPLDactualizacionesPerfilTransaccionalD
		(IdActualizacionPerfilTransaccional,IdPersona,IdSocio,IdSocioeconomico,DatoTransaccional,ValorDeclaracion,ValorOperaciones)
		SELECT 
		@Id
		,sc.IdPersona
		,sc.IdSocio 
		,sc.IdSocioeconomico
		,1
		,sc.NumeroDepositos
		,t.AvgNumDepositos
		FROM @socios sc
		INNER JOIN @totales t
			ON t.IdSocio = sc.IdSocio
		WHERE t.AvgNumDepositos>=(sc.NumeroDepositos*@PorcentajeVariacion)

		INSERT INTO dbo.tPLDactualizacionesPerfilTransaccionalD
		(IdActualizacionPerfilTransaccional,IdPersona,IdSocio,IdSocioeconomico,DatoTransaccional,ValorDeclaracion,ValorOperaciones)
		SELECT 
		@Id
		,sc.IdPersona
		,sc.IdSocio 
		,sc.IdSocioeconomico
		,2
		,sc.NumeroRetiros
		,t.AvgNumRetiros
		FROM @socios sc
		INNER JOIN @totales t
			ON t.IdSocio = sc.IdSocio
		WHERE t.AvgNumRetiros>=(sc.NumeroRetiros*@PorcentajeVariacion)

		INSERT INTO dbo.tPLDactualizacionesPerfilTransaccionalD
		(IdActualizacionPerfilTransaccional,IdPersona,IdSocio,IdSocioeconomico,DatoTransaccional,ValorDeclaracion,ValorOperaciones)
		SELECT 
		@Id
		,sc.IdPersona
		,sc.IdSocio 
		,sc.IdSocioeconomico
		,3
		,sc.MontoDepositos
		,t.AvgMontoDepositos
		FROM @socios sc
		INNER JOIN @totales t
			ON t.IdSocio = sc.IdSocio
		WHERE t.AvgMontoDepositos>=(sc.MontoDepositos*@PorcentajeVariacion)

		INSERT INTO dbo.tPLDactualizacionesPerfilTransaccionalD
		(IdActualizacionPerfilTransaccional,IdPersona,IdSocio,IdSocioeconomico,DatoTransaccional,ValorDeclaracion,ValorOperaciones)
		SELECT 
		@Id
		,sc.IdPersona
		,sc.IdSocio 
		,sc.IdSocioeconomico
		,4
		,sc.MontoRetiros
		,t.AvgMontoRetiros
		FROM @socios sc
		INNER JOIN @totales t
			ON t.IdSocio = sc.IdSocio
		WHERE t.AvgMontoRetiros>=(sc.MontoRetiros*@PorcentajeVariacion)

	    UPDATE soc SET soc.NumeroDepositos=TRY_CAST(d.ValorOperaciones AS INT)
        FROM dbo.tSCSpersonasSocioeconomicos soc 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdSocioeconomico = soc.IdSocioeconomico
				AND d.IdActualizacionPerfilTransaccional=@Id
					AND d.DatoTransaccional=1

		UPDATE soc SET soc.NumeroRetiros=TRY_CAST(d.ValorOperaciones AS INT)
        FROM dbo.tSCSpersonasSocioeconomicos soc 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdSocioeconomico = soc.IdSocioeconomico
				AND d.IdActualizacionPerfilTransaccional=@Id
					AND d.DatoTransaccional=2
				 
		UPDATE soc SET soc.MontoDepositos=d.ValorOperaciones
        FROM dbo.tSCSpersonasSocioeconomicos soc 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdSocioeconomico = soc.IdSocioeconomico
				AND d.IdActualizacionPerfilTransaccional=@Id
					AND d.DatoTransaccional=3

		UPDATE soc SET soc.MontoRetiros=d.ValorOperaciones
        FROM dbo.tSCSpersonasSocioeconomicos soc 
		INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
			ON d.IdSocioeconomico = soc.IdSocioeconomico
				AND d.IdActualizacionPerfilTransaccional=@Id
					AND d.DatoTransaccional=4
		
		IF @pDEBUG=1
		begin
			SELECT 
			e.IdActualizacionPerfilTransaccional,
            e.Fecha,
            e.PorcentajeVariacion,
            e.MesesEvaluados,
            e.Inicio,
            e.Fin,
            d.IdActualizacionPerfilTransaccional,
            d.IdPersona,
            d.IdSocio,
            d.IdSocioeconomico,
            d.DatoTransaccional,
            d.ValorDeclaracion,
            d.ValorOperaciones,
            d.Fecha
			FROM dbo.tPLDactualizacionesPerfilTransaccionalE e  WITH(NOLOCK) 
			INNER JOIN dbo.tPLDactualizacionesPerfilTransaccionalD d  WITH(NOLOCK) 
				ON d.IdActualizacionPerfilTransaccional = e.IdActualizacionPerfilTransaccional
			WHERE e.IdActualizacionPerfilTransaccional=@Id

			ROLLBACK TRANSACTION
			--RETURN 0
		END 
		else
			COMMIT TRANSACTION;		
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		
		 SELECT
	    ERROR_NUMBER() AS ErrorNumber,
	    ERROR_STATE() AS ErrorState,
	    ERROR_SEVERITY() AS ErrorSeverity,
	    ERROR_PROCEDURE() AS ErrorProcedure,
	    ERROR_LINE() AS ErrorLine,
	    ERROR_MESSAGE() AS ErrorMessage;
		
	END CATCH;
	
END
GO
