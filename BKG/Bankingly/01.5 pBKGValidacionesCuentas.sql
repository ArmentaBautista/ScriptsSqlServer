
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGValidacionesCuentas')
BEGIN
	DROP PROC pBKGValidacionesCuentas
	SELECT 'pBKGValidacionesCuentas BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pBKGValidacionesCuentas
@TipoOperacion INT = 0,
@IsError bit = 0 OUTPUT,
@BackendMessage VARCHAR(1024) = '' OUTPUT,
@BackendReference VARCHAR(1024) = '' OUTPUT,
@BackendCode VARCHAR(10) = '' OUTPUT,
@IdCuentaDeposito INT = 0 OUTPUT,
@IdCuentaRetiro INT = 0 OUTPUT,
@DebitProductBankIdentifier VARCHAR(50) = '',
@CreditProductBankIdentifier VARCHAR(50) = '',
@Amount DECIMAL(23,8) = 0,
@ValueDate DATE = '19000101'
AS 
BEGIN

	DECLARE @IdSocioDeposito INT = 0,
			@IdSocioRetiro INT = 0,
			@SaldoMinimo DECIMAL(23,8) = 0,
			@IdTipoDproductoRetiro INT = 0,
			@SaldoDisponible INT = 0,
			@IdEstatusRetiro INT = 0,
			@IdEstatusDeposito INT = 0,
			@IdEstatusSocioRetiro INT = 0,
			@IdEstatusSocioDeposito INT = 0;

	SET @IsError = 0;

	SELECT @IdSocioRetiro = c.IdSocio,@IdCuentaRetiro = c.IdCuenta,@SaldoMinimo = pff.SaldoMinimo,@IdTipoDproductoRetiro = c.IdTipoDProducto,@SaldoDisponible = fs.MontoDisponible - pff.SaldoMinimo,
	@IdEstatusRetiro = c.IdEstatus,@IdEstatusSocioRetiro = s.IdEstatus FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN  dbo.tAYCproductosFinancieros pff  WITH(NOLOCK)  ON pff.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK)  ON s.IdSocio = c.IdSocio
	INNER JOIN dbo.fAYCsaldo(0) fs ON fs.IdCuenta = c.IdCuenta
	WHERE c.Codigo = @DebitProductBankIdentifier
	
	SELECT @IdSocioDeposito = c.IdSocio,@IdCuentaDeposito = c.IdCuenta,@IdEstatusDeposito = c.IdEstatus,@IdEstatusSocioDeposito = s.IdEstatus FROM dbo.tAYCcuentas c  WITH(NOLOCK)
	INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdSocio = c.IdSocio 
	WHERE c.Codigo = @CreditProductBankIdentifier

	IF(@TipoOperacion NOT IN (1,2,6,7,9,10))
	BEGIN	
		SET @IsError = 1;
		SET @BackendMessage = 'Operación no soportada';
		SET @BackendReference = 'Operación no admitida';
		SET @BackendCode = '0098';
		RETURN;
	END 

	IF(@IdTipoDproductoRetiro = 143) --Validacion de retiro a productos de credito
	BEGIN
		SET @IsError = 1;
		SET @BackendMessage = CONCAT('La cuenta ',@DebitProductBankIdentifier,' no admite operaciones de retiro');
		SET @BackendReference = 'Operación no admitida';
		SET @BackendCode = '1';
		RETURN;
	END 

	IF(@SaldoDisponible < @Amount) --Validacion de saldo a cuenta de retiro
	BEGIN		
		SET @IsError = 1;
		SET @BackendMessage = 'No cuenta con saldo suficiente para realizar la operación';
		SET @BackendReference = 'Saldo insuficiente';
		SET @BackendCode = '2';
		RETURN;
	END 

	IF(@IdEstatusRetiro <> 1) --Validacion del estatus a cuenta de retiro
	BEGIN	
		SET @IsError = 1;
		SET @BackendMessage = 'La cuenta de retiro no se encuentra Activa';
		SET @BackendReference = 'Estatus de la cuenta incorrecto';
		SET @BackendCode = '3';
		RETURN;
	END

	IF(@IdEstatusDeposito <> 1) --Validacion del estatus a cuenta de deposito
	BEGIN	
		SET @IsError = 1;
		SET @BackendMessage = CONCAT('La cuenta de deposito no se encuentra Activa ',@IdEstatusDeposito);
		SET @BackendReference = 'Estatus de la cuenta incorrecto';
		SET @BackendCode = '4';
		RETURN;
	END

	IF(@TipoOperacion = 1) -- 1	Transferencias cuentas propias
	BEGIN
		IF(@IdSocioRetiro <> @IdSocioDeposito)
		BEGIN
			SET @IsError = 1;
			SET @BackendMessage = 'Las cuentas no pertenecen al mismo socio';
			SET @BackendReference = 'Tipo de operacion incorrecta';
			SET @BackendCode = '5';
			RETURN;
        END
	END
END
GO

