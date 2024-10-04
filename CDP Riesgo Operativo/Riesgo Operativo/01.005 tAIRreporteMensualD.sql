/* JCA.19/4/2024.01:29 
Nota: RiesgoOperativo. Detalle del reporte mensual. listado de las incidencias registradas
*/
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAIRreporteMensualD')
BEGIN
	CREATE TABLE [dbo].[tAIRreporteMensualD]
	(
		-- Generales
		IdReporteMensualD 				INT NOT NULL IDENTITY,
		IdReporteMensualE				INT NOT NULL,
		FechaIdentificacionEvento		DATE NOT NULL,
		FechaEvento						DATE NOT NULL,
		Evento							VARCHAR(128) NOT NULL,
		EventoDescripcion				VARCHAR(1024) NOT NULL,
		ActividadOrigen					VARCHAR(64) NOT NULL,
		AreaActividadOrigen				VARCHAR(64) NOT NULL,
		-- Clasificacion
		IdClasificacionRiesgoCategoria	INT NOT NULL,
		IdClasificacionRiesgoTipo		INT NOT NULL,
		IdClasificacionRiesgoSubtipo	INT NOT NULL,
		-- Acciones
		AccionImplementada				VARCHAR(128) NOT NULL,
		PerdidaOcasionadaEsperada		VARCHAR(128) NOT NULL,
		AccionDescripcion				VARCHAR(1024) NOT NULL,
		Recomendaciones					VARCHAR(1024) NOT NULL,
		Comentarios						VARCHAR(1024) NOT NULL,
		ExisteControlImplementado		BIT NOT NULL DEFAULT 0,
		-- Control
		Fecha							DATE NOT NULL DEFAULT GETDATE(),
		Alta							DATETIME NOT NULL DEFAULT GETDATE(),
		IdEstatus 						INT NOT NULL DEFAULT 1,
		IdSesion 						INT NOT NULL,
		IdUsuario						INT NOT NULL,
		-- Actualizacion 
		IdUsuarioUltimaModificacion		INT NOT NULL,
		FechaUltimaModificacion			DATE DEFAULT GETDATE()
		                           		    
		CONSTRAINT PK_tAIRreporteMensualD_IdReporteMensualD PRIMARY KEY(IdReporteMensualD) ,
		CONSTRAINT FK_tAIRreporteMensualD_IdReporteMensualE FOREIGN KEY (IdReporteMensualE) REFERENCES dbo.tAIRreporteMensualE (IdReporteMensualE),

		CONSTRAINT FK_tAIRreporteMensualD_IdClasificacionRiesgoCategoria	FOREIGN KEY (IdClasificacionRiesgoCategoria)	REFERENCES dbo.tAIRclasificacionRiesgoCategoria	(IdClasificacionRiesgoCategoria),
		CONSTRAINT FK_tAIRreporteMensualD_IdClasificacionRiesgoTipo			FOREIGN KEY (IdClasificacionRiesgoTipo)			REFERENCES dbo.tAIRclasificacionRiesgoTipo		(IdClasificacionRiesgoTipo),
		CONSTRAINT FK_tAIRreporteMensualD_IdClasificacionRiesgoSubtipo		FOREIGN KEY (IdClasificacionRiesgoSubtipo)		REFERENCES dbo.tAIRclasificacionRiesgoSubtipo	(IdClasificacionRiesgoSubtipo),

		CONSTRAINT FK_tAIRreporteMensualD_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus),
		CONSTRAINT FK_tAIRreporteMensualD_IdSesion FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion),
		CONSTRAINT FK_tAIRreporteMensualD_IdUsuario FOREIGN KEY (IdUsuario) REFERENCES dbo.tCTLusuarios (IdUsuario),
		CONSTRAINT FK_tAIRreporteMensualD_IdUsuarioUltimaModificacion FOREIGN KEY (IdUsuarioUltimaModificacion) REFERENCES dbo.tCTLusuarios (IdUsuario)
		) ON [PRIMARY]
		
		SELECT 'Tabla Creada tAIRreporteMensualD' AS info
END
ELSE 
	-- DROP TABLE tAIRreporteMensualD
	SELECT 'tAIRreporteMensualD Existe'
GO

