


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCTLexcepcionesOffLine')
BEGIN
	CREATE TABLE [dbo].[tCTLexcepcionesOffLine]
	(
		IdUsuario 				INT NOT NULL,		 
		Alta					DATETIME NOT NULL DEFAULT GETDATE(),
		UltimoCambio			DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL
		
		CONSTRAINT PK_tCTLexcepcionesOffLine_IdUsuario FOREIGN KEY (IdUsuario) REFERENCES dbo.tCTLusuarios (IdUsuario),
		CONSTRAINT FK_tCTLexcepcionesOffLine_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tCTLexcepcionesOffLine_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tCTLexcepcionesOffLine' AS info
END
ELSE 
	-- DROP TABLE tCTLexcepcionesOffLine
	SELECT 'tCTLexcepcionesOffLine Existe'
GO

