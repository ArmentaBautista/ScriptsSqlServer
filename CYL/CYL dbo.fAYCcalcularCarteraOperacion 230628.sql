SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO




ALTER FUNCTION [dbo].[fAYCcalcularCarteraOperacion]
(
    @FechaTrabajo AS DATE,
    @Decimales AS INT = 2,
    @IdCuenta AS INT = 0,
    @IdSocio AS INT = 0,
    @CodigoOperacion AS VARCHAR(20) = 'DevPag'
)
RETURNS TABLE
AS
RETURN
(
    SELECT -- sdo.CapitalGenerado-sdo.CapitalPagado-sdo.CapitalCondonado
        x.IdCuenta,
        c.IdSocio,
        Capital = c.SaldoCapital,
        DiasMoraCapital = CASE
                              WHEN c.PrimerVencimientoPendienteCapital < @FechaTrabajo THEN
                                  DATEDIFF(d, c.PrimerVencimientoPendienteCapital, @FechaTrabajo)
                              ELSE
                                  0
                          END,
        DiasMoraInteres = CASE
                              WHEN c.PrimerVencimientoPendienteInteres < @FechaTrabajo THEN
                                  DATEDIFF(d, c.PrimerVencimientoPendienteInteres, @FechaTrabajo)
                              ELSE
                                  0
                          END,
        CapitalAtrasado = x.CapitalAtrasado,
        ParcialidadesCapitalAtrasadas = x.ParcialidadesCapitalAtrasadas,
        CapitalVigente = CASE
                             WHEN x.IdEstatusCartera = 28 THEN
                                 c.SaldoCapital
                             ELSE
                                 0
                         END,
        CapitalVencido = CASE
                             WHEN x.IdEstatusCartera = 29 THEN
                                 c.SaldoCapital
                             ELSE
                                 0
                         END,
        x.InteresOrdinario,
        x.InteresMoratorio,
        InteresOrdinarioVigente = CASE
                                      WHEN x.IdEstatusCartera = 28 THEN -- Pagos Fijos
                                          x.InteresOrdinario
                                      ELSE
                                          0
                                  END,
        InteresOrdinarioVencido = CASE
                                      WHEN x.IdEstatusCartera = 29 THEN -- Pagos Fijos
                                          x.InteresOrdinario
                                      ELSE
                                          0
                                  END,
        InteresOrdinarioCuentasOrden = x.InteresOrdinarioCuentasOrden,
        InteresOrdinarioTotal = ISNULL(x.InteresOrdinario,0) + ISNULL(x.InteresOrdinarioIVA,0) + ISNULL(ip.InteresOrdinarioDistribuido,0) + ISNULL(ip.IvaInteresOrdinarioDistribuido,0) + ISNULL(ip.InteresOrdinarioAplazado,0) + ISNULL(ip.IvaInteresOrdinarioAplazado,0),
        InteresMoratorioVigente = CASE
                                      WHEN x.IdEstatusCartera = 28 THEN -- Pagos Fijos
                                          x.InteresMoratorio
                                      ELSE
                                          0
                                  END,
        InteresMoratorioVencido = CASE
                                      WHEN x.IdEstatusCartera = 29 THEN -- Pagos Fijos
                                          x.InteresMoratorio
                                      ELSE
                                          0
                                  END,
        InteresMoratorioCuentasOrden = x.InteresMoratorioCuentasOrden,
        InteresMoratorioTotal = x.InteresMoratorio + x.InteresMoratorioIVA,
        InteresOrdinarioIVA,
        InteresMoratorioIVA,
        x.CapitalAlDia,
        CapitalExigible,
        InteresOrdinarioAtrasado,
        InteresOrdinarioIVAAtrasado,
        x.InteresOrdinarioTotalAtrasado,
                                     --InteresOrdinarioTotalAtrasado=InteresOrdinarioAtrasado + round(InteresOrdinarioAtrasado*c.TasaIVA,2),  
        InteresMoratorioAtrasado = x.InteresMoratorio + x.InteresMoratorioCuentasOrden,
        InteresMoratorioIVAAtrasado = ROUND(x.InteresMoratorio + x.InteresMoratorioCuentasOrden, 2),
                                     --InteresMoratorioTotalAtrasado=x.InteresMoratorio + x.InteresMoratorioCuentasOrden + round(x.InteresMoratorio + x.InteresMoratorioCuentasOrden,2),
        x.InteresOrdinarioTotalMasIVA,
        x.InteresMoratorioTotalMasIVA,
        IVAInteresOrdinario = x.InteresOrdinarioIVA,
        IVAInteresMoratorio = x.InteresMoratorioIVA,
        DiasTranscurridos = x.DiasTranscurridos,
        x.IdEstatusCartera,
        InteresOrdinarioPeriodo = 0, --x.InteresCalculado,
        c.ParteCubierta,
        x.ProximoVencimiento,
        Cargos = s.Cargos + x.SaldoCargos,
        CargosImpuestos = s.Impuestos + x.SaldoIVACargos,
                                     --CargosTotal=s.Cargos + s.Impuestos,
        Impuestos = x.InteresOrdinarioIVA + x.InteresMoratorioIVA + s.Impuestos,
                                     --Total=x.CapitalExigible + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA + x.InteresMoratorioIVA + s.Cargos + s.Impuestos,
                                     --TotalAtrasado=x.CapitalAtrasado + x.InteresOrdinarioAtrasado + x.InteresMoratorio + s.Cargos + s.Impuestos
                                     --			+ round(InteresOrdinarioAtrasado*c.TasaIVA,2) + round(x.InteresMoratorio + x.InteresMoratorioCuentasOrden,2),
        MoraMaxima = x.MoraMaxima,
        ParcialidadesVencidas = x.ParcialidadesVencidas,
        SaldoTotal = c.SaldoCapital + x.InteresOrdinarioTotalMasIVA + x.InteresMoratorioTotalMasIVA + s.Cargos
                     + s.Impuestos,
                                     ----agregar columnas Saldo al dia, Saldoexigible, Total a Liquidar
        SaldoAlDía = x.CapitalAlDia + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA
                     + x.InteresMoratorioIVA + s.Cargos + s.Impuestos + x.SaldoCargos +  x.SaldoIVACargos,
        SaldoExigible = x.CapitalExigible + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA
                        + x.InteresMoratorioIVA + s.Cargos + s.Impuestos + x.SaldoCargos + x.SaldoIVACargos ,
        TotalALiquidar = SaldoCapital + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA
                         + x.InteresMoratorioIVA + s.Cargos + s.Impuestos + x.SaldoCargos + x.SaldoIVACargos + ISNULL(ip.InteresOrdinarioDistribuido,0) + ISNULL(ip.IvaInteresOrdinarioDistribuido,0) + ISNULL(ip.InteresOrdinarioAplazado,0) + ISNULL(ip.IvaInteresOrdinarioAplazado,0),
        SaldoAlDíaSinCargos = x.CapitalAlDia + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA
                              + x.InteresMoratorioIVA,
        SaldoExigibleSinCargos = x.CapitalExigible + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA
                                 + x.InteresMoratorioIVA,
        TotalALiquidarSinCargos = SaldoCapital + x.InteresOrdinario + x.InteresMoratorio + x.InteresOrdinarioIVA
                                  + x.InteresMoratorioIVA + ISNULL(ip.InteresOrdinarioDistribuido,0) + ISNULL(ip.IvaInteresOrdinarioDistribuido,0) + ISNULL(ip.InteresOrdinarioAplazado,0) + ISNULL(ip.IvaInteresOrdinarioAplazado,0),
        x.SaldoCargos,
        x.SaldoIVACargos
    FROM tAYCcuentas c WITH (NOLOCK)
        JOIN
        (
            SELECT ct.IdCuenta,
                   Cargos = ISNULL(sa.Cargos, 0),
                   Impuestos = ISNULL(sa.Impuestos, 0)
            FROM tAYCcuentas ct WITH (NOLOCK)
                LEFT JOIN dbo.fSDOsaldoCargosCuentas(@FechaTrabajo) sa
                    ON sa.IdCuenta = ct.IdCuenta
            WHERE ct.IdTipoDProducto = 143
                  AND ct.IdEstatus = 1
        ) AS s
            ON c.IdCuenta = s.IdCuenta
        JOIN
        (
            SELECT faid.IdCuenta,
                   faid.IdSaldo,
                   DiasTranscurridos = SUM(faid.DiasTranscurridos),
                   --CapitalExigible = SUM(faid.SaldoCapital),				
                   CapitalAtrasado = SUM(   CASE
                                                WHEN faid.Vencimiento < @FechaTrabajo THEN
                                                    faid.SaldoCapital
                                                ELSE
                                                    0
                                            END
                                        ),
                   InteresOrdinario = SUM(faid.SaldoInteresOrdinario + faid.SaldoInteresOrdinarioCuentasOrden + ISNULL(cd.InteresAplazado,0)
                                          + faid.InteresOrdinario
                                          + IIF(c.IdTipoDParcialidad = 415 AND faid.AplicaAjuste = 1,
                                                faid.AjusteInteresOrdinarioPagosFijos,
                                                0)
                                         ),
                   InteresOrdinarioCuentasOrden = SUM(   CASE
                                                             WHEN faid.IdTipoDParcialidad = 415 THEN -- Pagos Fijos
                                                                 faid.SaldoInteresOrdinarioCuentasOrden
                                                                 + faid.PendienteDevengarVencido
                                                             ELSE
                                                                 faid.SaldoInteresOrdinarioCuentasOrden
                                                                 + CASE
                                                                       WHEN faid.DiasVencido > 0 THEN
                                                                           ROUND(
                                                                                    faid.DiasVencido
                                                                                    / faid.DiasTranscurridos
                                                                                    * faid.InteresOrdinario,
                                                                                    2
                                                                                )
                                                                       ELSE
                                                                           0
                                                                   END
                                                         END
                                                     ),
                   InteresMoratorio = SUM(faid.SaldoInteresMoratorio + faid.SaldoInteresMoratorioCuentasOrden
                                          + faid.InteresMoratorio
                                         ),
                   InteresMoratorioCuentasOrden = SUM(   faid.SaldoInteresMoratorioCuentasOrden
                                                         + CASE
                                                               WHEN faid.DiasMoraVencido > 0 THEN
                                                                   ROUND(
                                                                            faid.DiasMoraVencido / faid.DiasMora
                                                                            * faid.InteresMoratorio,
                                                                            2
                                                                        )
                                                               ELSE
                                                                   0
                                                           END
                                                     ),
                   InteresOrdinarioIVA = SUM(faid.SaldoIVAinteresOrdinario + faid.SaldoIVAinteresOrdinarioCuentasOrden + ISNULL(cd.IVAinteresAplazado,0)
                                             + faid.IVAinteresOrdinario
                                             + IIF(c.IdTipoDParcialidad = 415 AND faid.AplicaAjuste = 1,
                                                   faid.AjusteIVAInteresOrdinarioPagosFijos,
                                                   0)
                                            ),
                   InteresMoratorioIVA = SUM(faid.SaldoIVAinteresMoratorio + faid.IVAinteresMoratorio
                                             + faid.SaldoIVAinteresMoratorioCuentasOrden
                                            ),
                   CapitalAlDia = SUM(   CASE
                                             WHEN faid.Vencimiento <= @FechaTrabajo THEN
                                                 faid.SaldoCapital
                                             ELSE
                                                 0
                                         END
                                     ),
                   CapitalExigible = SUM(   CASE
                                                WHEN faid.Inicio < @FechaTrabajo THEN
                                                    faid.SaldoCapital
                                                ELSE
                                                    0
                                            END
                                        ),
                   InteresOrdinarioAtrasado = SUM(   CASE
                                                         WHEN faid.Vencimiento < @FechaTrabajo THEN
                                                             faid.SaldoInteresOrdinario
                                                             + faid.SaldoInteresOrdinarioCuentasOrden
                                                             + faid.InteresOrdinario
															 + ISNULL(cd.InteresAplazado,0)
                                                             + IIF(c.IdTipoDParcialidad = 415 AND faid.AplicaAjuste = 1,
                                                                   faid.AjusteInteresOrdinarioPagosFijos,
                                                                   0)
                                                         ELSE
                                                             0
                                                     END
                                                 ),
                   InteresOrdinarioTotalAtrasado = SUM(   CASE
                                                              WHEN faid.Vencimiento < @FechaTrabajo THEN
                                                                  faid.SaldoInteresOrdinario
                                                                  + faid.SaldoIVAinteresOrdinario
                                                                  + faid.InteresOrdinario + faid.IVAinteresOrdinario
																  + ISNULL(cd.InteresAplazado,0)
                                                                  + IIF(
                                                                        c.IdTipoDParcialidad = 415
                                                                        AND faid.AplicaAjuste = 1,
                                                                        faid.AjusteIVAInteresOrdinarioPagosFijos
                                                                        + faid.AjusteInteresOrdinarioPagosFijos,
                                                                        0) + faid.SaldoInteresOrdinarioCuentasOrden
                                                                  + faid.SaldoIVAinteresOrdinarioCuentasOrden
                                                              ELSE
                                                                  0
                                                          END
                                                      ),
                   InteresOrdinarioIVAAtrasado = SUM(   CASE
                                                            WHEN faid.Vencimiento < @FechaTrabajo THEN
                                                                +faid.SaldoIVAinteresOrdinario
                                                                + faid.IVAinteresOrdinario
																+ ISNULL(cd.IVAinteresAplazado,0)
                                                                + IIF(
                                                                      c.IdTipoDParcialidad = 415 AND faid.AplicaAjuste = 1,
                                                                      faid.AjusteIVAInteresOrdinarioPagosFijos,
                                                                      0) + faid.SaldoIVAinteresOrdinarioCuentasOrden
                                                            ELSE
                                                                0
                                                        END
                                                    ),
                   InteresOrdinarioTotalMasIVA = SUM(   faid.SaldoInteresOrdinario + faid.SaldoIVAinteresOrdinario
                                                        + faid.InteresOrdinario + faid.IVAinteresOrdinario + ISNULL(cd.IVAinteresAplazado,0)
                                                        + IIF(
                                                              c.IdTipoDParcialidad = 415
                                                              AND faid.AplicaAjuste = 1,
                                                              faid.AjusteIVAInteresOrdinarioPagosFijos
                                                              + faid.AjusteInteresOrdinarioPagosFijos,
                                                              0) + faid.SaldoInteresOrdinarioCuentasOrden
                                                        + faid.SaldoIVAinteresOrdinarioCuentasOrden
                                                    ),
                   InteresMoratorioTotalMasIVA = SUM(faid.SaldoInteresMoratorio + faid.SaldoIVAinteresMoratorio
                                                     + faid.InteresMoratorio + faid.IVAinteresMoratorio
                                                     + faid.SaldoInteresMoratorioCuentasOrden
                                                     + faid.SaldoIVAinteresMoratorioCuentasOrden
                                                    ),
                   MoraMaxima = MAX(faid.MoraMaxima),
                   ParcialidadesVencidas = COUNT(DISTINCT CASE
                                                              WHEN faid.Vencimiento < @FechaTrabajo
                                                                   AND faid.SaldoCapital > 0 THEN
                                                                  faid.IdParcialidad
                                                              ELSE
                                                                  NULL
                                                          END
                                                ),
                   ParcialidadesCapitalAtrasadas = COUNT(DISTINCT CASE
                                                                      WHEN faid.Vencimiento < @FechaTrabajo
                                                                           AND faid.SaldoCapital > 0 THEN
                                                                          faid.IdParcialidad
                                                                      ELSE
                                                                          NULL
                                                                  END
                                                        ),
                   ProximoVencimiento = MAX(faid.Vencimiento),
                   c.NumeroParcialidades,
                   InteresCalculado = SUM(   CASE
                                                 WHEN ven.FechaVencido != '1900-01-01'
                                                      OR c.IdEstatusCartera = 29 THEN
                                                     0
                                                 ELSE
                                                     CASE
                                                         WHEN faid.IdTipoDParcialidad = 415 THEN -- Pagos Fijos
                                                             faid.InteresOrdinario - faid.PendienteDevengarVencido
                                                         ELSE
                                                             faid.InteresOrdinario
                                                             - CASE
                                                                   WHEN faid.DiasVencido > 0 THEN
                                                                       ROUND(
                                                                                faid.DiasVencido
                                                                                / faid.DiasTranscurridos
                                                                                * faid.InteresOrdinario,
                                                                                2
                                                                            )
                                                                   ELSE
                                                                       0
                                                               END
                                                     END
                                             END
                                         ),
                   IdEstatusCartera = MIN(   CASE
                                                 WHEN ven.DiasMoraCapital = 0
                                                      AND ven.DiasMoraInteres = 0 THEN
                                                     28
                                                 WHEN ven.FechaVencido != '1900-01-01'
                                                      OR c.IdEstatusCartera = 29 THEN
                                                     29
                                                 ELSE
                                                     28
                                             END
                                         ),
                   SaldoCargos = SUM(ISNULL(faid.SaldoCargo1, 0) + ISNULL(faid.SaldoCargo2, 0)
                                     + ISNULL(faid.SaldoCargo3, 0) + ISNULL(faid.SaldoCargo4, 0)
                                     + ISNULL(faid.SaldoCargo5, 0)
                                    ),
                   SaldoIVACargos = SUM(ISNULL(faid.SaldoIVACargo1, 0) + ISNULL(faid.SaldoIVACargo2, 0)
                                        + ISNULL(faid.SaldoIVACargo3, 0) + ISNULL(faid.SaldoIVACargo4, 0)
                                        + ISNULL(faid.SaldoIVACargo5, 0)
                                       )
            --CapitalMasAtrasado=sum(faid.CapitalMasAtrasado)
            FROM dbo.fAYCcalcularInteresesDeudoresSocio(@IdCuenta, @IdSocio, @FechaTrabajo, 2, 'DEVPAG') faid
                JOIN fAYCcalcularVencimientoCredito(@IdCuenta, @FechaTrabajo, NULL, NULL) ven
                    ON faid.IdCuenta = ven.IdCuenta
                JOIN tAYCcuentas c WITH (NOLOCK)
                    ON faid.IdCuenta = c.IdCuenta
				LEFT JOIN dbo.tAYCmovimientosContingenciaD cd  WITH(NOLOCK) ON cd.IdParcialidad = faid.IdParcialidad
            WHERE (
                      faid.IdSocio = @IdSocio
                      OR @IdSocio = 0
                  )
            GROUP BY faid.IdCuenta,
                     faid.IdSaldo,
                     c.NumeroParcialidades
        ) AS x
            ON x.IdCuenta = c.IdCuenta
		LEFT JOIN  (SELECT par.IdCuenta,
						   SUM(par.InteresOrdinario) InteresOrdinarioDistribuido,
						   SUM(par.IVAInteresOrdinario) IvaInteresOrdinarioDistribuido,
						   SUM(ISNULL(cd.InteresAplazado, 0)) InteresOrdinarioAplazado,
						   SUM(ISNULL(cd.IVAinteresAplazado, 0)) IvaInteresOrdinarioAplazado
					FROM dbo.tAYCparcialidades par WITH (NOLOCK)
						LEFT JOIN dbo.tAYCmovimientosContingenciaD cd WITH (NOLOCK)
							ON cd.IdParcialidad = par.IdParcialidad
					WHERE par.Inicio > @FechaTrabajo
						  AND par.IdCuenta = @IdCuenta
					GROUP BY par.IdCuenta) ip
				ON ip.IdCuenta = x.IdCuenta
);


GO

