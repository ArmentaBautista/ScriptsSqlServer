




SELECT OBJECT_NAME(c.object_id) , c.name 
FROM sys.columns c 
INNER JOIN sys.tables t ON t.object_id = c.object_id
WHERE c.name='%crede%'

