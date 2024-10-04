
IF(object_id('pADMeliminarConstraints') is not null)
BEGIN
	DROP PROC pADMeliminarConstraints
	SELECT 'pADMeliminarConstraints BORRADO' AS info
END
GO

CREATE PROC pADMeliminarConstraints
@pTabla AS VARCHAR(128),
@pCampo AS VARCHAR(128)
AS
BEGIN

DECLARE @restricciones AS TABLE(
	Tabla VARCHAR(128),
	Campo VARCHAR(128),
	ConstraintName VARCHAR(128)
)

INSERT INTO @restricciones
SELECT 
[Tabla]			= t.name, 
[Columna]		= c.name,
[Constraint]	= d.name
FROM sys.default_constraints d 
INNER JOIN sys.tables t
	ON t.object_id = d.parent_object_id
		AND t.name=@ptabla
INNER JOIN sys.columns c  
	ON c.object_id = t.object_id 
		AND c.column_id = d.parent_column_id
			AND c.name = @pCampo

/* declare variables */
DECLARE @restriccion VARCHAR(max)

DECLARE eliminarRestricciones CURSOR FAST_FORWARD READ_ONLY FOR SELECT 
																r.ConstraintName
																FROM @restricciones r
OPEN eliminarRestricciones
FETCH NEXT FROM eliminarRestricciones INTO @restriccion
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(max)=CONCAT('ALTER TABLE ',@pTabla,' DROP CONSTRAINT ',@restriccion)
	PRINT @sql
	EXEC sys.sp_executesql @sql
	PRINT 'Constraint borrado'

    FETCH NEXT FROM eliminarRestricciones INTO @restriccion
END

CLOSE eliminarRestricciones
DEALLOCATE eliminarRestricciones

RETURN 0;
END
GO