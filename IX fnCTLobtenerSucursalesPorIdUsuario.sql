



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnCTLobtenerSucursalesPorIdUsuario')
BEGIN
	DROP FUNCTION dbo.fnCTLobtenerSucursalesPorIdUsuario
	SELECT 'fnCTLobtenerSucursalesPorIdUsuario BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnCTLobtenerSucursalesPorIdUsuario(
@pIdUsuario INT
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
	WHERE u.IdUsuario=@pIdUsuario
	GROUP BY up.IdSucursal
)
GO







