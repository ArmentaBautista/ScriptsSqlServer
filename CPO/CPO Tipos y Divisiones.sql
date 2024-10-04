

SELECT --1 AS conteo, c.Codigo, p.Codigo AS CodigoProducto, p.Descripcion AS Producto
p.Codigo, p.Descripcion, e.Descripcion AS EstatusProducto, COUNT(1) AS Cuentas
FROM dbo.tAYCcuentas c  WITH(nolock) 
RIGHT JOIN dbo.tAYCproductosFinancieros p  WITH(nolock) ON p.IdProductoFinanciero = c.IdProductoFinanciero
														AND p.IdTipoDDominioCatalogo=143
														AND	p.Descripcion LIKE '%auto%'
														AND	p.Codigo IN ('1135','2387','2365','7358','2358')
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = p.IdEstatusActual
INNER JOIN dbo.tCTLestatus e  WITH(nolock) ON e.IdEstatus = ea.IdEstatus
WHERE c.IdEstatus=1
GROUP BY p.Codigo, p.Descripcion, e.Descripcion
ORDER BY e.Descripcion




