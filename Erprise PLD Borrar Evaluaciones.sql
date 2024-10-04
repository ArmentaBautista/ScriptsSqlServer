

BEGIN TRY
	BEGIN TRANSACTION;
   
    DECLARE @Evals TABLE( IdEvaluacionRiesgo INT)

	INSERT @Evals
	SELECT e.IdEvaluacionRiesgo FROM tPLDmatrizEvaluacionesRiesgo e  WITH(NOLOCK) WHERE e.Fecha='20240111'

	DELETE t
	FROM tPLDmatrizEvaluacionesRiesgoCalificacionesFinales t
	INNER JOIN @Evals e ON e.IdEvaluacionRiesgo = t.IdEvaluacionRiesgo
	
	DELETE t
	FROM tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas t
	INNER JOIN @Evals e ON e.IdEvaluacionRiesgo = t.IdEvaluacionRiesgo

	DELETE t
	FROM tPLDmatrizEvaluacionesRiesgoCalificaciones t
	INNER JOIN @Evals e ON e.IdEvaluacionRiesgo = t.IdEvaluacionRiesgo

	DELETE t
	FROM tPLDmatrizEvaluacionesRiesgo t
	INNER JOIN @Evals e ON e.IdEvaluacionRiesgo = t.IdEvaluacionRiesgo
		
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

