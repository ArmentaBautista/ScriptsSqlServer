

SELECT 1 AS conteo, c.Codigo AS NoCuenta,
p.Codigo AS CodigoProducto, p.Descripcion AS Producto,
c.IdTipoDProducto, tprod.Descripcion TipoProducto,
c.IdDivision, d.Descripcion AS Division,
c.IdTipoDTablaEstimacion, ttabla.Descripcion TablaEstimacion,
DATEPART(YEAR,c.FechaAlta) AS Año,
DATEPART(MONTH,c.FechaAlta) AS Mes
FROM dbo.tAYCcuentas c  WITH(nolock) 
INNER JOIN dbo.tAYCproductosFinancieros p  WITH(nolock) ON p.IdProductoFinanciero = c.IdProductoFinanciero
														AND	p.Codigo IN ('1135','2387','2365','7358','2358')
INNER JOIN dbo.tCTLtiposD tprod  WITH(nolock) ON tprod.IdTipoD = c.IdTipoDAIC
INNER JOIN dbo.tCTLtiposD ttabla  WITH(nolock) ON ttabla.IdTipoD = c.IdTipoDTablaEstimacion
INNER JOIN dbo.tCNTdivisiones d  WITH(nolock) ON d.IdDivision = c.IdDivision
WHERE c.IdEstatus=1


