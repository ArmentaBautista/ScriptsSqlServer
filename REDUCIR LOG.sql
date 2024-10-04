DECLARE @BD AS VARCHAR(100) = DB_NAME();


DECLARE @SqlCommand AS NVARCHAR(MAX);

SELECT @SqlCommand = CONCAT('
USE ', @BD, ';

-- cambiamos el recovery a nodo simple
ALTER DATABASE ', @BD, '
SET RECOVERY SIMPLE;

-- reducirmos el archivo log a 1 MB.
DBCC SHRINKFILE (', @BD, '_Log, 1);

-- reducirmos la base de datos.
DBCC SHRINKDATABASE(N''', @BD, ''' )

-- devolvemos el nivel de recovery a full
ALTER DATABASE ', @BD, '
SET RECOVERY FULL;
');

EXECUTE( @SqlCommand );



