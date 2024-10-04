
/* INFO (?_?) JCA.17/08/2023.01:28 a. m. 
Nota:Proceso de agregado de columna para el tipo de persona y hacer la distinción de las edades y sus ponderaciones
*/

/*  (???)    JCA.17/08/2023.01:29 a. m. Nota: Crear tabla temporal para guardar los datos existentes                */
SELECT * INTO ##tPLDmatrizConfiguracionEdades FROM dbo.tPLDmatrizConfiguracionEdades
GO

/* ?^•?•^?   JCA.17/08/2023.01:30 a. m. Nota: Borrado y creado de la tabla de Edades                */
DROP TABLE dbo.tPLDmatrizConfiguracionEdades
GO

	CREATE TABLE [dbo].[tPLDmatrizConfiguracionEdades]
	(
		Id 				int NOT NULL PRIMARY KEY IDENTITY,
		Tipo			INT NOT NULL, -- PF = 1, P?M = 2
		Edad			INT NOT null DEFAULT 0,
		Puntos			NUMERIC(5,2) DEFAULT 0,
		Alta			DateTime default GetDate(),
		IdEstatus 		int NOT NULL DEFAULT 1
	)
GO

/*  (???)    JCA.17/08/2023.01:31 a. m. Nota: Regresamos los datos de las Edades de PF y borramos la temporal              */
INSERT INTO dbo.tPLDmatrizConfiguracionEdades(Tipo,Edad,Puntos)
SELECT 1,Edad,Puntos FROM ##tPLDmatrizConfiguracionEdades
GO

DROP TABLE ##tPLDmatrizConfiguracionEdades
go


DECLARE @contador AS INT=0

WHILE @contador<=110 
BEGIN	
	--INSERT INTO tPLDmatrizconfiguracionEdades (edad,puntos) VALUES (@contador,floor(rand()*101))
	INSERT INTO tPLDmatrizconfiguracionEdades (tipo,edad,puntos) VALUES (1,@contador,1)
	SET @contador=@contador+1
END
GO

/* ?^•?•^?   JCA.17/08/2023.01:32 a. m. Nota: Borrado y llenado de Edades para PM                */
DELETE FROM dbo.tPLDmatrizConfiguracionEdades WHERE Tipo=2
GO

DECLARE @contador AS INT=0
WHILE @contador<=110 
BEGIN	
	INSERT INTO tPLDmatrizconfiguracionEdades (Tipo,edad,puntos) VALUES (2,@contador,1)
	SET @contador=@contador+1
END
GO

SELECT * FROM dbo.tPLDmatrizConfiguracionEdades
GO

