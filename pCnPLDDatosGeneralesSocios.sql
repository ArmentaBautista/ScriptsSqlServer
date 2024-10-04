

-- Socios con aportación parcial


select *
from tCNTdivisiones
where Descripcion like '%parcial%'

/*
-21 aportación completar
-24 aportación parcial
*/

-- Socios con Aportación Parcial
select IdSocio
from tAYCcuentas c with(nolock)
where IdDivision=-24
  and IdEstatus=1

-- Socios
select IdSocio
from tSCSsocios sc with(nolock)
where IdEstatus=1
    and EsSocioValido=1

select IdSocio
from tSCSsocios sc with(nolock)
where IdEstatus=1
    and EsSocioValido=1


select
p.IdPersona

from tSCSsocios sc with(nolock)
inner join tGRLpersonas p with(nolock)
    on sc.IdPersona = p.IdPersona
left join tGRLpersonasFisicas pf with(nolock)
    on p.IdPersona = pf.IdPersona
left join tGRLpersonasMorales pm with(nolock)
    on p.IdPersona = pm.IdPersona




select * from sys.objects where name like '_AIR%' OR name like 'pCnAIR%'




-- tAIRclasificacionRiesgoCategoria
-- tAIRclasificacionRiesgoTipo
-- tAIRclasificacionRiesgoSubtipo
-- tAIRreporteMensualE
-- tAIRreporteMensualD
-- pAIRriesgoOperativoF3
-- pAIRreporteMensualE
-- pAIRreporteMensualDinsert
-- pAIRreporteMensualDlist
-- pAIRreporteMensualDupdate
-- pAIRriesgoOperativo
-- pCnAIRdesagregadoEventosRiesgoOperativo
-- pCnAIReventosPorFecha
