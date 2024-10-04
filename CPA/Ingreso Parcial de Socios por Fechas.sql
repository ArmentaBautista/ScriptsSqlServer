
IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnAYCoperacionesIngresoParcialSociosFechas')
	DROP PROC pCnAYCoperacionesIngresoParcialSociosFechas
GO

CREATE PROC pCnAYCoperacionesIngresoParcialSociosFechas
@fechaInicial AS DATE,
@fechaFinal AS DATE
as
-- Ingreso Parcial de Socios por Fechas


SELECT suc.Descripcion AS Sucursal, sc.Codigo AS NoSocio, p.Nombre, c.Codigo AS NoCuenta, c.Descripcion AS Producto, c.SaldoCapital, c.FechaAlta, tf.CapitalGenerado, c.IdDivision
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio 
											  AND c.IdDivision=-24 
											  AND c.FechaAlta BETWEEN @fechaInicial AND @fechaFinal
LEFT JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
left JOIN (
			SELECT c.IdCuenta, MAX(f.CapitalGenerado) AS CapitalGenerado
			FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK) 
			INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta 
															AND c.IdDivision=-24
															AND c.FechaAlta BETWEEN @fechaInicial AND @fechaFinal 
			WHERE f.IdTipoSubOperacion=500
			GROUP BY c.IdCuenta
			) tf ON tf.IdCuenta = c.IdCuenta															
ORDER BY Sucursal