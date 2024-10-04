
USE iERP_FNG_CSM
GO

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fGYCAvisosCobranzaFNG')
BEGIN
	DROP FUNCTION fGYCAvisosCobranzaFNG
	SELECT 'fGYCAvisosCobranzaFNG BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fGYCAvisosCobranzaFNG(
										@Sucursal VARCHAR(20)='*'
										,@MoraInicial INT =0
										,@MoraFinal INT =0
										,@CodigoRuta VARCHAR(20)='*'
										,@Socio VARCHAR(50)='*'
										,@FechaCartera DATE ='19000101'
										,@Producto VARCHAR(50)='*'
										,@Domicilio VARCHAR(150)='*'
										,@Empresa VARCHAR(150)='*'
										)
RETURNS TABLE
RETURN(
SELECT 
		socio= CONCAT(soc.Codigo,' <-> ',perSocio.Nombre)
		,Domicilio = CASE WHEN domSocioCobranza.IdDomicilio IS NOT NULL THEN
						  	domSocioCobranza.Calle
						  WHEN domSocio.IdDomicilio IS NOT NULL OR domSocio.Descripcion <> '' THEN 
						  	domSocio.Calle
						  ELSE --domCoral.calle 
						  	CONCAT(domCoral.calle,' ',domCoral.numero_ext,' ',domCoral.numero_int)
					  END
		,DetalleDomicilioSocio =CASE WHEN domSocioCobranza.IdDomicilio IS NOT NULL THEN 
									 	domSocioCobranza.Descripcion
									 WHEN domSocio.IdDomicilio IS NOT NULL OR domSocio.Descripcion <> ''	THEN 
									 	domSocio.Descripcion
									 ELSE--CONCAT(domCoral.calle,' ',domCoral.numero_ext,' ',domCoral.numero_int,' ',domCoral.EntreCalles,' ',domCoral.Asentamiento,' C.P. ',domCoral.codpostal,' ',domCoral.comunidad,' ',domCoral.Ciudad,' ',domCoral.Estado) COLLATE DATABASE_DEFAULT									
									 	domCoral.DomicilioCompleto
								END			
		,Cuenta = CONCAT(cue.Codigo,' <-> ',cue.Descripcion)
		,SaldoCapital = CONVERT(NUMERIC(18,2),cue.SaldoCapital)
		--,SaldoAlDía = cartera.CapitalAtrasado + cartera.InteresOrdinario + cartera.InteresMoratorioTotal +cartera.IVAInteresOrdinario + cartera.Cargos + cartera.CargosImpuestos --cartera.IVAInteresMoratorio +				
		,fechaUltProxPago.FechaUltimoPago
		,TotalALiquidar = CONVERT(NUMERIC(18,2), cue.SaldoCapital + (CASE WHEN cartera.IdEstatusCartera=29 THEN
										cartera.InteresOrdinario - cartera.InteresOrdinarioCuentasOrden
								 ELSE
										cartera.InteresOrdinario END)
							+ cartera.InteresMoratorioTotal + cartera.IVAInteresOrdinario + cartera.Cargos + cartera.CargosImpuestos)--cartera.IVAInteresMoratorio +
		,MontoEntregado=CONVERT(NUMERIC(18,2),cue.MontoEntregado)
		,CapitalAtrasado = CONVERT(NUMERIC(18,2),cartera.CapitalAlDia)
		,InteresOrdinario = CASE WHEN cartera.IdEstatusCartera=29 THEN
										CONVERT(NUMERIC(18,2),cartera.InteresOrdinario - cartera.InteresOrdinarioCuentasOrden)
								 ELSE
										CONVERT(NUMERIC(18,2),cartera.InteresOrdinario) END	
		,InteresMoratorio= CONVERT(NUMERIC(18,2),(cartera.InteresMoratorioTotal - cartera.IVAinteresMoratorio))
		,IVA = CONVERT(NUMERIC(18,2),cartera.IVAInteresOrdinario+cartera.IVAinteresMoratorio)--+cartera.CargosImpuestos		
		,SaldoTotalSinCargos= CONVERT(NUMERIC(18,2),cartera.CapitalAlDia + (CASE WHEN cartera.IdEstatusCartera=29 THEN
																				 		cartera.InteresOrdinario - cartera.InteresOrdinarioCuentasOrden
																				  ELSE
																				 		cartera.InteresOrdinario END	)
								+ cartera.InteresMoratorioTotal + cartera.IVAInteresOrdinario) --+ cartera.IVAInteresMoratorio 		
		,cartera.MoraMaxima
		,PlazoVencido=cue.PrimerVencimientoPendienteInteres
		,pA.ParcialidadesAtrasadas
		,EstatusCartera=estCartera.Descripcion
		,PorcentagePagado = CASE WHEN saldoCuenta.CapitalPagado < cue.MontoEntregado THEN 
									CONCAT('% ',CONVERT(NUMERIC(18,2), ROUND(((ISNULL(saldoCuenta.CapitalPagado,0) /ISNULL(cue.MontoEntregado,0))*100),2)))
								ELSE 
									CONCAT('% ',CONVERT(NUMERIC(18,2), ROUND(((ISNULL(cue.MontoEntregado,0) /ISNULL(saldoCuenta.CapitalPagado,0))*100),2)))
								END	
		,Amortizacion=CONVERT(NUMERIC(18,2), ISNULL(MontosParcialidades.TotalParcialidad,0))

		,AportacionSocial = CONVERT(NUMERIC(18,2),haberessocio.AportacionSocial)
		,Ahorro = CONVERT(NUMERIC(18,2),haberessocio.Ahorro)	
		,Reciprocidad = CONVERT(NUMERIC(18,2),haberessocio.Reciprocidad)
		
		,cartera.FechaCartera
		,contenidoAvisos.Encabezado
		,contenidoAvisos.Contenido1
		,contenidoAvisos.Contenido2
		,contenidoAvisos.Contenido3
		,AvisoCobranzaDescripcion =CONCAT(contenidoAvisos.MoraInicial,' A ',contenidoAvisos.MoraFinal,' DIAS DE MORA')
		,NombreEmpresa= lab.Empresa -- perEmpresa.Nombre
		,cue.IdCuenta
		,ProcentajePagadoAmortzacion=ISNULL(MontosParcialidades.ProcentajePagadoAmortzacion,0)
		,Sucursal = SUC.Codigo
		,Producto = producto.Codigo
		,ProductoDescripcion = producto.Descripcion
FROM dbo.tAYCcuentas cue WITH(NOLOCK)
INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = cue.IdProductoFinanciero
INNER JOIN dbo.tSCSsocios soc WITH(NOLOCK) ON soc.IdSocio = cue.IdSocio AND cue.IdTipoDProducto=143 AND soc.IdEstatus=1 AND soc.EsSocioValido=1 
INNER JOIN dbo.tCTLsucursales suc With(nolock) ON suc.IdSucursal = cue.IdSucursal
INNER JOIN dbo.tGRLpersonas perSocio WITH(NOLOCK) ON perSocio.IdPersona = soc.IdPersona AND cue.IdEstatus IN(1,53,73)
INNER JOIN dbo.tAYCcartera cartera With(nolock) ON cartera.IdCuenta = cue.IdCuenta AND cartera.FechaCartera= @FechaCartera
INNER JOIN dbo.tGRLpersonasFisicas perFisSocio WITH(NOLOCK) ON perFisSocio.IdPersonaFisica = perSocio.IdPersonaFisica
INNER JOIN dbo.tCTLestatus estCartera With(nolock) ON cue.IdEstatusCartera=estCartera.IdEstatus
INNER JOIN dbo.tSDOsaldos saldoCuenta With(nolock) on cue.IdCuenta=saldoCuenta.IdCuenta
--INNER JOIN dbo.tCTLempresas empresa WITH(NOLOCK) ON empresa.IdEmpresa=1
--INNER JOIN dbo.tGRLpersonas perEmpresa WITH(NOLOCK) ON perEmpresa.IdPersona = empresa.IdPersona
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
LEFT JOIN dbo.tCTLlaborales lab  WITH(NOLOCK) ON lab.IdPersona = perSocio.IdPersona
WHERE NOT EXISTS(SELECT 1 FROM dbo.tGYCcuentasJuridico juridico WITH(NOLOCK) WHERE juridico.IdCuenta=cue.IdCuenta AND juridico.IdEstatus=1)	
		--AND NOT EXISTS(SELECT 1 FROM dbo.tGYCcuentasProcesoJudicial judicial With(NOLOCK) WHERE cue.IdCuenta=judicial.IdCuenta AND judicial.IdEstatus=1)
		AND (ISNULL(MontosParcialidades.ProcentajePagadoAmortzacion,0)< 50)
		AND (@Sucursal='*' OR suc.Codigo=@Sucursal)
		AND ((@MoraInicial=0 AND @MoraFinal=0)OR (cartera.MoraMaxima BETWEEN @MoraInicial AND @MoraFinal))
		AND (@CodigoRuta='*' OR ruta.Codigo=@CodigoRuta)
		AND (@Socio='*' OR soc.Codigo=@Socio)
		-- Nuevos reporteador
		AND (@Producto='*' OR producto.Descripcion=@Producto)
		AND (@Domicilio='*' OR CASE WHEN domSocioCobranza.IdDomicilio IS NOT NULL THEN
								  	domSocioCobranza.Calle
								  WHEN domSocio.IdDomicilio IS NOT NULL OR domSocio.Descripcion <> '' THEN 
								  	domSocio.Calle
								  ELSE --domCoral.calle 
								  	CONCAT(domCoral.calle,' ',domCoral.numero_ext,' ',domCoral.numero_int)
							  END = @Domicilio)
		AND (@Empresa='*' OR lab.Empresa LIKE '%' + @Empresa + '%')
)
 
GO

