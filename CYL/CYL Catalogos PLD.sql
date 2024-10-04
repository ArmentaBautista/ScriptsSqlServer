
USE iERP_CYL
GO

SELECT *
FROM dbo.tCTLtiposE e  WITH(nolock) 
INNER JOIN dbo.tCATlistasD ld  WITH(nolock) ON ld.IdTipoE = e.IdTipoE
WHERE e.Descripcion LIKE '%giro%'



SELECT ld.IdListaD,ld.Codigo,ld.Descripcion 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=36

SELECT ld.IdListaD,ld.Codigo,ld.Descripcion 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
WHERE ld.IdTipoE=185



SELECT ld.IdListaD,ld.Codigo,ld.Descripcion, ld.IdTipoE 
FROM dbo.tCATlistasD ld  WITH(nolock) 
WHERE ld.IdListaD=-815

