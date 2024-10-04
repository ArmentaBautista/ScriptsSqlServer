


update ld set ld.codigo='AHO', ld.descripcion='AHORRO' from tCATlistasD ld where ld.idlistad=-36
update ld set ld.codigo='INV', ld.descripcion='INVERSIÓN' from tCATlistasD ld where ld.idlistad=-37
GO


select ea.IdEstatus, ld.*
from tCATlistasD ld WITH (NOLOCK)
inner JOIN tCTLestatusActual ea WITH (NOLOCK)
    on ld.IdEstatusActual = ea.IdEstatusActual
where IdTipoE=180


select ea.IdEstatus, ld.*
-- begin TRAN UPDATE ea set ea.IdEstatus=1
from tCATlistasD ld WITH (NOLOCK)
inner JOIN tCTLestatusActual ea WITH (NOLOCK)
    on ld.IdEstatusActual = ea.IdEstatusActual
where ld.IdTipoE=180
    AND  ld.IdListaD in (-40,-39,-38,-37,-36,-1408,-1409 );

-- COMMIT

select ea.IdEstatus, ld.*
-- begin TRAN UPDATE ea set ea.IdEstatus=2
from tCATlistasD ld WITH (NOLOCK)
inner JOIN tCTLestatusActual ea WITH (NOLOCK)
    on ld.IdEstatusActual = ea.IdEstatusActual
where ld.IdTipoE=180
    AND  ld.IdListaD NOT in (-40,-39,-38,-37,-36,-1408,-1409 );

-- COMMIT