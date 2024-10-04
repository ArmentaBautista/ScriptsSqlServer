/* JCA.19/4/2024.01:19 
Nota: Riesgo Operativo, catálogo de clasificaciones de Tipo de Riesgo
*/

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAIRclasificacionRiesgoTipo')
BEGIN
	CREATE TABLE [dbo].[tAIRclasificacionRiesgoTipo]
	(
		IdClasificacionRiesgoTipo 		INT NOT NULL IDENTITY,
		IdClasificacionRiesgoCategoria	INT NOT NULL,
		Codigo							VARCHAR(16) NOT NULL,
		Descripcion						VARCHAR(64) NOT NULL,
		Alta							DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 						INT NOT NULL DEFAULT 1,
		IdSesion 						INT NOT NULL
		
		CONSTRAINT PK_tAIRclasificacionRiesgoTipo_IdClasificacionRiesgoTipo PRIMARY KEY(IdClasificacionRiesgoTipo),
		CONSTRAINT FK_tAIRclasificacionRiesgoTipo_IdClasificacionRiesgoCategoria FOREIGN KEY (IdClasificacionRiesgoCategoria) REFERENCES dbo.tAIRclasificacionRiesgoCategoria (IdClasificacionRiesgoCategoria),
		CONSTRAINT FK_tAIRclasificacionRiesgoTipo_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tAIRclasificacionRiesgoTipo_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		)
		
		SELECT 'Tabla Creada tAIRclasificacionRiesgoTipo' AS info
END
ELSE 
	-- DROP TABLE tAIRclasificacionRiesgoTipo
	SELECT 'tAIRclasificacionRiesgoTipo Existe'
GO

