

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCYLoperacionesAhorroFuturo')
BEGIN
	DROP PROC pCYLoperacionesAhorroFuturo
	SELECT 'pCYLoperacionesAhorroFuturo BORRADO' AS info
END
GO

CREATE PROC pCYLoperacionesAhorroFuturo
@Fecha AS DATE='19000101'
AS
BEGIN
	DECLARE @codigoProducto AS VARCHAR(24)='AF'
	IF @Fecha='19000101'
		SET @Fecha=GETDATE();

	IF DATEPART(dd, @Fecha) BETWEEN 1 AND 5
	BEGIN
		-- SELECT pf.Codigo, pf.Descripcion AS Producto , opf.IdTipoOperacion, opf.IdEstatus
		UPDATE opf SET opf.IdEstatus=1
		FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCoperacionProducto opf  WITH(NOLOCK) ON opf.IdProductoFinanciero = pf.IdProductoFinanciero
		WHERE pf.Codigo=@codigoProducto AND opf.IdTipoOperacion = 501
	END
	ELSE
	BEGIN
		UPDATE opf SET opf.IdEstatus=2
		FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCoperacionProducto opf  WITH(NOLOCK) ON opf.IdProductoFinanciero = pf.IdProductoFinanciero
		WHERE pf.Codigo=@codigoProducto AND opf.IdTipoOperacion = 501
	END
END 
