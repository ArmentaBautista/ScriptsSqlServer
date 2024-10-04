



SELECT 'Disabled trigger ' + t.name + ' on ' + OBJECT_NAME(t.parent_id) + ' 
GO;'
FROM sys.triggers t  WITH(NOLOCK) 
WHERE t.name like '%bitacora%'
AND t.is_disabled=0



