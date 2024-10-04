
USE iERP_DRA
go

DECLARE @idEmpresa int = 7
declare @periodo varchar (7) = '2021-03'


select @IdEmpresa as IdEmpresa, Periodo = replace(Per.Codigo,'-',''),hd.*
from 
	tSDOhistorialDeudoras	hd JOIN
	tCTLperiodos			per on per.IdPeriodo = hd.IdPeriodo
where per.codigo = @periodo


