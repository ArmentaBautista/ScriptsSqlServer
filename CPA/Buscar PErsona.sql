


USE ierp_cpa

SELECT sc.IdEstatus, sc.EsSocioValido, p.Nombre, *
-- UPDATE sc SET sc.IdEstatus=1
-- UPDATE sc SET sc.EsSocioValido=0
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE p.Nombre LIKE	'%santana nu%'

 


 SELECT p.IdEstatus, p.Nombre, *
-- UPDATE p SET p.IdEstatus=2
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
WHERE p.Nombre LIKE	'%HECTOR EDUARDO SANTANA NUÑEZ%'

 SELECT p.IdEstatus, p.Nombre, *
-- UPDATE p SET p.IdEstatus=2
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
WHERE p.IdPersona=97823