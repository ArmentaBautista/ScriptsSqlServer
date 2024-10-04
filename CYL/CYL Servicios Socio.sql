
USE iERP_CYL_VAL

SELECT ea.IdEstatus, ld.* 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.Descripcion LIKE '%herbalife%'

SELECT ea.IdEstatus, ld.* 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.IdTipoE=180


SELECT ea.IdEstatus, ld.* 
-- UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.IdTipoE=180 AND ld.IdListaD >0

