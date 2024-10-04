
USE iERP_CYL

SELECT pf.CrearConAportacionSocial, * 
FROM dbo.tAYCproductosFinancieros pf  WITH(nolock) 
WHERE pf.IdTipoDDominioCatalogo=144 AND pf.Codigo NOT IN ('AP','AM','AI')

/*
UPDATE pf SET pf.CrearConAportacionSocial=1
FROM dbo.tAYCproductosFinancieros pf  WITH(nolock) 
WHERE pf.IdTipoDDominioCatalogo=144 AND pf.Codigo NOT IN ('AP','AM','AI')
*/


