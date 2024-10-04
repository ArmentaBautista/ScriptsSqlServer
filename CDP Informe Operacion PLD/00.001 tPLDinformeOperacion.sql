
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDinformeOperacion')
BEGIN
	CREATE TABLE [dbo].[tPLDinformeOperacion]
	(
		IdInformeOperacion 		INT NOT NULL IDENTITY,
		IdOperacionPLD			INT NOT NULL,
		Notas					NVARCHAR(max) NOT NULL,
		Archivo					VARBINARY(max) NULL,
		Alta					DATETIME DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL,
		IdSesion 				INT NOT NULL
		
		CONSTRAINT PK_tPLDinformeOperacion_IdInformeOperacion PRIMARY KEY(IdInformeOperacion) ,
		CONSTRAINT FK_tPLDinformeOperacion_IdOperacionPLD FOREIGN KEY (IdOperacionPLD) REFERENCES dbo.tPLDoperaciones (IdOperacion),
		CONSTRAINT FK_tPLDinformeOperacion_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tPLDinformeOperacion_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tPLDinformeOperacion' AS info
END
ELSE 
	-- DROP TABLE tPLDinformeOperacion
	SELECT 'tPLDinformeOperacion Existe'
GO

