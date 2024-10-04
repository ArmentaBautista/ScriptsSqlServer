USE iERP_KFT_VAL

SELECT pf.Codigo, pf.Descripcion , pf.PermiteReduccionPlazo, pf.PermiteReduccionCuota, pf.PermitePagoAdelantado
-- UPDATE pf SET pf.PermiteReduccionPlazo=0, pf.PermiteReduccionCuota=1, pf.PermitePagoAdelantado=1
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
WHERE pf.IdTipoDDominioCatalogo=143

