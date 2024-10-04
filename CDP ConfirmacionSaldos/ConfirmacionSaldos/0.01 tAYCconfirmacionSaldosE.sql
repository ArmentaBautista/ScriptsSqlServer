/* JCA.17/4/2024.02:51 
Nota: Tabla de Encabezado para los trámites de Confirmación de saldos
*/

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAYCconfirmacionSaldosE')
BEGIN
	CREATE TABLE tAYCconfirmacionSaldosE(
	IdConfirmacionSaldos			INT PRIMARY KEY IDENTITY,	
	FechaCorte						DATE NOT NULL,
	FechaTrabajo					DATE NOT NULL,
	IdSocio							INT NOT NULL,
	YaImpreso						BIT NOT NULL DEFAULT 0,
	IdSesion						INT NOT	NULL FOREIGN KEY REFERENCES dbo.tCTLsesiones(IdSesion),
	IdUsuario						INT NOT NULL FOREIGN KEY REFERENCES dbo.tCTLusuarios(IdUsuario),
	Alta							DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	IdEstatus						INT NOT NULL DEFAULT 13 FOREIGN KEY REFERENCES dbo.tCTLestatus(IdEstatus)
	)

	SELECT 'Tabla Creada tAYCconfirmacionSaldosE' AS info	
END
ELSE 
	/*
	DROP TABLE tAYCconfirmacionSaldosD
	DROP TABLE tAYCconfirmacionSaldosE
	*/ 
	SELECT 'tAYCconfirmacionSaldosE Existe'
GO




