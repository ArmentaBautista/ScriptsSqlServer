



SELECT 
sc.Codigo AS NoSocio,
p.Nombre,
t.Telefono
FROM dbo.ifGRLpersonasSociosTelefonosCelulares() t
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON t.IdRelTelefonos=p.IdRelTelefonos
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdPersona = p.IdPersona
INNER JOIN (
	SELECT 
	telefono
	FROM dbo.ifGRLpersonasSociosTelefonosCelulares() repetidos
	GROUP BY repetidos.Telefono
	HAVING COUNT(1)>2
	) telrep ON telrep.Telefono = t.Telefono
ORDER BY t.Telefono

