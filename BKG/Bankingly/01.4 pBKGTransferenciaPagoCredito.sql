
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGTransferenciaPagoCredito')
BEGIN
	DROP PROC pBKGTransferenciaPagoCredito
	SELECT 'pBKGTransferenciaPagoCredito BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pBKGTransferenciaPagoCredito
@IdOperacion INT = 0 OUTPUT,
@Folio INT = 0 OUTPUT,
@Fecha DATE = '19000101', --ValueDate
@Monto NUMERIC (23,2) = 0, --Amount
@MontoComision NUMERIC(23,2) = 0, --TransactionCost
@IdCuentaRetiro INT = 0, --DebitProductBankIdentifier
@IdCuentaDeposito  INT = 0, --CreditProductBankIdentifier
@Concepto VARCHAR(80),--Description
@IdOperacionPadre INT = 0,
@AfectaSaldo BIT = 0 --Description
AS 
BEGIN

	
	EXECUTE dbo.pGRLgenerarOperacionPadre @IdTipoOperacion =  1021,               -- int
	                                  @IdOperacion = @IdOperacion OUTPUT, -- int
	                                  @IdOperacionPadre = @IdOperacionPadre,              -- int 
	                                  @FechaTrabajo = @Fecha,      -- date 
	                                  @Serie = '',                        -- varchar(10)
	                                  @IdSucursal = 1,                    -- int		
	                                  @IdSesion = 0,     -- int  
	                                  @Folio = @Folio OUTPUT,             -- int	
	                                  @Concepto = @Concepto,     -- varchar(80) 
	                                  @Referencia = 'Operación Bankingly',     -- varchar(30)
	                                  @IdPersona = 0,                     -- int
	                                  @IdRecurso = 0,                     -- int
	                                  @IdSocio = 0        -- int
	


	EXECUTE dbo.pSDOgenerarTransaccionFinancieraRetiroAcreedora @IdCuenta = @IdCuentaRetiro,                -- int
	                                                            @IdOperacion = @IdOperacion,             -- int
	                                                            @GeneraTransaccion = 1,    -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR LA TRANSACCION
	                                                            @ConsultarTransaccion = 0, -- bit
	                                                            @Monto = @Monto,                -- numeric(18, 2)
	                                                            @Concepto = @Concepto,               -- varchar(80)
	                                                            @Referencia = 'Operación Bankingly'              -- varchar(30)


	EXEC dbo.pAYCaplicacionPagoCredito @IdCuenta = @IdCuentaDeposito,                      -- int
	                                   @IdSocio = 0,                       -- int
	                                   @FechaTrabajo = @Fecha,       -- date
	                                   @Decimales = 2,                     -- int
	                                   @CodigoOperacion = 'DevPAg',              -- varchar(20)
	                                   @MontoAplicacion = @Monto,            -- numeric(18, 2)
	                                   @GenerarMovimiento = 1,          -- bit
	                                   @GenerarOperacion = 0,           -- bit
	                                   @IdOperacion = @IdOperacion, -- int
	                                   @IdTipoOperacion = 500,               -- int
	                                   @Concepto = @Concepto,                     -- varchar(80)
	                                   @Referencia = 'Operación Bankingly',                   -- varchar(30)
	                                   @IdSesion = 0,                      -- int
	                                   @ConsultarFinancierasD = 0
	 
        --Afectacion de saldos
	IF(@AfectaSaldo = 1)
	BEGIN
		EXEC dbo.pAYCactualizarSaldoParcialidades @IdOperacion = @IdOperacion; -- int

		EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @TipoOperacion = '', -- varchar(10)
																  @IdOperacion = @IdOperacion,    -- int
																  @Factor = 1       -- decimal(23, 8)

		EXEC dbo.pAYCactualizarPrimerVencimientoPendiente @IdOperacion = @IdOperacion; -- int


		EXEC dbo.pCTLvalidarAplicacionPlanPagosSaldo @TipoOperacion = 'PROVCART', -- varchar(20)
													 @IdCuenta = 0,               -- int
													 @IdOperacion = @IdOperacion; -- int
    END
	

	IF @IdOperacion!=0 
	BEGIN
		DECLARE @SaldoCredito AS NUMERIC(23,2)=(SELECT Capital+IIF(c.IdEstatusCartera=28,f.InteresOrdinario+f.InteresMoratorio,0) FROM dbo.fAYCsaldo(@IdCuentaDeposito) f INNER JOIN dbo.tAYCcuentas c WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta WHERE c.IdCuenta=@IdCuentaDeposito);
		EXEC dbo.pAYCDesbloqueoGarantiaCredito @IdCuentaCredito = @IdCuentaDeposito, -- int
		                                       @SaldoCuenta = @SaldoCredito,  -- numeric(23, 2)
		                                       @AfectaSaldo = 0,  -- bit
		                                       @IdOperacion = @IdOperacion      -- int
		

	END

    EXEC dbo.pIMPgenerarTransaccionesImpuestos @IdOperacionPadre = @IdOperacion; -- int


END 
GO

