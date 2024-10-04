


declare @fechaActual as date=eomonth('20240215')
declare @fechaInicial as date = dateadd(month,-12,@fechaActual)

declare @cuentas as table(
	IdSocio int,
	NoSocio	varchar(128),
	IdPersona	int,
	Nombre	varchar(128),
	IdCuenta	int,
	NoCuenta	varchar(32),
	Producto	varchar(64)
)

insert into @cuentas
select 
sc.IdSocio, sc.Codigo, p.IdPersona, p.Nombre, c.IdCuenta, c.Codigo, c.Descripcion
from dbo.tSCSsocios sc  with(nolock) 
inner join dbo.tGRLpersonas p  with(nolock) on p.IdPersona = sc.IdPersona
inner join dbo.tAYCcuentas c  with(nolock) 
	on c.IdSocio = sc.IdSocio
where sc.IdSocio=28848

select * from @cuentas

declare @opsEfectivo as table(
	IdOperacion	int,
	IdTransaccionD int,
	Monto	numeric(15,2)
)

insert into @opsefectivo
select op.IdOperacion, td.IdTransaccionD, td.Monto 
from dbo.tSDOtransaccionesD td  with(nolock) 
inner join dbo.tCTLestatusActual ea  with(nolock) 
	on ea.IdEstatusActual = td.IdEstatusActual
		and ea.IdEstatus=1
inner join dbo.tGRLoperaciones op  with(nolock) 
	on op.IdOperacion = td.IdOperacion
		and op.Fecha between @fechaInicial and @fechaActual
			and ea.IdEstatus=1
where td.IdMetodoPago=-2 
	and td.EsCambio=0
		
select op.IdOperacion, tf.IdTransaccion, tf.MontoSubOperacion, c.Nombre, c.NoCuenta, tf.Fecha
from dbo.tSDOtransaccionesFinancieras tf  with(nolock) 
inner join (
	select o.IdOperacion
	from @opsEfectivo o
	group by o.IdOperacion
) op
	on op.IdOperacion = tf.IdOperacion
INNER JOIN @cuentas c
	on c.IdCuenta = tf.IdCuenta
where tf.IdEstatus=1
	and tf.IdTipoSubOperacion=501

