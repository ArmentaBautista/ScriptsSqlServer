

IF NOT EXISTS (
    SELECT *
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tPLDoperaciones'
    AND COLUMN_NAME = 'Columna40'
)
BEGIN
    ALTER TABLE dbo.tPLDoperaciones
    ADD Columna40 varchar(1024) NOT NULL DEFAULT '';
END
GO

IF NOT EXISTS (
    SELECT *
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'tPLDoperaciones'
    AND COLUMN_NAME = 'Columna41'
)
BEGIN
    ALTER TABLE dbo.tPLDoperaciones
    ADD Columna41 varchar(1024) NOT NULL DEFAULT '';
END
GO


SELECT * FROM dbo.tPLDoperaciones

