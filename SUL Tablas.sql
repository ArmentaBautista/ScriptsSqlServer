



/* declare variables */
DECLARE @tabla AS NVARCHAR(100)
DECLARE @counter AS INT=1

DECLARE tablas CURSOR FAST_FORWARD READ_ONLY FOR SELECT name FROM sys.tables 
OPEN tablas FETCH NEXT FROM tablas INTO @tabla
WHILE @@FETCH_STATUS = 0
BEGIN
    
	DECLARE @sql AS NVARCHAR(500)='insert into ix.ConteoRegistrosTablas (Tabla,Registros,SqlSelect)
									select ''' + @tabla + ''' as Tabla, count(1) as NoRegistros 
									,''select * from ' + @tabla + '''
									from ' + @tabla
	EXEC sys.sp_executesql @sql
	PRINT @counter
	SET @counter+=1

    FETCH NEXT FROM tablas INTO @tabla
END

CLOSE tablas
DEALLOCATE tablas




