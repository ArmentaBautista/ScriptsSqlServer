
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCbitacoraPermisosPorProductoFinanciero')
BEGIN
	DROP PROC pCnAYCbitacoraPermisosPorProductoFinanciero
	SELECT 'pCnAYCbitacoraPermisosPorProductoFinanciero BORRADO' AS info
END
GO

CREATE PROC pCnAYCbitacoraPermisosPorProductoFinanciero
@Inicio DATE='19000101',
@Fin DATE='19000101'
AS
BEGIN

IF @Inicio='19000101' OR @Fin='19000101' OR @Fin<@Inicio
BEGIN
	SELECT 'Debe proporcionar un rango de fechas válido' AS Info
	RETURN 0
END

	SELECT 
	ss.Host,
	usuarioCambio.Usuario AS UsuarioConfiguracion,
	u.Usuario AS UsuarioAsignado,
	pf.Codigo AS CodigoProducto,
	pf.Descripcion AS Producto,
	be.FechaHora,
	eant.Descripcion AS EstatusAnterior,
	e.Descripcion aS Estatus
	FROM dbo.tCTLProductosFinancierosUsuarios pa  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = pa.IdEstatusActual
			and ea.IdEstatusActual<>0
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
		ON pf.IdProductoFinanciero = pa.IdProductoFinanciero
	INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
		ON u.IdUsuario = pa.IdUsuario
	INNER JOIN dbo.tCTLbitacoraEstatus be  WITH(NOLOCK) 
		ON be.IdEstatusActual = ea.IdEstatusActual 
			AND CAST(be.FechaHora AS DATE) BETWEEN @Inicio AND @Fin
	INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
		ON e.IdEstatus = be.IdEstatus
	INNER JOIN dbo.tCTLestatus eant  WITH(NOLOCK) 
		ON eant.IdEstatus = be.IdEstatusAnterior
	INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) 
		ON ss.IdSesion = be.IdSesion
			AND ss.IdSesion<>0
	INNER JOIN dbo.tCTLusuarios usuarioCambio  WITH(NOLOCK) 
		ON usuarioCambio.IdUsuario = ss.IdUsuario

END
GO



