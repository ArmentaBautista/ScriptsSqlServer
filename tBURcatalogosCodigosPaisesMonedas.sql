


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBURcatalogosCodigosPaisesMonedas')
BEGIN
	CREATE TABLE [dbo].[tBURcatalogosCodigosPaisesMonedas]
	(
		Id 					INT NOT NULL PRIMARY KEY,
		Codigo				VARCHAR(32) NOT NULL UNIQUE,
		Pais				VARCHAR(256) NOT NULL,
		Alta				DATETIME DEFAULT GETDATE(),
		IdEstatus 			INT NOT NULL DEFAULT 1
	) ON [PRIMARY]
	
	SELECT 'Tabla Creada tBURcatalogosCodigosPaisesMonedas' AS info
	
	ALTER TABLE dbo.tBURcatalogosCodigosPaisesMonedas 
	ADD CONSTRAINT FK_tBURcatalogosCodigosPaisesMonedas_IdEstatus 
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
END
ELSE 
	-- DROP TABLE tBURcatalogosCodigosPaisesMonedas
	SELECT 'tBURcatalogosCodigosPaisesMonedas Existe'
GO