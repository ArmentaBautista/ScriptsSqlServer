
SELECT p.Nombre, COUNT(1)
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN (
			SELECT --p.IdPersona, sc.Codigo, sc.EsSocioValido, p.Nombre, sc.FechaAlta, p.IdEstatus, p.Alta
			p.Nombre
			FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
				ON p.IdPersona = sc.IdPersona
			WHERE CAST(p.Alta AS DATE)<'20200430'
			GROUP BY p.Nombre
) t ON p.Nombre=t.Nombre
WHERE CAST(p.Alta AS DATE)>='20200430'
GROUP BY p.Nombre
HAVING COUNT(1)>2
ORDER BY p.Nombre
GO

SELECT p.IdPersona, p.Nombre, CAST(p.Alta AS DATE)
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN (
			SELECT --p.IdPersona, sc.Codigo, sc.EsSocioValido, p.Nombre, sc.FechaAlta, p.IdEstatus, p.Alta
			p.Nombre
			FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
				ON p.IdPersona = sc.IdPersona
			WHERE CAST(p.Alta AS DATE)<'20200430'
			GROUP BY p.Nombre
) t ON p.Nombre=t.Nombre
WHERE p.Nombre LIKE '%jaime bravo%'
GROUP BY p.IdPersona, p.Nombre,CAST(p.Alta AS DATE)
ORDER BY p.Nombre
GO

SELECT p.Alta, * FROM dbo.tGRLpersonas p WHERE p.Nombre like '%guadalupe erika fu%'

DECLARE @nombreBuscado AS VARCHAR(64)='guadalupe erika fu'

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, p.Alta, p.IdPersona, p.Nombre, sc.IdSesion
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE p.Nombre LIKE '%' + @nombreBuscado + '%'

