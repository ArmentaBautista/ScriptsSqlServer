

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnCTLvalidarSucursalPorUsuario')
BEGIN
	DROP FUNCTION dbo.fnCTLvalidarSucursalPorUsuario
	SELECT 'fnCTLvalidarSucursalPorUsuario BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnCTLvalidarSucursalPorUsuario(
@pIdSucursal INT,
@pIdUsuario INT,
@pIdSesion INT
)
RETURNS BIT
AS
BEGIN
	DECLARE @Respuesta AS BIT=0;

	IF @pIdSesion<>0
	BEGIN
		SELECT @pIdUsuario=ss.IdUsuario FROM dbo.tCTLsesiones ss  WITH(NOLOCK) WHERE ss.IdSesion=@pIdSesion
	END
	
	IF EXISTS(
				SELECT 1 
				FROM dbo.tCTLusuarios u WITH(NOLOCK) 
				INNER JOIN dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) 
					ON up.IdRel=u.IdRelPerfiles
						AND up.IdSucursal=@pIdSucursal
				INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
					ON ea.IdEstatusActual = up.IdEstatusActual
						AND ea.IdEstatus=1
				WHERE u.IdUsuario=@pIdUsuario
				GROUP BY up.IdSucursal
				)
		SET @Respuesta=1
	ELSE
		SET @Respuesta=0

	RETURN @Respuesta
END
GO