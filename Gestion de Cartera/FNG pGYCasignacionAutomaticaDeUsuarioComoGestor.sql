
IF (OBJECT_ID('pGYCasignacionAutomaticaDeUsuarioComoGestor') IS NOT NULL)
    BEGIN
        DROP PROC pGYCasignacionAutomaticaDeUsuarioComoGestor
        SELECT 'pGYCasignacionAutomaticaDeUsuarioComoGestor BORRADO' AS info
    END
GO

CREATE PROC pGYCasignacionAutomaticaDeUsuarioComoGestor
AS
BEGIN
DECLARE @FechaTrabajo as DATE = current_timestamp;

DECLARE @ctas as TABLE(
    IdCuenta INT PRIMARY KEY,
    IdUsuario INT,
    IdEstatus INT,
    IdSocio INT,
    IdSucursal INT,
    Monto   INT
                      );

DECLARE @personas as TABLE (
    IdUsuario INT,
    IdPersona INT,
    IdGestor INT
                           )

    insert into @ctas
    select c.idcuenta, c.IdUsuarioAlta, c.IdEstatus,c.IdSocio,c.IdSucursal,c.Monto
    from tAYCcuentas c WITH (NOLOCK)
    where FechaActivacion = @FechaTrabajo

    insert into @personas
    SELECT u.IdUsuario, g.IdPersona, g.IdGestor
    FROM tCTLusuarios u WITH (NOLOCK)
    inner JOIN tGYCgestores g WITH (NOLOCK)
        on u.IdPersonaFisica=g.IdPersona

BEGIN TRY
	BEGIN TRANSACTION;
            update ce set IdGestor= p.IdGestor
            from @ctas c
            inner join tAYCcuentasEstadisticas ce WITH (NOLOCK)
                on c.IdCuenta=ce.IdCuenta
            inner join @personas p
                on p.IdUsuario=c.IdUsuario

            insert into dbo.tGYCasignacionCarteraD
            (
                IdCuenta,
                IdGestor,
                Capital,
                Total,
                SaldoTotal,
                IdEstatusCartera,
                IdEstatus,
                IdSocio,
                Idsucursal,
                FechaAsignacion,
                IdEstatusCuenta
            )
            SELECT c.IdCuenta, p.IdGestor,c.Monto,c.Monto,c.Monto,28,1,c.IdSocio,c.IdSucursal,@FechaTrabajo,c.IdEstatus
            FROM @ctas c
            inner join @personas p
                on p.IdUsuario=c.IdUsuario

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
--TODO mandar correo con los datos del error
-- 	 SELECT
--     ERROR_NUMBER() AS ErrorNumber,
--     ERROR_STATE() AS ErrorState,
--     ERROR_SEVERITY() AS ErrorSeverity,
--     ERROR_PROCEDURE() AS ErrorProcedure,
--     ERROR_LINE() AS ErrorLine,
--     ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

--TODO mandar correo indicando el número de cuentas asignadas

END
GO


