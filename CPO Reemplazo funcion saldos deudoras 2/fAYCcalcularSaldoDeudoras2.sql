IF EXISTS
(
    SELECT name
    FROM sys.objects o
    WHERE o.name = 'fAYCcalcularSaldoDeudoras2'
)
BEGIN
    DROP FUNCTION fAYCcalcularSaldoDeudoras2;
    SELECT 'fAYCcalcularSaldoDeudoras2 BORRADO' AS info;
END;
GO

CREATE FUNCTION [dbo].[fAYCcalcularSaldoDeudoras2]
(
    @IdCuenta AS INT = 0, -- 0 = Todas la Cuentas
    @IdSocio AS INT = 0,
    @FechaTrabajo AS DATE,
    @Decimales AS INT = 2
)
RETURNS @SaldosCredito TABLE
(
    [IdCuenta] [INT],
    [Capital] [NUMERIC](14, 2),
    [IdSocio] [INT],
    [InteresOrdinario] [NUMERIC](14, 2),
    [InteresOrdinarioIVA] [NUMERIC](14, 2),
    [InteresOrdinarioTotal] [NUMERIC](14, 2),
    [InteresMoratorio] [NUMERIC](14, 2),
    [InteresMoratorioIVA] [NUMERIC](14, 2),
    [InteresMoratorioTotal] [NUMERIC](14, 2),
    [CapitalAtrasado] [NUMERIC](14, 2),
    [CapitalAlDia] [NUMERIC](14, 2),
    [CapitalExigible] [NUMERIC](14, 2),
    [InteresOrdinarioAtrasado] [NUMERIC](14, 2),
    [InteresOrdinarioIVAAtrasado] [NUMERIC](14, 2),
    [InteresOrdinarioTotalAtrasado] [NUMERIC](14, 2),
    [InteresMoratorioAtrasado] [NUMERIC](14, 2),
    [InteresMoratorioIVAAtrasado] [NUMERIC](14, 2),
    [InteresMoratorioTotalAtrasado] [NUMERIC](14, 2),
    [DiasTranscurridos] [INT],
    [DiasMora] [INT],
    [Cargos] [NUMERIC](14, 2),
    [CargosImpuestos] [NUMERIC](14, 2),
    [CargosTotal] [NUMERIC](14, 2),
    [Impuestos] [NUMERIC](14, 2),
    [Total] [NUMERIC](14, 2),
    [TotalAtrasado] [NUMERIC](14, 2),
    [TotalAlDia] [NUMERIC](14, 2),
    [MoraMaxima] [INT],
    [ParcialidadesVencidas] [INT],
    [SaldoTotal] [NUMERIC](14, 2),
    [ParcialidadesCapitalAtrasadas] [INT],
    [NumeroParcialidades] [INT],
    [SaldoAlDía] [NUMERIC](14, 2),
    [SaldoExigible] [NUMERIC](14, 2),
    [TotalALiquidar] [NUMERIC](14, 2),
    [SaldoAlDíaSinCargos] [NUMERIC](14, 2),
    [SaldoExigibleSinCargos] [NUMERIC](14, 2),
    [TotalALiquidarSinCargos] [NUMERIC](14, 2),
    [CargosCobranza] [NUMERIC](14, 2),
    [IvaCargosCobranza] [DECIMAL](14, 2),
    [SegurosPlanPagos] [NUMERIC](14, 2),
    [IvaSegurosPlanPagos] [NUMERIC](14, 2)
)
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM dbo.tAYCcarteraOperacionDiariatransito t WITH (NOLOCK)
        WHERE t.idcuenta = @IdCuenta
    )
    BEGIN
        -- Caso: LA cuenta se consulta y ESTÁ pendiente de recálcculo
        INSERT @SaldosCredito
        (
            IdCuenta,
            Capital,
            IdSocio,
            InteresOrdinario,
            InteresOrdinarioIVA,
            InteresOrdinarioTotal,
            InteresMoratorio,
            InteresMoratorioIVA,
            InteresMoratorioTotal,
            CapitalAtrasado,
            CapitalAlDia,
            CapitalExigible,
            InteresOrdinarioAtrasado,
            InteresOrdinarioIVAAtrasado,
            InteresOrdinarioTotalAtrasado,
            InteresMoratorioAtrasado,
            InteresMoratorioIVAAtrasado,
            InteresMoratorioTotalAtrasado,
            DiasTranscurridos,
            DiasMora,
            Cargos,
            CargosImpuestos,
            CargosTotal,
            Impuestos,
            Total,
            TotalAtrasado,
            TotalAlDia,
            MoraMaxima,
            ParcialidadesVencidas,
            SaldoTotal,
            ParcialidadesCapitalAtrasadas,
            NumeroParcialidades,
            SaldoAlDía,
            SaldoExigible,
            TotalALiquidar,
            SaldoAlDíaSinCargos,
            SaldoExigibleSinCargos,
            TotalALiquidarSinCargos,
            CargosCobranza,
            IvaCargosCobranza,
            SegurosPlanPagos,
            IvaSegurosPlanPagos
        )
        SELECT sd.IdCuenta,
               sd.Capital,
               sd.IdSocio,
               sd.InteresOrdinario,
               sd.InteresOrdinarioIVA,
               sd.InteresOrdinarioTotal,
               sd.InteresMoratorio,
               sd.InteresMoratorioIVA,
               sd.InteresMoratorioTotal,
               sd.CapitalAtrasado,
               sd.CapitalAlDia,
               sd.CapitalExigible,
               sd.InteresOrdinarioAtrasado,
               sd.InteresOrdinarioIVAAtrasado,
               sd.InteresOrdinarioTotalAtrasado,
               sd.InteresMoratorioAtrasado,
               sd.InteresMoratorioIVAAtrasado,
               sd.InteresMoratorioTotalAtrasado,
               sd.DiasTranscurridos,
               sd.DiasMora,
               sd.Cargos,
               sd.CargosImpuestos,
               sd.CargosTotal,
               sd.Impuestos,
               sd.Total,
               sd.TotalAtrasado,
               sd.TotalAlDia,
               sd.MoraMaxima,
               sd.ParcialidadesVencidas,
               sd.SaldoTotal,
               sd.ParcialidadesCapitalAtrasadas,
               sd.NumeroParcialidades,
               sd.SaldoAlDía,
               sd.SaldoExigible,
               sd.TotalALiquidar,
               sd.SaldoAlDíaSinCargos,
               sd.SaldoExigibleSinCargos,
               sd.TotalALiquidarSinCargos,
               sd.CargosCobranza,
               sd.IvaCargosCobranza,
               sd.SegurosPlanPagos,
               sd.IvaSegurosPlanPagos
        FROM dbo.fAYCcarteraOperacionDiaria(@IdCuenta, 0, @FechaTrabajo, 2) sd;

    END;
    ELSE
    BEGIN
        -- Caso: LA cuenta se consulta y no esta pendiente de recalcculo
        INSERT @SaldosCredito
        (
            IdCuenta,
            Capital,
            IdSocio,
            InteresOrdinario,
            InteresOrdinarioIVA,
            InteresOrdinarioTotal,
            InteresMoratorio,
            InteresMoratorioIVA,
            InteresMoratorioTotal,
            CapitalAtrasado,
            CapitalAlDia,
            CapitalExigible,
            InteresOrdinarioAtrasado,
            InteresOrdinarioIVAAtrasado,
            InteresOrdinarioTotalAtrasado,
            InteresMoratorioAtrasado,
            InteresMoratorioIVAAtrasado,
            InteresMoratorioTotalAtrasado,
            DiasTranscurridos,
            DiasMora,
            Cargos,
            CargosImpuestos,
            CargosTotal,
            Impuestos,
            Total,
            TotalAtrasado,
            TotalAlDia,
            MoraMaxima,
            ParcialidadesVencidas,
            SaldoTotal,
            ParcialidadesCapitalAtrasadas,
            NumeroParcialidades,
            SaldoAlDía,
            SaldoExigible,
            TotalALiquidar,
            SaldoAlDíaSinCargos,
            SaldoExigibleSinCargos,
            TotalALiquidarSinCargos,
            CargosCobranza,
            IvaCargosCobranza,
            SegurosPlanPagos,
            IvaSegurosPlanPagos
        )
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
               DiasMora,
               Cargos,
               CargosImpuestos,
               CargosTotal,
               c.Impuestos,
               Total,
               TotalAtrasado,
               TotalAlDia,
               c.MoraMaxima,
               c.ParcialidadesVencidas,
               c.SaldoTotal,
               c.ParcialidadesCapitalAtrasadas,
               c.NumeroParcialidades,
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
        FROM dbo.tAYCcarteraOperacionDiaria c WITH (NOLOCK)
        WHERE c.IdCuenta = @IdCuenta;

    END;


END;
GO

