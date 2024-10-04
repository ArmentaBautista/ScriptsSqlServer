
select 
count(1)
from tGRLpersonasfisicas p

select 
count(p.NumeroIMMS)
from tGRLpersonasfisicas p


select 
count(1)
from tGRLpersonasfisicas p
where p.NumeroIMMS is null

select 
count(NumeroIMMS)
from tGRLpersonasfisicas p
where p.NumeroIMMS is null

select 
count(p.NumeroIMMS)
from tGRLpersonasfisicas p
where not p.NumeroIMMS is null