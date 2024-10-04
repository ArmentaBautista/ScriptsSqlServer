

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
SELECT 
sc.IdSocio, sc.Codigo, p.IdPersona, p.Nombre, c.IdCuenta, c.Codigo, c.Descripcion
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	on c.IdSocio = sc.IdSocio		
where sc.IdSocio=28848

select * from @cuentas

declare @financieras as table(
	IdTransaccion	int,
	IdOperacion	int,
	Fecha	date,
	IdTipoSubOperacion	int,
	MontoSubOperacion	numeric(15,2)
)

insert into @financieras
select tf.IdTransaccion,tf.IdOperacion, tf.Fecha,tf.IdTipoSubOperacion,tf.MontoSubOperacion
from dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
INNER JOIN @cuentas c 
	on c.IdCuenta = tf.IdCuenta
where tf.IdEstatus=1
	and tf.IdTipoSubOperacion=501
		and tf.Fecha between @fechaInicial and @fechaActual

declare @td as table(
	IdOperacion	int,
	Idtransaccion	int,
	Fecha	date,
	Monto	numeric(15,2)
)

insert into @td
select op.IdOperacion, td.IdTransaccionD , ff.Fecha, td.Monto
from dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	on ea.IdEstatusActual = td.IdEstatusActual
		and ea.IdEstatus=1
INNER join (
	select f.IdOperacion
	from @financieras f
	group by f.IdOperacion
) op
	on op.IdOperacion = td.IdOperacion
INNER JOIN @financieras ff 
	on ff.IdOperacion = td.IdOperacion
where td.IdMetodoPago=-2 
	and td.EsCambio=0

select * from @td
order by Fecha		


