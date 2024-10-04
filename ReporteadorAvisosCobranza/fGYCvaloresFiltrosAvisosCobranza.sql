

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fGYCvaloresFiltrosAvisosCobranza')
BEGIN
	DROP FUNCTION fGYCvaloresFiltrosAvisosCobranza
	SELECT 'fGYCvaloresFiltrosAvisosCobranza BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fGYCvaloresFiltrosAvisosCobranza(
@FechaCartera AS DATE='19000101'
)
RETURNS TABLE
RETURN(
SELECT 
		sucursal=suc.Codigo
		,Domicilio = CASE WHEN domSocioCobranza.IdDomicilio IS NOT NULL THEN
						  	domSocioCobranza.Calle
						  WHEN domSocio.IdDomicilio IS NOT NULL OR domSocio.Descripcion <> '' THEN 
						  	domSocio.Calle
						  ELSE --domCoral.calle 
						  	CONCAT(domCoral.calle,' ',domCoral.numero_ext,' ',domCoral.numero_int)
					  END	
		,producto=producto.Descripcion
		,cartera.FechaCartera
		,cue.IdCuenta
FROM dbo.tAYCcuentas cue WITH(NOLOCK)
INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = cue.IdProductoFinanciero
INNER JOIN dbo.tSCSsocios soc WITH(NOLOCK) ON soc.IdSocio = cue.IdSocio AND cue.IdTipoDProducto=143 AND soc.IdEstatus=1 AND soc.EsSocioValido=1 
INNER JOIN dbo.tCTLsucursales suc With(nolock) ON suc.IdSucursal = cue.IdSucursal
INNER JOIN dbo.tGRLpersonas perSocio WITH(NOLOCK) ON perSocio.IdPersona = soc.IdPersona AND cue.IdEstatus IN(1,53,73)
INNER JOIN dbo.tAYCcartera cartera With(nolock) ON cartera.IdCuenta = cue.IdCuenta AND cartera.FechaCartera= @FechaCartera
INNER JOIN dbo.tGRLpersonasFisicas perFisSocio WITH(NOLOCK) ON perFisSocio.IdPersonaFisica = perSocio.IdPersonaFisica
INNER JOIN dbo.tCTLestatus estCartera With(nolock) ON cue.IdEstatusCartera=estCartera.IdEstatus
INNER JOIN dbo.tSDOsaldos saldoCuenta With(nolock) on cue.IdCuenta=saldoCuenta.IdCuenta
INNER JOIN dbo.tCTLempresas empresa WITH(NOLOCK) ON empresa.IdEmpresa=1
INNER JOIN dbo.tGRLpersonas perEmpresa WITH(NOLOCK) ON perEmpresa.IdPersona = empresa.IdPersona
INNER JOIN dbo.tAYCavisosCobranzaContenido contenidoAvisos WITH(NOLOCK) ON cartera.MoraMaxima BETWEEN contenidoAvisos.MoraInicial AND contenidoAvisos.MoraFinal AND contenidoAvisos.IdEstatus=1
INNER JOIN (SELECT  Socio.IdSocio
					,AportacionSocial = SUM(IIF(prod.IdProductoFinanciero = 1,ISNULL(saldo.Saldo,0),0))
					,Ahorro=SUM(IIF(prod.IdProductoFinanciero IN(3,6),ISNULL(saldo.Saldo,0),0))
					,Reciprocidad= SUM(IIF(prod.IdProductoFinanciero = 27,ISNULL(saldo.Saldo,0),0))	
			FROM dbo.tAYCcuentas cuenta WITH (NOLOCK)
			INNER JOIN dbo.tAYCproductosFinancieros prod WITH (NOLOCK) ON prod.IdProductoFinanciero = cuenta.IdProductoFinanciero AND prod.IdProductoFinanciero IN( 1, 3,4,6,27)
			INNER JOIN dbo.fAYCsaldo(0) saldo ON saldo.IdCuenta = cuenta.IdCuenta
			INNER JOIN dbo.tSCSsocios Socio WITH (NOLOCK) ON Socio.IdSocio = cuenta.IdSocio AND socio.EsSocioValido=1 AND socio.IdEstatus=1
			GROUP BY Socio.IdSocio		
			) haberessocio ON haberessocio.IdSocio = soc.IdSocio
LEFT JOIN dbo.fGYCparcialidadesAtrazadas(@FechaCartera) pA ON pA.IdCuenta = cue.IdCuenta
LEFT JOIN (SELECT IdCuenta
						,TotalParcialidad= ISNULL(Capital,0) - ISNULL(CapitalPagado,0) --+ InteresOrdinario + IVAInteresOrdinario + InteresMoratorio  + IVAInteresMoratorio
						,PacialidadTotal = Capital + InteresOrdinario + IVAInteresOrdinario + InteresMoratorio  + IVAInteresMoratorio
						,ParcialdiadTotalPagada = CapitalPagado + InteresOrdinarioPagado + IVAInteresOrdinarioPagado + InteresMoratorioPagado  + IVAInteresMoratorioPagado
						,ProcentajePagadoAmortzacion = IIF((Capital + InteresOrdinario + IVAInteresOrdinario + InteresMoratorio  + IVAInteresMoratorio) = 0,0, ROUND((((CapitalPagado + InteresOrdinarioPagado + IVAInteresOrdinarioPagado + InteresMoratorioPagado  + IVAInteresMoratorioPagado) /
											    (Capital + InteresOrdinario + IVAInteresOrdinario + InteresMoratorio  + IVAInteresMoratorio)) * 100 ),2))
						,NumeroFila= ROW_NUMBER()OVER(PARTITION BY IdCuenta ORDER BY Fin DESC)
				FROM dbo.tAYCparcialidades WITH(NOLOCK)
				WHERE EstaPagada=0 AND IdEstatus=1 AND Vencimiento <= @FechaCartera
				) MontosParcialidades ON MontosParcialidades.IdCuenta = cue.IdCuenta AND MontosParcialidades.NumeroFila = 1
LEFT JOIN(SELECT MunicipioDescripcion=mun.Descripcion, domSocio.IdDomicilio,
                                                       domSocio.IdRel,
                                                       domSocio.Descripcion,
                                                       domSocio.Calle,
                                                       domSocio.NumeroExterior,
                                                       domSocio.NumeroInterior,
                                                       domSocio.Calles,
                                                       domSocio.CodigoPostal,
                                                       domSocio.Asentamiento,
                                                       domSocio.Ciudad,
                                                       domSocio.Municipio,
                                                       domSocio.Estado,
                                                       domSocio.Pais,
                                                       domSocio.Referencia
													   ,domSocio.IdAsentamiento
	          FROM  dbo.tCATdomicilios domSocio With(nolock) 					  
			  INNER JOIN dbo.tCTLestatusActual domSocioEst WITH(NOLOCK) ON domSocioEst.IdEstatusActual = domSocio.IdEstatusActual AND domSocio.IdTipoD=11 AND domSocioEst.IdEstatus=1			  
			  INNER JOIN dbo.tCTLmunicipios mun With(nolock) ON mun.IdMunicipio = domSocio.IdMunicipio
			  WHERE domSocio.IdRel>0
		 ) domSocio ON  domSocio.IdRel=perSocio.IdRelDomicilios
LEFT JOIN(SELECT MunicipioDescripcion=mun.Descripcion,domSocio.IdDomicilio,
                                                       domSocio.IdRel,
                                                       domSocio.Descripcion,
                                                       domSocio.Calle,
                                                       domSocio.NumeroExterior,
                                                       domSocio.NumeroInterior,
                                                       domSocio.Calles,
                                                       domSocio.CodigoPostal,
                                                       domSocio.Asentamiento,
                                                       domSocio.Ciudad,
                                                       domSocio.Municipio,
                                                       domSocio.Estado,
                                                       domSocio.Pais,
                                                       domSocio.Referencia
													   ,domSocio.IdAsentamiento
	          FROM  dbo.tCATdomicilios domSocio With(nolock)					   
			  INNER JOIN dbo.tCTLestatusActual domSocioEst WITH(NOLOCK) ON domSocioEst.IdEstatusActual = domSocio.IdEstatusActual AND domSocio.IdTipoD=2661 AND domSocioEst.IdEstatus=1			  
			  INNER JOIN dbo.tCTLmunicipios mun With(nolock) ON mun.IdMunicipio = domSocio.IdMunicipio
			  WHERE domSocio.IdRel>0
		 ) domSocioCobranza ON  domSocioCobranza.IdRel=perSocio.IdRelDomicilios
LEFT JOIN dbo.tGYCdomiciliosPersonasCoral domCoral ON domCoral.idpersona = soc.IdPersona --soc.Codigo COLLATE DATABASE_DEFAULT
LEFT JOIN (SELECT  tsf.IdCuenta
					   ,FechaUltimoPago= MAX(tsf.Fecha)
				FROM dbo.tSDOtransaccionesFinancieras tsf WITH (NOLOCK)
				INNER JOIN dbo.tAYCcuentas cue WITH (NOLOCK) ON cue.IdCuenta = tsf.IdCuenta
				WHERE tsf.IdTipoSubOperacion = 500 AND tsf.IdEstatus = 1 AND cue.IdTipoDProducto = 143 AND cue.IdEstatus IN ( 1, 53, 73 )
				GROUP BY tsf.IdCuenta
				)fechaUltProxPago ON fechaUltProxPago.IdCuenta = cue.IdCuenta
LEFT JOIN(SELECT ru.IdAsentamiento,r.Codigo
		   FROM dbo.tGYCRutasD ru WITH(NOLOCK) 
		   INNER JOIN dbo.tGYCRutas r WITH(NOLOCK) ON r.IdRuta = ru.IdRuta
		) AS ruta ON ruta.IdAsentamiento = IIF(domSocioCobranza.IdDomicilio IS NOT NULL,domSocioCobranza.IdAsentamiento, domSocio.IdAsentamiento)
WHERE NOT EXISTS(SELECT 1 FROM dbo.tGYCcuentasJuridico juridico WITH(NOLOCK) WHERE juridico.IdCuenta=cue.IdCuenta AND juridico.IdEstatus=1)	
		AND (ISNULL(MontosParcialidades.ProcentajePagadoAmortzacion,0)< 50)
		

) 
GO