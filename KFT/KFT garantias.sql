

USE iERP_KFT
GO



SELECT g.IdCuentaGarantiaDisponible, g.IdCuentaGarantiaLiquida, g.IdCuentaGarantiaLiberada, ea.IdEstatus
-- UPDATE g SET g.IdCuentaGarantiaDisponible=1288928, g.IdCuentaGarantiaLiquida=1288928, g.IdCuentaGarantiaLiberada=1288928
-- BEGIN TRAN UPDATE ea SET ea.IdEstatus=2
FROM dbo.tAYCgarantias g  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = g.IdEstatusActual
INNER JOIN dbo.tAYCaperturas a  WITH(NOLOCK) ON a.IdApertura = g.IdApertura
WHERE a.Folio=1108


-- COMMIT


SELECT * FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdCuenta IN (1440116	,1834938	,1440116)


SELECT * FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.Codigo='H040535224IN'
