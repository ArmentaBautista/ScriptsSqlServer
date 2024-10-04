

-- Sub consulta como un campo
select 
p.Nombre, p.ApellidoPaterno, p.ApellidoMaterno
, DATEDIFF(YEAR,p.FechaNacimiento,GETDATE()) AS Edad
, (SELECT AVG(DATEDIFF(YEAR,p.FechaNacimiento,GETDATE())) FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK)) AS EdadPromedio
FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK) 

-- Alternativa
DECLARE @fechaHoy AS DATE=GETDATE()
DECLARE @promedio AS INT
SELECT @promedio= AVG(DATEDIFF(YEAR,p.FechaNacimiento,GETDATE())) FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK)

select 
p.Nombre, p.ApellidoPaterno, p.ApellidoMaterno, DATEDIFF(YEAR,p.FechaNacimiento,@fechaHoy) AS Edad, @promedio AS EdadPromedio
FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK) 

-- Sub consulta para cálculo de un campo
select 
p.Nombre, p.ApellidoPaterno, p.ApellidoMaterno
, DATEDIFF(YEAR,p.FechaNacimiento,GETDATE()) AS Edad
, (SELECT AVG(DATEDIFF(YEAR,p.FechaNacimiento,GETDATE())) FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK)) AS EdadPromedio
, (
	(SELECT AVG(DATEDIFF(YEAR,p.FechaNacimiento,GETDATE())) FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK)) 
	- 
	DATEDIFF(YEAR,p.FechaNacimiento,GETDATE())
	)AS Diferencia
FROM dbo.tGRLpersonasFisicas p  WITH(NOLOCK) 
GO

-- subconsulta Como lista de Valores
SELECT p.Domicilio 
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
WHERE p.IdPersona in (
						SELECT pf.IdPersona 
						FROM dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
						WHERE DATEDIFF(YEAR,pf.FechaNacimiento,GETDATE())<18
						-- 2342,45646,4564,232
						)

SELECT Domicilio 
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
WHERE p.IdPersona in (2342,45646,4564,232)
