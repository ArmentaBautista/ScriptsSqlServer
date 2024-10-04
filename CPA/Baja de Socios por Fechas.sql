
IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnAYCoperacionesBajasSociosFechas')
	DROP PROC pCnAYCoperacionesBajasSociosFechas
GO

CREATE PROC pCnAYCoperacionesBajasSociosFechas
@fechaInicial AS DATE,
@fechaFinal AS DATE
AS
-- Baja de Socios por Fechas

SELECT suc.Descripcion AS Sucursal, sc.Codigo AS NoSocio, p.Nombre, c.Codigo AS NoCuenta, c.Descripcion AS Producto, c.SaldoCapital, ce.FechaBaja, mb.Descripcion, c.IdDivision
FROM dbo.tAYCbajasSocios bj  WITH(NOLOCK)
INNER JOIN dbo.tCATlistasD mb  WITH(NOLOCK) ON mb.IdListaD = bj.IdListaDmotivoBaja
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = bj.IdSocio 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio 
											  AND c.IdDivision=-21 									  
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
															AND ce.FechaBaja BETWEEN @fechaInicial AND @fechaFinal
LEFT JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
WHERE bj.IdBajaSocio > 0
ORDER BY Sucursal


