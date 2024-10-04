
USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionNivelesRiesgo')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionNivelesRiesgo
	SELECT 'Tabla existente tPLDmatrizConfiguracionNivelesRiesgo' AS info
	GOTO Fin
END

CREATE TABLE [dbo].tPLDmatrizConfiguracionNivelesRiesgo
(
	Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
	Tipo			 INT NOT null , -- 1. Menores, 2. Mayores, 3. Morales
	TipoDescripcion	 VARCHAR(128) NULL,
	NivelRiesgo		 INT NOT null , -- 1. Bajo, 2. Medio, 3. Alto
	NivelRiesgoDescripcion		 VARCHAR(128) NULL,
	Valor1			 INT NOT NULL ,
	Valor2			 INT NOT NULL ,	
	Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
	IdEstatus 		 INT NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: