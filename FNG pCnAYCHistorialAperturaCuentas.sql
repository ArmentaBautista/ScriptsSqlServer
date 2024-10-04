
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCHistorialAperturaCuentas')
BEGIN
	DROP PROC pCnAYCHistorialAperturaCuentas
	SELECT 'pCnAYCHistorialAperturaCuentas BORRADO' AS info
END
GO

CREATE PROC pCnAYCHistorialAperturaCuentas
@fechaInicial AS DATE ='19000101',
@fechaFinal AS DATE ='19000101'
AS
	SELECT  -- p.IdPersona, sc.IdSocio, c.IdCuenta , pf.IdProductoFinanciero
	--c.idcuentarenovada, c.idcuentarestructurada,
	a.fecha AS FechaApertura
	, eapertura.descripcion AS EstatusApertura, ecuenta.descripcion AS EstatusCuenta, eentrega.descripcion AS EstatusEntrega, ce.fechaentregada
	, suc.codigo AS SucursalCodigo, suc.descripcion AS Sucursal
	, sc.Codigo AS NoSocio, p.Nombre, a.folio, c.Codigo AS NoCuenta,pf.Codigo AS ProductoCodigo, pf.Descripcion AS ProductoDescripcion
	, c.FechaAlta, c.montosolicitado, c.monto, c.montoentregado 
	,DATEDIFF(DAY,a.Fecha,GETDATE()) AS DiasDesdeApertura
	FROM tayccuentas c  WITH(nolock) 
	INNER JOIN dbo.tCTLestatus ecuenta  WITH(nolock) ON ecuenta.idestatus=c.idestatus
	INNER JOIN dbo.tCTLestatus eentrega  WITH(nolock) ON eentrega.idestatus=c.idestatusentrega
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(nolock) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tCTLsucursales suc  WITH(nolock) ON suc.idsucursal=c.idsucursal
	INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(nolock) ON ce.idcuenta=c.idcuenta AND ce.IdApertura=c.IdApertura
	INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio
	INNER JOIN dbo.tGRLpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
	INNER JOIN  dbo.tAYCaperturas a  WITH(nolock) ON a.idapertura=c.idapertura 
	INNER JOIN dbo.tCTLestatus eapertura  WITH(nolock) ON eapertura.idestatus=a.idestatus
	WHERE  c.IdTipoDProducto IN (143) AND c.IdApertura<>0--AND c.idcuenta=c.idcuentarestructurada
	AND a.Fecha BETWEEN @fechaInicial AND @fechaFinal
--	AND a.folio=22532
	ORDER BY a.Fecha		
GO

