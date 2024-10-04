

USE iERP_CYL
GO


SELECT ea.IdEstatus, ld.IdListaD, ld.codigo, ld.Descripcion, lv.IdListaD, lv.codigo, lv.Descripcion
--begin tran UPDATE lv SET lv.Descripcion=ld.Descripcion
FROM iERP_CYL.dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN  iERP_CYL.dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus IN (1)
INNER JOIN iERP_CYL_CAP.dbo.tCATlistasD lv  WITH(nolock) ON lv.IdListaD = ld.IdListaD
WHERE ld.IdTipoE=182 AND lv.Descripcion<>ld.Descripcion

go

-- COMMIT

SELECT ld.IdTipoD, ld.codigo, ld.Descripcion, lv.IdTipoD, lv.codigo, lv.Descripcion
-- begin tran UPDATE lv SET lv.Descripcion=ld.Descripcion
FROM iERP_CYL.dbo.tCTLtiposD ld  WITH(nolock)  
INNER JOIN iERP_CYL_CAP.dbo.tCTLtiposD lv  WITH(nolock) ON lv.IdTipoD = ld.IdTipoD
WHERE ld.IdTipoE IN (183) AND lv.Descripcion<>ld.Descripcion
