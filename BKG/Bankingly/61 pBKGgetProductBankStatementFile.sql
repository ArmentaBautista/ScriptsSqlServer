
-- 61 pBKGgetProductBankStatementFile


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductBankStatementFile')
BEGIN
	DROP PROC pBKGgetProductBankStatementFile
	SELECT 'pBKGgetProductBankStatementFile BORRADO' AS info
END
GO

CREATE PROC pBKGgetProductBankStatementFile
@ProductBankIdentifier		VARCHAR(24)='',
@ProductBankStatementDate	VARCHAR(8)='',
@ProductBankStatementId		VARCHAR(128)='',
@ProductType				INT=0
AS
BEGIN

--#region Documentación INPUT
	/*
		ProductBankIdentifier		string		Identificador interno del producto en el backend, asociado al archivo de estado de cuenta.
		ProductBankStatementDate	DateTime	Fecha del archivo de estado de cuenta.
		ProductBankStatementId		string		Identificador del archivo de estado de cuenta
		ProductType					int			Tipo de producto según catálogo ProductTypes.
	*/
--#endregion Documentación

--#region Documentación OUTPUT
	/*
		ProductBankStatementFile		byte[]	Archivo del estado de cuenta en formato pdf
		ProductBankStatementFileName	string	Nombre del archivo de estado de cuenta
	*/
--#endregion Documentación OUTPUT

DECLARE @ProductBankStatementFileName AS VARCHAR(128);
SET @ProductBankStatementFileName=IIF(@ProductBankStatementId='',CONCAT(@ProductBankStatementDate,'-',@ProductBankIdentifier),@ProductBankStatementId)
SELECT @ProductBankStatementFileName

END
GO
