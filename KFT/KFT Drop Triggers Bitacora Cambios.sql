



SELECT 'DROP TRIGGER ' + t.name + ' 
GO'
FROM sys.triggers t  WITH(NOLOCK) 
WHERE t.name like '%BitacoraCambios%'
GO


SELECT t.name AS Bitacora, OBJECT_NAME(t.parent_id) AS Tabla
FROM sys.triggers t  WITH(NOLOCK) 
WHERE t.name like '%BitacoraCambios%'
GO

SELECT * FROM dbo.vOBJECTS o  WITH(NOLOCK) WHERE o.DEFINITION LIKE '%BitacoraCambios%'

