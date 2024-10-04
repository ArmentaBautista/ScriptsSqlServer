
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fAYCconsultarCarteraCobranza')
BEGIN
	DROP FUNCTION dbo.fAYCconsultarCarteraCobranza
	SELECT 'fAYCconsultarCarteraCobranza BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fAYCconsultarCarteraCobranza]
    (
      @FechaCartera DATE ,
      @Sucursal VARCHAR(20) ,
      @Cuenta VARCHAR(30)
    )
RETURNS TABLE
AS
RETURN
    ( SELECT    funcion.IdCuenta ,
                funcion.Socio ,
                funcion.[Nombre Socio] ,
                Producto = pr.Descripcion ,
                Cuenta = cuenta.Codigo ,
                Sucursal = suc.Codigo ,
                [Activación] = cuenta.FechaActivacion ,
                [Monto Otorgado] = cuenta.MontoEntregado ,
                Vencimiento = cuenta.Vencimiento ,
                [Mora Máxima] =  funcion.[Mora Máxima],
                [Capital Insoluto] = funcion.[Capital vigente] + funcion.[Capital Vencido] ,
                funcion.[Capital atrasado] ,
                [Interés Ordinario] = ISNULL(funcion.[Interés Ordinario Vigente],0)
                + ISNULL(funcion.[Interés Ordinario Vencido],0)
                --+ ISNULL(funcion.[Interés Ordinario Cuentas Orden],0) 
				,
                [IVA Interés Ordinario] = funcion.[IVA Interés Ordinario] ,
                [Interés Moratorio] = funcion.[Interés Moratorio Vigente]
                + funcion.[Interés Moratorio Vencido]
                --+ funcion.[Interés Moratorio Cuentas Orden] 
				,
                [IVA Interés Moratorio] = funcion.[IVA Interés Moratorio] ,
		--[Gastos Cobranza Estimados]=IIF(f.[Días Mora Capital] > 4 OR f.[Días Mora Interés] > 4, isnull([Parcialidades Atrasadas]*cg.Monto, 0),0),
		--[IVA Gastos Cobranza Estimados]=isnull(ROUND([Parcialidades Atrasadas]*cg.Monto*cg.TasaIVA,2),0),
                [Gastos Cobranza Estimados] = ISNULL(ROUND(cg.Cargos, 2), 0) ,
                [IVA Gastos Cobranza Estimados] = ISNULL(ROUND(cg.CargosIVA, 2),0) ,
                [Para regularizarse] = funcion.[Capital atrasado]
					+ funcion.[Interés Ordinario Vigente]
					+ funcion.[Interés Ordinario Vencido]
					--+ funcion.[Interés Ordinario Cuentas Orden]
					+ ROUND(( funcion.[Interés Ordinario Vigente]
					          + funcion.[Interés Ordinario Vencido]
					          --+ funcion.[Interés Ordinario Cuentas Orden] 
							  ) * cuenta.TasaIva,
					        2) + funcion.[Interés Moratorio Vigente]
					+ funcion.[Interés Moratorio Vencido]
					--+ funcion.[Interés Moratorio Cuentas Orden]
					+ ROUND(( funcion.[Interés Moratorio Vigente]
					          + funcion.[Interés Moratorio Vencido]
					  --        + funcion.[Interés Moratorio Cuentas Orden] 
							  ) * cuenta.TasaIva,
					        2) + ISNULL(ROUND(cg.Cargos + cg.CargosIVA, 2), 0) ,
                [Para liquidar] = funcion.[Capital vigente] + funcion.[Capital Vencido]
					+ funcion.[Interés Ordinario Vigente]
					+ funcion.[Interés Ordinario Vencido]
					--+ funcion.[Interés Ordinario Cuentas Orden]
					+ ROUND(( funcion.[Interés Ordinario Vigente]
					          + funcion.[Interés Ordinario Vencido]
					          --+ funcion.[Interés Ordinario Cuentas Orden] 
							  ) * cuenta.TasaIva,
					        2) + funcion.[Interés Moratorio Vigente]
					+ funcion.[Interés Moratorio Vencido]
					--+ funcion.[Interés Moratorio Cuentas Orden]
					+ ROUND(( funcion.[Interés Moratorio Vigente]
					          + funcion.[Interés Moratorio Vencido]
					          --+ funcion.[Interés Moratorio Cuentas Orden] 
							  ) * cuenta.TasaIva,
					        2) + ISNULL(ROUND(cg.Cargos + cg.CargosIVA, 2), 0) ,
                [Días Objetivo] = cuenta.Dias ,
		--[Abono Requerido]=CASE WHEN [Parcialidades Atrasadas] > 0 THEN round(c.MontoEntregado/c.NumeroParcialidades*f.[Parcialidades Atrasadas]-f.[Capital Atrasado],2) ELSE 0 END,
		--se comenta campo para agregar modificación que considera los campos de IVA en cartera para el interes ordinario atrasado.
                --[Abono Requerido] = ISNULL(cma.CapitalMasAtrasado, 0)
                --+ f.[Interés Ordinario Vigente]
                --+ f.[Interés Ordinario Vencido]
                --+ f.[Interés Ordinario Cuentas Orden]
                --+ ROUND(( f.[Interés Ordinario Vigente]
                --          + f.[Interés Ordinario Vencido]
                --          + f.[Interés Ordinario Cuentas Orden] ) * c.TasaIva,
                --        2) + f.[Interés Moratorio Vigente]
                --+ f.[Interés Moratorio Vencido]
                --+ f.[Interés Moratorio Cuentas Orden]
                --+ ROUND(( f.[Interés Moratorio Vigente]
                --          + f.[Interés Moratorio Vencido]
                --          + f.[Interés Moratorio Cuentas Orden] ) * c.TasaIva,
                --        2) ,

				[Abono Requerido] =funcion.SaldoAlDía, ---- ISNULL(cma.CapitalMasAtrasado, 0)
    ----            + f.[Interés Ordinario Atrasado]
				----+ f.[IVA Interés Ordinario Atrasado]
    --            + funcion.[Interés Moratorio Vencido]
    --            --+ funcion.[Interés Moratorio Cuentas Orden]
    --            + ROUND(( funcion.[Interés Moratorio Vigente]
    --                      + funcion.[Interés Moratorio Vencido]
    --                      + funcion.[Interés Moratorio Cuentas Orden] 
				--		  ) * cuenta.TasaIva,
    --                    2) ,
                [Abono Exigible] = funcion.SaldoExigible, --ISNULL(funcion.[Capital Exigible], 0)
        --        + funcion.[Interés Ordinario Vigente]
        --        + funcion.[Interés Ordinario Vencido]
        --        --+ funcion.[Interés Ordinario Cuentas Orden]
        --        + ROUND(( funcion.[Interés Ordinario Vigente]
        --                  + funcion.[Interés Ordinario Vencido]
        --                  --+ funcion.[Interés Ordinario Cuentas Orden] 
						  --) * cuenta.TasaIva,
        --                2) + funcion.[Interés Moratorio Vigente]
        --        + funcion.[Interés Moratorio Vencido]
        --        --+ funcion.[Interés Moratorio Cuentas Orden]
        --        + ROUND(( funcion.[Interés Moratorio Vigente]
        --                  + funcion.[Interés Moratorio Vencido]
        --                  --+ funcion.[Interés Moratorio Cuentas Orden] 
						  --) * cuenta.TasaIva,
        --                2) ,
                [Rango Morosidad] = tbl.Descripción ,--'De ' + CAST(tbl.PlazoInicial as varchar(20)) + ' a ' + CAST(tbl.PlazoFinal as varchar(20)) + ' días',
                [En Cartera Vencida] = funcion.[En Cartera vencida] ,
                [Próximo Abono] = funcion.[Próximo Abono] ,
                Asentamiento = ase.Descripcion ,
                Municipio = mun.Descripcion ,
                p.Domicilio ,
                [Teléfono] = tel.Telefonos ,
                Aval1 ,
                Aval2 ,
                Aval3 ,
                Ejecutivo = ejp.Nombre ,
                Promotor = prop.Nombre ,
                [Código del Gestor] = g.Codigo ,
                [Gestor] = g.Nombre ,
                [Última Gestión] = gestiones.UltimaGestion ,
                [Numero Gestiones] = gestiones.NumeroGestiones ,
                [Visitas] = gestiones.Visitas ,
                Actividad=datosGestion.Actividad,
				Resultado=datosGestion.Resultado,
				Nota=datosGestion.Nota,
                [Fecha de Asignación] = ac.FechaAsignacion,
				[Saldo al Día] = funcion.SaldoAlDía,
				[Saldo Exigible] = funcion.SaldoExigible,
			    [Total a Liquidar] = funcion.TotalALiquidar,
			    [Saldo al Día Sin Cargos] = funcion.SaldoAlDíaSinCargos,
			    [Saldo Exigible Sin Cargos] = funcion.SaldoExigibleSinCargos,
			    [Total a Liquidar Sin Cargos]= funcion.TotalALiquidarSinCargos,			
				EstatusCartera=estCar.descripcion
				,[En Departamento Juridico]= IIF(cueJuridico.IdCuenta IS NOT NULL,'SI','NO')
				,[En Proceso Judicial] = IIF(cueProdJud.IdCuenta IS NOT NULL, 'SI','NO')				
				,[Giro Socio]=InfoAdicionalSocio.Giro
				,[Ingresos Declarados]=InfoAdicionalSocio.IngresosDeclarados
				,[Score Circulo de Credito]=InfoAdicionalSocio.ScoreCirculo
				,[Empresa Convenio]=InfoAdicionalSocio.EmpresaConvenio
				,[Correo Electrónico]=InfoAdicionalSocio.EmailsSocio
				,funcion.[Fecha último pago de capital]
				,funcion.[Monto último pago de capital]
				,funcion.[Fecha último pago de Interés]
				,funcion.[Monto último pago de interés]
				,[DiasMora] = iif(funcion.[Días mora Capital] > funcion.[Días mora Interés], funcion.[Días mora Capital], funcion.[Días mora Interés]) 
      FROM      fAYCconsultarCartera(@FechaCartera, @Sucursal, IIF(@Cuenta = '*', '*', @Cuenta)) funcion
                INNER JOIN tAYCcuentas cuenta WITH ( NOLOCK ) ON funcion.IdCuenta = cuenta.IdCuenta --AND c.Codigo='10804-3126-7632'--AND f.Cuenta='10807-3126-4288'
                INNER JOIN dbo.tCTLestatus estCar WITH(NOLOCK) ON estCar.IdEstatus = cuenta.IdEstatusCartera
                INNER JOIN tCOMvendedores pro ON cuenta.IdVendedor = pro.IdVendedor
                INNER JOIN tGRLpersonas prop ON pro.IdPersona = prop.IdPersona
                INNER JOIN tCTLusuarios ej ON cuenta.IdUsuarioAlta = ej.IdUsuario
                INNER JOIN tGRLpersonas ejp ON ej.IdPersonaFisica = ejp.IdPersona
				INNER JOIN dbo.tSDOsaldos saldo ON saldo.IdCuenta = cuenta.IdCuenta
                INNER JOIN tCTLsucursales suc WITH ( NOLOCK ) ON saldo.IdSucursal = suc.IdSucursal
                INNER JOIN tAYCproductosFinancieros pr WITH ( NOLOCK ) ON cuenta.IdProductoFinanciero = pr.IdProductoFinanciero
                INNER JOIN tSCSsocios soc WITH ( NOLOCK ) ON cuenta.IdSocio = soc.IdSocio
                INNER JOIN tGRLpersonas p WITH ( NOLOCK ) ON soc.IdPersona = p.IdPersona                
                INNER JOIN tCTLasentamientos ase WITH ( NOLOCK ) ON p.IdAsentamiento = ase.IdAsentamiento
                INNER JOIN tCTLmunicipios mun WITH ( NOLOCK ) ON p.IdMunicipio = mun.IdMunicipio
                INNER JOIN tCTLtiposD AIC WITH ( NOLOCK ) ON cuenta.IdTipoDAIC = AIC.IdTipoDPadre AND AIC.IdTipoD IN (721, 722, 724 )	
                INNER JOIN ( SELECT   0 AS PlazoInicial ,
                                0 AS PlazoFinal ,
                                Descripción = '0 Días'
                       UNION --Rangos: Cartera Sana, de 1 a 3, de 4 a 30, de 31 a 60, de 61 a 90, de 90 a 180, de 181 a 30, más de 360
                       SELECT   1 AS PlazoInicial ,
                                3 AS PlazoFinal ,
                                Descripción = '1 a 3 Días'
                       UNION
                       SELECT   4 AS PlazoInicial ,
                                30 AS PlazoFinal ,
                                Descripción = '4 a 30 Días'
                       UNION
                       SELECT   31 AS PlazoInicial ,
                                60 AS PlazoFinal ,
                                Descripción = '31 a 60 Días'
                       UNION
                       SELECT   61 AS PlazoInicial ,
                                90 AS PlazoFinal ,
                                Descripción = '61 a 90 Días'
                       UNION
                       SELECT   91 AS PlazoInicial ,
                                180 AS PlazoFinal ,
                                Descripción = '91 a 180 Días'
                       UNION
                       SELECT   181 AS PlazoInicial ,
                                360 AS PlazoFinal ,
                                Descripción = '181 a 360 Días'
                       union
                       SELECT   361 AS PlazoInicial ,
                                999999 AS PlazoFinal ,
                                Descripción = 'Mayor a 360 Días'
                     ) tbl ON funcion.[Mora Máxima] BETWEEN tbl.PlazoInicial AND tbl.PlazoFinal
                LEFT JOIN dbo.vCATtelefonosAgrupados tel WITH ( NOLOCK ) ON tel.IdRel = p.IdRelTelefonos
	---------------------------Gestor-asignado-----------------------------------
                LEFT JOIN dbo.tGYCasignacionCarteraD ac WITH ( NOLOCK ) ON ac.IdCuenta = cuenta.IdCuenta
                                                              AND ac.IdEstatus = 1
                LEFT JOIN dbo.vGYCgestores g WITH ( NOLOCK ) ON g.IdGestor = ac.IdGestor
                LEFT JOIN ( SELECT  eve.IdGestor ,
                                    cuenta.IdCuenta ,
                                    [UltimaGestion] = MAX(eve.FechaRealizada) ,
                                    [NumeroGestiones] = COUNT(eve.IdActividad) ,
                                    [Visitas] = SUM(IIF(eve.IdTipoD = 1376
                                                    OR eve.IdTipoD = 1374, 1, 0))
                            FROM    dbo.tGRLeventos eve WITH ( NOLOCK )
                                    INNER JOIN dbo.tAYCcuentas cuenta WITH ( NOLOCK ) ON eve.IdCuenta = cuenta.IdCuenta
                            WHERE   eve.FechaRealizada BETWEEN DATEADD(DAY,
                                                              -30,
                                                              @FechaCartera)
                                                       AND    @FechaCartera
                                    AND eve.IdEstatus = 50
                            GROUP BY eve.IdGestor ,
                                    cuenta.IdCuenta
                          ) AS gestiones ON gestiones.IdGestor = g.IdGestor
                                            AND gestiones.IdCuenta = cuenta.IdCuenta
                LEFT JOIN ( SELECT  cuenta.IdCuenta ,
                                    CapitalMasAtrasado = p.Capital
                                    - ( p.CapitalPagado + p.CapitalCondonado )
                            FROM    tAYCparcialidades p WITH ( NOLOCK )
                                    JOIN tAYCcuentas cuenta WITH ( NOLOCK ) ON p.IdCuenta = cuenta.IdCuenta AND p.IdEstatus=1
                            WHERE   cuenta.PrimerVencimientoPendienteCapital = p.Vencimiento
                                    AND p.Vencimiento < @FechaCartera
                          ) cma ON cuenta.IdCuenta = cma.IdCuenta
                
                LEFT JOIN tAYCavalesCartera avales ON cuenta.RelAvales = avales.RelAvales
                LEFT JOIN ( SELECT  IdCuenta ,
                                    Cargos = SUM(Cargos) ,
                                    CargosIVA = SUM(CargosIVA)
                            FROM    ( SELECT    a.IdCuenta ,
                                                Cargos = a.Monto ,
                                                CargosIVA = ( a.Monto
                                                              * imp.TasaIVA )
                                      FROM      fSDOcargosDescuentosParcialidadAtrasada(@FechaCartera) a
                                                INNER JOIN tIMPimpuestos imp
                                                WITH ( NOLOCK ) ON a.IdImpuesto = imp.IdImpuesto
                                      UNION ALL
                                      SELECT    a.IdCuenta ,
                                                Cargos = a.Monto ,
                                                CargosIVA = ( a.Monto
                                                              * imp.TasaIVA )
                                      FROM      tSDOcargosDescuentos a WITH ( NOLOCK )
                                                INNER JOIN tIMPimpuestos imp
                                                WITH ( NOLOCK ) ON a.IdImpuesto = imp.IdImpuesto
                                      WHERE     a.IdParcialidad != 0
                                                AND a.IdEstatus = 24
                                    ) cargos
                            GROUP BY cargos.IdCuenta
                          ) cg ON cuenta.IdCuenta = cg.IdCuenta
                LEFT JOIN dbo.tGYCcuentasJuridico cueJuridico With(nolock) ON cueJuridico.IdCuenta = cuenta.IdCuenta AND cuejuridico.IdEstatus = 1
				LEFT JOIN dbo.tGYCcuentasProcesoJudicial cueProdJud With(nolock) ON cueProdJud.IdCuenta = cuenta.IdCuenta AND cueprodjud.IdEstatus = 1
				LEFT JOIN (SELECT  labSocio.Giro
									,IngresosDeclarados = CAST(ISNULL(socPerSocio.IngresosOrdinarios,0) + ISNULL(socPerSocio.IngresosExtraordinarios,0) AS NUMERIC(18,6))
									,cueEstSocio.ClavePrevencionSIC
									,ScoreCirculo= cue.CalificacionSIC --scoreSocio.ScoreFinalFV
									,EmpresaConvenio=perEmpresas.Nombre 
									,EmailsSocio = emails.Emails
									,cue.IdSocio,cue.IdCuenta
							FROM dbo.tAYCcuentas cue WITH(NOLOCK)
							INNER JOIN  dbo.tSCSsocios soc WITH(NOLOCK) ON soc.IdSocio = cue.IdSocio AND cue.IdTipoDProducto=143 AND cue.IdEstatus IN(1,53,73)
							INNER JOIN dbo.tGRLpersonas persocio WITH(NOLOCK) ON persocio.IdPersona = soc.IdPersona AND soc.EsSocioValido=1 AND soc.IdEstatus=1							
							INNER JOIN dbo.tAYCcuentasEstadisticas cueEstSocio WITH(NOLOCK) ON cueEstSocio.IdCuenta = cue.IdCuenta AND cueEstSocio.IdApertura = cue.IdApertura
							LEFT JOIN dbo.vCATEmailsAgrupados emails ON emails.IdRel=persocio.IdRelEmails
							LEFT JOIN( SELECT labSocio.Giro,labSocio.IdPersona
									 		   FROM dbo.tCTLlaborales labSocio WITH(NOLOCK) 
									 		   INNER JOIN dbo.tCTLestatusActual estAct WITH(nolock) ON estAct.IdEstatusActual = labSocio.IdEstatusActual AND estAct.IdEstatus=1 AND labSocio.IdEstatusActual>0
									 ) labSocio ON labSocio.IdPersona = persocio.IdPersona
							LEFT JOIN dbo.tSCSpersonasSocioeconomicos socPerSocio WITH(nolock) ON socPerSocio.IdSocioeconomico = persocio.IdSocioeconomico
							LEFT JOIN dbo.tSCSconveniosCreditosEmpresas conEmpresas WITH(NOLOCK) ON conEmpresas.IdConvenioCreditoEmpresa = cueEstSocio.IdConvenioCreditoEmpresa
							LEFT JOIN dbo.tGRLpersonas perEmpresas WITH(NOLOCK) ON perEmpresas.IdPersona = conEmpresas.IdPersona
							--LEFT JOIN dbo.tmpTscoreCredito scoreSocio WITH(nolock) ON scoreSocio.IdSocio = soc.IdSocio
				) InfoAdicionalSocio ON infoadicionalsocio.IdCuenta=cuenta.IdCuenta AND InfoAdicionalSocio.IdSocio = soc.IdSocio 
				LEFT JOIN (SELECT cue.IdCuenta,eve.IdGestor,Actividad=act.Descripcion,Resultado=Res.Descripcion,eve.Nota
						   		,Numero=ROW_NUMBER()OVER(PARTITION BY cue.IdCuenta ORDER BY eve.HoraRealizada DESC)
						   from dbo.tGRLeventos eve With(nolock) 
						   INNER JOIN dbo.tAYCcuentas cue With(nolock) ON cue.IdCuenta = eve.IdCuenta
						   INNER JOIN dbo.tCATactividadesResultados act With(nolock) ON eve.IdActividad=act.IdActividadResultado 
						   INNER JOIN dbo.tCATactividadesResultados Res With(nolock) ON eve.IdResultado=Res.IdActividadResultado 
						   WHERE eve.IdEvento>0 AND eve.IdEstatus<>2
						   )datosGestion ON datosGestion.IdCuenta = cuenta.IdCuenta AND datosGestion.IdGestor = g.IdGestor AND datosGestion.Numero=1
    );











GO

