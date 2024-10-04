
SELECT pf.Codigo, pf.Descripcion AS Producto , pt.TasaInteresOrdinarioAnual, pt.TasaInteresMoratorioAnual
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
INNER JOIN dbo.tCTLproductosFinancierosTasas pt  WITH(NOLOCK) ON pt.RelTasas = pf.IdProductoFinanciero
WHERE pf.IdTipoDDominioCatalogo=143
ORDER BY Producto, pt.TasaInteresOrdinarioAnual
