
USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionGeografia')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionGeografia
	SELECT 'Tabla existente tPLDmatrizConfiguracionGeografia' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tPLDmatrizConfiguracionGeografia]
(
	Id 				int NOT NULL PRIMARY KEY IDENTITY,
	Tipo			INT NOT null DEFAULT 4, -- Asentamiento=1, Ciudad=2, Municipio=3, Estado=4, País=5
	IdUbicacion		INT NOT NULL ,
	Descripcion		VARCHAR(128) NULL,
	Puntos			NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			DateTime	 NOT NULL DEFAULT GetDate(),
	IdEstatus 		int NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:


