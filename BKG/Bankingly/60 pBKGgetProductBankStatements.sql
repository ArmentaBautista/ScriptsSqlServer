

-- 60 pBKGgetProductBankStatements


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductBankStatements')
BEGIN
	DROP PROC pBKGgetProductBankStatements
	SELECT 'pBKGgetProductBankStatements BORRADO' AS info
END
GO

CREATE PROC pBKGgetProductBankStatements
@ClientBankIdentifier	VARCHAR(24)='',
@ProductBankIdentifier	VARCHAR(24)='',
@ProductType			INT=0	
AS
BEGIN

--#region Documentación  INPUT
	/*
	ClientBankIdentifier	string	Identificador del cliente en el backend.
	ProductBankIdentifier	string	Identificador del producto en el backend para el cual se está solicitando la lista de estados de cuenta.
	ProductType				int		Tipo de producto según catálogo ProductTypes.
	*/
--#endregion Documentación

--#region Documentación  OUTPUT
	/*
	ProductBankIdentifier		string		Identificador interno del producto en el backend, asociado al archivo de estado de cuenta.
	ProductBankStatementDate	DateTime	Fecha del archivo de estado de cuenta. Esta fecha se despliega al usuario final para que poder seleccionar el estado de cuenta.
	ProductBankStatementId		string		Identificador del archivo de estado de cuenta en el backend.
	ProductType					int			Tipo de producto según catálogo ProductTypes.
	*/
--#endregion Documentación

	DECLARE @fechaTrabajo AS DATE=GETDATE();
	DECLARE @fecha12mesesAntes AS DATE=DATEADD(YEAR,-1,@fechaTrabajo);

	SELECT 
	 ProductBankIdentifier		= @ProductBankIdentifier
	,ProductBankStatementDate	= per.Codigo
	,ProductBankStatementId		= CONCAT(per.Codigo,'-',@ProductBankIdentifier)
	,ProductType				= @ProductType
	FROM dbo.tCTLperiodos per  WITH(NOLOCK) 
	WHERE per.Inicio>=@fecha12mesesAntes AND per.Fin<=@fechaTrabajo
	AND per.EsAjuste=0


END
GO


