
/* JCA.18/4/2024.21:18 
Nota: Hecho para CDP, guarda los tramites de encuesta, para las bajas de socios.
Utiliza las tablas de la estructura de los cuestionarios de erprise
*/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tEBSencuestaBajaSocios')
BEGIN
	CREATE TABLE [dbo].tEBSencuestaBajaSocios
	(
		IdEncuestaBajaSocios 	INT NOT NULL IDENTITY,
		IdSocio					INT NOT NULL,
		Fecha					DATE NOT NULL,
		Alta					DATETIME DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL,

		CONSTRAINT PK_tEBSencuestaBajaSocios_IdEncuestaBajaSocios PRIMARY KEY (IdEncuestaBajaSocios),
		CONSTRAINT FK_tEBSencuestaBajaSocios_IdSocio FOREIGN KEY (IdSocio) REFERENCES dbo.tSCSsocios(IdSocio)
	) ON [PRIMARY]
	SELECT 'Tabla Creada tEBSencuestaBajaSocios' AS info
	
	ALTER TABLE dbo.tEBSencuestaBajaSocios
	ADD CONSTRAINT FK_tEBSencuestaBajaSocios_IdEstatus
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
	ALTER TABLE dbo.tEBSencuestaBajaSocios
	ADD CONSTRAINT FK_tEBSencuestaBajaSocios_IdSesion
	FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)	

END
ELSE 
	-- DROP TABLE tEBSencuestaBajaSocios
	SELECT 'tEBSencuestaBajaSocios Existe'
GO

