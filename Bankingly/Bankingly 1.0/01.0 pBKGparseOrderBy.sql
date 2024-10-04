

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGparseOrderBy')
BEGIN
	DROP PROC pBKGparseOrderBy
	SELECT 'pBKGparseOrderBy BORRADO' AS info
END
GO

CREATE PROC pBKGparseOrderBy
@pOrderByField AS VARCHAR(128),
@pCampoOrden VARCHAR(128) OUTPUT,
@pTipoOrden VARCHAR(128) OUTPUT
AS
BEGIN

	DECLARE @camposOrden TABLE(
		Id		INT PRIMARY KEY IDENTITY,
		Valor	NVARCHAR(max)
	)

	if EXISTS(SELECT 1 FROM STRING_SPLIT(@pOrderByField,' ') HAVING COUNT(1)>1)
	BEGIN
		INSERT INTO @camposOrden (Valor)
		SELECT value FROM STRING_SPLIT(@pOrderByField,' ')

		SELECT @pcampoOrden=Valor FROM @camposOrden where Id=1
		SELECT @ptipoOrden=Valor FROM @camposOrden WHERE Id=2
	END

	--SELECT @campoOrden
	--SELECT @tipoOrden 
END
GO

