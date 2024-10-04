

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fAYCconsultarCartera')
BEGIN
	DROP function dbo.fAYCconsultarCartera
	SELECT 'fAYCconsultarCartera BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fAYCconsultarCartera]
    (
      @FechaCartera DATE ,
      @Sucursal VARCHAR(20) ,
      @Cuenta VARCHAR(30)
    )
RETURNS TABLE
AS
RETURN
    ( SELECT    cta.IdCuenta ,
                soc.Codigo AS Socio ,
                [Código Interfaz] = soc.CodigoInterfaz ,
                [Nombre Socio] = prs.Nombre ,
                Cuenta = cta.Codigo ,
                Sucursal = suc.Codigo ,
                [Sucursal Nombre] = suc.Descripcion ,
                Producto = pf.Descripcion ,
                [Ocupación] = ListaOcupacion.Descripcion,
                [Activación] = cta.FechaActivacion ,
                Plazo = DATEDIFF(m, cta.FechaActivacion, cta.Vencimiento) ,
                [Dias Plazo] = cta.Dias ,
                [Número de Parcialidades] = cta.NumeroParcialidades ,
                Finalidad = fin.Descripcion ,
                [Descripción Finalidad] = cta.DescripcionLarga ,
                [División]=division.Descripcion,
		--TPrest='',
                [Monto Entregado] = cta.MontoEntregado ,
                [Tasa Interes Ordinario] = cta.InteresOrdinarioAnual * 100 ,
		--IOPend='',
                [Fecha último pago Capital] = h.FechaUltimoPagoCapital ,
                [Fecha último pago Interés] = h.FechaUltimoPagoInteres ,
                [Días Transcurridos] = c.DiasTranscurridos ,
                cta.Vencimiento ,
                [Capital atrasado] = c.CapitalAtrasado ,
                [Días mora Capital] = c.DiasMoraCapital ,
                [Días mora Interés] = c.DiasMoraInteres ,
				--[Mora Máxima]=c.MoraMaxima, 
                [Parcialidades atrasadas] = c.ParcialidadesCapitalAtrasadas ,
                [Capital vigente] = c.CapitalVigente ,
                [Interés Ordinario Vigente] = c.InteresOrdinarioVigente ,
				[Interés Ordinario Atrasado] = c.InteresOrdinarioAtrasado,
				[IVA Interés Ordinario Atrasado] = c.IVAinteresOrdinarioAtrasado,
                [Interés Moratorio Total] = c.InteresMoratorioTotal ,
                [Interés Moratorio Vigente] = InteresMoratorioVigente ,
                [Interés Moratorio Vencido] = InteresMoratorioVencido ,
                [Interés Moratorio Cuentas Orden] = c.InteresMoratorioCuentasOrden ,
                [Capital Vencido] = CapitalVencido ,
                [Interés Ordinario Vencido] = InteresOrdinarioVencido ,
                [Interés Ordinario Cuentas Orden] = c.InteresOrdinarioCuentasOrden ,
                [Interés Ordinario Mes] = InteresOrdinarioPeriodo ,
                [En Cartera vencida] = CASE WHEN estatusCartera.IdEstatus = 29
                                            THEN 'Sí'
                                            ELSE 'No'
                                       END ,
		--IOpagado='',
		--IOxPagar='',
                [Monto Solicitado] = cta.MontoSolicitado ,
		--Estimacion=0,
		--IODevPagado='',
		--IODevNoPagado='',
		--IOxDev='',
                [Renovada/Restructurada] = CASE WHEN cta.IdCuentaRenovada
                                                     + cta.IdCuentaRestructurada > 0
                                                THEN 'Sí'
                                                ELSE 'No'
                                           END ,
		--ZonaMarg='',
                [Tipo de préstamo] = cla.Descripcion ,
		--ZonaMarginal='',
                [Monto Garantía] = c.ParteCubierta,
		--[Garantia Hipotecaria]='',
		--[CubiertaGarHipo] ='',
		--[ParteCubierta] =0,
		--[ParteExpuesta] =0,
		--[Porcentaje Estimacion parte cubierta] =0,
		--[Porcentaje Estimacion parte expuesta] =0,
		--[Porcentaje Régimen Transitorio] =100,
		--[Estimación Parte Cubierta] =h.EstimacionParteCubierta,
		--[Estimacion Parte Expuesta] =h.EstimacionParteExpuesta,
		--[Estimación Adicional] =h.EstimacionAdicional,
                [Único] = CASE WHEN cta.IdTipoDParcialidad = 719 THEN 'Sí'
                               ELSE 'No'
                          END ,
                [Pago Fijo] = CASE WHEN cta.IdTipoDParcialidad = 415 THEN 'Sí'
                                   ELSE 'No'
                              END ,
                [Interés S/S insolutos] = 'Sí' ,
                [Día Fijo] = CASE WHEN cta.VenceMismoDia = 1 THEN 'Sí'
                                  ELSE 'No'
                             END ,
                [Condición Pago] = mp.DescripcionModalidadPago ,
		--[SubTipoPrestamo] ='',
                [Pagos Sostenidos] = cta.PagosSostenidos ,
                [Próximo Abono] = c.ProximoVencimiento ,
                [Monto Otorgado Mes] = CASE WHEN MONTH(cta.FechaActivacion) = MONTH(@FechaCartera)
                                                 AND YEAR(cta.FechaActivacion) = YEAR(@FechaCartera)
                                            THEN cta.MontoEntregado
                                            ELSE 0
                                       END ,
                [Capital Exigible] = c.CapitalExigible ,
                [Convenio] = cce.Folio,
				[SaldoAlDía] = c.CapitalAtrasado + IIF(cta.IdEstatusCartera=28,(c.InteresOrdinario-c.InteresOrdinarioCuentasOrden),c.InteresOrdinario) + c.InteresMoratorioTotal + c.IVAInteresOrdinario +  c.Cargos + c.CargosImpuestos,
		        [SaldoExigible] = c.CapitalExigible + IIF(cta.IdEstatusCartera=28,(c.InteresOrdinario-c.InteresOrdinarioCuentasOrden),c.InteresOrdinario) + c.InteresMoratorioTotal + c.IVAInteresOrdinario + c.Cargos + c.CargosImpuestos,
		        [TotalALiquidar] = cta.SaldoCapital + IIF(cta.IdEstatusCartera=28,(c.InteresOrdinario-c.InteresOrdinarioCuentasOrden),c.InteresOrdinario) + c.InteresMoratorioTotal + c.IVAInteresOrdinario + c.Cargos + c.CargosImpuestos,
                [SaldoAlDíaSinCargos] = c.CapitalAtrasado + IIF(cta.IdEstatusCartera=28,(c.InteresOrdinario-c.InteresOrdinarioCuentasOrden),c.InteresOrdinario) + c.InteresMoratorioTotal  + c.IVAInteresOrdinario ,
		        [SaldoExigibleSinCargos] = c.CapitalExigible + IIF(cta.IdEstatusCartera=28,(c.InteresOrdinario-c.InteresOrdinarioCuentasOrden),c.InteresOrdinario) + c.InteresMoratorioTotal  + c.IVAInteresOrdinario,
		        [TotalALiquidarSinCargos] = cta.saldocapital + IIF(cta.IdEstatusCartera=28,(c.InteresOrdinario-c.InteresOrdinarioCuentasOrden),c.InteresOrdinario) + c.InteresMoratorioTotal  + c.IVAInteresOrdinario,
				[IVA Interés Ordinario] = C.IVAInteresOrdinario,
				[IVA Interés Moratorio] = c.IVAInteresMoratorio
				,[Usuario Solicitud]=perUsuAlta.Nombre
				,[Usuario Autorizo]=perUsuAutorizo.Nombre
				,[Fecha último pago de capital]=c.FechaUltimoPagoCapital
				,[Monto último pago de capital]=c.MontoUltimoPagoCapital
				,[Fecha último pago de Interés]=c.FechaUltimoPagoInteres
				,[Monto último pago de interés]=c.MontoUltimoPagoInteres
				,c.IdEstatusCartera
				--,c.MoraPromedio
				--,c.PagosRealizados
				--,c.PagosAnticipados
				--,c.PagosAtrasados
				--,c.PagosPuntuales				
				--,[Interesés Ordinarios Cobrados]=c.InteresOrdinarioPagado
				--,[Interesés Moratorios Cobrados]=c.InteresMoratorioPagado
				,[Mora Máxima]=ISNULL(Parcialidades.MoraMaxima,0)
				,[Días Promedio de Atraso]=ISNULL(Parcialidades.[Mora Promedio],0)
				,[Número de Pagos Realizados]=ISNULL(Parcialidades.PagosRealizados,0)
				,[Número de Pagos Anticipados o Adelantados]=ISNULL(Parcialidades.[Pagos Anticipados],0)
				,[Número de Pagos con Atraso]=ISNULL(Parcialidades.[Pagos Atrasados],0)
				,[Número de Pagos Puntuales]=ISNULL(Parcialidades.[Pagos Puntuales],0)
				,[Interés Ordinario Cobrado]=Saldos.InteresOrdinarioPagado
				,[Interés Moratorio Cobrado]=Saldos.InteresMoratorioPagado
				,[DiasMora] = iif(c.DiasMoraCapital > c.DiasMoraInteres, c.DiasMoraCapital, c.DiasMoraInteres) 
      FROM      tAYCcartera c WITH ( NOLOCK )
                INNER JOIN dbo.tCTLestatus estatusCartera WITH ( NOLOCK ) ON c.IdEstatusCartera = estatusCartera.IdEstatus
                LEFT JOIN tSDOhistorialDeudoras h WITH ( NOLOCK ) ON c.IdCuenta = h.IdCuenta AND h.IdPeriodo = c.IdPeriodo
                JOIN tAYCcuentas cta WITH ( NOLOCK ) ON c.IdCuenta = cta.IdCuenta
                INNER JOIN dbo.tCTLtiposD tipoProducto WITH ( NOLOCK ) ON cta.IdTipoDProducto = tipoProducto.IdTipoD
                JOIN tSCSsocios soc WITH ( NOLOCK ) ON cta.IdSocio = soc.IdSocio
                JOIN tCTLsucursales suc WITH ( NOLOCK ) ON cta.IdSucursal = suc.IdSucursal
                JOIN tAYCproductosFinancieros pf WITH ( NOLOCK ) ON cta.IdProductoFinanciero = pf.IdProductoFinanciero
                JOIN tCTLtiposD cla WITH ( NOLOCK ) ON cta.IdTipoDAICclasificacion = cla.IdTipoD
                JOIN tAYCfinalidades fin ON cta.IdFinalidad = fin.IdFinalidad
                JOIN tCNTdivisiones division ON division.IdDivision = cta.IdDivision
--join tCTLtiposD tp on cta.IdTipoDParcialidad=tp.IdTipoD
                JOIN vSITmodalidadPago mp WITH ( NOLOCK ) ON cta.IdCuenta = mp.IdCuenta
                JOIN tGRLpersonas prs WITH ( NOLOCK ) ON soc.IdPersona = prs.IdPersona
                INNER JOIN tAYCcuentasEstadisticas ces WITH ( NOLOCK ) ON ces.IdCuenta = c.IdCuenta AND ces.IdApertura = cta.IdApertura
                INNER JOIN tSCSconveniosCreditosEmpresas cce WITH ( NOLOCK ) ON cce.IdConvenioCreditoEmpresa = ces.IdConvenioCreditoEmpresa
                INNER JOIN dbo.tCTLusuarios usuAlta WITH(NOLOCK) ON cta.IdUsuarioAlta=usuAlta.IdUsuario
				INNER JOIN dbo.tGRLpersonas perUsuAlta WITH(NOLOCK) ON perUsuAlta.IdPersona=usuAlta.IdPersonaFisica
				INNER JOIN dbo.tCTLusuarios usuAutorizo WITH(NOLOCK) ON usuAutorizo.IdUsuario=cta.IdUsuarioAutorizo
				INNER JOIN dbo.tGRLpersonas perUsuAutorizo WITH(NOLOCK) ON perUsuAutorizo.IdPersona= usuAutorizo.IdPersonaFisica
				LEFT JOIN dbo.tGRLpersonasFisicas personaFisicas WITH(NOLOCK) ON personaFisicas.IdPersona = prs.IdPersona
				LEFT JOIN dbo.tCATlistasD ListaOcupacion WITH(NOLOCK) ON ListaOcupacion.IdListaD = personaFisicas.IdListaDOcupacion 
				LEFT JOIN (
								SELECT parcialidad.IdCuenta,
								[MoraMaxima]=MAX(CASE WHEN parcialidad.CapitalPagado<parcialidad.Capital AND parcialidad.PagadoCapital='1900-01-01' AND parcialidad.Vencimiento<=@FechaCartera
															 THEN DATEDIFF(DAY,parcialidad.Vencimiento,@FechaCartera)
														WHEN parcialidad.Vencimiento> @FechaCartera
															 THEN 0
														WHEN parcialidad.CapitalPagado>=parcialidad.Capital AND parcialidad.PagadoCapital != '1900-01-01' AND parcialidad.Vencimiento>=parcialidad.PagadoCapital
															 THEN 0
														WHEN parcialidad.CapitalPagado>=parcialidad.Capital AND parcialidad.PagadoCapital = '1900-01-01'
															 THEN 0
														ELSE 
															 DATEDIFF(DAY,parcialidad.Vencimiento,parcialidad.PagadoCapital)
													END ),
								[Mora Promedio]= cast(sum(cast(CASE WHEN parcialidad.CapitalPagado<parcialidad.Capital AND parcialidad.PagadoCapital='1900-01-01' AND parcialidad.Vencimiento<=@FechaCartera
															 THEN DATEDIFF(DAY,parcialidad.Vencimiento,@FechaCartera)
														WHEN parcialidad.Vencimiento> @FechaCartera
															 THEN 0
														WHEN parcialidad.CapitalPagado>=parcialidad.Capital AND parcialidad.PagadoCapital != '1900-01-01' AND parcialidad.Vencimiento>=parcialidad.PagadoCapital
															 THEN 0
														WHEN parcialidad.CapitalPagado>=parcialidad.Capital AND parcialidad.PagadoCapital = '1900-01-01'
															 THEN 0
														ELSE 
															 DATEDIFF(DAY,parcialidad.Vencimiento,parcialidad.PagadoCapital)
													END as numeric(23,2)))/ISNULL(atraso.PagosReales,sum(IIF(IIF( parcialidad.Vencimiento<=@FechaCartera,1,0)=0,1,IIF( parcialidad.Vencimiento<=@FechaCartera,1,0)))) as decimal(18,2)),
								[Pagos Transcurridos]= sum(IIF( parcialidad.Vencimiento<=@FechaCartera,1,0)),
								[PagosRealizados]=ISNULL(atraso.PagosReales,0),
								[Pagos Anticipados]=SUM(IIF(parcialidad.PagadoCapital<parcialidad.Vencimiento AND parcialidad.PagadoCapital != '1900-01-01',1,0)),
								[Pagos Atrasados]=SUM(IIF(parcialidad.PagadoCapital>parcialidad.Vencimiento AND parcialidad.PagadoCapital != '1900-01-01',1,0)),
								[Pagos Puntuales]=SUM(IIF(parcialidad.PagadoCapital=parcialidad.Vencimiento AND parcialidad.PagadoCapital != '1900-01-01',1,0))								
								FROM dbo.tAYCparcialidades parcialidad WITH (NOLOCK)
								LEFT JOIN  dbo.vAYCdiasAtraso atraso on atraso.IdCuenta= parcialidad.IdCuenta
								WHERE parcialidad.IdEstatus=1
								GROUP BY parcialidad.IdCuenta,atraso.PagosReales				
				)Parcialidades ON Parcialidades.IdCuenta = c.IdCuenta
				--INNER JOIN (
				--							 SELECT f.IdCuenta,
				--							 [InteresOrdinarioPagado] = SUM(f.InteresOrdinarioPagado+f.InteresOrdinarioPagadoVencido),
				--							 [InteresMoratorioPagado] = SUM(f.InteresMoratorioPagado+f.InteresMoratorioPagadoVencido)
				--							 FROM tSDOtransaccionesFinancieras f with (nolock)
				--							 where IdEstatus=1
				--							 group by f.IdCuenta
								
				--)Saldos on Saldos.IdCuenta = c.IdCuenta
				INNER JOIN tSDOsaldos Saldos with (nolock) on Saldos.IdCuenta = c.IdCuenta
      WHERE     tipoProducto.IdTipoD = 143
                AND ( suc.Codigo = @Sucursal
                      OR @Sucursal = '*'
                    )
                AND c.FechaCartera = @FechaCartera
                AND ( cta.Codigo = @Cuenta
                      OR @Cuenta = '*'
                    )
    ); 







GO

