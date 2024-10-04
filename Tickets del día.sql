
SELECT COUNT(1) AS NumOperaciones
FROM dbo.tGRLoperaciones op  WITH(nolock) 
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(nolock)  ON tf.IdOperacion = op.IdOperacion
INNER JOIN dbo.tSDOsaldos sdo  WITH(nolock) ON sdo.IdSaldo = tf.IdSaldoDestino
INNER JOIN dbo.tAYCcuentas cta  WITH(nolock) ON cta.IdCuenta = sdo.IdCuenta
WHERE op.IdTipoOperacion=1 AND op.Fecha='20210314'


SELECT cta.IdTipoDProducto, pf.Descripcion,COUNT(1) AS NumOperaciones
FROM dbo.tGRLoperaciones op  WITH(nolock) 
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(nolock)  ON tf.IdOperacion = op.IdOperacion
INNER JOIN dbo.tSDOsaldos sdo  WITH(nolock) ON sdo.IdSaldo = tf.IdSaldoDestino
INNER JOIN dbo.tAYCcuentas cta  WITH(nolock) ON cta.IdCuenta = sdo.IdCuenta
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(nolock) ON pf.IdProductoFinanciero = cta.IdProductoFinanciero
WHERE op.IdTipoOperacion=1 AND op.Fecha='20210314'
GROUP BY cta.IdTipoDProducto, pf.Descripcion
ORDER BY NumOperaciones desc