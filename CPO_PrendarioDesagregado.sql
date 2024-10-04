

USE iERP_OBL



SELECT 
DATEPART(YEAR,c.FechaAlta) AS Año
,DATEPART(MONTH,c.FechaAlta) AS Mes,DATEPART(DAY,c.FechaAlta) AS Dia
,pf.Codigo, pf.Descripcion AS Producto
, COUNT(idcuenta) AS NoCuentas
,c.NumeroMaximoRefrendos
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
WHERE c.EsPrendario=1 AND c.IdEstatus=1 
GROUP BY DATEPART(YEAR,c.FechaAlta), DATEPART(MONTH,c.FechaAlta), DATEPART(DAY,c.FechaAlta),pf.Codigo, pf.Descripcion, c.NumeroMaximoRefrendos
ORDER BY Año, Mes,NoCuentas

SELECT suc.Descripcion AS Sucursal,
pf.Codigo AS ProductoCodigo, pf.Descripcion AS Producto
, c.Codigo AS NoCuenta, sc.Codigo AS NoSocio, p.Nombre
,c.NumeroMaximoRefrendos, cd.SaldoTotal
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN iERP_OBL_RPT.dbo.tAYCcarteraDiaria cd  WITH(NOLOCK) ON cd.IdCuenta = c.IdCuenta AND cd.FechaCartera='20200209'
WHERE c.EsPrendario=1 AND c.IdEstatus=1 AND c.NumeroMaximoRefrendos >0
ORDER BY pf.IdProductoFinanciero, suc.IdSucursal


