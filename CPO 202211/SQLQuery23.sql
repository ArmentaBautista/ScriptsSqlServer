

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcarteraOperacionDiariaAplicarTransito')
BEGIN
	DROP PROC pAYCcarteraOperacionDiariaAplicarTransito
	SELECT 'pAYCcarteraOperacionDiariaAplicarTransito' AS info
END
GO

CREATE PROC pAYCcarteraOperacionDiariaAplicarTransito
AS
BEGIN

	-- Cursor para recorrer cuentas en transito
	/* declare variables */
	DECLARE @IdCuentaTransito INT
	
	DECLARE cuentasTransito CURSOR FAST_FORWARD READ_ONLY FOR SELECT idcuenta FROM tAYCcarteraOperacionDiariaEnTransito WITH(NOLOCK)
	OPEN cuentasTransito
	FETCH NEXT FROM cuentasTransito INTO @IdCuentaTransito
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		DELETE FROM tAYCcarteraOperacionDiaria WHERE IdCuenta=@IdCuentaTransito

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
		SELECT @fecha,@alta,
			   sc.IdCuenta,
               sc.Capital,
               sc.IdSocio,
               sc.InteresOrdinario,
               sc.InteresOrdinarioIVA,
               sc.InteresOrdinarioTotal,
               sc.InteresMoratorio,
               sc.InteresMoratorioIVA,
               sc.InteresMoratorioTotal,
               sc.CapitalAtrasado,
               sc.CapitalAlDia,
               sc.CapitalExigible,
               sc.InteresOrdinarioAtrasado,
               sc.InteresOrdinarioIVAAtrasado,
               sc.InteresOrdinarioTotalAtrasado,
               sc.InteresMoratorioAtrasado,
               sc.InteresMoratorioIVAAtrasado,
               sc.InteresMoratorioTotalAtrasado,
               sc.DiasTranscurridos,
               sc.DiasMora,
               sc.Cargos,
               sc.CargosImpuestos,
               sc.CargosTotal,
               sc.Impuestos,
               sc.Total,
               sc.TotalAtrasado,
               sc.TotalAlDia,
               sc.MoraMaxima,
               sc.ParcialidadesVencidas,
               sc.SaldoTotal,
               sc.ParcialidadesCapitalAtrasadas,
               sc.NumeroParcialidades,
               sc.SaldoAlDía,
               sc.SaldoExigible,
               sc.TotalALiquidar,
               sc.SaldoAlDíaSinCargos,
               sc.SaldoExigibleSinCargos,
               sc.TotalALiquidarSinCargos,
               sc.CargosCobranza,
               sc.IvaCargosCobranza,
               sc.SegurosPlanPagos,
               sc.IvaSegurosPlanPagos
		FROM dbo.fAYCcalcularSaldoDeudoras2(@IdCuentaTransito,0,@fecha,2) sc	
	
	    FETCH NEXT FROM cuentasTransito INTO @IdCuentaTransito
	END
	
	CLOSE cuentasTransito
	DEALLOCATE cuentasTransito


END	



