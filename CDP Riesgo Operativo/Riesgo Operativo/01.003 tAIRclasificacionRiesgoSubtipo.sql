/* JCA.19/4/2024.01:20 
Nota: Riesgo Operativo. Catalogo de subtipos de clasificación del riesgo
*/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAIRclasificacionRiesgoSubtipo')
BEGIN
	CREATE TABLE [dbo].[tAIRclasificacionRiesgoSubtipo]
	(
		IdClasificacionRiesgoSubtipo 	INT NOT NULL IDENTITY,
		IdClasificacionRiesgoTipo 		INT NOT NULL,
		Codigo							VARCHAR(16) NOT NULL,
		Descripcion						VARCHAR(64) NOT NULL,
		Alta							DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 						INT NOT NULL DEFAULT 1,
		IdSesion 						INT NOT NULL
		
		CONSTRAINT PK_tAIRclasificacionRiesgoSubtipo_IdClasificacionRiesgoSubtipo PRIMARY KEY(IdClasificacionRiesgoSubtipo),
		CONSTRAINT FK_tAIRclasificacionRiesgoSubtipo_IdClasificacionRiesgoTipo FOREIGN KEY (IdClasificacionRiesgoTipo) REFERENCES dbo.tAIRclasificacionRiesgoTipo (IdClasificacionRiesgoTipo),
		CONSTRAINT FK_tAIRclasificacionRiesgoSubtipo_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tAIRclasificacionRiesgoSubtipo_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tAIRclasificacionRiesgoSubtipo' AS info
END
ELSE 
	-- DROP TABLE tAIRclasificacionRiesgoSubtipo
	SELECT 'tAIRclasificacionRiesgoSubtipo Existe'
GO

