
-- pBKGgetLoanPayments


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoanPayments')
BEGIN
	DROP PROC pBKGgetLoanPayments
	SELECT 'pBKGgetLoanPayments BORRADO' AS info
END
GO

CREATE PROC pBKGgetLoanPayments
@ProductBankIdentifier AS VARCHAR(32),
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=1,
@PageSize AS INT=999
AS
BEGIN
	

--#region Documentacion
	/*
	CapitalBalance			decimal?	Saldo o balance del capital del préstamo
	FeeNumber				int			Número de cuota asociada al pago de préstamo
	MovementType 			int			Tipo de pago de préstamo según LoanPaymentTypes			1	Payoff loan		2	Pay loan fee		3	Other value
	NormalInterestAmount	decimal?	Monto de interés normal
	OthersAmount			decimal?	Otros conceptos asociados al pago
	OverdueInterestAmount	decimal?	Monto de interés vencido
	PaymentDate				DateTime?	Fecha de pago
	PrincipalAmount			decimal?	Monto principal del pago
	TotalAmount				decimal?	Monto total del pago
	LoanPaymentsCount		int			Cantidad total de pagos
	*/
--#endregion Documentacion

	DECLARE @idCuenta AS INT;
	DECLARE @idApertura AS INT;
	DECLARE @NumCuotas AS INT;
	DECLARE @CapitalBalance AS NUMERIC(23,8);
	DECLARE @LoanPaymentsCount INT;
	
	SELECT @idCuenta=idcuenta, @NumCuotas=c.NumeroParcialidades, @idApertura=c.IdApertura FROM dbo.tAYCcuentas c WITH(NOLOCK) WHERE c.Codigo=@ProductBankIdentifier
	SELECT TOP 1 @CapitalBalance = cartera.Capital FROM dbo.tAYCcartera cartera  WITH(NOLOCK) WHERE cartera.IdCuenta=@idCuenta ORDER BY cartera.FechaCartera DESC

	SELECT @LoanPaymentsCount=COUNT(1) FROM dbo.tAYCparcialidades p  WITH(NOLOCK) WHERE p.IdCuenta=@idCuenta AND p.EstaPagada=1

	DECLARE @query AS nVARCHAR(MAX) =CONCAT('
	SELECT 
		CapitalBalance			= ',@CapitalBalance,',
		FeeNumber				= p.NumeroParcialidad,
		MovementType 			= IIF(p.NumeroParcialidad=',@NumCuotas,',1,2),	
		NormalInterestAmount	= p.InteresOrdinarioPagado,
		OthersAmount			= 0,
		OverdueInterestAmount	= p.InteresMoratorioPagado,
		PaymentDate				= IIF(p.PagadoCapital>p.PagadoInteresOrdinario,p.PagadoCapital,p.PagadoInteresOrdinario),
		PrincipalAmount			= p.CapitalPagado,
		TotalAmount				= p.CapitalPagado + p.InteresOrdinarioPagado + p.InteresMoratorioPagado,
		LoanPaymentsCount		= ', @LoanPaymentsCount,'
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	WHERE p.idapertura=',@idApertura ,' AND p.IdCuenta=',@idCuenta ,' AND p.EstaPagada=1 ')
	
	
	-- Establecer datos de la paginación
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Determinación de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='p.NumeroParcialidad ASC'

	
		-- Implementación de Ordenamiento dinámico
		SET @query = CONCAT(@query,
												' ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,' ROWS ONLY')
		--PRINT @query	

		EXEC sys.sp_executesql @query

END
GO


