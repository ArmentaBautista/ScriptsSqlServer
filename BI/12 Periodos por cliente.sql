
USE iERP_BI
go


DECLARE @NumeroEmpresa AS TINYINT = 6
/*
SELECT 'tSITcatalogoMinimo', t.IdPeriodo, COUNT(1) AS NumeroRegistros FROM dbo.tSITcatalogoMinimo t  WITH(nolock) 
WHERE t.IdEmpresa=@NumeroEmpresa GROUP BY t.IdPeriodo ORDER BY t.IdPeriodo DESC

SELECT 'tSITcatalogoMinimoSaldos', IdPeriodo, Periodo , COUNT(1) AS NumeroRegistros FROM dbo.tSITcatalogoMinimoSaldos 
WHERE IdEmpresa=@NumeroEmpresa GROUP BY IdPeriodo, Periodo ORDER BY IdPeriodo DESC

SELECT 'tBSIsucursales', Periodo, COUNT(1) AS NumeroRegistros FROM dbo.tBSIsucursales 
WHERE IdEmpresa=@NumeroEmpresa GROUP BY  Periodo ORDER BY Periodo DESC

SELECT 'tBSIcuentas', fechaBI, COUNT(1) AS NumeroRegistros from dbo.tBSIcuentas c  WITH(NOLOCK)
WHERE IdEmpresa=@NumeroEmpresa GROUP BY  c.FechaBI ORDER BY c.FechaBI DESC
*/
SELECT 'tBSIcarteraDiaria', fechaBI, cd.FechaCartera, COUNT(1) AS NumeroRegistros FROM dbo.tBSIcarteraDiaria cd  WITH(NOLOCK) 
WHERE IdEmpresa=@NumeroEmpresa GROUP BY  cd.FechaBI, cd.FechaCartera ORDER BY cd.FechaBI DESC

SELECT 'tBSIsociosSucursal', fechaBI, COUNT(1) AS NumeroRegistros FROM dbo.tBSIsociosSucursal cd WITH(NOLOCK) 
WHERE IdEmpresa=@NumeroEmpresa GROUP BY  cd.FechaBI ORDER BY cd.FechaBI DESC

SELECT 'tBSIcaptacion', fechaBI, COUNT(1) AS NumeroRegistros FROM dbo.tBSIcaptacion cd WITH(NOLOCK) 
WHERE IdEmpresa=@NumeroEmpresa GROUP BY  cd.FechaBI ORDER BY cd.FechaBI DESC


