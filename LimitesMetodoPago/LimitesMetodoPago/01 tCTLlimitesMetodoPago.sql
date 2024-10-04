

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCTLlimitesMetodosPago')
BEGIN
	CREATE TABLE [dbo].[tCTLlimitesMetodosPago]
	(
		IdLimitesMetodosPago INT NOT NULL PRIMARY KEY IDENTITY,
		IdMetodoPago		INT	NOT NULL, 
		IdRecurso			INT NOT NULL,
		IdTipoOperacion		INT NOT NULL,
		IdTipoSubOperacion	INT NOT NULL,
		LimiteInferior		NUMERIC(12,2) NOT NULL DEFAULT 0,
		LimiteSuperior		NUMERIC(12,2) NOT NULL DEFAULT 0,
		Alta				DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 			INT NOT NULL DEFAULT 1,
		IdUsuarioAlta 		INT NOT NULL DEFAULT 0,
		IdSesion 			INT NOT NULL DEFAULT 0
	) ON [PRIMARY]
	SELECT 'Tabla Creada tCTLlimitesMetodosPago' AS info
	
	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdMetodoPago 
	FOREIGN KEY (IdMetodoPago) REFERENCES dbo.tCATmetodosPago (IdMetodoPago)

	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdRecurso 
	FOREIGN KEY (IdRecurso) REFERENCES dbo.tCTLrecursos (IdRecurso)

	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdTipoOperacion 
	FOREIGN KEY (IdTipoOperacion) REFERENCES dbo.tCTLtiposOperacion (IdTipoOperacion)

	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdTipoSubOperacion 
	FOREIGN KEY (IdTipoSubOperacion) REFERENCES dbo.tCTLtiposOperacion (IdTipoOperacion)
	
	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdEstatus 
	FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdUsuarioAlta 
	FOREIGN KEY (IdUsuarioAlta) REFERENCES dbo.tCTLusuarios (IdUsuario)
	
	ALTER TABLE dbo.tCTLlimitesMetodosPago 
	ADD CONSTRAINT FK_tCTLlimitesMetodosPago_IdSesion 
	FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)	

	CREATE UNIQUE NONCLUSTERED INDEX UK_IdMetodoPago_IdRecurso_IdTipoOperacion_IdTipoSubOperacion
	ON dbo.tCTLlimitesMetodosPago (IdMetodoPago,IdRecurso,IdTipoOperacion,IdTipoSubOperacion);

END
ELSE 
	-- DROP TABLE tCTLlimitesMetodosPago
	SELECT 'tCTLlimitesMetodosPago Existe'
GO


