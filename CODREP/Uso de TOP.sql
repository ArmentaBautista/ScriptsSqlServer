

USE intelixDEV
go

/* JCA USO DE WITH TIES PARA INCLUIR DUPLICADOS EN EL TOP*/
select top 65 with ties
codigo, saldocapital 
from tayccuentas c 
where c.saldocapital>0
	and c.idestatus=1
		and c.idtipodproducto=144
order by c.saldocapital asc


select top 24 percent
codigo, saldocapital 
from tayccuentas c 
where c.saldocapital>0
	and c.idestatus=1
		and c.idtipodproducto=144
order by c.saldocapital asc


select top 24 percent with ties
codigo, saldocapital 
from tayccuentas c 
where c.saldocapital>0
	and c.idestatus=1
		and c.idtipodproducto=144
order by c.saldocapital asc


