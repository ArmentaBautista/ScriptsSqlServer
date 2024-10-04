
-- pBKGgetLoanRates


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoanRates')
BEGIN
	DROP PROC pBKGgetLoanRates
	SELECT 'pBKGgetLoanRates BORRADO' AS info
END
GO

CREATE PROC pBKGgetLoanRates
@ProductBankIdentifier AS VARCHAR(32)='',
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=0,
@PageSize AS INT=0
AS
BEGIN
	

--#region Documentacion
	/*
	InitialDate  	DateTime	Fecha inicio donde comienza a aplicarse dicha tasa
	Rate			decimal		Tasa de interés
	LoanRatesCount	int			Cantidad total de tasas de interés del préstamo
	*/
--#endregion Documentacion

	SELECT 
	InitialDate  	= c.Alta,
	Rate			= c.InteresOrdinarioAnual,
	LoanRatesCount	= 1
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	WHERE c.Codigo=@ProductBankIdentifier

END


GO


