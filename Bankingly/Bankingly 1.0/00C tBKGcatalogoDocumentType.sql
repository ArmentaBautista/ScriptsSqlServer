


IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tBKGcatalogoDocumentType')
BEGIN
	CREATE TABLE tBKGcatalogoDocumentType
	(
		IdDocumentType			INT NOT NULL PRIMARY KEY,
		DocumentType			VARCHAR(24) NOT NULL,
		IdListaDidentificacion	INT NOT NULL,
		IdEstatus				INT NOT NULL
	)	

	ALTER TABLE dbo.tBKGcatalogoDocumentType ADD CONSTRAINT FK_tBKGcatalogoDocumentType_IdListaDidentificacion
	FOREIGN KEY (IdListaDidentificacion) REFERENCES dbo.tCATlistasD (IdListaD)

	ALTER TABLE dbo.tBKGcatalogoDocumentType ADD CONSTRAINT DF_tBKGcatalogoDocumentType_IdEstatus DEFAULT 1 FOR IdEstatus

END
ELSE
	SELECT 'tBKGcatalogoDocumentType ya existe'
	-- DROP TABLE tBKGcatalogoDocumentType
GO



