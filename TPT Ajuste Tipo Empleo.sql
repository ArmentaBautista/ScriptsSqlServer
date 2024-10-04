


SELECT ea.IdEstatus, ld.*
FROM dbo.tCATlistasD ld  WITH(nolock) INNER JOIN  
dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus IN (1)
WHERE ld.IdTipoE=182 
go



UPDATE ld SET ld.DescripcionLarga='INDEPENDIENTE'
FROM dbo.tCATlistasD ld  WITH(nolock) INNER JOIN  
dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=182 AND ld.IdListaD=-1335
go

UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(nolock) INNER JOIN  
dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=182 AND ld.IdListaD=-35
GO


