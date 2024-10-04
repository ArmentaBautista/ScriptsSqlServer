

USE iERP_KFT_VLD


SELECT sc.Codigo AS NoSocio, h.ClaveSocio,  p.Nombre , COUNT(sc.IdSocio) NoHuellas
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tDIGhuellasImportadas h  WITH(NOLOCK) ON sc.Codigo COLLATE DATABASE_DEFAULT LIKE '%' + h.ClaveSocio + '%'
-- WHERE sc.Codigo LIKE '%1021001%'
GROUP BY sc.Codigo, h.ClaveSocio,  p.Nombre 


SELECT ClaveSocio, COUNT(IdHuellaDigital) HuellasCapturadas
FROM dbo.tDIGhuellasImportadas
GROUP BY ClaveSocio

