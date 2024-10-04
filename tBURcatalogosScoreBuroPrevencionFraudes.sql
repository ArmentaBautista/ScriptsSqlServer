


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBURcatalogosScoreBuroPrevencionFraudes')
BEGIN
	CREATE TABLE [dbo].[tBURcatalogosScoreBuroPrevencionFraudes]
	(
		Id 					INT NOT NULL PRIMARY KEY IDENTITY,
		Codigo				VARCHAR(32) NOT NULL UNIQUE,
		Descripcion			VARCHAR(1024) NOT NULL,
		EsRazon				BIT DEFAULT 1,
		EsExclusion			BIT DEFAULT 0,
		EsError				BIT DEFAULT 0,
		Mensaje				VARCHAR(1024) DEFAULT '',
		Alta				DATETIME DEFAULT GETDATE(),
		IdEstatus 			INT NOT NULL DEFAULT 1
	) ON [PRIMARY]
	
	SELECT 'Tabla Creada tBURcatalogosScoreBuroPrevencionFraudes' AS info
	
	ALTER TABLE dbo.tBURcatalogosScoreBuroPrevencionFraudes 
	ADD CONSTRAINT FK_tBURcatalogosScoreBuroPrevencionFraudes_IdEstatus 
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
END
ELSE 
	-- DROP TABLE tBURcatalogosScoreBuroPrevencionFraudes
	SELECT 'tBURcatalogosScoreBuroPrevencionFraudes Existe'
GO
