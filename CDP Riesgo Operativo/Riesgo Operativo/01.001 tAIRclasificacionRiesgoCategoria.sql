/* JCA.19/4/2024.01:14 
Nota: Modulo: Riesgo Operativo. Catalogo de Clasificación del Riesgo
*/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAIRclasificacionRiesgoCategoria')
BEGIN
	CREATE TABLE [dbo].[tAIRclasificacionRiesgoCategoria]
	(
		IdClasificacionRiesgoCategoria 	INT NOT NULL IDENTITY,
		Codigo							VARCHAR(16) NOT NULL,
		Descripcion						VARCHAR(64) NOT NULL,
		Alta							DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 						INT NOT NULL DEFAULT 1,
		IdSesion 						INT NOT NULL
		
		CONSTRAINT PK_tAIRclasificacionRiesgoCategoria_IdClasificacionRiesgoCategoria PRIMARY KEY(IdClasificacionRiesgoCategoria) ,
		CONSTRAINT FK_tAIRclasificacionRiesgoCategoria_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tAIRclasificacionRiesgoCategoria_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tAIRclasificacionRiesgoCategoria' AS info
END
ELSE 
	-- DROP TABLE tAIRclasificacionRiesgoCategoria
	SELECT 'tAIRclasificacionRiesgoCategoria Existe'
GO

