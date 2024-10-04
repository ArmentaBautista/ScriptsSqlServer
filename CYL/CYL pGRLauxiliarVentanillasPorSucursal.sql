
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGRLauxiliarVentanillasPorSucursal')
BEGIN
	DROP PROC pGRLauxiliarVentanillasPorSucursal
	SELECT 'pGRLauxiliarVentanillasPorSucursal BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pGRLauxiliarVentanillasPorSucursal
@pSucursalCodigo as varchar(20)=''
AS 
BEGIN
	 
	 DECLARE @IdSucursal AS INT=ISNULL((SELECT IdSucursal 
										FROM dbo.tCTLsucursales  WITH(NOLOCK) 
										WHERE Codigo=@pSucursalCodigo),0)

	 SELECT
	 suc.Descripcion AS Sucursal
	,suc.Codigo AS CodigoSucursal
	, c.Codigo as Ventanilla
	, FORMAT(ISNULL(sdo.saldo,0), 'C') AS Saldo 
	fROM dbo.tGRLcuentasABCD C  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
		ON suc.IdSucursal = C.IdSucursal
	 INNER JOIN dbo.tSDOsaldos sdo  WITH(NOLOCK) 
		ON sdo.IdCuentaABCD = C.IdCuentaABCD
	 INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = C.IdEstatusActual
			AND ea.IdTipoDDominio=851
	WHERE ((@IdSucursal=0) OR (c.IdSucursal = @IdSucursal))
	ORDER BY Sucursal, Ventanilla

         



end

GO