
-- USE intelixDEV
GO

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPERresponsablesDeSucursal')
BEGIN
	CREATE TABLE [dbo].[tPERresponsablesDeSucursal]
	(
		IdResponsableSucursal INT NOT NULL IDENTITY,
		IdSucursal	INT NOT NULL,
		IdPersonaFisica	INT NOT NULL, 
		Alta					DATETIME DEFAULT GETDATE(),
		IdEstatus 				INT NOT NULL DEFAULT 1,
		IdSesion 				INT NOT NULL
		
		CONSTRAINT PK_tPERresponsablesDeSucursal_IdSuursalPersonaResponsable PRIMARY KEY(IdResponsableSucursal),
		CONSTRAINT FK_tPERresponsablesDeSucursal_IdSucursal FOREIGN KEY (IdSucursal) REFERENCES dbo.tCTLsucursales(IdSucursal),
		CONSTRAINT FK_tPERresponsablesDeSucursal_IdPersonaFisica FOREIGN KEY (IdPersonaFisica) REFERENCES dbo.tGRLpersonasFisicas(IdPersonaFisica),
		CONSTRAINT FK_tPERresponsablesDeSucursal_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tPERresponsablesDeSucursal_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tPERresponsablesDeSucursal' AS info
END
ELSE 
	-- DROP TABLE tPERresponsablesDeSucursal
	SELECT 'tPERresponsablesDeSucursal Existe'
GO


