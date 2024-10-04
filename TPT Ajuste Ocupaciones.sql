


UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(nolock) INNER JOIN  
dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=36 AND ld.IdListaD BETWEEN 227 AND 434


SELECT ea.IdEstatus, * 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN  dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=36
ORDER BY ld.IdListaD


