

SELECT pf.Codigo, pf.Descripcion AS Producto, ca.MontoMinimo, ca.MontoMaximo
, ca.CuotaAhorro, ca.PorcentajeAhorro --ca.*
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcompromisoAhorro ca  WITH(NOLOCK) ON ca.RelCompromisoAhorro = pf.RelCompromisoAhorro
WHERE pf.IdTipoDDominioCatalogo=143
ORDER BY pf.IdProductoFinanciero


