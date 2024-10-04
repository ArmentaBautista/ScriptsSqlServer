
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDalertasBloqueoPorInactividad')
BEGIN
	DROP PROC pCnPLDalertasBloqueoPorInactividad
	SELECT 'pCnPLDalertasBloqueoPorInactividad BORRADO' AS info
END
GO

CREATE PROC dbo.pCnPLDalertasBloqueoPorInactividad
		@NoSocio AS VARCHAR(20)=''
AS
		DECLARE @Agrupador AS VARCHAR(128)='CTA_SIN_MOV_24MESES'


		IF @NoSocio<>'' AND @NoSocio<>'*'
		begin
			SELECT 
			msg.Agrupador
			, suc.Descripcion AS Sucursal
			, sc.Codigo AS NoSocio, p.Nombre
			, e.Descripcion EstatusAlerta
			, usrE.Usuario AS UsuarioEmisor, puser.Nombre AS NombreUsuarioEmisor
			, msg.Concepto, msg.Referencia, msg.Mensaje
			,tdi.Descripcion AS Instruccion
			,CAST(msg.Alta AS DATE) AS Fecha
			,CAST(msg.Alta AS time) AS Hora
			FROM dbo.tCTLmensajes msg
			INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
				ON sc.IdSocio=msg.IdDominio
					AND sc.Codigo=@NoSocio
			INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK)
				ON suc.IdSucursal = sc.IdSucursal
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
				ON p.IdPersona = sc.IdPersona
			INNER JOIN dbo.tCTLusuarios usrE  WITH(NOLOCK) 
				ON usrE.IdUsuario = msg.UsuarioEmisor
			INNER JOIN dbo.tGRLpersonas puser  WITH(NOLOCK) 
				ON puser.IdPersona = usrE.IdPersonaFisica
			INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
				ON e.IdEstatus = msg.IdEstatus
			INNER JOIN dbo.tCTLtiposD tdi  WITH(NOLOCK) 
				ON tdi.IdTipoD = msg.IdTipoDinstruccion
			WHERE msg.IdTipoDdominio=208
				AND msg.Agrupador=@Agrupador
			
			RETURN;
		end

		IF @NoSocio='' OR @NoSocio='*'
		begin
			SELECT 
			msg.Agrupador
			, suc.Descripcion AS Sucursal
			, sc.Codigo AS NoSocio, p.Nombre
			, e.Descripcion EstatusAlerta
			, usrE.Usuario AS UsuarioEmisor, puser.Nombre AS NombreUsuarioEmisor
			, msg.Concepto, msg.Referencia, msg.Mensaje
			,tdi.Descripcion AS Instruccion
			,CAST(msg.Alta AS DATE) AS Fecha
			,CAST(msg.Alta AS time) AS Hora
			FROM dbo.tCTLmensajes msg
			INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
				ON sc.IdSocio=msg.IdDominio
			INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK)
				ON suc.IdSucursal = sc.IdSucursal
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
				ON p.IdPersona = sc.IdPersona
			INNER JOIN dbo.tCTLusuarios usrE  WITH(NOLOCK) 
				ON usrE.IdUsuario = msg.UsuarioEmisor
			INNER JOIN dbo.tGRLpersonas puser  WITH(NOLOCK) 
				ON puser.IdPersona = usrE.IdPersonaFisica
			INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
				ON e.IdEstatus = msg.IdEstatus
			INNER JOIN dbo.tCTLtiposD tdi  WITH(NOLOCK) 
				ON tdi.IdTipoD = msg.IdTipoDinstruccion
			WHERE msg.IdTipoDdominio=208
				AND msg.Agrupador=@Agrupador

			RETURN;
		end

GO

