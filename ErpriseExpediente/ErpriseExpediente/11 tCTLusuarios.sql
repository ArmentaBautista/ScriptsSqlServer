
USE ErpriseExpediente
GO



IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tCTLusuarios')
BEGIN
	-- DROP TABLE tCTLusuarios
	
	CREATE TABLE tCTLusuarios(
		IdUsuario		INT	PRIMARY KEY IDENTITY,
		Usuario			VARCHAR(32) NOT NULL UNIQUE,
		Contraseña		VARBINARY(MAX) NULL,
		Digitalizacion	BIT	DEFAULT 1,
		Reportes		BIT	DEFAULT 0,
		Usuarios		BIT	DEFAULT 0,
		IdEstatus		INT DEFAULT 0 -- Establecer contraseña
	)
		
	SELECT 'tCTLusuarios BORRADO' AS info
END
GO

