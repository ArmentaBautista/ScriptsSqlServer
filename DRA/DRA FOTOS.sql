
use iERP_DRA
GO

SELECT *
FROM dbo.tCTLconsultas c  WITH(NOLOCK) 
WHERE c.Descripcion LIKE '%foto%'


SELECT soc.Codigo AS NoSocio, CONCAT(pf.Nombre,' ', pf.ApellidoPaterno, ' ',pf.ApellidoMaterno ) AS Nombre
FROM dbo.tGRLpersonasFisicas pf WITH(NOLOCK)
INNER JOIN dbo.tSCSsocios soc WITH(NOLOCK) ON soc.IdPersona = pf.IdPersonaFisica AND soc.EsSocioValido=1
--WHERE pf.Fotografia IS NOT NULL
WHERE pf.Fotografia IS NULL
