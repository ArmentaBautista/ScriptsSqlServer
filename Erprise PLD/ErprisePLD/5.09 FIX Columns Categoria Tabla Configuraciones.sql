
/********  JCA.13/8/2024.19:52 Info: 5.09 agregado de campos para categorizar los parámetros del módulo de PLD  ********/
IF NOT EXISTS(SELECT  1
				FROM sys.tables t 
				INNER JOIN sys.columns c 
					ON c.object_id = t.object_id
						AND c.name='Categoria1'
				WHERE t.name='tPLDconfiguracion')
BEGIN
	ALTER TABLE dbo.tPLDconfiguracion
		ADD Categoria1 VARCHAR(32) DEFAULT ''		

	SELECT 'Columna Categoria1 Agregada' AS Info
END
GO

IF NOT EXISTS(SELECT  1
				FROM sys.tables t 
				INNER JOIN sys.columns c 
					ON c.object_id = t.object_id
						AND c.name='Categoria2'
				WHERE t.name='tPLDconfiguracion')
BEGIN
	ALTER TABLE dbo.tPLDconfiguracion
		ADD Categoria2 VARCHAR(32) DEFAULT ''		

	SELECT 'Columna Categoria2 Agregada' AS Info
END
GO


