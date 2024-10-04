
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fAYCcarteraOperacionDiaria')
BEGIN
	DROP PROC fAYCcarteraOperacionDiaria
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fAYCcarteraOperacionDiaria]
(
    @IdCuenta AS INT = 0, -- 0 = Todas la Cuentas
    @IdSocio AS INT = 0,
    @FechaTrabajo AS DATE,
    @Decimales AS INT = 2
)
RETURNS TABLE
AS
RETURN
( -- Cuentas Activas ------------------------------------------------------------------------------------------
    SELECT c.IdCuenta,
           c.Capital,
           c.IdSocio,
           InteresOrdinario = c.InteresOrdinario,
           c.InteresOrdinarioIVA,
           InteresOrdinarioTotal = c.InteresOrdinarioTotal,
           InteresMoratorio = c.InteresMoratorio,
           InteresMoratorioIVA = c.InteresMoratorioIVA,
           InteresMoratorioTotal = c.InteresMoratorioTotal,
           c.CapitalAtrasado,
           c.CapitalAlDia,
           c.CapitalExigible,
           c.InteresOrdinarioAtrasado,
           c.InteresOrdinarioIVAAtrasado,
           InteresOrdinarioTotalAtrasado = c.InteresOrdinarioTotalAtrasado,
           c.InteresMoratorioAtrasado,
           c.InteresMoratorioIVAAtrasado,
           InteresMoratorioTotalAtrasado = c.InteresMoratorioAtrasado + c.InteresMoratorioIVAAtrasado,
           c.DiasTranscurridos,
           DiasMora = c.MoraMaxima,
           Cargos = c.Cargos, --+ c.SaldoCargos,
           CargosImpuestos = c.CargosImpuestos + c.SaldoIVACargos,
           CargosTotal = c.Cargos + c.SaldoCargos + c.CargosImpuestos + c.SaldoIVACargos,
           c.Impuestos,
           Total = c.CapitalExigible + c.InteresOrdinario + c.InteresMoratorioTotal + c.InteresOrdinarioIVA
                        + c.InteresMoratorioIVA + c.Cargos + c.CargosImpuestos,
           --TotalAtrasado=c.CapitalAtrasado+c.InteresOrdinarioAtrasado+c.InteresOrdinarioIVAAtrasado+c.InteresMoratorioAtrasado+c.InteresMoratorioIVAAtrasado+c.Cargos+c.CargosImpuestos,
           TotalAtrasado = c.CapitalAtrasado + c.InteresOrdinarioTotal + c.InteresMoratorioTotal
                           + c.InteresOrdinarioIVA + c.InteresMoratorioIVA + c.Cargos + c.CargosImpuestos,
           TotalAlDia = c.CapitalAlDia + c.InteresOrdinarioTotal + c.InteresMoratorioTotal + c.InteresOrdinarioIVA
                        + c.InteresMoratorioIVA + c.Cargos + c.CargosImpuestos,
           c.MoraMaxima,
           c.ParcialidadesVencidas,
           c.SaldoTotal,
           c.ParcialidadesCapitalAtrasadas,
           cta.NumeroParcialidades,
           c.SaldoAlDía,
           c.SaldoExigible,
           c.TotalALiquidar,
           c.SaldoAlDíaSinCargos,
           c.SaldoExigibleSinCargos,
           c.TotalALiquidarSinCargos,
		   c.CargosCobranza,
		   c.IvaCargosCobranza,
		   c.SegurosPlanPagos,
		   c.IvaSegurosPlanPagos
    FROM tAYCcuentas cta WITH(NOLOCK)
        JOIN fAYCcalcularCartera(@FechaTrabajo, 2, @IdCuenta, @IdSocio) c
            ON cta.IdCuenta = c.IdCuenta
    WHERE (
              cta.IdCuenta = @IdCuenta
              OR @IdCuenta = 0
          )
          AND
          (
              cta.IdSocio = @IdSocio
              OR @IdSocio = 0
          )
    UNION
    -- Cuentas Castigadas ---------------------------------------------------------------------------------------
    SELECT cta.IdCuenta,
           Capital = c.SaldoCapital,
           cta.IdSocio,
           InteresOrdinario = c.SaldoInteresOrdinarioCuentasOrden,
           InteresOrdinarioIVA = c.SaldoIVAinteresOrdinarioCuentasOrden,
           InteresOrdinarioTotal = c.SaldoInteresOrdinarioCuentasOrden + c.SaldoIVAinteresOrdinarioCuentasOrden,
           InteresMoratorio = c.SaldoInteresMoratorioCuentasOrden,
           InteresMoratorioIVA = c.SaldoIVAinteresMoratorioCuentasOrden,
           InteresMoratorioTotal = c.SaldoInteresMoratorioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           CapitalAtrasado = c.SaldoCapital,
           CapitalAlDia = c.SaldoCapital,
           CapitalExigible = c.SaldoCapital,
           InteresOrdinarioAtrasado = c.SaldoInteresOrdinarioCuentasOrden,
           InteresOrdinarioIVAAtrasado = c.SaldoIVAinteresOrdinarioCuentasOrden,
           InteresOrdinarioTotalAtrasado = c.SaldoInteresOrdinarioCuentasOrden + c.SaldoIVAinteresOrdinarioCuentasOrden,
           InteresMoratorioAtrasado = c.SaldoInteresMoratorioCuentasOrden,
           InteresMoratorioIVAAtrasado = c.SaldoIVAinteresMoratorioCuentasOrden,
           InteresMoratorioTotalAtrasado = c.SaldoInteresMoratorioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           DiasTranscurridos = 0,
           DiasMora = IIF(
                          cta.Vencimiento != '1900-01-01'
                          AND cta.Vencimiento < @FechaTrabajo,
                          DATEDIFF(d, cta.Vencimiento, @FechaTrabajo),
                          0),
           Cargos = 0,
           --SaldoAlDia =0,
           --SaldoExigible = 0,
           --TotalALiquidar = 0,
           CargosImpuestos = 0,
           CargosTotal = 0,
           Impuestos = c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           Total = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden + c.SaldoIVAinteresOrdinarioCuentasOrden
                   + c.SaldoInteresMoratorioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           --TotalAtrasado=c.CapitalAtrasado+c.InteresOrdinarioAtrasado+c.InteresOrdinarioIVAAtrasado+c.InteresMoratorioAtrasado+c.InteresMoratorioIVAAtrasado+c.Cargos+c.CargosImpuestos,
           TotalAtrasado = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden
                           + c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoInteresMoratorioCuentasOrden
                           + c.SaldoIVAinteresMoratorioCuentasOrden,
           TotalAlDia = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden + c.SaldoIVAinteresOrdinarioCuentasOrden
                        + c.SaldoInteresMoratorioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           MoraMaxima = IIF(
                            cta.Vencimiento != '1900-01-01'
                            AND cta.Vencimiento < @FechaTrabajo,
                            DATEDIFF(d, cta.Vencimiento, @FechaTrabajo),
                            0),
           ParcialidadesVencidas = 0,
           SaldoTotal = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden + c.SaldoIVAinteresOrdinarioCuentasOrden
                        + c.SaldoInteresMoratorioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           0 AS ParcialidadesCapitalAtrasadas,
           cta.NumeroParcialidades,
           SaldoAlDia = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden + c.SaldoIVAinteresOrdinarioCuentasOrden
                        + c.SaldoInteresMoratorioCuentasOrden + c.SaldoIVAinteresMoratorioCuentasOrden,
           SaldoExigible = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden
                           + c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoInteresMoratorioCuentasOrden
                           + c.SaldoIVAinteresMoratorioCuentasOrden,
           TotalALiquidar = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden
                            + c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoInteresMoratorioCuentasOrden
                            + c.SaldoIVAinteresMoratorioCuentasOrden,
           SaldoAlDíaSinCargos = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden
                                 + c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoInteresMoratorioCuentasOrden
                                 + c.SaldoIVAinteresMoratorioCuentasOrden,
           SaldoExigibleSinCargos = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden
                                    + c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoInteresMoratorioCuentasOrden
                                    + c.SaldoIVAinteresMoratorioCuentasOrden,
           TotalALiquidarSinCargos = c.SaldoCapital + c.SaldoInteresOrdinarioCuentasOrden
                                     + c.SaldoIVAinteresOrdinarioCuentasOrden + c.SaldoInteresMoratorioCuentasOrden
                                     + c.SaldoIVAinteresMoratorioCuentasOrden,
			CargosCobranza = 0,
		   IvaCargosCobranza = 0,
		   SegurosPlanPagos = 0,
		   IvaSegurosPlanPagos = 0
    FROM tAYCcuentas cta WITH(NOLOCK)
        JOIN [fAYCobtenerSaldoCuentasCastigadasSocio](@FechaTrabajo, 2, @IdCuenta, @IdSocio) c
            ON cta.IdCuenta = c.IdCuenta
    WHERE (
              cta.IdCuenta = @IdCuenta
              OR @IdCuenta = 0
          )
          AND
          (
              cta.IdSocio = @IdSocio
              OR @IdSocio = 0
          )
);

GO

