

SELECT c.idcuenta, TfErp.UltMov
FROM dbo.tAYCcuentas c  WITH(nolock) 
LEFT JOIN (
			SELECT tf.IdCuenta, MAX(tf.Fecha) AS UltMov FROM dbo.tSDOtransaccionesFinancieras tf WITH(NOLOCK)
			INNER join tGRLoperaciones op with(nolock) on op.IdOperacion=tf.IdOperacion and op.IdTipoOperacion in (1,10)
			WHERE tf.IdTipoSubOperacion IN (500,501)
			GROUP BY tf.IdCuenta
			) AS TfErp ON TfErp.IdCuenta = c.IdCuenta
WHERE c.IdEstatus IN(1,56) AND c.IdTipoDProducto IN(144,398,1570,2196)


