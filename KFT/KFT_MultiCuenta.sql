USE iERP_KFT_VAL

SELECT pf.Codigo, pf.Descripcion AS producto, pf.EsMultiCuenta
-- UPDATE pf SET pf.EsMultiCuenta=1
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
WHERE pf.IdTipoDDominioCatalogo=143 
ORDER BY producto