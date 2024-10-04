


IF(object_id('pLstPERresponsablesDeSucursalActivos') is not null)
BEGIN
	DROP PROC pLstPERresponsablesDeSucursalActivos
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE PROCEDURE pLstPERresponsablesDeSucursalActivos
AS
BEGIN    
        SELECT 1
        FROM tCTLresponsablesDeSucursal rs WITH(NOLOCK) 
        INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON rs.idsucursal=suc.IdSucursal
		INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
			ON pf.IdPersonaFisica=rs.IdPersonaFisica
		WHERE rs.idestatus=1
END
GO

