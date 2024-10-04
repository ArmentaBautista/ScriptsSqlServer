


declare @emails as table(
	IdEmail		int,
	IdRel		int,
	Email		varchar(64)
)

insert into @emails
select e.IdEmail, e.IdRel, e.email
from dbo.tCATemails e  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	on ea.IdEstatusActual = e.IdEstatusActual
		and ea.IdEstatus=1
where e.IdRel<>0

declare @emailsDup as table(
	Email		varchar(64)
)

insert into @emailsDup
SELECT 
e.email
from @emails e 
GROUP BY e.email
HAVING COUNT(1)>1

SELECT 
e.Email
,s.Descripcion AS Sucursal
,sc.Codigo AS Nosocio, p.Nombre, p.Domicilio
,e.IdEmail,e.IdRel 
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN @emails e  
	ON e.IdRel=p.IdRelEmails
INNER JOIN @emailsDup d 
	ON d.Email = e.Email
LEFT JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.IdPersona = p.IdPersona
LEFT JOIN dbo.tCTLsucursales s  WITH(NOLOCK) 
	ON s.IdSucursal = sc.IdSucursal
ORDER BY e.Email
