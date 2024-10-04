USE intelixDEV
GO

/* @^..^@   JCA.03/02/2024.03:26 a. m. Nota: FIX DATOS TRANSACCIONALES SOCIOECONOMICOS  */
BEGIN TRY
	BEGIN TRANSACTION;

	--SELECT 
	--p.IdPersona, p.Nombre, p.Codigo AS NoSocio
	--,montoD.Descripcion,	montoD.RangoFin/2 AS PromedioMontoD
	--,montoR.Descripcion,	montoR.RangoFin/2 AS PromedioMontoR
	--,numD.Descripcion,		ROUND(numD.RangoFin/2,0) AS PromedioNumD
	--,numR.Descripcion,		ROUND(numR.RangoFin/2,0) AS PromedioNumR
	--, se.MontoDepositos, se.MontoRetiros,se.NumeroDepositos, se.NumeroRetiros
	UPDATE se 
	SET 
	se.MontoDepositos=CAST(montoD.RangoFin/2 AS NUMERIC(18,2)) ,
	se.MontoRetiros=CAST(montoR.RangoFin/2 AS NUMERIC(18,2)),
	se.NumeroDepositos=CAST(ROUND(numD.RangoFin/2,0) AS INTEGER),
	se.NumeroRetiros=CAST(ROUND(numR.RangoFin/2,0) AS INTEGER)
	FROM (
		SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre,p.IdSocioeconomico
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		) p 
		INNER JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) 
			ON se.IdSocioeconomico = p.IdSocioeconomico
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
GO



SELECT 
p.IdPersona, sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, 
p.IdSocioeconomico, p.Nombre
, se.MontoDepositos, se.MontoRetiros,se.NumeroDepositos, se.NumeroRetiros
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) 
	ON se.IdSocioeconomico = p.IdSocioeconomico
INNER JOIN dbo.tCTLestatusActual ea WITH (NOLOCK) 
	ON ea.IdEstatusActual = se.IdEstatusActual 
		AND ea.IdEstatus = 1
GO


