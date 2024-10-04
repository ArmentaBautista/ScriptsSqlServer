

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tATNStiposAtencion')
BEGIN
	CREATE TABLE [dbo].[tATNStiposAtencion]
	(
		IdTipoAtencion 		INT NOT NULL IDENTITY,
		Codigo					VARCHAR(16) NOT NULL UNIQUE,
		Descripcion				VARCHAR(32) NOT NULL,
		Alta					DATETIME DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL 
		
		CONSTRAINT PK_tATNStiposAtencion_IdTipoAtencion PRIMARY KEY(IdTipoAtencion) ,
		CONSTRAINT FK_tATNStiposAtencion_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tATNStiposAtencion_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tATNStiposAtencion' AS info
END
ELSE 
	-- DROP TABLE tATNStiposAtencion
	SELECT 'tATNStiposAtencion Existe'
GO

