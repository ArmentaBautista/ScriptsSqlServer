


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPERarchivarHuellasDigitalesActualizadas')
BEGIN
	DROP PROC pPERarchivarHuellasDigitalesActualizadas
	SELECT 'pPERarchivarHuellasDigitalesActualizadas BORRADO' AS info
END
GO

CREATE PROC pPERarchivarHuellasDigitalesActualizadas
@idPersona INT=0,
@idUsuarioAlta INT=0,
@idSesion INT=0
AS
BEGIN

	BEGIN TRAN
      BEGIN TRY

			-- Volcado de datos originales
			INSERT INTO dbo.tPERhuellasDigitalesPersonaActualizaciones (IdHuella,IdPersona,NumeroHuella,HuellaDigital,IdUsuarioAlta,IdSesion)
			SELECT hp.IdHuella, hp.RelHuellasDigitalesPersona, hp.NumeroHuella, hp.HuellaDigital, @idUsuarioAlta, @idSesion 
			FROM dbo.tPERhuellasDigitalesPersona hp  WITH(NOLOCK) WHERE hp.RelHuellasDigitalesPersona=@idPersona AND hp.IdEstatus=1

			-- Borrado de huellas 
			DELETE FROM dbo.tPERhuellasDigitalesPersona WHERE RelHuellasDigitalesPersona=@idPersona AND IdEstatus=1
			
			COMMIT TRANSACTION
       END TRY
     BEGIN CATCH
            ROLLBACK TRANSACTION

			SELECT
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_STATE() AS ErrorState,
				ERROR_SEVERITY() AS ErrorSeverity,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_LINE() AS ErrorLine,
				ERROR_MESSAGE() AS ErrorMessage;
     END CATCH

END