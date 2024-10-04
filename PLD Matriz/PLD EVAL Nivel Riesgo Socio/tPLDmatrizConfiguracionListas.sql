
USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionListas')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionListas
	SELECT 'Tabla existente tPLDmatrizConfiguracionListas' AS info
	GOTO Fin
END

CREATE TABLE [dbo].tPLDmatrizConfiguracionListas
(
	Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
	Tipo			 INT NOT null DEFAULT 4, -- PropietarioReal=1, ProveedorRecursos=2, PEP=3, PEP Asimilado=4, ListarRIESGO=5, ListaBloqueada=6
	IdValor			 INT NOT NULL ,
	ValorDescripcion VARCHAR(128) NULL,
	Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
	IdEstatus 		 INT NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: