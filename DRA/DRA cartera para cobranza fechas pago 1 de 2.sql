SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO




ALTER FUNCTION [dbo].[fAYCconsultarCarteraCobranza]
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
				cuenta.TipoCartera,
				Emproblemado=IIF(cuenta.EstaEmproblemada=1 ,'Emproblemado',''),
                Sucursal = suc.Codigo ,
                [Activaci�n] = cuenta.FechaActivacion ,
                [Monto Otorgado] = cuenta.MontoEntregado ,
                Vencimiento = cuenta.Vencimiento ,
                [Mora M�xima] =  funcion.[Mora M�xima],--IIF(f.[D�as mora Capital] > f.[D�as mora Inter�s], [D�as mora Capital], f.[D�as mora Inter�s]) ,
                [Capital Insoluto] = funcion.[Capital vigente] + funcion.[Capital Vencido] ,
                funcion.[Capital atrasado] ,
                [Inter�s Ordinario] = funcion.[Inter�s Ordinario Vigente]
                + funcion.[Inter�s Ordinario Vencido]
                + funcion.[Inter�s Ordinario Cuentas Orden] ,
                [IVA Inter�s Ordinario] = funcion.[IVA Inter�s Ordinario] ,
                [Inter�s Moratorio] = funcion.[Inter�s Moratorio Vigente]
                + funcion.[Inter�s Moratorio Vencido]
                + funcion.[Inter�s Moratorio Cuentas Orden] ,
                [IVA Inter�s Moratorio] = funcion.[IVA Inter�s Moratorio] ,
		--[Gastos Cobranza Estimados]=IIF(f.[D�as Mora Capital] > 4 OR f.[D�as Mora Inter�s] > 4, isnull([Parcialidades Atrasadas]*cg.Monto, 0),0),
		--[IVA Gastos Cobranza Estimados]=isnull(ROUND([Parcialidades Atrasadas]*cg.Monto*cg.TasaIVA,2),0),
                [Gastos Cobranza Estimados] = ISNULL(ROUND(cg.Cargos, 2), 0) ,
                [IVA Gastos Cobranza Estimados] = ISNULL(ROUND(cg.CargosIVA, 2),0) ,
                [Para regularizarse] = funcion.[Capital atrasado]
                + funcion.[Inter�s Ordinario Vigente]
                + funcion.[Inter�s Ordinario Vencido]
                + funcion.[Inter�s Ordinario Cuentas Orden]
                + ROUND(( funcion.[Inter�s Ordinario Vigente]
                          + funcion.[Inter�s Ordinario Vencido]
                          + funcion.[Inter�s Ordinario Cuentas Orden] ) * cuenta.TasaIva,
                        2) + funcion.[Inter�s Moratorio Vigente]
                + funcion.[Inter�s Moratorio Vencido]
                + funcion.[Inter�s Moratorio Cuentas Orden]
                + ROUND(( funcion.[Inter�s Moratorio Vigente]
                          + funcion.[Inter�s Moratorio Vencido]
                          + funcion.[Inter�s Moratorio Cuentas Orden] ) * cuenta.TasaIva,
                        2) + ISNULL(ROUND(cg.Cargos + cg.CargosIVA, 2), 0) ,
                [Para liquidar] = funcion.[Capital vigente] + funcion.[Capital Vencido]
                + funcion.[Inter�s Ordinario Vigente]
                + funcion.[Inter�s Ordinario Vencido]
                + funcion.[Inter�s Ordinario Cuentas Orden]
                + ROUND(( funcion.[Inter�s Ordinario Vigente]
                          + funcion.[Inter�s Ordinario Vencido]
                          + funcion.[Inter�s Ordinario Cuentas Orden] ) * cuenta.TasaIva,
                        2) + funcion.[Inter�s Moratorio Vigente]
                + funcion.[Inter�s Moratorio Vencido]
                + funcion.[Inter�s Moratorio Cuentas Orden]
                + ROUND(( funcion.[Inter�s Moratorio Vigente]
                          + funcion.[Inter�s Moratorio Vencido]
                          + funcion.[Inter�s Moratorio Cuentas Orden] ) * cuenta.TasaIva,
                        2) + ISNULL(ROUND(cg.Cargos + cg.CargosIVA, 2), 0) ,
                [D�as Objetivo] = cuenta.Dias ,
		--[Abono Requerido]=CASE WHEN [Parcialidades Atrasadas] > 0 THEN round(c.MontoEntregado/c.NumeroParcialidades*f.[Parcialidades Atrasadas]-f.[Capital Atrasado],2) ELSE 0 END,
		--se comenta campo para agregar modificaci�n que considera los campos de IVA en cartera para el interes ordinario atrasado.
                --[Abono Requerido] = ISNULL(cma.CapitalMasAtrasado, 0)
                --+ f.[Inter�s Ordinario Vigente]
                --+ f.[Inter�s Ordinario Vencido]
                --+ f.[Inter�s Ordinario Cuentas Orden]
                --+ ROUND(( f.[Inter�s Ordinario Vigente]
                --          + f.[Inter�s Ordinario Vencido]
                --          + f.[Inter�s Ordinario Cuentas Orden] ) * c.TasaIva,
                --        2) + f.[Inter�s Moratorio Vigente]
                --+ f.[Inter�s Moratorio Vencido]
                --+ f.[Inter�s Moratorio Cuentas Orden]
                --+ ROUND(( f.[Inter�s Moratorio Vigente]
                --          + f.[Inter�s Moratorio Vencido]
                --          + f.[Inter�s Moratorio Cuentas Orden] ) * c.TasaIva,
                --        2) ,

				[Abono Requerido] = ISNULL(cma.CapitalMasAtrasado, 0)
    --            + f.[Inter�s Ordinario Atrasado]
				--+ f.[IVA Inter�s Ordinario Atrasado]
                + funcion.[Inter�s Moratorio Vencido]
                + funcion.[Inter�s Moratorio Cuentas Orden]
                + ROUND(( funcion.[Inter�s Moratorio Vigente]
                          + funcion.[Inter�s Moratorio Vencido]
                          + funcion.[Inter�s Moratorio Cuentas Orden] ) * cuenta.TasaIva,
                        2) ,
                [Abono Exigible] = ISNULL(funcion.[Capital Exigible], 0)
                + funcion.[Inter�s Ordinario Vigente]
                + funcion.[Inter�s Ordinario Vencido]
                + funcion.[Inter�s Ordinario Cuentas Orden]
                + ROUND(( funcion.[Inter�s Ordinario Vigente]
                          + funcion.[Inter�s Ordinario Vencido]
                          + funcion.[Inter�s Ordinario Cuentas Orden] ) * cuenta.TasaIva,
                        2) + funcion.[Inter�s Moratorio Vigente]
                + funcion.[Inter�s Moratorio Vencido]
                + funcion.[Inter�s Moratorio Cuentas Orden]
                + ROUND(( funcion.[Inter�s Moratorio Vigente]
                          + funcion.[Inter�s Moratorio Vencido]
                          + funcion.[Inter�s Moratorio Cuentas Orden] ) * cuenta.TasaIva,
                        2) ,
                [Rango Morosidad] = tbl.Descripci�n ,--'De ' + CAST(tbl.PlazoInicial as varchar(20)) + ' a ' + CAST(tbl.PlazoFinal as varchar(20)) + ' d�as',
                [En Cartera Vencida] = funcion.[En Cartera vencida] ,
                [Pr�ximo Abono] = funcion.[Pr�ximo Abono] ,
                Asentamiento = ase.Descripcion ,
                Municipio = mun.Descripcion ,
                p.Domicilio ,
                [Tel�fono] = tel.Telefonos ,
                Aval1 ,
                Aval2 ,
                Aval3 ,
                Ejecutivo = ejp.Nombre ,
                Promotor = prop.Nombre ,
                [C�digo del Gestor] = g.Codigo ,
                [Gestor] = g.Nombre ,
                [�ltima Gesti�n] = gestiones.UltimaGestion ,
                [Numero Gestiones] = gestiones.NumeroGestiones ,
                [Visitas] = gestiones.Visitas ,
				Actividad=datosGestion.Actividad,
				Resultado=datosGestion.Resultado,
				Nota=datosGestion.Nota,
                [Fecha de Asignaci�n] = ac.FechaAsignacion,
				[Saldo al D�a] = funcion.SaldoAlD�a,
				[Saldo Exigible] = funcion.SaldoExigible,
			    [Total a Liquidar] = funcion.TotalALiquidar,
			    [Saldo al D�a Sin Cargos] = funcion.SaldoAlD�aSinCargos,
			    [Saldo Exigible Sin Cargos] = funcion.SaldoExigibleSinCargos,
			    [Total a Liquidar Sin Cargos]= funcion.TotalALiquidarSinCargos,			
				EstatusCartera=estCar.descripcion
				, cuenta.PrimerVencimientoPendienteInteres
				, cuenta.PrimerVencimientoPendienteCapital
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
				INNER JOIN dbo.tCATdomicilios domPer WITH(NOLOCK) ON domper.IdRel=p.IdRelDomicilios AND domPer.IdTipoD=11
				INNER JOIN dbo.tCTLestatusActual estActDom WITH(NOLOCK) ON estActDom.IdEstatusActual = domPer.IdEstatusActual AND estActDom.IdEstatus=1
                INNER JOIN tCTLasentamientos ase WITH ( NOLOCK ) ON domPer.IdAsentamiento = ase.IdAsentamiento
                INNER JOIN tCTLmunicipios mun WITH ( NOLOCK ) ON domPer.IdMunicipio = mun.IdMunicipio
                INNER JOIN tCTLtiposD AIC WITH ( NOLOCK ) ON cuenta.IdTipoDAIC = AIC.IdTipoDPadre AND AIC.IdTipoD IN (721, 722, 724 )	
                INNER JOIN ( SELECT   0 AS PlazoInicial ,
                                0 AS PlazoFinal ,
                                Descripci�n = '0 D�as'
                       UNION --Rangos: Cartera Sana, de 1 a 3, de 4 a 30, de 31 a 60, de 61 a 90, de 90 a 180, de 181 a 30, m�s de 360
                       SELECT   1 AS PlazoInicial ,
                                3 AS PlazoFinal ,
                                Descripci�n = '1 a 3 D�as'
                       UNION
                       SELECT   4 AS PlazoInicial ,
                                30 AS PlazoFinal ,
                                Descripci�n = '4 a 30 D�as'
                       UNION
                       SELECT   31 AS PlazoInicial ,
                                60 AS PlazoFinal ,
                                Descripci�n = '31 a 60 D�as'
                       UNION
                       SELECT   61 AS PlazoInicial ,
                                90 AS PlazoFinal ,
                                Descripci�n = '61 a 90 D�as'
                       UNION
                       SELECT   91 AS PlazoInicial ,
                                180 AS PlazoFinal ,
                                Descripci�n = '91 a 180 D�as'
                       UNION
                       SELECT   181 AS PlazoInicial ,
                                360 AS PlazoFinal ,
                                Descripci�n = '181 a 360 D�as'
                       UNION
                       SELECT   361 AS PlazoInicial ,
                                999999 AS PlazoFinal ,
                                Descripci�n = 'Mayor a 360 D�as'
                     ) tbl ON funcion.[Mora M�xima] BETWEEN tbl.PlazoInicial AND tbl.PlazoFinal
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
				LEFT JOIN (SELECT cue.IdCuenta,eve.IdGestor,Actividad=act.Descripcion,Resultado=Res.Descripcion,eve.Nota
						   		,Numero=ROW_NUMBER()OVER(PARTITION BY cue.IdCuenta ORDER BY eve.HoraRealizada DESC)
						   from dbo.tGRLeventos eve With(nolock) 
						   INNER JOIN dbo.tAYCcuentas cue With(nolock) ON cue.IdCuenta = eve.IdCuenta
						   INNER JOIN dbo.tCATactividadesResultados act With(nolock) ON eve.IdActividad=act.IdActividadResultado 
						   INNER JOIN dbo.tCATactividadesResultados Res With(nolock) ON eve.IdResultado=Res.IdActividadResultado 
						   WHERE eve.IdEvento>0 AND eve.IdEstatus<>2
						   )datosGestion ON datosGestion.IdCuenta = cuenta.IdCuenta AND datosGestion.IdGestor = g.IdGestor AND datosGestion.Numero=1
                LEFT JOIN (
		--select c.IdCuenta, p.IdRelCargosComisionesAsignados, ca.IdCargoComision, bs.Codigo, ca.Monto, imp.TasaIVA
		--from tAYCcuentas c with(NOLOCK) 
		--join tAYCproductosFinancieros p with(NOLOCK)  on c.IdProductoFinanciero=p.IdProductoFinanciero
		--join tAYCcargosComisionesAsignados ca with(NOLOCK)  on p.IdRelCargosComisionesAsignados=ca.IdRel AND ca.IdTipoDAplicacion=1913 AND ca.IdTipoDrangoSobre IN (493,1442) AND c.MontoEntregado between Inicial and Final AND ca.IdEstatus=1
		--join tGRLbienesServicios bs with(NOLOCK)  on ca.IdBienServicioCargoComision = bs.IdBienServicio
		--join tIMPimpuestos imp with(NOLOCK)  on bs.IdImpuesto=imp.IdImpuesto
		--WHERE p.IdRelCargosComisionesAsignados > 0 AND c.IdTipoDProducto=143 AND c.IdEstatus=1
                            SELECT  IdCuenta ,
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
    );




GO

