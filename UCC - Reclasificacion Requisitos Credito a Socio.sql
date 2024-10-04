

-- USE iERP_UCC_TEST
GO

SELECT dig.* 
-- BEGIN TRAN UPDATE dig SET dig.EsObligatorioGuardar=0 -- 208
FROM dbo.tDIGrequisitos dig  WITH(NOLOCK) 
WHERE dig.EsObligatorioGuardar=1

-- COMMIT


SELECT ea.IdEstatus, d.IdTipoD, d.Descripcion, dig.* 
-- BEGIN TRAN UPDATE dig SET dig.IdTipoDDominio=208 -- 208
FROM dbo.tDIGrequisitos dig  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dig.IdEstatusActual
left JOIN dbo.tCTLtiposD d  WITH(NOLOCK) ON d.IdTipoD = dig.IdTipoDDominio
WHERE dig.IdRequisito>0 
 AND dig.IdTipoDDominio=143
AND dig.IdRequisito NOT IN (17,14,5,15)

-- 17,14,5,15

-- COMMIT



SELECT ea.IdEstatus, d.IdTipoD, d.Descripcion, dig.* 
-- BEGIN TRAN UPDATE dig SET dig.IdTipoDDominio=208 -- 208
FROM dbo.tDIGrequisitos dig  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dig.IdEstatusActual
left JOIN dbo.tCTLtiposD d  WITH(NOLOCK) ON d.IdTipoD = dig.IdTipoDDominio
-- ORDER BY dig.Descripcion asc
WHERE dig.IdRequisito NOT IN (7,8,9,10,11)



