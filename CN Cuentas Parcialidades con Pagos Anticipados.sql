

select 
tf.Fecha
,[NoSocio] = sc.Codigo 
,p.Nombre
,[NoCuenta] = c.Codigo
,[Producto] = c.Descripcion
,pc.NumeroParcialidad
,pc.TotalAnticipado
from dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa  with(nolock) 
inner join dbo.tSDOtransaccionesFinancieras tf  with(nolock) 
	on tf.IdTransaccion = aa.IdTransacccionFinanciera
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	on c.IdCuenta = aa.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	on p.IdPersona = sc.IdPersona
INNER JOIN (
		Select 
		 temp.IdCuenta
		,temp.IdApertura
		,temp.IdParcialidad
		,temp.NumeroParcialidad
		, [TotalAnticipado] = Sum(temp.CapitalPagado - temp.Capital) 
		From dbo.tAYCparcialidades temp With(NoLock) 
		Inner Join dbo.tAYCcuentas cu With(NoLock) 
			on cu.IdCuenta = temp.IdCuenta 
				and cu.IdApertura = temp.IdApertura
		INNER JOIN dbo.tSDOtransaccionFinancieraPagoAdelantadoAnticipado aa  WITH(NOLOCK) 
			on aa.IdCuenta = cu.IdCuenta
		where temp.CapitalPagado > temp.Capital 
			And temp.IdEstatus = 1 
				and temp.EstaPagada=1
		Group By temp.IdCuenta, temp.IdApertura, temp.IdParcialidad, temp.NumeroParcialidad
) pc on pc.IdCuenta = c.IdCuenta
order by tf.Fecha, c.IdCuenta, pc.IdParcialidad


