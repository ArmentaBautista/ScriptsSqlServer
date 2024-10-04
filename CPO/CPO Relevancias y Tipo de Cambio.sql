



SELECT t.Codigo AS TipoOperacion, op.Folio, op.Fecha, FORMAT(op.Total, 'C', 'es-MX') AS Total 
, mp.Descripcion AS MetodoPago, FORMAT(td.Monto, 'C', 'es-MX') AS Monto , td.IdTipoSubOperacion, td.EsCambio
, tf.IdCuenta
, sc.Codigo AS NoSocio
, c.Codigo AS NoCuenta, c.Descripcion AS Producto
,  tf.IdTipoSubOperacion, FORMAT(tf.MontoSubOperacion,'C','es-MX') AS MontoTF
, FORMAT(tc.FactorCompraDestino,'C','es-MX') AS TipoDeCambio
, FORMAT(tf.MontoSubOperacion/tc.FactorCompraDestino,'C','es-MX') AS Dolares
, td.EsCambio
FROM dbo.tGRLoperaciones op  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion t  WITH(NOLOCK) ON t.IdTipoOperacion = op.IdTipoOperacion
INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON td.IdOperacion = op.IdOperacion --AND td.EsCambio=0
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = op.IdOperacion
LEFT JOIN (
			SELECT d.Descripcion, tc.FactorCompraDestino ,tc.Alta,tc.Fecha,  DATEADD(DAY,1,tc.Fecha) AS FechaPLD
			FROM dbo.tDIVfactoresTipoCambio tc  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLdivisas d  WITH(NOLOCK) ON d.IdDivisa = tc.IdDivisaOrigen
			WHERE tc.IdDivisaOrigen=-4 AND  tc.Fecha BETWEEN '20221231' AND '20230401'
			) tc  ON tc.FechaPLD = tf.Fecha
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
WHERE op.Folio IN (2252206)
ORDER BY op.Fecha ASC, op.Folio

