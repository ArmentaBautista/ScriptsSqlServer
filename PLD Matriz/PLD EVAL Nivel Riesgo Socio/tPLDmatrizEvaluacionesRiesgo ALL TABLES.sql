
/* Evaluaciones Riesgo tPLDmatrizEvaluacionesRiesgo */
	IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizEvaluacionesRiesgo')
	BEGIN
		CREATE TABLE [dbo].[tPLDmatrizEvaluacionesRiesgo]
		(
			IdEvaluacionRiesgo	INT NOT NULL PRIMARY KEY IDENTITY,
			Fecha				DATE NOT NULL,
			Agrupador			VARCHAR(25) NOT NULL,
			Individual			BIT NOT NULL DEFAULT 0,
			Masiva				BIT NOT NULL DEFAULT 0,
			Alta				DATETIME DEFAULT GETDATE(),
			IdEstatus 			INT NOT NULL
		) ON [PRIMARY]
		SELECT 'Tabla Creada tPLDmatrizEvaluacionesRiesgo' AS info
	
		IF NOT EXISTS(SELECT name FROM sys.indexes o WHERE o.name='Ix_tPLDmatrizEvaluacionesRiesgo_Fecha')
		BEGIN 
			CREATE INDEX Ix_tPLDmatrizEvaluacionesRiesgo_Fecha ON tPLDmatrizEvaluacionesRiesgo (Fecha)
			SELECT 'Ix_tPLDmatrizEvaluacionesRiesgo_Fecha Creado' AS info
		END	

		IF NOT EXISTS(SELECT name FROM sys.indexes o WHERE o.name='Ix_tPLDmatrizEvaluacionesRiesgo_Agrupador')
		BEGIN 
			CREATE INDEX Ix_tPLDmatrizEvaluacionesRiesgo_Agrupador ON tPLDmatrizEvaluacionesRiesgo (Agrupador)
			SELECT 'Ix_tPLDmatrizEvaluacionesRiesgo_Agrupador Creado' AS info
		END	

	END
	GO

/* Calificaciones tPLDmatrizEvaluacionesRiesgoCalificaciones */
IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tPLDmatrizEvaluacionesRiesgoCalificaciones')
BEGIN
	CREATE table tPLDmatrizEvaluacionesRiesgoCalificaciones(
		IdEvaluacionRiesgo	INT NOT NULL,
		IdPersona			INT NOT NULL,
		IdSocio				INT NOT NULL,
		IdFactor			INT NOT NULL,
		Factor				VARCHAR(64) NOT NULL,
		Elemento			VARCHAR(128) NOT NULL,
		Valor				VARCHAR(10) NOT NULL,
		ValorDescripcion	VARCHAR(256) NULL,
		Puntos				INT NOT NULL DEFAULT 0,
		IdEstatus 			INT NOT NULL,
	)	
	SELECT 'tPLDmatrizEvaluacionesRiesgoCalificaciones Creada' AS info

	-- Foreign Key
	ALTER TABLE dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones 
	ADD CONSTRAINT FK_tPLDmatrizEvaluacionesRiesgoCalificaciones_IdEvaluacionRiesgo FOREIGN KEY (IdEvaluacionRiesgo) REFERENCES tPLDmatrizEvaluacionesRiesgo (IdEvaluacionRiesgo)
	
	-- Index
	CREATE INDEX Ix_tPLDmatrizEvaluacionesRiesgoCalificaciones_IdSocio ON tPLDmatrizEvaluacionesRiesgoCalificaciones (IdSocio)
	
END
GO

/* CalificacionesAgrupadas tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas */
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas')
BEGIN
	CREATE TABLE [dbo].tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas
	(
		IdEvaluacionRiesgo	INT NOT NULL, 
		IdSocio				INT, 
		IdFactor			INT, 
		Factor				VARCHAR(64), 
		SumaFactor			INT, 
		PonderacionFactor	NUMERIC(4,3),
		PuntajeFactor		NUMERIC(10,2),
		IdEstatus 			INT NOT NULL,
	) ON [PRIMARY]
	SELECT 'Tabla Creada tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas' AS info

	-- Foreign Key
	ALTER TABLE dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas 
	ADD CONSTRAINT FK_tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas_IdEvaluacionRiesgo FOREIGN KEY (IdEvaluacionRiesgo) REFERENCES tPLDmatrizEvaluacionesRiesgo (IdEvaluacionRiesgo)
	
	-- Index
	CREATE INDEX Ix_tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas_IdSocio ON tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas (IdSocio)
	
END
GO

/* CalificacionesFinales  tPLDmatrizEvaluacionesRiesgoCalificacionesFinales */
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizEvaluacionesRiesgoCalificacionesFinales')
BEGIN
	CREATE TABLE [dbo].[tPLDmatrizEvaluacionesRiesgoCalificacionesFinales]
	(
		IdEvaluacionRiesgo			INT NOT NULL, 
		IdSocio						INT NOT NULL, 
		Calificacion				NUMERIC(10,2) NOT NULL,
		NivelDeRiesgo				SMALLINT NOT NULL,
		NivelDeRiesgoDescripcion	VARCHAR(32) NOT NULL,
		IdEstatus 					INT NOT NULL
	) ON [PRIMARY]
	SELECT 'Tabla Creada tPLDmatrizEvaluacionesRiesgoCalificacionesFinales' AS info
	
	-- Foreign Key
	ALTER TABLE dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales 
	ADD CONSTRAINT FK_tPLDmatrizEvaluacionesRiesgoCalificacionesFinales_IdEvaluacionRiesgo FOREIGN KEY (IdEvaluacionRiesgo) REFERENCES tPLDmatrizEvaluacionesRiesgo (IdEvaluacionRiesgo)
	
	-- Index
	CREATE INDEX Ix_tPLDmatrizEvaluacionesRiesgoCalificacionesFinales_IdSocio ON tPLDmatrizEvaluacionesRiesgoCalificacionesFinales (IdSocio)

END
GO







