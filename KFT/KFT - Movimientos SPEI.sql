	
	--DECLARE @FechaInicial AS DATE=''
	--DECLARE @idUsuario AS INT=

	SELECT  
			Folio = solicitud.Folio ,
			[Sucursal] = sucursales.Descripcion,
			[Tipo] = 'Envío',
			[Fecha de Envío] = envioPeticion.Fecha_Hora_Mov ,
			[Número de Socio] = socios.Codigo,
			[Socio] = envioPeticion.Nombre_Ordenante ,
			[Cuenta] = cuentaSocio.Codigo,
			[Producto] = cuentaSocio.Descripcion ,
			--[Beneficiario / Ordenante Externo] = envioPeticion.Nombre_Beneficiario ,
			--[Cuenta Beneficiario / Ordenante Externo] = envioPeticion.Cuenta_Beneficiario ,
			[Monto] = envioPeticion.Monto ,
			[Comisión] = [envioPeticion].[Comision] + envioPeticion.ImpuestoComision ,
			--[Fecha confirmación] = IIF(actualizacionPeticionEnvio.IdOperacion = 0,'',CONVERT(VARCHAR(30),operacion.Fecha,103)) ,
			--[Folio Banxico]=[envioRespuesta].[Folio_Banxico],
			[Operación] = IIF(operacion.IdOperacion = 0, '', CONCAT(tipoOperacion.Codigo,'-',operacion.Serie,operacion.Folio)) ,
			--[Concepto] =iif (actualizacionPeticionEnvio.estatus='R' AND actualizacionPeticionEnvio.IdOperacion=0,CONCAT('RECHAZO: ',actualizacionPeticionEnvio.Mensaje_Referencia), operacion.Concepto),
			[Póliza] = IIF(polizaE.IdPolizaE = 0, '', CONCAT(listaD.Codigo, '-',polizaE.Folio))
			,solicitud.IdSesion
			, envioPeticion.IdUsuarioAlta
			, operacion.IdUsuarioAlta
			, operacion.IdSesion
			--,ss.IdUsuario
			
	FROM    
			dbo.tSPEIsolicitudes solicitud WITH ( NOLOCK )
			INNER JOIN dbo.tSPEIenvioPeticiones envioPeticion WITH ( NOLOCK ) ON envioPeticion.IdEnvioPeticion = solicitud.IdPeticion
			INNER JOIN dbo.tAYCcuentas cuentaSocio WITH ( NOLOCK ) ON cuentaSocio.IdCuenta = envioPeticion.IdCuenta
			INNER JOIN dbo.tSCSsocios socios WITH (NOLOCK) ON socios.IdSocio = cuentaSocio.IdSocio
			INNER JOIN dbo.tSPEIenvioRespuestas envioRespuesta WITH ( NOLOCK ) ON envioRespuesta.IdEnvioPeticion = envioPeticion.IdEnvioPeticion
			INNER JOIN dbo.tSPEIactualizacionEnvioPeticiones actualizacionPeticionEnvio WITH ( NOLOCK ) ON actualizacionPeticionEnvio.IdEnvioPeticion = envioPeticion.IdEnvioPeticion AND actualizacionPeticionEnvio.IdEstatus != 2
			INNER JOIN dbo.tGRLoperaciones operacion WITH ( NOLOCK ) ON operacion.IdOperacion = actualizacionPeticionEnvio.IdOperacion AND operacion.IdEstatus IN(0, 1)
			INNER JOIN dbo.tCTLtiposOperacion tipoOperacion WITH ( NOLOCK ) ON tipoOperacion.IdTipoOperacion = operacion.IdTipoOperacion
			INNER JOIN dbo.tCNTpolizasE polizaE WITH ( NOLOCK ) ON polizaE.IdPolizaE = operacion.IdPolizaE
			INNER JOIN dbo.tCATlistasD listaD WITH ( NOLOCK ) ON listaD.IdListaD = operacion.IdListaDPoliza
			LEFT JOIN dbo.tCTLsucursales sucursales WITH (NOLOCK) ON sucursales.IdSucursal = operacion.IdSucursal
			--LEFT JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) ON ss.IdSesion = operacion.IdSesion
	WHERE   
			solicitud.IdSolicitud != 0
			ORDER BY operacion.Fecha DESC