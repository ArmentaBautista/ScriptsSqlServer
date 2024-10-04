
/********  JCA.7/5/2024.23:14 Info: Tabla para registro de las ppe's que se dan de baja mediante el comando  ********/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDbitacoraComandoBajaPpe')
BEGIN
	CREATE TABLE [dbo].[tPLDbitacoraComandoBajaPpe]
	(
		Id 						INT NOT NULL IDENTITY,
		IdPersona				INT CONSTRAINT FK_tPLDbitacoraComandoBajaPpe_IdPersona FOREIGN KEY (IdPersona) REFERENCES dbo.tGRLpersonas (IdPersona),
		IdSesion 				INT NOT NULL,
		Alta					DATETIME DEFAULT GETDATE(),
		
		CONSTRAINT PK_tPLDbitacoraComandoBajaPpe_Id PRIMARY KEY(Id),
		CONSTRAINT FK_tPLDbitacoraComandoBajaPpe_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tPLDbitacoraComandoBajaPpe' AS info
END
ELSE 
	-- DROP TABLE tPLDbitacoraComandoBajaPpe
	SELECT 'tPLDbitacoraComandoBajaPpe Existe'
GO

