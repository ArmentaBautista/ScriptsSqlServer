
USE iERP_FNG
GO



SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, p.IdPersona, p.Nombre, sc.Alta, sc.FechaAlta, tf.FechaAP, tf.NoCuenta
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
LEFT JOIN (
		SELECT  c.IdSocio,c.Codigo AS NoCuenta, tf.Fecha as FechaAP
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
			ON c.IdCuenta = tf.IdCuenta
				AND c.IdProductoFinanciero=1
		WHERE tf.IdTipoSubOperacion=500
			AND tf.IdEstatus=1
) tf ON tf.IdSocio = sc.IdSocio
WHERE sc.FechaAlta='19000101' 
AND sc.IdSocio<>0
ORDER BY sc.Alta




