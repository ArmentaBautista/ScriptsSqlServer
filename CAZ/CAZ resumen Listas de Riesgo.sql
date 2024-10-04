
use iERP_KFT
go


select 
DATEPART(YEAR, lb.Alta) AS Año, DATEPART(MONTH, lb.Alta) AS Mes, DATEPART(DAY, lb.Alta) AS Dia
,t.Descripcion AS Tipo1, tl.Descripcion AS Tipo2, COUNT(1) AS Num
from tPLDlistasBloqueadas lb with(nolock)
INNER JOIN dbo.tCTLtiposD t  WITH(NOLOCK) ON t.IdTipoD = lb.IdTipoDlistaBloqueada
INNER JOIN dbo.tCTLtiposD tl  WITH(NOLOCK) ON tl.IdTipoD = lb.IdTipoDListaPLD
GROUP BY DATEPART(YEAR, lb.Alta), DATEPART(MONTH, lb.Alta), DATEPART(DAY, lb.Alta), t.Descripcion, tl.Descripcion
ORDER BY Año DESC, Mes DESC, Dia DESC

/*

select 
lb.Alta,t.Descripcion AS Tipo1, tl.Descripcion AS Tipo2, lb.*
from tPLDlistasBloqueadas lb with(nolock)
INNER JOIN dbo.tCTLtiposD t  WITH(NOLOCK) ON t.IdTipoD = lb.IdTipoDlistaBloqueada
INNER JOIN dbo.tCTLtiposD tl  WITH(NOLOCK) ON tl.IdTipoD = lb.IdTipoDListaPLD
--WHERE CAST(lb.Alta AS DATE) BETWEEN '20230201' AND '20230210'
WHERE lb.Paterno LIKE '%sandov%' and lb.Materno LIKE '%castañe%' AND lb.Nombre LIKE '%rob%'
ORDER BY lb.Alta

*/