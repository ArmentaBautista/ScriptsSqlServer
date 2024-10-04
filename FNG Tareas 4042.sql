



SELECT 
[NoSocio]					= sc.Codigo,
[Nombre]					= p.Nombre,
sc.CalificacionNivelRiesgo,
sc.DescripcionNivelRiesgo,
[EsPEP]						= IIF(pep.Id IS NULL,0,1)
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
LEFT JOIN dbo.tPLDppe pep  WITH(NOLOCK) 
	ON pep.IdPersona = p.IdPersona
		AND pep.IdSocio=sc.IdSocio
WHERE sc.IdEstatus=1 
AND sc.EsSocioValido=1


