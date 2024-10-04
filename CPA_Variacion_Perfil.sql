
SELECT sc.Codigo, p.Nombre,c.IdCuenta, c.Codigo, c.Descripcion, tf.Fecha, tf.MontoSubOperacion
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio AND c.IdEstatus=1 AND c.IdTipoDProducto=143
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta = c.IdCuenta and MontoSubOperacion!=0 --AND tf.IdTipoSubOperacion=500
WHERE p.Nombre LIKE '%carlos armenta b%'

DECLARE @desv AS DECIMAL
DECLARE @prom AS DECIMAL

SELECT --sc.Codigo, p.Nombre,c.IdCuenta, c.Codigo, c.Descripcion, 
--tf.MontoSubOperacion,
--@desv= 
STDEV(tf.MontoSubOperacion)
--@prom=
,AVG(tf.MontoSubOperacion)
,STDEV(tf.MontoSubOperacion)/AVG(tf.MontoSubOperacion)
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio AND c.IdEstatus=1 AND c.IdTipoDProducto=143
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdCuenta = c.IdCuenta  and MontoSubOperacion!=0 --AND tf.IdTipoSubOperacion=500
WHERE p.Nombre LIKE '%carlos armenta b%'
-- GROUP BY sc.Codigo, p.Nombre,c.IdCuenta, c.Codigo, c.Descripcion, tf.MontoSubOperacion
--GROUP BY  tf.MontoSubOperacion

SELECT @desv, @prom, @desv/@prom