

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcarteraOperacionDiaria')
BEGIN
	DROP PROC pAYCcarteraOperacionDiaria
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE PROC pAYCcarteraOperacionDiaria
AS
BEGIN

TRUNCATE TABLE dbo.tAYCcarteraOperacionDiaria    

DECLARE @fecha AS DATE=GETDATE()
DECLARE @alta AS DATETIME=GETDATE()


INSERT INTO dbo.tAYCcarteraOperacionDiaria
(
    Fecha,
    Alta,
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
SELECT @fecha,
	   @alta,
	   sd.IdCuenta,
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
       sd.IvaSegurosPlanPagos FROM  dbo.fAYCcarteraOperacionDiaria (0, 0, @fecha, 2) sd

END