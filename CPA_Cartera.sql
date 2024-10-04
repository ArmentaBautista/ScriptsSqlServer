IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fAYCcartera')
	DROP FUNCTION fAYCcartera
GO


CREATE FUNCTION fAYCcartera
(
	 @FechaCartera DATE =''
)
RETURNS TABLE
AS
RETURN
    ( 
		SELECT
		[CodigoSucursal] = suc.Codigo
		,[Sucursal] = suc.Descripcion
		,[NoSocio] = sc.Codigo
		,[Socio] = p.Nombre
		,[CodigoProducto] = pf.Codigo
		,[Producto] = pf.Descripcion 
		,[NoCuenta] = c.codigo
		,[TipoAmortizacion]= tamor.Descripcion
		,[NoPagos] = c.NumeroParcialidades
		,[PeriodicidadPago] = tplazo.Descripcion
		,[DiasPeriodo] = c.Dias
		,[DiasAño] = c.DiasTipoAnio
		,[TasaInteresAnual] = c.InteresOrdinarioAnual
		,[TasaInteresMensual] = c.InteresOrdinarioMensual
		,[TasaMoratorioAnual] = c.InteresMoratorioAnual
		,[TasaMoratorioMensual] = c.InteresMoratorioMensual
		,[TasaIVA] = c.TasaIva
		,[FechaActivacion] = c.FechaActivacion
		,[Monto Solicitado] = c.MontoSolicitado
		,[MontoOtorgado] = c.Monto
		,[MontoEntregado] = c.MontoEntregado
		,[FechaVencimiento] = c.Vencimiento
		,[Finalidad] = fin.Descripcion
		,[FinalidadDescripcion] = c.DescripcionLarga
		,[TipoCredito] = tprod.Descripcion
		,[Division] = division.Descripcion
		,[DiasMoralCapital] = cr.DiasMoraCapital
		,[DiasMoraInteres] = cr.DiasMoraInteres
		,[ParcialidadesAtrasadas] = cr.ParcialidadesCapitalAtrasadas
		,[Capital] = cr.Capital
		,[CapitalVigente] = cr.CapitalVigente
		,[CapitalVencido] = cr.CapitalVencido
		,[CapitalAtrasado] = cr.CapitalAtrasado
		,[CapitalActual] = cr.CapitalExigible
		,[IO] = cr.InteresOrdinario
		,[IVA IO] = cr.IVAInteresOrdinario
		,[IO Atrasado] = cr.interesOrdinarioAtrasado
		,[IVA IO Atrasado] = cr.IVAinteresOrdinarioAtrasado
		,[IO Total Atrasado] = cr.InteresOrdinarioTotalAtrasado
		,[IO Vigente] = cr.InteresOrdinarioVigente
		,[IO Vencido] = cr.InteresOrdinarioVencido
		,[IO CuentasOrden] = cr.InteresOrdinarioCuentasOrden
		,[IM Total] = cr.InteresMoratorioTotal
		,[IVA IM] = cr.IVAinteresMoratorio
		,[IM Vigente] = cr.InteresMoratorioVigente
		,[IM Vencido] = cr.InteresMoratorioVencido
		,[IM CuentasOrden] = cr.InteresMoratorioCuentasOrden
		,[Cargos] = cr.Cargos
		,[IVA Cargos] = cr.CargosImpuestos
		,[Cargos Total] = cr.CargosTotal
		,[SaldoAtrasado] = cr.CapitalAtrasado 
						+ cr.interesOrdinarioAtrasado +  cr.IVAinteresOrdinarioAtrasado
						+ cr.InteresMoratorioTotal + cr.IVAInteresMoratorio  
						+ cr.Cargos + cr.CargosImpuestos
		,[SaldoAlDia] = cr.CapitalAtrasado 
						+ cr.InteresOrdinario +  cr.IVAInteresOrdinario 
						+ cr.IVAInteresMoratorio + cr.InteresMoratorioTotal  
						+ cr.Cargos + cr.CargosImpuestos
		,[SaldoActual] = cr.CapitalExigible 
						+ cr.InteresOrdinario +  cr.IVAInteresOrdinario 
						+ cr.IVAInteresMoratorio + cr.InteresMoratorioTotal  
						+ cr.Cargos + cr.CargosImpuestos
		,[EstatusCartera] = ecartera.Descripcion
		,[ProximoVencimiento] = cr.ProximoVencimiento
		,[FechaUltimoPagoCapital] = hd.FechaUltimoPagoCapital
		,[FechaUltimoPagoInteres] = hd.FechaUltimoPagoInteres
		,[RestructuraRenovacion] = cr.RestructuraRenovacion
		,[PagosSostenidos]=c.PagosSostenidos
		,[Estimacion] = cr.Estimacion
		,[EstimacionAdicional] = cr.EstimacionAdicional
		,[EstimacionCNBV] = cr.EstimacionCNBV
		,[EstimacionRiesgosOperativos] = cr.EstimacionRiesgosOperativos
		,[Rango Morosidad] = tbl.Descripcion
		,[Asentamiento/Colonia] = asentamiento.Descripcion
		,[Localidad/Ciudad] = ciudad.Descripcion
		,[Municipio] = municipio.Descripcion
		,[Telefonos] = tel.Telefonos
		,[Aval1] = avales.Aval1
		,[Aval2] = avales.Aval2
		,[Aval3] = avales.Aval3
		FROM tAYCcartera cr WITH ( NOLOCK )
		INNER JOIN tayccuentas c  WITH(NOLOCK) ON c.idcuenta=cr.IdCuenta
		INNER JOIN dbo.tCTLtiposD tplazo  WITH(NOLOCK) ON tplazo.IdTipoD = c.IdTipoDPlazo
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		LEFT JOIN dbo.tCTLasentamientos asentamiento  WITH(NOLOCK) ON asentamiento.IdAsentamiento = p.IdAsentamiento
		LEFT JOIN dbo.tCTLciudades ciudad  WITH(NOLOCK) ON ciudad.IdCiudad = p.IdCiudad
		left JOIN dbo.tCTLmunicipios municipio  WITH(NOLOCK) ON municipio.IdMunicipio = p.IdMunicipio
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
		INNER JOIN dbo.tAYCfinalidades fin  WITH(NOLOCK) ON fin.IdFinalidad = c.IdFinalidad
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		INNER JOIN dbo.tCTLestatus ecartera  WITH(NOLOCK) ON ecartera.IdEstatus = cr.IdEstatusCartera
		INNER JOIN (       SELECT   0 AS PlazoInicial , 0 AS PlazoFinal ,Descripcion = '0 Días'
					 UNION SELECT   1 AS PlazoInicial ,3 AS PlazoFinal ,Descripcion = '1 a 3 Días'
					 UNION SELECT   4 AS PlazoInicial ,30 AS PlazoFinal ,Descripcion = '4 a 30 Días'
					 UNION SELECT   31 AS PlazoInicial ,60 AS PlazoFinal ,Descripcion = '31 a 60 Días'
					 UNION SELECT   61 AS PlazoInicial ,90 AS PlazoFinal ,Descripcion = '61 a 90 Días'
					 UNION SELECT   91 AS PlazoInicial ,180 AS PlazoFinal ,Descripcion = '91 a 180 Días'
					 UNION SELECT   181 AS PlazoInicial ,360 AS PlazoFinal ,Descripcion = '181 a 360 Días'
					 UNION SELECT   361 AS PlazoInicial , 999999 AS PlazoFinal ,Descripcion = 'Mayor a 360 Días'
					) tbl ON cr.MoraMaxima BETWEEN tbl.PlazoInicial AND tbl.PlazoFinal
		LEFT JOIN dbo.vCATtelefonosAgrupados tel WITH (NOLOCK) ON tel.IdRel = p.IdRelTelefonos
		LEFT JOIN tAYCavalesCartera avales  WITH(NOLOCK)  ON avales.RelAvales = c.RelAvales
		INNER JOIN dbo.tCNTdivisiones division  WITH(NOLOCK) ON division.IdDivision = c.IdDivision
		INNER JOIN dbo.tCTLtiposD tprod  WITH(NOLOCK) ON tprod.IdTipoD = c.IdTipoDAIC
		LEFT JOIN dbo.tSDOhistorialDeudoras hd  WITH(NOLOCK) ON hd.IdCuenta = c.IdCuenta AND hd.IdPeriodo = cr.IdPeriodo
		INNER JOIN dbo.tCTLtiposD tamor  WITH(NOLOCK) ON tamor.IdTipoD=c.IdTipoDParcialidad
WHERE cr.FechaCartera=@FechaCartera
 );
 GO
