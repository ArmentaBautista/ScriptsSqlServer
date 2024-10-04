

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAUDmovimientosPorProductoFecha')
BEGIN
	DROP PROC pAUDmovimientosPorProductoFecha
	SELECT 'pAUDmovimientosPorProductoFecha BORRADO' AS info
END
GO

CREATE PROC pAUDmovimientosPorProductoFecha
@p_fechaInicial AS DATE,
@p_fechaFinal AS DATE,
@p_producto AS VARCHAR(32)
AS
BEGIN

DECLARE @fechaInicial AS DATE = @p_fechaInicial
DECLARE @fechaFinal AS DATE = @p_fechaFinal
DECLARE @producto AS VARCHAR(32)=@p_producto

SELECT 
c.Codigo AS NoCuenta, pf.Codigo AS CodigoProfucto, pf.Descripcion AS Producto, tope.Codigo as TipoOperacion, op.Folio, op.Fecha 
, IIF(tf.IdTipoSubOperacion=500,'DEPOSITO','RETIRO') AS TipoMovimiento , tf.MontoSubOperacion
, mp.Descripcion AS MetodoPago, td.Monto, u.Usuario
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
--AND pf.IdProductoFinanciero = 3012
AND pf.Codigo=@producto
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta = c.IdCuenta
AND tf.IdEstatus=1
AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal
INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion = tf.IdOperacion
AND op.IdEstatus=1
INNER JOIN dbo.tCTLtiposOperacion tope  WITH(NOLOCK) ON tope.IdTipoOperacion = op.IdTipoOperacion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = op.IdUsuarioAlta
INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON td.IdOperacion = op.IdOperacion
AND td.EsCambio=0
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = td.IdEstatusActual 
AND ea.IdEstatus=1
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago

END
GO

