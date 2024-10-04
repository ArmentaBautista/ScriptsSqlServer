
USE [1G_BURGOS_CYR]
GO

/* declare variables */
DECLARE @variable VARCHAR(max)

DECLARE iden CURSOR FAST_FORWARD READ_ONLY FOR SELECT sys.tables.name FROM sys.tables INNER JOIN sys.schemas ON schemas.schema_id = tables.schema_id AND schemas.name = 'dbo'

OPEN iden

FETCH NEXT FROM iden INTO @variable

WHILE @@FETCH_STATUS = 0
BEGIN
    
	PRINT	'EXEC dbo.sp_GeneraidentityTabla @nom_tbl =''' + @variable + ''''
	
    FETCH NEXT FROM iden INTO @variable
END

CLOSE iden
DEALLOCATE iden


