
USE iERP_CPA

SELECT td.Descripcion AS TipoMenor, pf.Codigo AS Producto, c.Codigo AS NoCuenta, sc.Codigo AS NoSocio, p.Nombre AS MenorAhorrador
FROM tayccuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) ON td.IdTipoD = sc.IdTipoDmenorAhorrador
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE pf.Descripcion LIKE '%infan%'
AND c.IdEstatus=1
