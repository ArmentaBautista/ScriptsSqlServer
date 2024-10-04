

SELECT 
cc.Vencimiento AS Vencimiento, ecc.Descripcion AS EstatusCredito, AP.Folio AS FolioApertura,cc.Codigo AS CuentaCredito, cc.Descripcion AS ProductoCredito
, cr.Codigo AS CuentaDomiciliada, pf.Codigo AS CodigoProductoDomiciliado, pf.Descripcion AS ProductoDomiciliado, cr.SaldoCapital, ecd.Descripcion AS EstatusCuentaDomiciliada
, su.Codigo AS CodSucursal,su.Descripcion AS Sucursal,  so.Codigo AS NoSocio, pe.Nombre AS Nombre
	FROM dbo.tAYCdomiciliaciones d  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentas cc  WITH(NOLOCK) ON cc.IdCuenta = d.IdCuentaCredito
	INNER JOIN dbo.tAYCcuentas cr  WITH(NOLOCK) ON cr.IdCuenta=d.IdCuentaRetiro
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(nolock) ON pf.IdProductoFinanciero = cr.IdProductoFinanciero
	INNER JOIN dbo.tAYCcuentas ca  WITH(NOLOCK) ON ca.IdCuenta=d.IdCuentaDepositoAhorro
	INNER JOIN dbo.tSCSsocios so WITH(NOLOCK) ON so.IdSocio = cc.IdSocio
	INNER JOIN dbo.tGRLpersonas pe WITH(NOLOCK) ON so.IdPersona = pe.IdPersona
	INNER JOIN dbo.tCTLsucursales su WITH(NOLOCK) ON su.IdSucursal = cc.IdSucursal
	LEFT JOIN dbo.tAYCaperturas AP WITH(NOLOCK) ON AP.IdApertura = cc.IdApertura
	INNER JOIN dbo.tCTLestatus ecc  WITH(nolock) ON ecc.IdEstatus = cc.IdEstatus
	INNER JOIN dbo.tCTLestatus ecd  WITH(nolock) ON ecd.IdEstatus = cr.IdEstatus
	WHERE d.IdEstatus=1 
	ORDER BY Vencimiento DESC





