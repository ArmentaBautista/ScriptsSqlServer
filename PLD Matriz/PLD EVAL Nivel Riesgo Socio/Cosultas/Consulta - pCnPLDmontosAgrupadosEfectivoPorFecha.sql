



/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- CONSULTA AGRUPADA
/*

DECLARE @fechaInicial DATE = '20230101'
DECLARE @fechaFinal DATE = '20230401'
DECLARE @montoAcumulado NUMERIC(18,2)=300000


SELECT 
 tf.NoSocio		
,tf.Nombre
,Acumulado		= FORMAT(SUM(td.Monto),'C','es-mx')
,Acumulado		= FORMAT(SUM(td.Monto),'N2','es-MX')
FROM dbo.tGRLoperaciones op  WITH(NOLOCK) 
INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON op.IdOperacion = td.IdOperacion
AND op.IdEstatus= 1
AND td.IdMetodoPago IN (-2,-10)
AND td.EsCambio=0
--and td.IdTipoSubOperacion=500
INNER JOIN (
		SELECT tf.IdOperacion, sc.Codigo AS NoSocio, p.Nombre 
		FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		WHERE tf.IdEstatus=1
		AND tf.Fecha BETWEEN @fechaInicial and @fechaFinal
		AND tf.IdTipoSubOperacion=500
		GROUP BY tf.IdOperacion, sc.Codigo, p.Nombre 
) tf ON tf.IdOperacion = op.IdOperacion 
WHERE op.IdEstatus=1
GROUP BY tf.NoSocio, tf.Nombre, td.IdTransaccionD
HAVING SUM(td.Monto)>=@montoAcumulado

*/


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- CONSULTA DE COMPROBACIÓN
/*

DECLARE @fechaInicial DATE = '20230101'
DECLARE @fechaFinal DATE = '20230401'
DECLARE @montoAcumulado NUMERIC(18,2)=300000


SELECT 
 NoSocio		= sc.Codigo 
,p.Nombre
,TipoOperacion	= t.Codigo
,op.Folio
,tf.MontoSubOperacion
,td.Monto
,op.Total
FROM dbo.tGRLoperaciones op  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion t WITH(NOLOCK) ON t.IdTipoOperacion = op.IdTipoOperacion
INNER JOIN dbo.tSDOtransaccionesD td  WITH(NOLOCK) ON op.IdOperacion = td.IdOperacion
AND op.IdEstatus= 1
AND td.IdMetodoPago IN (-2,-10)
AND td.EsCambio=0
--and td.IdTipoSubOperacion=500
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = op.IdOperacion
AND tf.IdEstatus=1
AND tf.Fecha BETWEEN @fechaInicial and @fechaFinal
AND tf.IdTipoSubOperacion=500
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE op.IdEstatus=1
AND sc.Codigo='001-000498'

*/


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- PRUEBA SP

EXEC pCnPLDmontosAgrupadosEfectivoPorFecha '20230201','20230301',100000





