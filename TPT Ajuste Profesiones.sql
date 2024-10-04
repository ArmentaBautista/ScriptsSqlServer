


UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(nolock) INNER JOIN  
dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1 WHERE 
ld.IdTipoE=35 AND ld.IdListaD BETWEEN 1 AND 226 


SELECT ea.IdEstatus, * 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN  dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=35 AND ld.IdListaD BETWEEN 227 AND 3078 ORDER BY ld.IdListaD


SELECT ea.IdEstatus, * 
FROM iERP_TPT.dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN  iERP_TPT.dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=35 AND ld.IdListaD BETWEEN 227 AND 3078 ORDER BY ld.IdListaD
