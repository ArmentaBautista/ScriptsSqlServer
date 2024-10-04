USE iERP_CPA
GO

SELECT 'DROP TRIGGER ' + t.name + ' 
GO'
FROM sys.triggers t  WITH(NOLOCK) 
WHERE t.name like '%Bitacora%'
GO


SELECT t.name AS Bitacora, OBJECT_NAME(t.parent_id) AS Tabla
FROM sys.triggers t  WITH(NOLOCK) 
WHERE t.name like '%bitacora%'
GO