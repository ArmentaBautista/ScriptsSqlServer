

USE [1G_AEMSA]
GO

/* declare variables */
DECLARE @tabla nVARCHAR(256)

DECLARE tablas CURSOR FAST_FORWARD READ_ONLY FOR SELECT name FROM sys.tables

OPEN tablas

FETCH NEXT FROM tablas INTO @tabla

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET NOCOUNT ON

	DECLARE @sql AS NVARCHAR(max)='
	if exists(
		SELECT vo.name 
		FROM vobjects vo
		INNER JOIN sys.triggers tr ON tr.object_id=vo.object_id	
		WHERE OBJECT_NAME(tr.parent_id)=''' + @tabla + ''' AND vo.DEFINITION LIKE ''%update ' + @tabla + '%'')
	begin
		SELECT + '' ENABLE TRIGGER '' + vo.name + '' ON '' + OBJECT_NAME(tr.parent_id)
		FROM vobjects vo
		INNER JOIN sys.triggers tr ON tr.object_id=vo.object_id	
		WHERE OBJECT_NAME(tr.parent_id)=''' + @tabla + ''' AND vo.DEFINITION LIKE ''%update ' + @tabla + '%''
	END'
	
	EXEC sp_executesql @sql

	--PRINT @sql

    FETCH NEXT FROM tablas INTO @tabla
END

CLOSE tablas
DEALLOCATE tablas










