USE iERP_CPA

SELECT c.Codigo, c.Descripcion
, ic.IdTipoD, ic.Descripcion AS InsCap, ii.IdTipoD, ii.Descripcion AS InsInt
, c.Vencimiento
-- BEGIN TRAN UPDATE c SET c.IdTipoDInstruccionCapital=454, c.IdTipoDInstruccionInteres=454
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
LEFT JOIN dbo.tCTLtiposD IC  WITH(NOLOCK) ON IC.IdTipoD = c.IdTipoDInstruccionCapital
LEFT JOIN dbo.tCTLtiposD II  WITH(NOLOCK) ON II.IdTipoD = c.IdTipoDInstruccionInteres
WHERE c.IdTipoDProducto=398
AND c.IdEstatus=1 --AND ic.IdTipoD=453 --AND ii.IdTipoD=454
ORDER BY c.Vencimiento ASC


-- COMMIT
