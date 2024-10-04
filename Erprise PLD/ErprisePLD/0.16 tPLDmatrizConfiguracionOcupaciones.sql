

-- 23 tPLDmatrizConfiguracionOcupaciones

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionOcupaciones')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionOcupaciones
	CREATE TABLE [dbo].tPLDmatrizConfiguracionOcupaciones
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null DEFAULT 1, -- Ocupacion = 1
		IdValor			 INT NOT NULL UNIQUE,	 -- IdListaDActividad
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 1,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) 

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionOcupaciones')

	SELECT 'Tabla existente tPLDmatrizConfiguracionOcupaciones' AS info	
END
GO

 
 SELECT * FROM tPLDmatrizConfiguracionOcupaciones
 GO
