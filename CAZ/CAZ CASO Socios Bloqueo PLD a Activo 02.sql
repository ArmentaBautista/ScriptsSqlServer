

DECLARE @nombreBuscado AS VARCHAR(64)='ana rosa santiago'

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre, sc.IdEstatus
-- BEGIN tran UPDATE sc SET sc.IdEstatus=1
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
--WHERE p.Nombre LIKE '%' + @nombreBuscado + '%'
WHERE sc.IdSocio=83295


-- COMMIT


-- rollback