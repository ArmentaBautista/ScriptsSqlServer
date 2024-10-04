
-- Agrupadores FNG

IF NOT EXISTS(SELECT * FROM dbo.tPLDmatrizRiesgoAgrupadores WHERE Agrupador='Cliente')
	INSERT INTO dbo.tPLDmatrizRiesgoAgrupadores (Agrupador,Ponderacion) VALUES ('Cliente',.08)
GO

IF NOT EXISTS(SELECT * FROM dbo.tPLDmatrizRiesgoAgrupadores WHERE Agrupador='Geograf�a')
	INSERT INTO dbo.tPLDmatrizRiesgoAgrupadores (Agrupador,Ponderacion) VALUES ('Geograf�a',.05)
GO

IF NOT EXISTS(SELECT * FROM dbo.tPLDmatrizRiesgoAgrupadores WHERE Agrupador='Transaccional')
	INSERT INTO dbo.tPLDmatrizRiesgoAgrupadores (Agrupador,Ponderacion) VALUES ('Transaccional',.8)
GO

DECLARE @IdAgrupadorCliente AS INT=(SELECT IdAgrupador FROM dbo.tPLDmatrizRiesgoAgrupadores WHERE Agrupador='Cliente')
DECLARE @IdAgrupadorGeografia AS INT=(SELECT IdAgrupador FROM dbo.tPLDmatrizRiesgoAgrupadores WHERE Agrupador='Geograf�a')
DECLARE @IdAgrupadorTransaccional AS INT=(SELECT IdAgrupador FROM dbo.tPLDmatrizRiesgoAgrupadores WHERE Agrupador='Transaccional')

