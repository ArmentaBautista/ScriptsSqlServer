
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tATNSsubtiposCausa')
BEGIN
	CREATE TABLE [dbo].[tATNSsubtiposCausa]
	(
		IdSubtipoCausa 			INT NOT NULL IDENTITY,
		Codigo					VARCHAR(16) NOT NULL UNIQUE,
		Descripcion				VARCHAR(128) NOT NULL,
		IdTipoCausa 			INT NOT NULL,
		Alta					DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL 
		
		CONSTRAINT PK_tATNSsubtiposCausa_IdSubtipoCausa PRIMARY KEY(IdSubtipoCausa) ,
		CONSTRAINT FK_tATNSsubtiposCausa_IdTipoCausa FOREIGN KEY (IdTipoCausa) REFERENCES dbo.tATNStiposCausa (IdTipoCausa),
		CONSTRAINT FK_tATNSsubtiposCausa_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tATNSsubtiposCausa_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tATNSsubtiposCausa' AS info
END
ELSE 
	-- DROP TABLE tATNSsubtiposCausa
	SELECT 'tATNSsubtiposCausa Existe'
GO

