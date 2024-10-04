
USE ierp_cpa

SELECT sc.IdEstatus, sc.EsSocioValido, p.Nombre, sc.IdSucursal, *
-- UPDATE sc SET sc.IdEstatus=1
-- UPDATE sc SET sc.EsSocioValido=0
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE sc.Codigo='12115000165'

-- 12115000165

-- COMMIT

