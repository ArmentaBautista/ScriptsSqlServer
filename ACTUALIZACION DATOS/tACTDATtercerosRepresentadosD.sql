
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tACTDATtercerosRepresentadosD')
BEGIN
	CREATE TABLE [dbo].[tACTDATtercerosRepresentadosD]
	(
		IdTercerosRepresentadosD	INT NOT NULL IDENTITY,
		IdTercerosRepresentadosE	INT NOT NULL,
		IdReferenciaPersonal		INT NOT NULL,
		IdPersonaReferencia			INT NOT NULL,
		RelReferenciasPersonales	INT NOT NULL,
		EsProveedorRecursos			BIT NOT NULL DEFAULT 0,
		EsPropietarioReal			BIT NOT NULL DEFAULT 0,
		EsRegistroAnterior			BIT NOT NULL DEFAULT 0,
		EsRegistroActual			BIT NOT NULL DEFAULT 0,
		Alta						DATETIME NOT NULL DEFAULT GETDATE(),
		
		CONSTRAINT PK_tACTDATtercerosRepresentadosD_IdTercerosRepresentadosD PRIMARY KEY(IdTercerosRepresentadosD),
		CONSTRAINT FK_tACTDATtercerosRepresentadosD_IdTercerosRepresentadosE 
			FOREIGN KEY (IdTercerosRepresentadosE) REFERENCES dbo.tACTDATtercerosRepresentadosE (IdTercerosRepresentadosE),
		CONSTRAINT FK_tACTDATtercerosRepresentadosD_IdReferenciaPersonal
			FOREIGN KEY (IdReferenciaPersonal) REFERENCES dbo.tSCSpersonasFisicasReferencias(IdReferenciaPersonal),
		CONSTRAINT FK_tACTDATtercerosRepresentadosD_IdPersonaReferencia
			FOREIGN KEY (IdPersonaReferencia) REFERENCES dbo.tGRLpersonas(IdPersona),
		CONSTRAINT FK_tACTDATtercerosRepresentadosD_RelReferenciasPersonales
			FOREIGN KEY (RelReferenciasPersonales) REFERENCES dbo.tGRLpersonas(IdPersona)
		)
		
		SELECT 'Tabla Creada tACTDATtercerosRepresentadosD' AS info
END
ELSE 
	-- DROP TABLE tACTDATtercerosRepresentadosD
	SELECT 'tACTDATtercerosRepresentadosD Existe'
GO

