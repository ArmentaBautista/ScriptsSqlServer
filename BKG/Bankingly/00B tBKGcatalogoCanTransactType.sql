

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoCanTransactType')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoCanTransactType]
	(
		CanTransactType		INT NOT NULL PRIMARY KEY,	
		CanTransctName		VARCHAR(24) NOT NULL,
		Descripcion			VARCHAR(64) NOT NULL 
	) ON [PRIMARY]
	
	SELECT 'Tabla Creada tBKGcatalogoCanTransactType' AS info
	
END
ELSE 
	-- DROP TABLE tBKGcatalogoCanTransactType
	SELECT 'tBKGcatalogoCanTransactType Existe'
GO

