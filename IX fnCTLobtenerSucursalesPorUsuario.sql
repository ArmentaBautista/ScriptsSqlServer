
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnCTLobtenerSucursalesPorUsuario')
BEGIN
	DROP FUNCTION dbo.fnCTLobtenerSucursalesPorUsuario
	SELECT 'fnCTLobtenerSucursalesPorUsuario BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnCTLobtenerSucursalesPorUsuario(
@pUsuario VARCHAR(40)
)
RETURNS TABLE
AS
RETURN(
	SELECT up.IdSucursal 
	FROM dbo.tCTLusuarios u WITH(NOLOCK) 
	INNER JOIN dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) 
		ON up.IdRel=u.IdRelPerfiles
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = up.IdEstatusActual
			AND ea.IdEstatus=1
	WHERE u.Usuario=@pUsuario
	GROUP BY up.IdSucursal
)
GO