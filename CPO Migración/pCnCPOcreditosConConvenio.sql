
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='dbo.pCnCPOcreditosConConvenio')
BEGIN
	DROP PROC dbo.pCnCPOcreditosConConvenio
	SELECT 'dbo.pCnCPOcreditosConConvenio BORRADO' AS info
END
GO

CREATE PROC dbo.pCnCPOcreditosConConvenio
AS
BEGIN

		SELECT 
		 [NoConvenio] = cce.Folio
		,[Empresa] = p.Nombre
		,[SucursalCodigo] = suc.Codigo
		,[Sucursal] = suc.Descripcion
		,[NoCuenta] = c.Codigo
		,[Producto] = pf.Descripcion
		,[NoSocio] = sc.Codigo
		,ps.Nombre
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) 
			ON ce.IdCuenta = c.IdCuenta
				AND ce.IdConvenioCreditoEmpresa<>0
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
			ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		INNER JOIN dbo.tSCSconveniosCreditosEmpresas cce  WITH(NOLOCK) 
			ON cce.IdConvenioCreditoEmpresa = ce.IdConvenioCreditoEmpresa
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = cce.IdEstatusActual
				AND ea.IdEstatus=1
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = cce.IdPersona
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON suc.IdSucursal = c.IdSucursal
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas ps  WITH(NOLOCK) 
			ON ps.IdPersona = sc.IdPersona
		WHERE c.IdEstatus=1
		ORDER BY cce.IdConvenioCreditoEmpresa
	
END
GO


