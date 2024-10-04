
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoProductTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoProductTypes]
	(
		ProductTypeId		INT NOT NULL PRIMARY KEY,
		ProductTypeName		VARCHAR(32) NOT NULL,
		Descripcion			VARCHAR(64) NOT NULL,
		IdTipoDproducto		INT NOT NULL,
		Revolvente			BIT NOT NULL,
		LineaCredito		BIT NOT NULL,
		IdEstatus 			INT NOT NULL
	) ON [PRIMARY]

	ALTER TABLE dbo.tBKGcatalogoProductTypes ADD CONSTRAINT DF_tBKGcatalogoProductTypes_IdEstatus DEFAULT 1 FOR IdEstatus
	ALTER TABLE dbo.tBKGcatalogoProductTypes ADD CONSTRAINT DF_tBKGcatalogoProductTypes_Revolvente DEFAULT 0 FOR Revolvente
	ALTER TABLE dbo.tBKGcatalogoProductTypes ADD CONSTRAINT DF_tBKGcatalogoProductTypes_LineaCredito DEFAULT 0 FOR LineaCredito

	SELECT 'Tabla Creada tBKGcatalogoProductTypes' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoProductTypes
	SELECT 'tBKGcatalogoProductTypes Existe'
GO


/*
SELECT * from tBKGcatalogoProductTypes

*/

GO

		
