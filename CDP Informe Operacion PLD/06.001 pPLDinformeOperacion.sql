
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDinformeOperacion')
BEGIN
	DROP PROC pPLDinformeOperacion
	SELECT 'pPLDinformeOperacion BORRADO' AS info
END
GO

CREATE PROC pPLDinformeOperacion
	@pTipoOperacion	INT,
    @pIdInformeOperacion INT = NULL,
    @pIdOperacionPLD INT = NULL,
    @pNotas NVARCHAR(max) = NULL,
    @pArchivo VARBINARY(max) = NULL,
    @pAlta DATETIME = NULL,
    @pIdEstatus INT = NULL,
    @pIdSesion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;


	IF (@pTipoOperacion ='C')
    BEGIN
		INSERT INTO [dbo].[tPLDinformeOperacion] (IdOperacionPLD, Notas, Archivo, Alta, IdEstatus, IdSesion)
        VALUES (@pIdOperacionPLD, @pNotas, @pArchivo, GETDATE(), @pIdEstatus, @pIdSesion);

		RETURN 1
	END

    IF (@pTipoOperacion ='D')
    BEGIN
        UPDATE [dbo].[tPLDinformeOperacion]
        SET IdEstatus = 2
        WHERE IdInformeOperacion = @pIdInformeOperacion;

		RETURN 1
    END
    
END;
