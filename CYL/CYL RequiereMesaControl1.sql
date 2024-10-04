

USE iERP_CYL

SELECT pf.RequiereMesaControl1, * 
FROM dbo.tAYCproductosFinancieros pf  WITH(nolock) 
WHERE pf.IdTipoDDominioCatalogo=143

/*
UPDATE pf SET pf.RequiereMesaControl1=1
FROM dbo.tAYCproductosFinancieros pf  WITH(nolock) 
WHERE pf.IdTipoDDominioCatalogo=143
*/
