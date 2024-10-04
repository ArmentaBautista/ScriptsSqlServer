

SELECT YEAR(c.FechaAlta) Año, c.Descripcion AS Producto, COUNT(1) AS NoCuentas
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdTipoDProducto IN (144,398)
AND c.FechaAlta >= '20140101'
GROUP BY YEAR(c.FechaAlta), c.Descripcion
ORDER BY Año

