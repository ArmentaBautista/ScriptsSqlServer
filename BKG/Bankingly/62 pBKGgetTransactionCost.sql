
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

--#region Documentaci�n INPUT
	/*
	FeatureId						int			Identificador de la funcionalidad seg�n cat�logo Features.
	TransactionTypeId				int			Identificador de la transacci�n seg�n cat�logo TransactionTypes.
	SubTransactionTypeId			int			Identificador del sub tipo de transacci�n seg�n cat�logo TransactionSubTypes.
	ValueDate						DateTime?	Fecha valor de la transacci�n.
	ClientBankIdentifier			string		Identificador interno del Cliente en el backend.
	CurrencyId						string		Identificador de la moneda de la transacci�n seg�n cat�logo Currencies.
	Amount							decimal		Monto de la transacci�n.
	DebitProductBankIdentifier		string		Identificador interno del producto a debitar en el backend
	DebitProductTypeId				int			Tipo de producto a debitar seg�n cat�logo ProductTypes.
	DebitCurrencyId					string		Identificador de la moneda del producto a debitar seg�n cat�logo Currencies.
	CreditProductBankIdentifier		string		Identificador interno del producto a acreditar en el backend
	CreditProductTypeId				int			Tipo de producto a acredidat seg�n cat�logo ProductTypes.
	CreditCurrencyId				string		Identificador de la moneda del producto a acreditar seg�n cat�logo Currencies.
	DestinationBankRoutingNumber	string		C�digo de ruta de la instituci�n destino de la transacci�n.
	AuthorizationCode				string		C�digo de autorizaci�n para acceder a un costo diferencial en caso de que corresponda.
	UserDocumentId					DocumentId	Tipo (seg�n DocumentType) y n�mero de documento de identidad del Usuario que ejecuta la transacci�n
	DocumentNumber
	DocumentType
	CancelCheckReasonCode			string		Raz�n de cancelaci�n de cheques (solo v�lido para funcionalidad de cancelaci�n de cheques).
	*/
--#endregion Documentaci�n

--#region Documetaci�n OUTPUT
	/*
	CostAmount		decimal	Monto indicando el costo de la transacci�n.
	CostCurrencyId	string	Identificador de la moneda seg�n el cat�logo Currencies, del monto que indica el costo de la transacci�n.
	*/
--#endregion Documetaci�n OUTPUT

SELECT 
 [CostAmount]		= 1
,[CostCurrencyId]	= '484'


END
GO


