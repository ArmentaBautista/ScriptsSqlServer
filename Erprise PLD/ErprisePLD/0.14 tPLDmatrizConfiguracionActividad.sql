

-- 19 tPLDmatrizConfiguracionActividad

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionActividad')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionActividad
	CREATE TABLE [dbo].tPLDmatrizConfiguracionActividad
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null DEFAULT 1, -- Actividad
		IdValor			 INT NOT NULL UNIQUE,	 -- IdListaDActividad
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 1,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) 

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionActividad')

	SELECT 'Tabla existente tPLDmatrizConfiguracionActividad' AS info	
END
GO

 
 SELECT * FROM tPLDmatrizConfiguracionActividad
 GO
 
