
USE iERP_KFT_VAL

SELECT pf.Codigo, pf.Descripcion AS producto, gt.MontoInicial, gt.MontoFinal, gt.PorcentajeReciprocidad , gt.ReciprocidadDefault, gt.IdEstatus
-- UPDATE gt SET gt.ReciprocidadDefault=1
FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
inner JOIN dbo.tAYCproductosFinancierosReciprocidades gt  WITH(NOLOCK) ON gt.IdProductoFinanciero = pf.IdProductoFinanciero
																		--AND gt.IdEstatus!=1 --AND gt.PorcentajeReciprocidad<=.1
WHERE pf.IdTipoDDominioCatalogo=143 --AND gt.ReciprocidadDefault=1
ORDER BY producto


-- DELETE FROM tAYCproductosFinancierosReciprocidades WHERE IdEstatus != 1


