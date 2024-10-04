
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGTransferenciaCuentasTerceroAhorro')
BEGIN
	DROP PROC pBKGTransferenciaCuentasTerceroAhorro
	SELECT 'pBKGTransferenciaCuentasTerceroAhorro BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pBKGTransferenciaCuentasTerceroAhorro
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
	
	DECLARE @IdTransaccionFinanciera INT;
	EXECUTE dbo.pSDOgenerarTransaccionFinancieraDepositoAcreedora @IdCuenta = @IdCuentaDeposito,          -- int
	                                                              @IdOperacion = @IdOperacion,                                          -- int
	                                                              @GeneraTransaccion = 1,         -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR TRANSACCION
	                                                              @ConsultarTransaccion = 0,                              -- bit
	                                                              @Monto = @Monto,                                             -- numeric(18, 2)
	                                                              @Concepto = @Concepto,                                            -- varchar(80)
	                                                              @Referencia = 'Operación Bankingly',             -- varchar(30)
	                                                              @IdTransaccionFinanciera = @IdTransaccionFinanciera OUTPUT -- int
	
	

	EXECUTE dbo.pSDOgenerarTransaccionFinancieraRetiroAcreedora @IdCuenta = @IdCuentaRetiro,                -- int
	                                                            @IdOperacion = @IdOperacion,             -- int
	                                                            @GeneraTransaccion = 1,    -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR LA TRANSACCION
	                                                            @ConsultarTransaccion = 0, -- bit
	                                                            @Monto = @Monto,                -- numeric(18, 2)
	                                                            @Concepto = @Concepto,               -- varchar(80)
	                                                            @Referencia = 'Operación Bankingly'              -- varchar(30)

	IF(@AfectaSaldo = 1)
	BEGIN	
		EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @TipoOperacion = '', -- varchar(10)
	                                                          @IdOperacion = @IdOperacion,    -- int
	                                                          @Factor = 1       -- decimal(23, 8)
	
		EXEC dbo.pIMPgenerarTransaccionesImpuestos @IdOperacionPadre = @IdOperacion; -- int
	END


END 
GO

