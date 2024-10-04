
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetMassiveTransactionBackEndInformation')
BEGIN
	DROP PROC pBKGgetMassiveTransactionBackEndInformation
	SELECT 'pBKGgetMassiveTransactionBackEndInformation BORRADO' AS info
END
GO

CREATE PROCEDURE [dbo].[pBKGgetMassiveTransactionBackEndInformation]
	@TransactionBackEndReference VARCHAR(20) = ''
AS
BEGIN
	SELECT imt.Amount Amount,
		   oir.BackendMessage BusinessMessage,
		   oir.BackendCode,
		   oir.BackendReference,
		   oir.Alta ExecutionDate,
		   IIF(oir.IsError = 1,0,1) ExecutedSuccesfully,
		   IIF(op.IdEstatus = 18,1,0) IsCanceled,
		   imt.ValueDate,
		   imt.ExchangeRate ExchangeRateTransaction,
		   imt.ExchangeRate ExchangeRateUSD
		   
	FROM dbo.tBKGbackendOperationItemResult oir  WITH(NOLOCK)  
	INNER JOIN dbo.tBKGpeticionesInsertMasiveTransaction imt  WITH(NOLOCK)  ON imt.IdPeticion = oir.IdPeticion
	LEFT JOIN dbo.tGRLoperaciones op  WITH(NOLOCK)  ON op.IdOperacion = oir.TransactionIdentity
	WHERE imt.TransactionId = @TransactionBackEndReference
END 
GO