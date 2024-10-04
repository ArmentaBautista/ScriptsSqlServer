


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLpermisosPorPerfilPorUsuario')
BEGIN
	DROP PROC pCTLpermisosPorPerfilPorUsuario
	SELECT 'pCTLpermisosPorPerfilPorUsuario BORRADO' AS info
END
GO

CREATE PROC pCTLpermisosPorPerfilPorUsuario
@pTipoOperacion AS VARCHAR(32)='',
@pUsuario AS VARCHAR(40)='',
@pIdRecurso AS INT=0,
@pSucursal AS VARCHAR(12)=''
AS
BEGIN
	-- Variables
	DECLARE @TipoOperacion AS VARCHAR(32) = @pTipoOperacion;
	DECLARE @Usuario AS VARCHAR(40) = @pUsuario;
	DECLARE @IdRecurso AS INT= @pIdRecurso;
	DECLARE @Sucursal AS  VARCHAR(12)= @pSucursal

	IF @TipoOperacion='PERMISOS_USUARIO'
	BEGIN
			SELECT 
			 [SucursalCodigo]		= suc.Codigo
			,[SucursalDescripcion]	= suc.Descripcion
			, u.IdUsuario
			, u.Usuario
			, per.IdPerfil
			, [PerfilCodigo]		= per.Codigo
			, [PerfilDescripcion]	= per.Descripcion
			, p.IdPermiso
			, rec.IdRecurso
			, [RecursoDescripcion]	= rec.Descripcion
			FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) ON u.IdRelPerfiles=up.IdRel
			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = up.IdEstatusActual AND ea.IdEstatus=1
			INNER JOIN dbo.tCATperfiles per  WITH(NOLOCK) ON per.IdPerfil = up.IdPerfil AND per.IdPerfil<>0
			INNER JOIN dbo.tCTLestatusActual eaper  WITH(NOLOCK) ON eaper.IdEstatusActual = per.IdEstatusActual AND eaper.IdEstatus=1
			INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = up.IdSucursal
			INNER JOIN dbo.tCTLpermisos p  WITH(NOLOCK) ON p.IdPerfil = per.IdPerfil
			INNER JOIN dbo.tCTLrecursos rec  WITH(NOLOCK) ON rec.IdRecurso = p.IdRecurso
			WHERE u.Usuario=@Usuario
			ORDER BY suc.IdSucursal, per.IdPerfil

			RETURN 1
	END

	IF @TipoOperacion='PERMISO_RECURSO_USUARIO'
	BEGIN
			SELECT 
			 [SucursalCodigo]		= suc.Codigo
			,[SucursalDescripcion]	= suc.Descripcion
			, u.IdUsuario
			, u.Usuario
			, per.IdPerfil
			, [PerfilCodigo]		= per.Codigo
			, [PerfilDescripcion]	= per.Descripcion
			, p.IdPermiso
			, rec.IdRecurso
			, [RecursoDescripcion]	= rec.Descripcion
			FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) ON u.IdRelPerfiles=up.IdRel
			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = up.IdEstatusActual AND ea.IdEstatus=1
			INNER JOIN dbo.tCATperfiles per  WITH(NOLOCK) ON per.IdPerfil = up.IdPerfil AND per.IdPerfil<>0
			INNER JOIN dbo.tCTLestatusActual eaper  WITH(NOLOCK) ON eaper.IdEstatusActual = per.IdEstatusActual AND eaper.IdEstatus=1
			INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = up.IdSucursal
			INNER JOIN dbo.tCTLpermisos p  WITH(NOLOCK) ON p.IdPerfil = per.IdPerfil
			INNER JOIN dbo.tCTLrecursos rec  WITH(NOLOCK) ON rec.IdRecurso = p.IdRecurso
			WHERE u.Usuario=@Usuario
			AND rec.IdRecurso=@IdRecurso
			
			RETURN 1
	END

	IF @TipoOperacion='PERMISO_RECURSO_USUARIO_SUCURSAL'
	BEGIN
			SELECT 
			 [SucursalCodigo]		= suc.Codigo
			,[SucursalDescripcion]	= suc.Descripcion
			, u.IdUsuario
			, u.Usuario
			, per.IdPerfil
			, [PerfilCodigo]		= per.Codigo
			, [PerfilDescripcion]	= per.Descripcion
			, p.IdPermiso
			, rec.IdRecurso
			, [RecursoDescripcion]	= rec.Descripcion
			FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) ON u.IdRelPerfiles=up.IdRel
			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = up.IdEstatusActual AND ea.IdEstatus=1
			INNER JOIN dbo.tCATperfiles per  WITH(NOLOCK) ON per.IdPerfil = up.IdPerfil AND per.IdPerfil<>0
			INNER JOIN dbo.tCTLestatusActual eaper  WITH(NOLOCK) ON eaper.IdEstatusActual = per.IdEstatusActual AND eaper.IdEstatus=1
			INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = up.IdSucursal
			INNER JOIN dbo.tCTLpermisos p  WITH(NOLOCK) ON p.IdPerfil = per.IdPerfil
			INNER JOIN dbo.tCTLrecursos rec  WITH(NOLOCK) ON rec.IdRecurso = p.IdRecurso
			WHERE u.Usuario=@Usuario
			AND rec.IdRecurso=@IdRecurso
			AND suc.codigo=@Sucursal
			
			RETURN 1
	END

	IF @TipoOperacion='PERFILES_USUARIO'
	BEGIN
		RETURN 1
	END

	IF @TipoOperacion='SUCURSALES_USUARIO'
	BEGIN
		RETURN 1
	END

END
GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pCTLpermisosPorPerfilPorUsuario')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pCTLpermisosPorPerfilPorUsuario')
END
GO

