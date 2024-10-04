

SELECT c.IdCuenta, c.Codigo AS Cuenta, c.Descripcion AS Producto, c.DescripcionLarga AS Etiqueta, c.SaldoCapital, t.UltimoMovimiento
--INTO iERP_DRA_HST.dbo.CuentasDisponibilidadSaldoCeroDepuradas
-- begin tran UPDATE c SET c.IdEstatus=7
-- begin tran UPDATE sdo SET sdo.IdEstatus=7
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSDOsaldos sdo  WITH(NOLOCK) ON sdo.IdCuenta = c.IdCuenta
LEFT JOIN (
			SELECT tf.IdCuenta, MAX(tf.Fecha ) AS UltimoMovimiento
			FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
			INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta AND c.IdTipoDProducto=144 
			GROUP BY tf.IdCuenta
		   ) t ON t.IdCuenta=c.IdCuenta
WHERE c.IdCuenta IN ( SELECT idcuenta FROM iERP_DRA_HST.dbo.CuentasDisponibilidadSaldoCeroDepuradas  WITH(NOLOCK) )

GO



SELECT s.Codigo AS NoSocio, p.Nombre,
 ca.* 
FROM iERP_DRA_HST.dbo.CuentasDisponibilidadSaldoCeroDepuradas ca WITH(NOLOCK)
INNER JOIN  dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta=ca.idcuenta
INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdSocio=c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = s.IdPersona
ORDER BY ca.ultimomovimiento desc

