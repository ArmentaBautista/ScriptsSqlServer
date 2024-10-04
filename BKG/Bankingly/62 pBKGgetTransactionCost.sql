
-- 62 pBKGgetTransactionCost

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetTransactionCost')
BEGIN
	DROP PROC pBKGgetTransactionCost
	SELECT 'pBKGgetTransactionCost BORRADO' AS info
END
GO

CREATE PROC pBKGgetTransactionCost
@FeatureId						INT=0,
@TransactionTypeId				INT=0,
@SubTransactionTypeId			INT=0,
@ValueDate						DATE='19000101',
@ClientBankIdentifier			VARCHAR(32)='',
@CurrencyId						VARCHAR(16)='',
@Amount							NUMERIC(18,2)=0,
@DebitProductBankIdentifier		VARCHAR(24)='',
@DebitProductTypeId				INT=0,
@DebitCurrencyId				VARCHAR(24)='',
@CreditProductBankIdentifier	VARCHAR(24)='',
@CreditProductTypeId			INT=0,
@CreditCurrencyId				VARCHAR(24)='',
@DestinationBankRoutingNumber	VARCHAR(24)='',
@AuthorizationCode				VARCHAR(24)='',
@DocumentNumber					VARCHAR(24)='',
@DocumentType					INT=0,
@CancelCheckReasonCode			VARCHAR(32)=''
AS
BEGIN

--#region Documentación INPUT
	/*
	FeatureId						int			Identificador de la funcionalidad según catálogo Features.
	TransactionTypeId				int			Identificador de la transacción según catálogo TransactionTypes.
	SubTransactionTypeId			int			Identificador del sub tipo de transacción según catálogo TransactionSubTypes.
	ValueDate						DateTime?	Fecha valor de la transacción.
	ClientBankIdentifier			string		Identificador interno del Cliente en el backend.
	CurrencyId						string		Identificador de la moneda de la transacción según catálogo Currencies.
	Amount							decimal		Monto de la transacción.
	DebitProductBankIdentifier		string		Identificador interno del producto a debitar en el backend
	DebitProductTypeId				int			Tipo de producto a debitar según catálogo ProductTypes.
	DebitCurrencyId					string		Identificador de la moneda del producto a debitar según catálogo Currencies.
	CreditProductBankIdentifier		string		Identificador interno del producto a acreditar en el backend
	CreditProductTypeId				int			Tipo de producto a acredidat según catálogo ProductTypes.
	CreditCurrencyId				string		Identificador de la moneda del producto a acreditar según catálogo Currencies.
	DestinationBankRoutingNumber	string		Código de ruta de la institución destino de la transacción.
	AuthorizationCode				string		Código de autorización para acceder a un costo diferencial en caso de que corresponda.
	UserDocumentId					DocumentId	Tipo (según DocumentType) y número de documento de identidad del Usuario que ejecuta la transacción
	DocumentNumber
	DocumentType
	CancelCheckReasonCode			string		Razón de cancelación de cheques (solo válido para funcionalidad de cancelación de cheques).
	*/
--#endregion Documentación

--#region Documetación OUTPUT
	/*
	CostAmount		decimal	Monto indicando el costo de la transacción.
	CostCurrencyId	string	Identificador de la moneda según el catálogo Currencies, del monto que indica el costo de la transacción.
	*/
--#endregion Documetación OUTPUT

SELECT 
 [CostAmount]		= 1
,[CostCurrencyId]	= '484'


END
GO


