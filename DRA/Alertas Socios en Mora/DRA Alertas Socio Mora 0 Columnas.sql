



-- COLUMNA AGRUPADOR
IF NOT EXISTS(SELECT c.name
			FROM sys.tables t
			INNER JOIN sys.columns c ON c.object_id = t.object_id
			WHERE t.name='tCTLmensajes' AND c.name='Agrupador')
BEGIN
	ALTER TABLE tCTLmensajes ADD Agrupador varchar(256)

	SELECT 'Columna Agrupador agregada' AS Info
END
ELSE
BEGIN
	SELECT 'Ya existia la columna Agrupador' AS Info
END
GO


-- COLUMNA REFERENCIA
IF NOT EXISTS(SELECT c.name
			FROM sys.tables t
			INNER JOIN sys.columns c ON c.object_id = t.object_id
			WHERE t.name='tCTLmensajes' AND c.name='Referencia')
BEGIN
	ALTER TABLE tCTLmensajes ADD Referencia varchar(256)

	SELECT 'Columna Referencia agregada' AS Info
END
ELSE
BEGIN
	SELECT 'Ya existia la columna referencia' AS Info
END
GO

-- COLUMNA CONCEPTO
IF NOT EXISTS(SELECT c.name
			FROM sys.tables t
			INNER JOIN sys.columns c ON c.object_id = t.object_id
			WHERE t.name='tCTLmensajes' AND c.name='Concepto')
BEGIN
	ALTER TABLE tCTLmensajes ADD Concepto varchar(256)

	SELECT 'Columna Concepto agregada' AS Info
END
ELSE
BEGIN
	SELECT 'Ya existia la columna Concepto' AS Info
END
GO



