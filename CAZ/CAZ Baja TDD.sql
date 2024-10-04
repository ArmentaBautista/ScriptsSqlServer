


select * 
-- begin tran update t set t.IdEstatus=2   
from dbo.tSCStarjetas t  WITH(NOLOCK) where t.NumeroTDD in ('5064580010000936','5064580010008863')



-- commit

