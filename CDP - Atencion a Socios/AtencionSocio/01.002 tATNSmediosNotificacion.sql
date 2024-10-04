
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tATNSmediosNotificacion')
BEGIN
	CREATE TABLE [dbo].[tATNSmediosNotificacion]
	(
		IdMedioNotificacion 	INT NOT NULL IDENTITY,
		Codigo					VARCHAR(16) NOT NULL UNIQUE,
		Descripcion				VARCHAR(32) NOT NULL,
		Alta					DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL 
		
		CONSTRAINT PK_tATNSmediosNotificacion_IdMedioNotificacion PRIMARY KEY(IdMedioNotificacion) ,
		CONSTRAINT FK_tATNSmediosNotificacion_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tATNSmediosNotificacion_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tATNSmediosNotificacion' AS info
END
ELSE 
	-- DROP TABLE tATNSmediosNotificacion
	SELECT 'tATNSmediosNotificacion Existe'
GO

