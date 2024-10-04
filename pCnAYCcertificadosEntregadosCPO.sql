


IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCcertificadosEntregadosCPO')
BEGIN
	DROP PROC pCnAYCcertificadosEntregadosCPO
END
GO

CREATE PROC pCnAYCcertificadosEntregadosCPO
@TipoOperacion AS VARCHAR(15)=null,
@NoSocio AS VARCHAR(24)=NULL,
@Sucusal AS VARCHAR(16)=null
AS
-- 1 Socio
-- 2 Sucursal
-- 3 Todos

IF @TipoOperacion='1'
BEGIN
		SELECT 
		[CodigoSucusal]		= suc.Codigo
		,[Sucursal]			= suc.Descripcion
		,[NoSocio]			= socio.Codigo 
		,[Nombre]			= persona.Nombre
		, [UsuarioAlta]		= usuario.Usuario
		FROM dbo.tDIGregistrosRequisitos RegReq  WITH(nolock) 
		INNER JOIN dbo.tGRLpersonas persona  WITH(nolock) ON persona.IdPersona = RegReq.IdPersona
		INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdPersona = persona.IdPersona
														AND socio.EsSocioValido=1
		INNER JOIN dbo.tCTLusuarios usuario  WITH(nolock) ON usuario.IdUsuario = RegReq.IdUsuarioAlta
		INNER JOIN dbo.tCTLsucursales suc  WITH(nolock) ON suc.IdSucursal=socio.IdSucursal
		WHERE RegReq.IdEstatus=1 AND RegReq.IdRequisito=1057
		AND socio.Codigo=@NoSocio
END

IF @TipoOperacion='2'
BEGIN
		SELECT 
		[CodigoSucusal]		= suc.Codigo
		,[Sucursal]			= suc.Descripcion
		,[NoSocio]			= socio.Codigo 
		,[Nombre]			= persona.Nombre
		, [UsuarioAlta]		= usuario.Usuario
		FROM dbo.tDIGregistrosRequisitos RegReq  WITH(nolock) 
		INNER JOIN dbo.tGRLpersonas persona  WITH(nolock) ON persona.IdPersona = RegReq.IdPersona
		INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdPersona = persona.IdPersona
														AND socio.EsSocioValido=1
		INNER JOIN dbo.tCTLusuarios usuario  WITH(nolock) ON usuario.IdUsuario = RegReq.IdUsuarioAlta
		INNER JOIN dbo.tCTLsucursales suc  WITH(nolock) ON suc.IdSucursal=socio.IdSucursal
		WHERE RegReq.IdEstatus=1 AND RegReq.IdRequisito=1057
		AND suc.Codigo=@Sucusal
END											

IF @TipoOperacion='3'
BEGIN
		SELECT 
		[CodigoSucusal]		= suc.Codigo
		,[Sucursal]			= suc.Descripcion
		,[NoSocio]			= socio.Codigo 
		,[Nombre]			= persona.Nombre
		, [UsuarioAlta]		= usuario.Usuario
		FROM dbo.tDIGregistrosRequisitos RegReq  WITH(nolock) 
		INNER JOIN dbo.tGRLpersonas persona  WITH(nolock) ON persona.IdPersona = RegReq.IdPersona
		INNER JOIN dbo.tSCSsocios socio  WITH(nolock) ON socio.IdPersona = persona.IdPersona
														AND socio.EsSocioValido=1
		INNER JOIN dbo.tCTLusuarios usuario  WITH(nolock) ON usuario.IdUsuario = RegReq.IdUsuarioAlta
		INNER JOIN dbo.tCTLsucursales suc  WITH(nolock) ON suc.IdSucursal=socio.IdSucursal
		WHERE RegReq.IdEstatus=1 AND RegReq.IdRequisito=1057
END		