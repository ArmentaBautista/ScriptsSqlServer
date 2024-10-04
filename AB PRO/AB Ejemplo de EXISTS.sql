
USE [1G_AEMSA]
GO

SET STATISTICS TIME, IO ON
GO

SELECT p.id_pro, p.clave,p.codigo,p.des
FROM dbo.cat_pro p  WITH(NOLOCK) 
WHERE p.status=1
	AND p.id_pro NOT IN (
					SELECT f.id_pro 
					FROM dbo.vta_fac_det f  WITH(NOLOCK) 
					WHERE f.id_pro>0
					)
GO



SELECT p.id_pro, p.clave,p.codigo,p.des
FROM dbo.cat_pro p  WITH(NOLOCK) 
WHERE p.status=1
	AND NOT EXISTS(
					SELECT 1 
					FROM dbo.vta_fac_det f  WITH(NOLOCK) 
					WHERE f.id_pro=p.id_pro
					)
GO

SET STATISTICS TIME, IO OFF
GO