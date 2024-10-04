

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vGYCvaloresFiltrosAvisosCobranza')
BEGIN
	DROP VIEW vGYCvaloresFiltrosAvisosCobranza
	SELECT 'vGYCvaloresFiltrosAvisosCobranza BORRADO' AS info
END
GO

CREATE VIEW vGYCvaloresFiltrosAvisosCobranza
AS
--DECLARE @FechaCartera AS DATE='20211009'
--DECLARE @Sucursal VARCHAR(20)='*'
--DECLARE @MoraInicial INT =0
--DECLARE @MoraFinal INT =9999
--DECLARE @CodigoRuta VARCHAR(20)=''
--DECLARE @Socio VARCHAR(50)='*'

SELECT 
		sucursal=suc.Codigo
		,Domicilio = CASE WHEN domSocioCobranza.IdDomicilio IS NOT NULL THEN
						  	domSocioCobranza.Calle
						  WHEN domSocio.IdDomicilio IS NOT NULL OR domSocio.Descripcion <> '' THEN 
						  	domSocio.Calle
						  ELSE --domCoral.calle 
						  	CONCAT(domCoral.calle,' ',domCoral.numero_ext,' ',domCoral.numero_int)
					  END
		--,DetalleDomicilioSocio =CASE WHEN domSocioCobranza.IdDomicilio IS NOT NULL THEN 
		--							 	domSocioCobranza.Descripcion
		--							 WHEN domSocio.IdDomicilio IS NOT NULL OR domSocio.Descripcion <> ''	THEN 
		--							 	domSocio.Descripcion
		--							 ELSE--CONCAT(domCoral.calle,' ',domCoral.numero_ext,' ',domCoral.numero_int,' ',domCoral.EntreCalles,' ',domCoral.Asentamiento,' C.P. ',domCoral.codpostal,' ',domCoral.comunidad,' ',domCoral.Ciudad,' ',domCoral.Estado) COLLATE DATABASE_DEFAULT									
		--							 	domCoral.DomicilioCompleto
		--						END			
		,producto=producto.Descripcion
		,cartera.FechaCartera
FROM dbo.tAYCcuentas cue WITH(NOLOCK)
INNER JOIN dbo.tSCSsocios soc WITH(NOLOCK) ON soc.IdSocio = cue.IdSocio AND cue.IdTipoDProducto=143 AND soc.IdEstatus=1 AND soc.EsSocioValido=1 
INNER JOIN dbo.tCTLsucursales suc With(nolock) ON suc.IdSucursal = cue.IdSucursal
INNER JOIN dbo.tGRLpersonas perSocio WITH(NOLOCK) ON perSocio.IdPersona = soc.IdPersona AND cue.IdEstatus IN(1,53,73)
INNER JOIN dbo.tAYCcartera cartera With(nolock) ON cartera.IdCuenta = cue.IdCuenta --AND cartera.FechaCartera= @FechaCartera
INNER JOIN dbo.tGRLpersonasFisicas perFisSocio WITH(NOLOCK) ON perFisSocio.IdPersonaFisica = perSocio.IdPersonaFisica
INNER JOIN dbo.tCTLestatus estCartera With(nolock) ON cue.IdEstatusCartera=estCartera.IdEstatus
INNER JOIN dbo.tAYCproductosFinancieros producto  WITH(NOLOCK) ON producto.IdProductoFinanciero = cue.IdProductoFinanciero
--INNER JOIN dbo.tAYCavisosCobranzaContenido contenidoAvisos WITH(NOLOCK) ON cartera.MoraMaxima BETWEEN contenidoAvisos.MoraInicial AND contenidoAvisos.MoraFinal AND contenidoAvisos.IdEstatus=1

--LEFT JOIN dbo.fGYCparcialidadesAtrazadas(@FechaCartera) pA ON pA.IdCuenta = cue.IdCuenta
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

LEFT JOIN(SELECT ru.IdAsentamiento,r.Codigo
		   FROM dbo.tGYCRutasD ru WITH(NOLOCK) 
		   INNER JOIN dbo.tGYCRutas r WITH(NOLOCK) ON r.IdRuta = ru.IdRuta
		) AS ruta ON ruta.IdAsentamiento = IIF(domSocioCobranza.IdDomicilio IS NOT NULL,domSocioCobranza.IdAsentamiento, domSocio.IdAsentamiento)
WHERE NOT EXISTS(SELECT 1 FROM dbo.tGYCcuentasJuridico juridico WITH(NOLOCK) WHERE juridico.IdCuenta=cue.IdCuenta AND juridico.IdEstatus=1)	
		--AND NOT EXISTS(SELECT 1 FROM dbo.tGYCcuentasProcesoJudicial judicial With(NOLOCK) WHERE cue.IdCuenta=judicial.IdCuenta AND judicial.IdEstatus=1)
		--AND (ISNULL(MontosParcialidades.ProcentajePagadoAmortzacion,0)< 50)
		--AND (@Sucursal='*' OR suc.Codigo=@Sucursal)
		--AND ((@MoraInicial=0 AND @MoraFinal=0)OR (cartera.MoraMaxima BETWEEN @MoraInicial AND @MoraFinal))
		--AND (@CodigoRuta='' OR ruta.Codigo=@CodigoRuta)
		--AND (@Socio='*' OR soc.Codigo=@Socio)