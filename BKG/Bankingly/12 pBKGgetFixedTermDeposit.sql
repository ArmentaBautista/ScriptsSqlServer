
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetFixedTermDeposit')
BEGIN
	DROP PROC pBKGgetFixedTermDeposit
	SELECT 'pBKGgetFixedTermDeposit BORRADO' AS info
END
GO

CREATE PROC pBKGgetFixedTermDeposit
@pProductBankIdentifier		varchar(32)
AS
BEGIN

/* INFO (⊙_☉) Entrada
Nombre del parámetro		Tipo de dato			Descripción
ProductBankIdentifier		String					Identificador interno del producto
*/

/* INFO (⊙_☉) Salida
Nombre del parámetro				Tipo de dato	Descripción
CdpName  							string			Nombre del certificado
CdpNumber  							string			Número del certificado
CurrentBalance  					decimal			Saldo o balance actual
DueDate  							DateTime?		Fecha de vencimiento
InterestEarned  					Decimal?		Intereses ganados
InterestPaid						Decimal?		Intereses pagados
InterestPayingAccount  				string			Cuenta pagadora de intereses
OriginalAmount  					Amount			Monto inicial del depósito
ProductBankIdentifier				string			Identificador interno del producto
Rate  								decimal			Tasa
RenewalDate  						DateTime		Fecha de renovación
StartDate  							DateTime?		Fecha de inicio
Term								string			Plazo
DebitProductBankIdentifier			string			Identificador interno del producto en el backend, donde ejecutar el débito del depósito a plazo
FixedTermDepositType				int				Identificador (interno del backend) del tipo de depósito a plazo
PaymentMethod						Catalog			Método de pago del depósito a plazo
TotalInterestAmount					Amount			Monto (y moneda) de los intereses del depósito a plazo
RenewalType							Catalog			Tipo de renovación
InterestCreditProductBankIdentifier	string			Identificador interno del producto en el backend, donde acreditar los intereses del depósito a plazo
DepositCreditProductBankIdentifier	string			Identificador interno del producto en el backend, donde se acredita el capital del depósito a plazo
FixedTermDepositBeneficiaries		List<FixedTermDepositBeneficiary>	Lista de beneficiarios

*/


SELECT 
 [CdpName]									= pf.codigo
,[CdpNumber]								= c.codigo
,[CurrentBalance]							= c.saldocapital
,[DueDate]									= c.vencimiento
,[InterestEarned]							= 0.0
,[InterestPaid]								= 0.0
,[InterestPayingAccount]					= ''
,[OriginalAmountCurrencyId]					= 40 -- MXP
,[OriginalAmountValue]						= c.monto
,[ProductBankIdentifier]					= pf.descripcion
,[Rate]										= c.interesordinarioanual
,[RenewalDate]								= ce.FechaUltimaReinversion
,[StartDate]								= c.FechaAlta
,[Term]										= c.Dias
,[DebitProductBankIdentifier]				= ''
,[FixedTermDepositType]						= 1
,[PaymentMethod]							= 'VARIOS'
,[TotalInterestAmountCurrencyId]			= 40 -- MXP
,[TotalInterestAmountValue]					= 0.0
,[RenewalType]								= 1
,[InterestCreditProductBankIdentifier]		= cInt.Codigo
,[DepositCreditProductBankIdentifier]		= cCap.Codigo
,[FixedTermDepositBeneficiaries]			= dbo.fnBKGobtenerBeneficiarioMayorPorcentaje(c.IdCuenta)	
--,[NoSocio]									= sc.Codigo -- QUITAR
FROM tayccuentas c  WITH(NOLOCK)
INNER JOIN taycproductosfinancieros pf  WITH(NOLOCK)
	ON pf.idproductofinanciero=c.idproductofinanciero
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) 
	ON ce.IdCuenta = c.IdCuenta
INNER JOIN dbo.tAYCcuentas cInt  WITH(NOLOCK) 
	ON cInt.IdCuenta=c.IdCuentaInteres
INNER JOIN dbo.tAYCcuentas cCap  WITH(NOLOCK) 
	ON cCap.IdCuenta=c.IdCuentaCapital
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK)
	ON sc.IdSocio = c.IdSocio
WHERE c.idtipodproducto=398
	AND c.Codigo=@pProductBankIdentifier

END
GO