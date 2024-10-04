


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBURcatalogosCodigosIndiceCapacidadCrediticiaICC')
BEGIN
	CREATE TABLE [dbo].[tBURcatalogosCodigosIndiceCapacidadCrediticiaICC]
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
	
	SELECT 'Tabla Creada tBURcatalogosCodigosIndiceCapacidadCrediticiaICC' AS info
	
	ALTER TABLE dbo.tBURcatalogosCodigosIndiceCapacidadCrediticiaICC 
	ADD CONSTRAINT FK_tBURcatalogosCodigosIndiceCapacidadCrediticiaICC_IdEstatus 
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
END
ELSE 
	-- DROP TABLE tBURcatalogosCodigosIndiceCapacidadCrediticiaICC
	SELECT 'tBURcatalogosCodigosIndiceCapacidadCrediticiaICC Existe'
GO