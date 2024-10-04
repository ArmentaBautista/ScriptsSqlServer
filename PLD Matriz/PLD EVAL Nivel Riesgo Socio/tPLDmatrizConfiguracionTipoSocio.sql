
USE iERP_DRA_TEST
go

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionTipoSocio')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionTipoSocio
	SELECT 'Tabla existente tPLDmatrizConfiguracionTipoSocio' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tPLDmatrizConfiguracionTipoSocio]
(
	Id 				int NOT NULL PRIMARY KEY IDENTITY,
	TipoSocio		INT NOT null DEFAULT 1 CHECK (TipoSocio IN (1,2,3,4)) UNIQUE,
	Descripcion		VARCHAR(24) NULL,
	Puntos			NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			DATETIME NOT NULL default GetDate(),
	IdEstatus 		int NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada tPLDmatrizConfiguracionTipoSocio' AS info

-- Goto tag
Fin: