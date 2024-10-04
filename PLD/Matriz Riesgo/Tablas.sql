

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizRiesgoAgrupadores')
BEGIN
		CREATE TABLE tPLDmatrizRiesgoAgrupadores
		(
			IdAgrupador INT PRIMARY KEY IDENTITY,
			Agrupador VARCHAR(35) null,
			Ponderacion NUMERIC(7,3),
			IdTipoD int,
			IdEstatus INT CONSTRAINT df_tPLDmatrizRiesgoAgrupadores_IdEstatus DEFAULT 0
		)

END
GO

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizRiesgoElementos')
BEGIN
		CREATE TABLE tPLDmatrizRiesgoElementos
		(
			IdAgrupador INT NOT NULL CONSTRAINT fk_tPLDelementosMatrizRiesgo_IdAgrupadorMatrizRiesgo FOREIGN KEY REFERENCES tPLDmatrizRiesgoAgrupadores(IdAgrupador),
			Elemento VARCHAR(35) null,
			Ponderacion NUMERIC(7,3),
			IdTipoD int,
			IdEstatus INT CONSTRAINT df_tPLDmatrizRiesgoElementos_IdEstatus DEFAULT 0
		)

END
GO


 -- DROP TABLE	dbo.tPLDmatrizRiesgoAgrupadores
 -- DROP TABLE	dbo.tPLDmatrizRiesgoElementos

