


IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCmovimientosPorSocio')
BEGIN
	DROP PROC pCnAYCmovimientosPorSocio
END
GO

CREATE PROC pCnAYCmovimientosPorSocio
@NoSocio AS VARCHAR(30)='',
@FechaInicial AS DATE='',
@FechaFinal AS DATE=''
AS




IF @NoSocio IS NULL OR @NoSocio=''
BEGIN
	SELECT 'Socio no encontrado'
	RETURN
END

IF @FechaInicial='19000101' OR @FechaFinal='19000101'
BEGIN
	SELECT 'Fecha no valida'
	RETURN
END

DECLARE @IdSocio AS INT=0;

SELECT @IdSocio= sc.IdSocio FROM dbo.tSCSsocios sc  WITH(nolock) WHERE sc.Codigo=@NoSocio

IF @IdSocio=0
BEGIN
	SELECT 'Socio no encontrado'
	RETURN
END


SELECT NoSocio=sc.Codigo,
		Nombre=p.Nombre,
		SucursalCuenta=sucCta.Codigo,
		NoCuenta=c.Codigo,
		CodigoProducto=pf.Codigo,
		Producto=pf.Descripcion,
		SucursalOperacion=sucOp.Codigo,
		TipoOperacion= tope.Codigo,
		Folio=oper.Folio,
		TipoMovimiento= CASE tf.IdTipoSubOperacion
						WHEN 500 THEN 'Depósito'
						WHEN 501 THEN 'Retiro'
						END,
		Monto=tf.MontoSubOperacion,
		Fecha=tf.Fecha,
		usuario=usr.Usuario,
		tf.Concepto, tf.Referencia
FROM dbo.tAYCcuentas c  WITH(nolock) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(nolock) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tCTLsucursales sucCta  WITH(nolock) ON sucCta.IdSucursal = c.IdSucursal
INNER JOIN dbo.tSCSsocios sc  WITH(nolock) ON sc.IdSocio = c.IdSocio
											AND sc.IdSocio=@IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(nolock) ON tf.IdCuenta = c.IdCuenta
															AND tf.Fecha BETWEEN @FechaInicial AND @FechaFinal
															AND tf.IdEstatus=1
LEFT JOIN dbo.tGRLoperaciones oper  WITH(nolock) ON oper.IdOperacion = tf.IdOperacion
															AND oper.IdTipoOperacion NOT IN (4,503,515)
INNER JOIN dbo.tCTLtiposOperacion tope  WITH(nolock) ON tope.IdTipoOperacion = oper.IdTipoOperacion
LEFT JOIN dbo.tCTLusuarios usr  WITH(nolock) ON usr.IdUsuario = oper.IdUsuarioAlta
LEFT JOIN dbo.tCTLsucursales sucOp  WITH(nolock) ON sucOp.IdSucursal = oper.IdSucursal
ORDER BY tf.Fecha


