
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tACTDATtercerosRepresentadosE')
BEGIN
	CREATE TABLE [dbo].[tACTDATtercerosRepresentadosE]
	(
		IdTercerosRepresentadosE	INT NOT NULL IDENTITY,
		FechaTrabajo				DATE NOT NULL,
		IdPersona				INT NOT NULL,
		Alta				DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 			INT NOT NULL DEFAULT 1,
		IdSesion 			INT NOT NULL
		
		CONSTRAINT PK_tACTDATtercerosRepresentadosE_IdTercerosRepresentadosE PRIMARY KEY(IdTercerosRepresentadosE),
		CONSTRAINT FK_tACTDATtercerosRepresentados_IdPersona FOREIGN KEY(IdPersona) REFERENCES dbo.tGRLpersonas(IdPersona),
		CONSTRAINT FK_tACTDATtercerosRepresentadosE_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tACTDATtercerosRepresentadosE_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tACTDATtercerosRepresentadosE' AS info
END
ELSE 
	-- DROP TABLE tACTDATtercerosRepresentadosE
	SELECT 'tACTDATtercerosRepresentadosE Existe'
GO

