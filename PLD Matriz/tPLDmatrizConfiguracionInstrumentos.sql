
USE iERP_DRA_TEST
GO

IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionInstrumentosCanales')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionInstrumentosCanales
	SELECT 'Tabla existente tPLDmatrizConfiguracionInstrumentosCanales' AS info
	GOTO Fin
END

CREATE TABLE [dbo].tPLDmatrizConfiguracionInstrumentosCanales
(
	Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
	Tipo			 INT NOT null , 
	IdValor1		 INT NOT NULL ,
	IdValor2		 INT NULL ,
	ValorDescripcion VARCHAR(256) NULL,
	Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
	Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
	IdEstatus 		 INT NOT NULL DEFAULT 1
) ON [PRIMARY]

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: