

IF(object_id('pPERresponsablesDeSucursal') is not null)
BEGIN
	DROP PROC pPERresponsablesDeSucursal
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE PROCEDURE pPERresponsablesDeSucursal
    @pIdSucursal INT,
    @pIdPersonaFisica INT,
    @pIdSesion INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificamos si ya existe un registro con el mismo IdSucursal, IdPersonaFisica y IdSesion
    IF EXISTS (
        SELECT 1
        FROM tCTLresponsablesDeSucursal  WITH(NOLOCK) 
        WHERE idestatus=1
			AND IdSucursal = @pIdSucursal
				AND IdPersonaFisica = @pIdPersonaFisica
    )
    BEGIN
        -- Si existe, actualizamos el registro existente con IdEstatus = 2
        UPDATE tPERresponsablesDeSucursal
        SET IdEstatus = 2
        WHERE IdSucursal = @pIdSucursal
			AND IdPersonaFisica = @pIdPersonaFisica
    END

    -- Insertamos un nuevo registro con IdEstatus = 1
    INSERT INTO tCTLresponsablesDeSucursal (IdSucursal, IdPersonaFisica, Alta, IdEstatus, IdSesion)
    VALUES (@pIdSucursal, @pIdPersonaFisica, GETDATE(), 1, @pIdSesion);
END
GO

