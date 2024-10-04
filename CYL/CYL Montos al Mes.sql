
USE iERP_CYL_VAL
GO




SELECT ea.IdEstatus, ld.* 
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.IdTipoE IN (175,176,177,178)



/*
BEGIN TRAN UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(nolock) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = ld.IdEstatusActual
WHERE ld.IdTipoE=176 AND ld.IdListaD IN (455,456,457)

*/

-- COMMIT
