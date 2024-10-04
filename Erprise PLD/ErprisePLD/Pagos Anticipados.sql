


select 
tf.Fecha
,sc.IdSocio
,[NoSocio] = sc.Codigo 
,p.Nombre
,[NoCuenta] = c.Codigo
,[Producto] = c.Descripcion
,pc.NumeroParcialidad
,pc.TotalAnticipado
FROM dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa  WITH(NOLOCK) 
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
	ON tf.IdTransaccion = aa.IdTransacccionFinanciera
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = aa.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
		AND p.Nombre LIKE '%SILVIO BARCENA LEAL%'
INNER JOIN (
		SELECT 
		 temp.IdCuenta
		,temp.IdApertura
		,temp.IdParcialidad
		,temp.NumeroParcialidad
		, [TotalAnticipado] = SUM(temp.CapitalPagado - temp.Capital) 
		FROM dbo.tAYCparcialidades temp WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas cu WITH(NOLOCK) 
			ON cu.IdCuenta = temp.IdCuenta 
				AND cu.IdApertura = temp.IdApertura
		INNER JOIN dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa  WITH(NOLOCK) 
			on aa.IdCuenta = cu.IdCuenta
		where temp.CapitalPagado > temp.Capital 
			And temp.IdEstatus = 1 
				and temp.EstaPagada=1
		Group By temp.IdCuenta, temp.IdApertura, temp.IdParcialidad, temp.NumeroParcialidad
) pc on pc.IdCuenta = c.IdCuenta
order by tf.Fecha, c.IdCuenta, pc.IdParcialidad



SELECT aa.id,aa.IdOperacion,aa.EsPagoAdelantado,aa.EsPagoAnticipado,aa.IdTipoDpagoAnticipado,aa.IdTransacccionFinanciera,aa.IdCuenta 
	FROM dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
		ON c.IdCuenta = aa.IdCuenta
	WHERE C.IdSocio= 178867






