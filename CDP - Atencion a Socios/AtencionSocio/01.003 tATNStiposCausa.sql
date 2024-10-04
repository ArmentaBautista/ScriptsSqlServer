
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tATNStiposCausa')
BEGIN
	CREATE TABLE [dbo].[tATNStiposCausa]
	(
		IdTipoCausa 			INT NOT NULL IDENTITY,
		Codigo					VARCHAR(16) NOT NULL UNIQUE,
		Descripcion				VARCHAR(128) NOT NULL,
		Alta					DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL 
		
		CONSTRAINT PK_tATNStiposCausa_IdTipoCausa PRIMARY KEY(IdTipoCausa) ,
		CONSTRAINT FK_tATNStiposCausa_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tATNStiposCausa_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tATNStiposCausa' AS info
END
ELSE 
	-- DROP TABLE tATNStiposCausa
	SELECT 'tATNStiposCausa Existe'
GO


