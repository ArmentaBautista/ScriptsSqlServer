

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pDIGinsertarArchivo')
BEGIN
	DROP PROC pDIGinsertarArchivo
	SELECT 'pDIGinsertarArchivo BORRADO' AS info
END
GO

CREATE PROC pDIGinsertarArchivo
@IdArchivoInfo AS INT=0,
@Archivo AS VARBINARY(max)=NULL
AS
BEGIN

BEGIN TRAN ARCHIVO

	BEGIN TRY
	-- Mandar a baja el archivo activo
	UPDATE a SET a.IdEstatus=2 FROM dbo.tDIGarchivos a WHERE a.IdEstatus=1 AND a.IdArchivoInfo=@IdArchivoInfo;

	-- Inserción de archivo
	INSERT INTO dbo.tDIGarchivos (IdArchivoInfo,Archivo)
	VALUES
	(   @IdArchivoInfo,       -- IdArchivoInfo - int
	    @Archivo    -- Archivo - varbinary(max)
	)


		ROLLBACK TRAN ARCHIVO
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN ARCHIVO
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage
	END CATCH

END -- fin del SP