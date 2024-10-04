

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCtrazabilidadCuenta')
BEGIN
	DROP PROC pCnAYCtrazabilidadCuenta
	SELECT 'pCnAYCtrazabilidadCuenta BORRADO' AS info
END
GO

CREATE PROC pCnAYCtrazabilidadCuenta
	@FechaInicial DATE='19000101',
	@FechaFinal DATE='19000101'
AS 
BEGIN 
		DECLARE @IdPerfil AS INT=0
		SELECT @IdPerfil= IdPerfil FROM dbo.vSISsesion
		DECLARE @IdUsuario AS INT =0
		SELECT @IdUsuario=IdUsuario FROM dbo.vSISsesion

		DECLARE @IdSesion AS INT =(SELECT IdSesion FROM dbo.vSISsesion)

		DECLARE @IdRelPerfiles AS INT =(SELECT IdRelPerfiles 
										FROM dbo.tCTLusuarios WITH (NOLOCK) 
										WHERE IdUsuario=@IdUsuario)

		/*Permitir ver todas las Solicitudes*/
	    --IF EXISTS (SELECT IdPerfil FROM dbo.tCTLpermisos WITH (NOLOCK) WHERE IdRecurso=2722 AND Especial=1 AND IdPerfil=@IdPerfil)

		  IF EXISTS(
						SELECT perfil.IdPerfil
						FROM dbo.tCTLsesiones sesion WITH (NOLOCK)
						INNER JOIN dbo.tCATperfiles perfil WITH (NOLOCK)   ON perfil.IdPerfil = sesion.IdPerfil
						INNER JOIN dbo.tCTLpermisos permiso WITH (NOLOCK)  ON permiso.IdPerfil = perfil.IdPerfil
						INNER JOIN dbo.tCTLrecursos recurso WITH (NOLOCK)  ON recurso.IdRecurso = permiso.IdRecurso
						WHERE sesion.IdSesion = @IdSesion   AND permiso.IdRecurso = 2722				  
					)
			BEGIN 
				SELECT 
				--@IdPerfil AS Perfil,
				--@IdUsuario AS Usuario,
				apertura.Fecha AS FechaSolicitud
				,sucursal.Descripcion AS Sucursal
				, usuario.Usuario AS Operador
				,apertura.Folio, cuenta.Codigo AS NoCuenta, pf.Codigo AS CodigoProducto, pf.Descripcion AS Producto
				, socio.Codigo AS NoSocio, persona.Nombre AS Socio
				, cuenta.MontoSolicitado, cuenta.Monto
				, eCuenta.Descripcion as Estatus, eEntrega.Descripcion as Desembolso
				, procred.Etapa
				, procred.FechaInicio, cast(procred.FechaInicio as time) as HoraInicio
				, procred.FechaFin, cast(procred.FechaFin as time) as HoraFin
				, uProceso.Usuario, pProceso.Nombre AS NombreUsuario
				,[Estatus Cartera] = EsCartera.Descripcion
				,TipoDeCartera = cuenta.TipoCartera
				,CAST(IIF(cuenta.IdCuentaRenovada!=0,1,0) AS BIT) AS [Es Renovación]
		        ,CAST(IIF(cuenta.IdCuentaRestructurada!=0,1,0)AS BIT) AS [Es Reestructura]
				FROM  dbo.tAYCaperturas apertura    WITH(NOLOCK) 
				INNER JOIN dbo.tAYCcuentas cuenta WITH(NOLOCK) ON cuenta.IdApertura = apertura.IdApertura
				INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = cuenta.IdProductoFinanciero
				INNER JOIN dbo.tCTLtiposD tipoproducto  WITH(NOLOCK) ON tipoproducto.IdTipoD = cuenta.IdTipoDProducto
																		AND tipoproducto.IdTipoD=143
				INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = apertura.IdSocio
				INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
				INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = apertura.IdSucursal
				INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = apertura.IdUsuarioAlta
				INNER JOIN dbo.tCTLestatus eCuenta  WITH(NOLOCK) ON eCuenta.IdEstatus = cuenta.IdEstatus
				INNER JOIN dbo.tCTLestatus eEntrega  WITH(NOLOCK) ON eEntrega.IdEstatus = cuenta.IdEstatusEntrega
				INNER JOIN dbo.tCTLestatus EsCartera WITH(NOLOCK) ON EsCartera.IdEstatus = cuenta.IdEstatusCartera
				-- duplica el tiempo
				left JOIN dbo.tAUTbitacoraProcesoCredito procred  WITH(NOLOCK) ON procred.IdCuenta = cuenta.IdCuenta
				left JOIN dbo.tCTLsesiones sesion  WITH(NOLOCK) ON sesion.IdSesion = procred.IdSesion
				left JOIN dbo.tCTLusuarios uProceso  WITH(NOLOCK) ON uProceso.IdUsuario = sesion.IdUsuario
				left JOIN dbo.tGRLpersonas pProceso  WITH(NOLOCK) ON pProceso.IdPersona = uProceso.IdPersonaFisica
				WHERE apertura.fecha BETWEEN @FechaInicial AND @FechaFinal
				ORDER BY apertura.Fecha,  sucursal.IdSucursal,
				 apertura.IdApertura
				 , procred.Id
	         RETURN;
          END 

		/*Permitir ver solo las Solicitudes de la sucursal del perfil del usuario*/
		---IF EXISTS (SELECT IdPerfil FROM dbo.tCTLpermisos WITH (NOLOCK) WHERE IdRecurso=2723 AND Especial=1 AND IdPerfil=@IdPerfil)
		IF EXISTS(
			SELECT perfil.IdPerfil
			FROM dbo.tCTLsesiones sesion WITH (NOLOCK)
			INNER JOIN dbo.tCATperfiles perfil WITH (NOLOCK)   ON perfil.IdPerfil = sesion.IdPerfil
			INNER JOIN dbo.tCTLpermisos permiso WITH (NOLOCK)  ON permiso.IdPerfil = perfil.IdPerfil
			INNER JOIN dbo.tCTLrecursos recurso WITH (NOLOCK)  ON recurso.IdRecurso = permiso.IdRecurso
			WHERE sesion.IdSesion = @IdSesion   AND permiso.IdRecurso = 2723				  
		)
		  BEGIN 
				SELECT 
				--@IdPerfil AS Perfil,
				--@IdUsuario AS Usuario,
				apertura.Fecha AS FechaSolicitud
				,sucursal.Descripcion AS Sucursal
				, usuario.Usuario AS Operador
				,apertura.Folio, cuenta.Codigo AS NoCuenta, pf.Codigo AS CodigoProducto, pf.Descripcion AS Producto
				, socio.Codigo AS NoSocio, persona.Nombre AS Socio
				, cuenta.MontoSolicitado, cuenta.Monto
				, eCuenta.Descripcion as Estatus, eEntrega.Descripcion as Desembolso
				, procred.Etapa
				, procred.FechaInicio, cast(procred.FechaInicio as time) as HoraInicio
				, procred.FechaFin, cast(procred.FechaFin as time) as HoraFin
				, uProceso.Usuario, pProceso.Nombre AS NombreUsuario
				,[Estatus Cartera] = EsCartera.Descripcion
				,TipoDeCartera = cuenta.TipoCartera
				,CAST(IIF(cuenta.IdCuentaRenovada!=0,1,0) AS BIT) AS [Es Renovación]
		        ,CAST(IIF(cuenta.IdCuentaRestructurada!=0,1,0)AS BIT) AS [Es Reestructura]
				FROM  dbo.tAYCaperturas apertura    WITH(NOLOCK) 
				INNER JOIN dbo.tAYCcuentas cuenta WITH(NOLOCK) ON cuenta.IdApertura = apertura.IdApertura
				INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = cuenta.IdProductoFinanciero
				INNER JOIN dbo.tCTLtiposD tipoproducto  WITH(NOLOCK) ON tipoproducto.IdTipoD = cuenta.IdTipoDProducto
																		AND tipoproducto.IdTipoD=143
				INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = apertura.IdSocio
				INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
				INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = apertura.IdSucursal
				INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = apertura.IdUsuarioAlta
				INNER JOIN dbo.tCTLestatus eCuenta  WITH(NOLOCK) ON eCuenta.IdEstatus = cuenta.IdEstatus
				INNER JOIN dbo.tCTLestatus eEntrega  WITH(NOLOCK) ON eEntrega.IdEstatus = cuenta.IdEstatusEntrega
				INNER JOIN dbo.tCTLestatus EsCartera WITH(NOLOCK) ON EsCartera.IdEstatus = cuenta.IdEstatusCartera
				-- duplica el tiempo
				left JOIN dbo.tAUTbitacoraProcesoCredito procred  WITH(NOLOCK) ON procred.IdCuenta = cuenta.IdCuenta
				left JOIN dbo.tCTLsesiones sesion  WITH(NOLOCK) ON sesion.IdSesion = procred.IdSesion
				left JOIN dbo.tCTLusuarios uProceso  WITH(NOLOCK) ON uProceso.IdUsuario = sesion.IdUsuario
				left JOIN dbo.tGRLpersonas pProceso  WITH(NOLOCK) ON pProceso.IdPersona = uProceso.IdPersonaFisica
				WHERE apertura.fecha BETWEEN @FechaInicial AND @FechaFinal 
				AND apertura.IdSucursal IN (SELECT p.IdSucursal 
											FROM dbo.tCTLusuariosPerfiles p WITH (NOLOCK) 
											INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
												ON ea.IdEstatusActual = p.IdEstatusActual
												AND ea.IdEstatus=1
											WHERE p.IdPerfil=@IdPerfil 
												AND p.IdRel=@IdRelPerfiles)
				ORDER BY apertura.Fecha,  sucursal.IdSucursal,
				 apertura.IdApertura
				 , procred.Id
		     RETURN;
         END 

	  /*Permitir ver solo las Solicitudes propias del usuario*/
	 --- IF EXISTS (SELECT IdPerfil FROM dbo.tCTLpermisos WITH (NOLOCK) WHERE IdRecurso=2724 AND Especial=1 AND IdPerfil=@IdPerfil)
	   IF EXISTS(
			SELECT perfil.IdPerfil
			FROM dbo.tCTLsesiones sesion WITH (NOLOCK)
			INNER JOIN dbo.tCATperfiles perfil WITH (NOLOCK)   ON perfil.IdPerfil = sesion.IdPerfil
			INNER JOIN dbo.tCTLpermisos permiso WITH (NOLOCK)  ON permiso.IdPerfil = perfil.IdPerfil
			INNER JOIN dbo.tCTLrecursos recurso WITH (NOLOCK)  ON recurso.IdRecurso = permiso.IdRecurso
			WHERE sesion.IdSesion = @IdSesion   AND permiso.IdRecurso = 2724				  
		)
		BEGIN 
				SELECT 
				--@IdPerfil AS Perfil,
				--@IdUsuario AS Usuario,
				apertura.Fecha AS FechaSolicitud
				,sucursal.Descripcion AS Sucursal
				, usuario.Usuario AS Operador
				,apertura.Folio, cuenta.Codigo AS NoCuenta, pf.Codigo AS CodigoProducto, pf.Descripcion AS Producto
				, socio.Codigo AS NoSocio, persona.Nombre AS Socio
				, cuenta.MontoSolicitado, cuenta.Monto
				, eCuenta.Descripcion as Estatus, eEntrega.Descripcion as Desembolso
				, procred.Etapa
				, procred.FechaInicio, cast(procred.FechaInicio as time) as HoraInicio
				, procred.FechaFin, cast(procred.FechaFin as time) as HoraFin
				, uProceso.Usuario, pProceso.Nombre AS NombreUsuario
				,[Estatus Cartera] = EsCartera.Descripcion
				,TipoDeCartera = cuenta.TipoCartera
				,CAST(IIF(cuenta.IdCuentaRenovada!=0,1,0) AS BIT) AS [Es Renovación]
		        ,CAST(IIF(cuenta.IdCuentaRestructurada!=0,1,0)AS BIT) AS [Es Reestructura]
				FROM  dbo.tAYCaperturas apertura    WITH(NOLOCK) 
				INNER JOIN dbo.tAYCcuentas cuenta WITH(NOLOCK) ON cuenta.IdApertura = apertura.IdApertura
				INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = cuenta.IdProductoFinanciero
				INNER JOIN dbo.tCTLtiposD tipoproducto  WITH(NOLOCK) ON tipoproducto.IdTipoD = cuenta.IdTipoDProducto
																		AND tipoproducto.IdTipoD=143
				INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = apertura.IdSocio
				INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
				INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = apertura.IdSucursal
				INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = apertura.IdUsuarioAlta
				INNER JOIN dbo.tCTLestatus eCuenta  WITH(NOLOCK) ON eCuenta.IdEstatus = cuenta.IdEstatus
				INNER JOIN dbo.tCTLestatus eEntrega  WITH(NOLOCK) ON eEntrega.IdEstatus = cuenta.IdEstatusEntrega
				INNER JOIN dbo.tCTLestatus EsCartera WITH(NOLOCK) ON EsCartera.IdEstatus = cuenta.IdEstatusCartera
				-- duplica el tiempo
				left JOIN dbo.tAUTbitacoraProcesoCredito procred  WITH(NOLOCK) ON procred.IdCuenta = cuenta.IdCuenta
				left JOIN dbo.tCTLsesiones sesion  WITH(NOLOCK) ON sesion.IdSesion = procred.IdSesion
				left JOIN dbo.tCTLusuarios uProceso  WITH(NOLOCK) ON uProceso.IdUsuario = sesion.IdUsuario
				left JOIN dbo.tGRLpersonas pProceso  WITH(NOLOCK) ON pProceso.IdPersona = uProceso.IdPersonaFisica
				WHERE apertura.fecha BETWEEN @FechaInicial AND @FechaFinal 
				AND apertura.IdUsuarioAlta=@IdUsuario
				ORDER BY apertura.Fecha,  sucursal.IdSucursal,
				 apertura.IdApertura
				 , procred.Id
		    RETURN;
       END 

END 


GO

