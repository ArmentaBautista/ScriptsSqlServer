



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnCTLobtenerSucursalesUsuarioPorIdSesion')
BEGIN
	DROP FUNCTION dbo.fnCTLobtenerSucursalesUsuarioPorIdSesion
	SELECT 'fnCTLobtenerSucursalesUsuarioPorIdSesion BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnCTLobtenerSucursalesUsuarioPorIdSesion(
@pIdSesion INT
)
RETURNS TABLE
AS
RETURN(
	SELECT up.IdSucursal ,u.IdUsuario
	FROM dbo.tCTLusuarios u WITH(NOLOCK) 
	INNER JOIN tctlsesiones ss  WITH(NOLOCK) 
		ON ss.IdUsuario = u.IdUsuario
			AND ss.IdSesion=@pIdSesion
	INNER JOIN dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) 
		ON up.IdRel=u.IdRelPerfiles
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = up.IdEstatusActual
			AND ea.IdEstatus=1
	GROUP BY up.IdSucursal ,u.IdUsuario
)
GO







