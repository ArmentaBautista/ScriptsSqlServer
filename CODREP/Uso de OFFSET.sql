

select
codigo, saldocapital 
from tayccuentas c 
where c.saldocapital>0
	and c.idestatus=1
		and c.idtipodproducto=144
order by c.saldocapital asc


select 
codigo, saldocapital 
from tayccuentas c 
where c.saldocapital>0
	and c.idestatus=1
		and c.idtipodproducto=144
order by c.saldocapital asc 
offset 5 rows

select 
codigo, saldocapital 
from tayccuentas c 
where c.saldocapital>0
	and c.idestatus=1
		and c.idtipodproducto=144
order by c.saldocapital asc 
offset 5 rows 
fetch next 5 rows only


