

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProducts')
BEGIN
	DROP PROC pBKGgetProducts
	SELECT 'pBKGgetProducts BORRADO' AS info
END
GO

CREATE PROC pBKGgetProducts
@ClientBankIdentifiers AS VARCHAR(24),
@ProductTypes AS VARCHAR(7)=''
AS
BEGIN
	
	
SELECT 
	ClientBankIdentifier			= sc.Codigo, 
	ProductBankIdentifier			= c.Codigo,
	ProductNumber					= c.Codigo,
	ProductStatusId					= c.IdEstatus,
	ProductTypeId					= pt.ProductTypeId,
	ProductAlias					= pf.Descripcion,
	CanTransact						= t.CanTransactType,
	CurrencyId						= '484'
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdEstatus=1 and sc.Codigo= @ClientBankIdentifiers
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = pf.IdProductoFinanciero
	WHERE c.IdEstatus=1 AND c.IdSocio=sc.idSocio
	order by ProductTypeId 
END
GO

