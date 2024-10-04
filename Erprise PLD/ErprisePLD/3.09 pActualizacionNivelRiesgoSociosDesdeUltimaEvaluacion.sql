

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion')
BEGIN
	DROP PROC pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion
	SELECT 'pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion BORRADO' AS info
END
GO

CREATE PROC pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion
@pMostrarCifras AS BIT=0
AS
BEGIN
-- 3.08 pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion	
	BEGIN TRY
    
		IF @pMostrarCifras=1
		BEGIN
			SELECT sc.IdListaDnivelRiesgo, sc.DescripcionNivelRiesgo, COUNT(1)
			FROM dbo.tSCSsocios sc  WITH(NOLOCK)
			WHERE sc.IdEstatus =1
			GROUP BY sc.IdListaDnivelRiesgo, sc.DescripcionNivelRiesgo	   
		END

		BEGIN TRANSACTION;
			UPDATE sc
			SET sc.IdListaDnivelRiesgo = CASE eval.NivelDeRiesgo WHEN 1 THEN -46 WHEN 2 THEN -45 WHEN 3 THEN -44 END
			, sc.DescripcionNivelRiesgo = UPPER(eval.NivelDeRiesgoDescripcion)
			, sc.CalificacionNivelRiesgo = eval.Calificacion
			FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
			INNER JOIN dbo.fnPLDultimaEvaluacionPorSocio(0) eval
				ON eval.IdSocio = sc.IdSocio	 			
		COMMIT TRANSACTION;
		
		IF @pMostrarCifras=1
		BEGIN
			SELECT sc.IdListaDnivelRiesgo, sc.DescripcionNivelRiesgo, COUNT(1)
			FROM dbo.tSCSsocios sc  WITH(NOLOCK)
			WHERE sc.IdEstatus =1
			GROUP BY sc.IdListaDnivelRiesgo, sc.DescripcionNivelRiesgo	   
		END

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

IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pActualizacionNivelRiesgoSociosDesdeUltimaEvaluacion')
END
GO




