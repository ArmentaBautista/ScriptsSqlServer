


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDcatalogoInusualidades')
BEGIN
	-- 20 tPLDcatalogoInusualidades

	CREATE TABLE [dbo].[tPLDcatalogoInusualidades]
	(
		Id 					INT NOT NULL PRIMARY KEY IDENTITY,
		Descripcion			VARCHAR(250) NOT NULL,
		ObjetoSQL			VARCHAR(128) NULL,
		Habilitado			BIT NOT NULL DEFAULT 1,
		IdTipoDPeriodicidad	INT NOT NULL DEFAULT 993,
		Alta				DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 			INT NOT NULL DEFAULT 1,
		IdUsuarioAlta 		INT NOT NULL DEFAULT -1,
		IdSesion 			INT NOT NULL DEFAULT 0
	) ON [PRIMARY]
	SELECT 'Tabla Creada tPLDcatalogoInusualidades' AS info
	
	ALTER TABLE dbo.tPLDcatalogoInusualidades 
	ADD CONSTRAINT FK_tPLDcatalogoInusualidades_IdTipoDPeriodicidad 
	FOREIGN KEY (IdTipoDPeriodicidad) REFERENCES dbo.tCTLtiposD (IdTipoD)
	
	ALTER TABLE dbo.tPLDcatalogoInusualidades 
	ADD CONSTRAINT FK_tPLDcatalogoInusualidades_IdEstatus 
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
	ALTER TABLE dbo.tPLDcatalogoInusualidades 
	ADD CONSTRAINT FK_tPLDcatalogoInusualidades_IdUsuarioAlta 
	FOREIGN KEY (IdUsuarioAlta) REFERENCES dbo.tCTLusuarios (IdUsuario)
	
	ALTER TABLE dbo.tPLDcatalogoInusualidades 
	ADD CONSTRAINT FK_tPLDcatalogoInusualidades_IdSesion 
	FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)	

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDcatalogoInusualidades')

END
ELSE 
	-- DROP TABLE tPLDcatalogoInusualidades
	SELECT 'tPLDcatalogoInusualidades Existe'
GO

