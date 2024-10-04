

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tASEMEXparentescos')
BEGIN
	CREATE TABLE [dbo].[tASEMEXparentescos]
	(
		IdTipoDparentesco	INT FOREIGN KEY REFERENCES dbo.tCTLtiposD(IdTipoD),
		ClaveParentesco		varchar(30) UNIQUE,
		Parentesco			VARCHAR(30),
		IdEstatus 			INT NOT NULL DEFAULT 1
	) ON [PRIMARY]
	
	SELECT 'Tabla Creada tASEMEXparentescos' AS info
	
	ALTER TABLE dbo.tASEMEXparentescos 
	ADD CONSTRAINT FK_tASEMEXparentescos_IdEstatus 
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
END
ELSE 
	-- DROP TABLE tASEMEXparentescos
	SELECT 'tASEMEXparentescos Existe'
GO

INSERT INTO dbo.tASEMEXparentescos (IdTipoDparentesco,ClaveParentesco,Parentesco)
SELECT 290		,'1CON','Conyuge'
UNION
SELECT 292		,'2HIJ','Hijo/a'
UNION
SELECT 291		,'3HER','Hermano/a'
UNION
SELECT 1617	,'4PAT','Padre / Madre'
UNION
SELECT 0		,'YNOP','Sin parentesco'
UNION
SELECT 1051	,'ZOTR','Otro'



/*
CveParentesco	NomParentesco
SELECT 290		,'1CON','Conyuge'
SELECT 292		,'2HIJ','Hijo/a'
SELECT 291		,'3HER','Hermano/a'
SELECT 1617	,'4PAT','Padre / Madre'
SELECT 0		,'YNOP','Sin parentesco'
SELECT 1051	,'ZOTR','Otro'
*/
