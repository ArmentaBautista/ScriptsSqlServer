
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetTransactionVoucher')
BEGIN
	DROP PROC pBKGgetTransactionVoucher
	SELECT 'pBKGgetTransactionVoucher BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE pBKGgetTransactionVoucher
@TransactionVoucherIdentifier VARCHAR(50) = '',
@RazonSocial VARCHAR(128) = '' OUTPUT
AS 
BEGIN

	SELECT @RazonSocial = per.Nombre FROM dbo.tCTLsucursales suc  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLempresas emp  WITH(NOLOCK)  ON emp.IdEmpresa = suc.IdEmpresa
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = emp.IdPersona
	WHERE suc.EsMatriz = 1

	SELECT op.Fecha Fecha,
       CONVERT(VARCHAR, op.Alta, 108) Hora,
       boir.TransactionIdentity IdTransaccionBKG,
       op.Folio IdOperacionErprise,
       pimt.DebitProductBankIdentifier NocuentaOrigen,
       'Retiro' OperacionOrigen,
       pimt.Amount MontoOrigen,
       pimt.CreditProductBankIdentifier NoCuentaDestino,
       'Deposito' OperacionDestino,
       pimt.Amount MontoDestino
FROM dbo.tGRLoperaciones op WITH (NOLOCK)
left JOIN dbo.tBKGbackendOperationItemResult boir WITH (NOLOCK)
	ON op.IdOperacion = boir.IdOperacion
left JOIN dbo.tBKGpeticionesInsertMasiveTransaction pimt WITH (NOLOCK)
	ON boir.IdPeticion = pimt.IdPeticion
WHERE op.Folio = @TransactionVoucherIdentifier;


END 
GO
