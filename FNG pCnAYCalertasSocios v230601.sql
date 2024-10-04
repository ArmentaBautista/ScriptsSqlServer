
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCalertasSocios')
BEGIN
	DROP PROC pCnAYCalertasSocios
	SELECT 'pCnAYCalertasSocios BORRADO' AS info
END
GO

CREATE PROC pCnAYCalertasSocios
		@NoSocio AS VARCHAR(20)=''
AS
		IF @NoSocio<>'' AND @NoSocio<>'*'
		begin
			SELECT sc.Codigo AS NoSocio, p.Nombre, e.Descripcion EstatusAlerta
			, usrE.Usuario AS UsuarioEmisor, puser.Nombre AS NombreUsuarioEmisor, msg.Mensaje
			,tdi.Descripcion AS Instruccion
			,CAST(msg.Alta AS DATE) AS Fecha
			,CAST(msg.Alta AS time) AS Hora
			FROM dbo.tCTLmensajes msg
			INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio=msg.IdDominio
														AND sc.Codigo=@NoSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
			INNER JOIN dbo.tCTLusuarios usrE  WITH(NOLOCK) ON usrE.IdUsuario = msg.UsuarioEmisor
			INNER JOIN dbo.tGRLpersonas puser  WITH(NOLOCK) ON puser.IdPersona = sc.IdPersona
			INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = msg.IdEstatus
			INNER JOIN dbo.tCTLtiposD tdi  WITH(NOLOCK) ON tdi.IdTipoD = msg.IdTipoDinstruccion
			WHERE sc.IdTipoDdominio=208
			
			RETURN;
		end

		IF @NoSocio='' OR @NoSocio='*'
		begin
			SELECT sc.Codigo AS NoSocio, p.Nombre, e.Descripcion EstatusAlerta
			, usrE.Usuario AS UsuarioEmisor, puser.Nombre AS NombreUsuarioEmisor, msg.Mensaje
			,tdi.Descripcion AS Instruccion
			,CAST(msg.Alta AS DATE) AS Fecha
			,CAST(msg.Alta AS time) AS Hora
			FROM dbo.tCTLmensajes msg
			INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio=msg.IdDominio
														--AND sc.Codigo=@NoSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
			INNER JOIN dbo.tCTLusuarios usrE  WITH(NOLOCK) ON usrE.IdUsuario = msg.UsuarioEmisor
			INNER JOIN dbo.tGRLpersonas puser  WITH(NOLOCK) ON puser.IdPersona = sc.IdPersona
			INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = msg.IdEstatus
			INNER JOIN dbo.tCTLtiposD tdi  WITH(NOLOCK) ON tdi.IdTipoD = msg.IdTipoDinstruccion
			WHERE sc.IdTipoDdominio=208
			
			RETURN;
		end

GO

