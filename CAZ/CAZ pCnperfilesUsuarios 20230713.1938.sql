
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnperfilesUsuarios')
BEGIN
	DROP PROC pCnperfilesUsuarios
	SELECT 'pCnperfilesUsuarios BORRADO' AS info
END
GO

CREATE PROC pCnperfilesUsuarios
		@Usuario as varchar(40)='',
		@SucursalCodigo as varchar(12)=''

AS
BEGIN

	--DECLARE @SQL AS NVARCHAR(MAX)=''

	--SET @SQL='select [Usuario]=upg.Usuario,[Nombre]=vu.Nombre,[Perfil]=upg.PerfilDescripcion, EstatusUsuario = upg.usuarioestatus, [Código Sucursal]=upg.SucursalCodigo,[Sucursal]=upg.SucursalDescripcion
	--from vCTLusuariosPerfilesGUI upg with(nolock)
	--inner join vCTLusuarios vu with(nolock) on upg.IdUsuario not in (-1,-2) and upg.IdUsuario=vu.IdUsuario
	--inner join tCTLusuarios u with(nolock) on u.IdUsuario=vu.IdUsuario
	--INNER JOIN tCTLestatusActual eat with(nolock) on eat.IdEstatusActual=u.IdEstatusActual
	--INNER JOIN tCTLestatus e with(nolock) on e.IdEstatus=eat.IdEstatus
	--where upg.IdEstatus=1 ' 
	--+IIF(@Usuario='*','',' AND upg.Usuario='''+@Usuario+'''')
	--+IIF(@SucursalCodigo='*','',' AND upg.SucursalCodigo='''+@SucursalCodigo+'''')+
	--' ORDER BY upg.Usuario'

	--PRINT @SQL
	--EXECUTE SYS.SP_EXECUTESQL @SQL


	DECLARE @Sucursal AS VARCHAR(32)=@SucursalCodigo
	--DECLARE @Usuario AS VARCHAR(32)='*'

	SELECT u.IdUsuario,
	u.Usuario
	, [Perfil] = p.Descripcion 
	, [CodigoSucursal] = suc.Codigo
	, [Sucursal] = suc.Descripcion
	, eaUp.Alta
	, eaUp.UltimoCambio
	, [UsuarioAlta] = uAlta.Usuario
	, [Estatus]= e.Descripcion
	FROM dbo.tCTLusuariosPerfiles up  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatusActual eaUp  WITH(NOLOCK) 
		ON eaUp.IdEstatusActual = up.IdEstatusActual
	INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
		ON e.IdEstatus = eaUp.IdEstatus
	INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
		ON u.IdRelPerfiles=up.IdRel
			AND u.IdUsuario NOT IN (0,-1,-2)
			AND ((@Usuario='*') OR (u.Usuario = @Usuario))
	INNER JOIN dbo.tCATperfiles p  WITH(NOLOCK) 
		ON p.IdPerfil = up.IdPerfil
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
		ON suc.IdSucursal = up.IdSucursal
		AND ((@Sucursal='*') OR (suc.Codigo = @Sucursal))
	INNER JOIN dbo.tCTLusuarios uAlta  WITH(NOLOCK) 
		ON uAlta.IdUsuario = eaUp.IdUsuarioAlta
	ORDER BY eaUp.UltimoCambio DESC, u.Usuario

END

GO

