-- Elementos FNG

IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Ocupacion')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'Ocupacion',0.2)
GO

IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Ocupacion')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'Ocupacion',0.2)
GO

 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Ocupacion')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'Ocupacion',0.2)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Profesion')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'Profesion',0.15)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='ActividadGiro')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'ActividadGiro',0.25)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Genero')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'Genero',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TieneTelefonoNacional')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TieneTelefonoNacional',0.02)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TieneTelefonoExtranjero')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TieneTelefonoExtranjero',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TipoTelefono')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TipoTelefono',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TieneCorreoElectronico')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TieneCorreoElectronico',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='FechaNacimiento')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'FechaNacimiento',0.05)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='EstadoCivil')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'EstadoCivil',0.03)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TieneActividadEmpresarial')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TieneActividadEmpresarial',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TieneIdFiscal')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TieneIdFiscal',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='CURP')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'CURP',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TipoIdentificación')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'TipoIdentificación',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='NoIdentificacion')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'NoIdentificacion',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='EstaVigenteIdentificacion')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'EstaVigenteIdentificacion',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='FirmaElectronica')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'FirmaElectronica',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='VigenciaFirmaElectronica')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (1,'VigenciaFirmaElectronica',0.01)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='NumeroNacionalidades')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'NumeroNacionalidades',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Nacionalidad')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'Nacionalidad',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Domicilio')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'Domicilio',0.2)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='TipoDomicilio')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'TipoDomicilio',0.15)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='PaísNacimiento')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'PaísNacimiento',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='EntidadNacimiento')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'EntidadNacimiento',0.05)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Sucursal')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'Sucursal',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='SucursalDestino')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (2,'SucursalDestino',0.2)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Canal')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (3,'Canal',0.05)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='FrecuenciaDepositos')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (3,'FrecuenciaDepositos',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='FrecuenciaRetiros')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (3,'FrecuenciaRetiros',0.1)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='MontoDepositos')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (3,'MontoDepositos',0.35)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='MontoRetiros')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (3,'MontoRetiros',0.35)
GO 
 IF NOT EXISTS(SELECT elemento FROM dbo.tPLDmatrizRiesgoElementos WHERE Elemento='Servicios')
	INSERT INTO tPLDmatrizRiesgoElementos (IdAgrupador,Elemento,Ponderacion) VALUES (3,'Servicios',0.05)
GO 



