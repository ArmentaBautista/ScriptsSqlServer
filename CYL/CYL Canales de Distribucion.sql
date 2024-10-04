


SELECT ea.IdEstatus, ld.* 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.IdTipoE=181



SELECT ea.IdEstatus, ld.* 
-- UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.IdListaD IN (496,497,498)


