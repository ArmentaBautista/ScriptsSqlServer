

DECLARE @nombreBuscado AS VARCHAR(64)='10815-001002'

SELECT 
soc.IdSocio, soc.Codigo, soc.EsSocioValido, soc.FechaAlta, p.IdPersona, p.Nombre
  , pbqq.Alta
    , lre.*
FROM dbo.tSCSsocios soc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = soc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersonaFisica = p.IdPersonaFisica
--left JOIN dbo.tPLDbitacoraBusquedaListasRiesgo bblr WITH(NOLOCK) 
--	ON CONCAT(RTRIM(bblr.Nombre),' ',RTRIM(bblr.ApellidoPaterno),' ',RTRIM(bblr.ApellidoMaterno))=p.Nombre 
--		AND bblr.Fecha=CONVERT(DATE,IIF(soc.Alta<soc.UltimoCambio,soc.UltimoCambio,soc.Alta)) 
LEFT JOIN dbo.tPLDpeticionPersonaBloqueadaQQ pbqq WITH(NOLOCK) 
	ON CONCAT(RTRIM(pbqq.Nombre),' ',RTRIM(pbqq.ApellidoPaterno),' ',RTRIM(pbqq.ApelldioMaterno))=p.Nombre --AND p.RFC=pbqq.RFC
		AND CAST(pbqq.Alta AS DATE)=CONVERT(DATE,IIF(soc.Alta<soc.UltimoCambio,soc.UltimoCambio,soc.Alta)) 
LEFT JOIN (SELECT IdPeticionPersonaBloqueada, Nombre,Paterno,Materno,Apellidos, NombreCompleto
			FROM dbo.tPLDpersonaBloqueadaQQ WITH(NOLOCK) 
			GROUP BY IdPeticionPersonaBloqueada, Nombre,Paterno,Materno,Apellidos, NombreCompleto) lre 
	ON lre.IdPeticionPersonaBloqueada=pbqq.IdPeticionPersonaBloqueada
WHERE soc.Codigo LIKE '%' + @nombreBuscado + '%'



-- SELECT pb.IdPeticionPersonaBloqueada*-1, * 

DELETE FROM dbo.tPLDpersonaBloqueadaQQ WHERE IdPeticionPersonaBloqueada IN (94265
,94274
,94270)

