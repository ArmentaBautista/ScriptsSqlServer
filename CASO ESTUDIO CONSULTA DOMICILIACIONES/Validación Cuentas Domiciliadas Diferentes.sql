

DECLARE @cuentasDomiciliadas AS	TABLE(
	IdDomiciliacion	int,
	Fecha			date,
	IdCuenta		int,
	EsCredito		bit,
	EsAhorro		bit,
	IdSocio			int,
	NoSocio			varchar(24),
	Socio			varchar(64),
	NoCuenta		varchar(24),
	Producto		varchar(80)
)

-- Cuentas domiciliación Credito
INSERT INTO @cuentasDomiciliadas (IdDomiciliacion,Fecha,IdCuenta,EsCredito,EsAhorro)
SELECT 
d.IdDomiciliacion,
d.Fecha,
d.IdCuentaCredito, 
1,
0
FROM dbo.tAYCdomiciliaciones d  WITH(NOLOCK)
WHERE d.IdEstatus=1
	and d.IdCuentaCredito>0

-- Cuentas domiciliación ahorro
INSERT INTO @cuentasDomiciliadas (IdDomiciliacion,Fecha,IdCuenta,EsCredito,EsAhorro)
SELECT 
d.IdDomiciliacion,
d.Fecha,
d.IdCuentaRetiro, 
0,
1
FROM dbo.tAYCdomiciliaciones d  WITH(NOLOCK)
WHERE d.IdEstatus=1
	and d.IdCuentaRetiro>0

-- complemento de cuentas
update cd set cd.IdSocio=c.IdSocio, cd.NoCuenta=c.Codigo, cd.Producto=c.Descripcion, cd.NoSocio=sc.Codigo, cd.Socio=p.Nombre
from @cuentasDomiciliadas cd
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK)
	on c.IdCuenta = cd.IdCuenta
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	on p.IdPersona = sc.IdPersona


select 
c.Fecha,
c.IdDomiciliacion
,c.EsCredito, c.IdSocio, c.NoSocio, c.Socio, c.NoCuenta, c.Producto 
,a.EsAhorro, a.IdSocio, a.NoSocio, a.Socio, a.NoCuenta, a.Producto
from @cuentasDomiciliadas c
INNER JOIN @cuentasDomiciliadas a
	on a.EsAhorro=1
	AND a.IdDomiciliacion = c.IdDomiciliacion
	and a.IdSocio<>c.IdSocio
where c.EsCredito=1
--order by a.Fecha

