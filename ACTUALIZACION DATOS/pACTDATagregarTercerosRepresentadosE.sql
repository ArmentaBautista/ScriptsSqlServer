
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pACTDATagregarTercerosRepresentadosE')
BEGIN
	DROP PROC pACTDATagregarTercerosRepresentadosE
	SELECT 'pACTDATagregarTercerosRepresentadosE BORRADO' AS info
END
GO

CREATE PROC pACTDATagregarTercerosRepresentadosE
@pFechaTrabajo DATE,
@pIdPersona INT,
@pIdSesion INT,
@Folio INT OUTPUT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION;
	    INSERT INTO dbo.tACTDATtercerosRepresentadosE(FechaTrabajo,IdPersona,IdSesion)
		VALUES (@pFechaTrabajo,@pIdPersona,@pIdSesion)

		SET @Folio=SCOPE_IDENTITY()		
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