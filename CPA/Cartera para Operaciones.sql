
IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnAYCcarteraOperaciones')
	DROP PROC pCnAYCcarteraOperaciones
GO

CREATE PROC pCnAYCcarteraOperaciones
	@FechaCartera AS DATE
AS

		SELECT  
						EstatusCartera=estCar.descripcion,
						[Rango Morosidad] = tbl.Descripción ,
						funcion.[Mora Máxima],
						funcion.[Días mora Capital]
						,funcion.[Días mora Interés], 

						CodigoSucursal = suc.Codigo ,
						funcion.Sucursal,
						funcion.Socio ,
						funcion.[Nombre Socio] ,
						Producto = cuenta.Descripcion ,
						Finalidad = cuenta.DescripcionLarga,
						Cuenta = cuenta.Codigo ,
						cuenta.FechaActivacion ,
						cuenta.MontoEntregado ,
						cuenta.Vencimiento ,
                
						funcion.[Capital atrasado] ,
				
						SaldoCapital = funcion.[Capital vigente] + funcion.[Capital Vencido] ,
						[SaldoInteresOrdinario] = funcion.[Interés Ordinario Vigente] + funcion.[Interés Ordinario Vencido] + funcion.[Interés Ordinario Cuentas Orden] ,
						[IVAInteresOrdinario] = funcion.[IVA Interés Ordinario] ,
						[SaldoInteresMoratorio] = funcion.[Interés Moratorio Vigente] + funcion.[Interés Moratorio Vencido] + funcion.[Interés Moratorio Cuentas Orden] ,
						[IVA Interés Moratorio] = funcion.[IVA Interés Moratorio] ,
		        
						SaldoAtrasado = funcion.[Capital atrasado] + funcion.[Interés Ordinario Vigente] + funcion.[Interés Ordinario Vencido] + funcion.[Interés Ordinario Cuentas Orden]
						+ ROUND(( funcion.[Interés Ordinario Vigente] + funcion.[Interés Ordinario Vencido] + funcion.[Interés Ordinario Cuentas Orden] ) * cuenta.TasaIva,2) 
						+ funcion.[Interés Moratorio Vigente] + funcion.[Interés Moratorio Vencido] + funcion.[Interés Moratorio Cuentas Orden]
						+ ROUND(( funcion.[Interés Moratorio Vigente] + funcion.[Interés Moratorio Vencido] + funcion.[Interés Moratorio Cuentas Orden] ) * cuenta.TasaIva,2)  ,
                
						SaldoTotal = funcion.[Capital vigente] + funcion.[Capital Vencido] + funcion.[Interés Ordinario Vigente] + funcion.[Interés Ordinario Vencido] + funcion.[Interés Ordinario Cuentas Orden]
						+ ROUND(( funcion.[Interés Ordinario Vigente] + funcion.[Interés Ordinario Vencido] + funcion.[Interés Ordinario Cuentas Orden] ) * cuenta.TasaIva, 2) + funcion.[Interés Moratorio Vigente]
						+ funcion.[Interés Moratorio Vencido] + funcion.[Interés Moratorio Cuentas Orden] 
						+ ROUND(( funcion.[Interés Moratorio Vigente] + funcion.[Interés Moratorio Vencido] + funcion.[Interés Moratorio Cuentas Orden] ) * cuenta.TasaIva,2)  ,
                
						SaldoExigible = ISNULL(funcion.[Capital Exigible], 0) + funcion.[Interés Ordinario Vigente]+ funcion.[Interés Ordinario Vencido]+ funcion.[Interés Ordinario Cuentas Orden]
						+ ROUND(( funcion.[Interés Ordinario Vigente]+ funcion.[Interés Ordinario Vencido]+ funcion.[Interés Ordinario Cuentas Orden] ) * cuenta.TasaIva,2) + funcion.[Interés Moratorio Vigente]
						+ funcion.[Interés Moratorio Vencido]+ funcion.[Interés Moratorio Cuentas Orden]
						+ ROUND(( funcion.[Interés Moratorio Vigente]+ funcion.[Interés Moratorio Vencido]+ funcion.[Interés Moratorio Cuentas Orden] ) * cuenta.TasaIva,2) ,
                
						[ProximoPago] = funcion.[Próximo Abono] ,
				
				
               
						usrS.Usuario AS EjecutivoCaptura,
						usrA.Usuario AS Autorizador,
						usrI.Usuario AS EjecutivoInstrumentacion,
						usrAc.Usuario AS UsuarioActivacion,
						usrE.Usuario AS UsuarioDesembolso,

						Asentamiento = ase.Descripcion ,
						Municipio = mun.Descripcion ,
						p.Domicilio ,
						[Teléfono] = tel.Telefonos ,
						avales.Aval1 ,
						avales.Aval2 ,
						avales.Aval3 ,
                
			--            [Saldo al Día] = funcion.SaldoAlDía,
						--[Saldo Exigible] = funcion.SaldoExigible,
					 --   [Total a Liquidar] = funcion.TotalALiquidar,
					 --   [Saldo al Día Sin Cargos] = funcion.SaldoAlDíaSinCargos,
					 --   [Saldo Exigible Sin Cargos] = funcion.SaldoExigibleSinCargos,
					 --   [Total a Liquidar Sin Cargos]= funcion.TotalALiquidarSinCargos,			
				
						1 AS Conteo		
			
			  FROM      fAYCconsultarCartera(@FechaCartera, '*', '*') AS funcion
						INNER JOIN tAYCcuentas cuenta WITH ( NOLOCK ) ON funcion.IdCuenta = cuenta.IdCuenta 
						INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK)  ON ce.IdCuenta = cuenta.IdCuenta
						INNER JOIN dbo.tCTLestatus estCar WITH(NOLOCK) ON estCar.IdEstatus = cuenta.IdEstatusCartera
						INNER JOIN tCTLsucursales suc WITH ( NOLOCK ) ON suc.IdSucursal=cuenta.IdSucursal

						INNER JOIN tCTLusuarios usrS  WITH(NOLOCK) ON usrS.IdUsuario= cuenta.IdUsuarioAlta 
						INNER JOIN dbo.tCTLusuarios usrA WITH(NOLOCK) ON usrA.IdUsuario = cuenta.IdUsuarioAutorizo
						INNER JOIN dbo.tCTLusuarios usrI WITH(NOLOCK) ON usrI.IdUsuario = cuenta.IdUsuarioInstrumento
						INNER JOIN dbo.tCTLusuarios usrAc WITH(NOLOCK) ON usrAc.IdUsuario = ce.IdUsuarioActivo
						INNER JOIN dbo.tCTLusuarios usrE WITH(NOLOCK) ON usrE.IdUsuario = cuenta.IdUsuarioEntrego

						--INNER JOIN dbo.tSDOsaldos saldo ON saldo.IdCuenta = cuenta.IdCuenta
                
						--INNER JOIN tAYCproductosFinancieros pr WITH ( NOLOCK ) ON cuenta.IdProductoFinanciero = pr.IdProductoFinanciero
						INNER JOIN tSCSsocios soc WITH ( NOLOCK ) ON cuenta.IdSocio = soc.IdSocio
						INNER JOIN tGRLpersonas p WITH ( NOLOCK ) ON soc.IdPersona = p.IdPersona           
				     
						INNER JOIN tCTLasentamientos ase WITH ( NOLOCK ) ON p.IdAsentamiento = ase.IdAsentamiento
						INNER JOIN tCTLmunicipios mun WITH ( NOLOCK ) ON p.IdMunicipio = mun.IdMunicipio
                	
						INNER JOIN ( SELECT   0 AS PlazoInicial ,
										0 AS PlazoFinal ,
										Descripción = 'A 0 Días'
							   UNION 
							   SELECT   1 AS PlazoInicial ,
										3 AS PlazoFinal ,
										Descripción = 'B 1 a 3 Días'
							   UNION
							   SELECT   4 AS PlazoInicial ,
										30 AS PlazoFinal ,
										Descripción = 'C 4 a 30 Días'
							   UNION
							   SELECT   31 AS PlazoInicial ,
										60 AS PlazoFinal ,
										Descripción = 'D 31 a 60 Días'
							   UNION
							   SELECT   61 AS PlazoInicial ,
										90 AS PlazoFinal ,
										Descripción = 'E 61 a 90 Días'
							   UNION
							   SELECT   91 AS PlazoInicial ,
										180 AS PlazoFinal ,
										Descripción = 'F 91 a 180 Días'
							   UNION
							   SELECT   181 AS PlazoInicial ,
										360 AS PlazoFinal ,
										Descripción = 'G 181 a 360 Días'
							   UNION
							   SELECT   361 AS PlazoInicial ,
										999999 AS PlazoFinal ,
										Descripción = 'F Mayor a 360 Días'
							 ) tbl ON funcion.[Mora Máxima] BETWEEN tbl.PlazoInicial AND tbl.PlazoFinal

						LEFT JOIN dbo.vCATtelefonosAgrupados tel WITH ( NOLOCK ) ON tel.IdRel = p.IdRelTelefonos
	
						LEFT JOIN ( SELECT  cuenta.IdCuenta ,
											CapitalMasAtrasado = p.Capital
											- ( p.CapitalPagado + p.CapitalCondonado )
									FROM tAYCcuentas cuenta WITH ( NOLOCK )    
									INNER JOIN tAYCparcialidades p WITH ( NOLOCK ) ON p.IdCuenta= cuenta.IdCuenta
																					AND p.Vencimiento < @FechaCartera
									INNER JOIN  dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = p.IdEstatus AND e.IdEstatus=1
									WHERE cuenta.IdTipoDProducto=143 AND cuenta.PrimerVencimientoPendienteCapital = p.Vencimiento
								  ) cma ON cuenta.IdCuenta = cma.IdCuenta
                
						LEFT JOIN tAYCavalesCartera avales ON cuenta.RelAvales = avales.RelAvales
             
