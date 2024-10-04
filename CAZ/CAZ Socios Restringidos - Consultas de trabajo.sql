
USE iERP_CAZ
GO


SELECT r.*, socio.codigo, p.Nombre
FROM dbo.tAYCsociosRestringidos r
INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = r.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON	p.IdPersona = socio.IdPersona
--WHERE r.IdEstatus=1
--WHERE socio.Codigo=''
ORDER BY Id DESC	


 -- UPDATE sr SET sr.IdEstatus=1 FROM dbo.tAYCsociosRestringidos sr WHERE id=720140

