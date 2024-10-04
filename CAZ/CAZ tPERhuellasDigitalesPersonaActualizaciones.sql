
IF EXISTS(SELECT name FROM sys.tables WHERE name='tPERhuellasDigitalesPersonaActualizaciones')
BEGIN
	-- DROP TABLE dbo.tPERhuellasDigitalesPersonaActualizaciones
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tPERhuellasDigitalesPersonaActualizaciones]
(
	FolioActualizacion	INT NOT NULL,
	IdHuella			INT NOT NULL ,
	IdPersona			INT NOT NULL, 
	NumeroHuella		INT NOT NULL CONSTRAINT [DF_tPERhuellasDigitalesPersonaActualizaciones_NumeroHuella] DEFAULT ((0)),
	HuellaDigital		VARBINARY (max) NULL,
	Alta				DATETIME NOT NULL CONSTRAINT [DF_tPERhuellasDigitalesPersonaActualizaciones_Alta] DEFAULT GetDate(),
	IdEstatus 			INT NOT NULL CONSTRAINT [DF_tPERhuellasDigitalesPersonaActualizaciones_IdEstatus] DEFAULT 1,
	IdUsuarioAlta 		INT NOT NULL,
	IdSesion 			INT NOT NULL
) ON [PRIMARY]


ALTER TABLE dbo.tPERhuellasDigitalesPersonaActualizaciones
ADD CONSTRAINT FK_tPERhuellasDigitalesPersonaActualizaciones_IdPersona 
FOREIGN KEY (IdPersona) REFERENCES dbo.tGRLpersonas (IdPersona)


SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:


