

IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnAYCtrazabilidadSolicitudes')
	DROP PROC pCnAYCtrazabilidadSolicitudes
GO

CREATE PROCEDURE [dbo].[pCnAYCtrazabilidadSolicitudes]
	@FechaInicial DATE='19000101',
	@FechaFinal DATE='19000101',
	@Folio AS VARCHAR(20)=''
AS 
		IF @Folio<>'' AND @Folio<>'*'
		BEGIN
				DECLARE @IdApertura AS INT=0;
				SELECT @IdApertura=a.IdApertura FROM dbo.tAYCaperturas a  WITH(NOLOCK) WHERE a.Folio=@Folio

				SELECT 
				apertura.Fecha AS FechaSolicitud
				,sucursal.Descripcion AS Sucursal, usuario.Usuario AS Operador
				,apertura.Folio, cuenta.Codigo AS NoCuenta, pf.Codigo AS CodigoProducto, pf.Descripcion AS Producto
				, socio.Codigo AS NoSocio, persona.Nombre AS Socio
				, eCuenta.Descripcion as Estatus, eEntrega.Descripcion as Desembolso
				, procred.Etapa
				, procred.FechaInicio, cast(procred.FechaInicio as time) as HoraInicio
				, procred.FechaFin, cast(procred.FechaFin as time) as HoraFin
				, uProceso.Usuario, pProceso.Nombre AS NombreUsuario
				FROM  dbo.tAYCaperturas apertura    WITH(NOLOCK) 
				INNER JOIN dbo.tAYCcuentas cuenta WITH(NOLOCK) ON cuenta.IdApertura = apertura.IdApertura
				INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = apertura.IdProductoFinanciero
				INNER JOIN dbo.tCTLtiposD tipoproducto  WITH(NOLOCK) ON tipoproducto.IdTipoD = cuenta.IdTipoDProducto
																		AND tipoproducto.IdTipoD=143
				INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = apertura.IdSocio
				INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
				INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = apertura.IdSucursal
				INNER JOIN dbo.tCTLusuarios usuario  WITH(NOLOCK) ON usuario.IdUsuario = apertura.IdUsuarioAlta
				INNER JOIN dbo.tCTLestatus eCuenta  WITH(NOLOCK) ON eCuenta.IdEstatus = cuenta.IdEstatus
				INNER JOIN dbo.tCTLestatus eEntrega  WITH(NOLOCK) ON eEntrega.IdEstatus = cuenta.IdEstatusEntrega
				-- duplica el tiempo
				left JOIN dbo.tAUTbitacoraProcesoCredito procred  WITH(NOLOCK) ON procred.IdCuenta = cuenta.IdCuenta
				left JOIN dbo.tCTLsesiones sesion  WITH(NOLOCK) ON sesion.IdSesion = procred.IdSesion
				left JOIN dbo.tCTLusuarios uProceso  WITH(NOLOCK) ON uProceso.IdUsuario = sesion.IdUsuario
				left JOIN dbo.tGRLpersonas pProceso  WITH(NOLOCK) ON pProceso.IdPersona = uProceso.IdPersonaFisica
				WHERE apertura.IdApertura=@IdApertura
				ORDER BY procred.Id
		END
        ELSE
        BEGIN	
				SELECT 
				apertura.Fecha AS FechaSolicitud
				,sucursal.Descripcion AS Sucursal
				, usuario.Usuario AS Operador
				,apertura.Folio, cuenta.Codigo AS NoCuenta, pf.Codigo AS CodigoProducto, pf.Descripcion AS Producto
				, socio.Codigo AS NoSocio, persona.Nombre AS Socio
				, eCuenta.Descripcion as Estatus, eEntrega.Descripcion as Desembolso
				, procred.Etapa
				, procred.FechaInicio, cast(procred.FechaInicio as time) as HoraInicio
				, procred.FechaFin, cast(procred.FechaFin as time) as HoraFin
				, uProceso.Usuario, pProceso.Nombre AS NombreUsuario
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
				-- duplica el tiempo
				left JOIN dbo.tAUTbitacoraProcesoCredito procred  WITH(NOLOCK) ON procred.IdCuenta = cuenta.IdCuenta
				left JOIN dbo.tCTLsesiones sesion  WITH(NOLOCK) ON sesion.IdSesion = procred.IdSesion
				left JOIN dbo.tCTLusuarios uProceso  WITH(NOLOCK) ON uProceso.IdUsuario = sesion.IdUsuario
				left JOIN dbo.tGRLpersonas pProceso  WITH(NOLOCK) ON pProceso.IdPersona = uProceso.IdPersonaFisica
				WHERE apertura.fecha BETWEEN @FechaInicial AND @FechaFinal
				ORDER BY apertura.Fecha,  sucursal.IdSucursal,
				 apertura.IdApertura
				 , procred.Id
		END	

GO