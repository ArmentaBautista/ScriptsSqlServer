
use iERP_DRA
GO

SELECT tdoc.IdTipoD, tdoc.Descripcion
FROM dbo.tDIGregistrosDocumentos regdoc  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD tdoc  WITH(NOLOCK) ON tdoc.IdTipoD = regdoc.IdTipoDdominio
GROUP BY tdoc.IdTipoD, tdoc.Descripcion 
GO

SELECT tdoc.IdTipoD, tdoc.Descripcion
FROM dbo.tDIGregistrosRequisitos regreq  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD tdoc  WITH(NOLOCK) ON tdoc.IdTipoD = regreq.IdTipoDdominio
GROUP BY tdoc.IdTipoD, tdoc.Descripcion 
GO





