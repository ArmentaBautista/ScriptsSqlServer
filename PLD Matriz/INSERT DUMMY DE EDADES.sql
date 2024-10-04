
USE iERP_DRA_TEST
GO

/* INSERT DUMMY DE EDADES */

/*

DECLARE @contador AS INT=0

WHILE @contador<=110 
begin	
	INSERT INTO tPLDmatrizconfiguracionEdades (edad,puntos) VALUES (@contador,floor(rand()*101))

	SET @contador=@contador+1
END

*/

SELECT * FROM tPLDmatrizconfiguracionEdades

/* 
delete from tPLDmatrizConfiguracionTipoPersona
INSERT INTO tPLDmatrizConfiguracionTipoPersona(TipoPersona,Puntos) VALUES(1,30)
INSERT INTO tPLDmatrizConfiguracionTipoPersona(TipoPersona,Puntos) VALUES(2,20)
INSERT INTO tPLDmatrizConfiguracionTipoPersona(TipoPersona,Puntos) VALUES(3,10)
*/

SELECT * FROM tPLDmatrizConfiguracionTipoPersona

/*
INSERT INTO tPLDmatrizConfiguracionGenero(Genero,Puntos) VALUES('M',20)
INSERT INTO tPLDmatrizConfiguracionGenero(Genero,Puntos) VALUES('F',10)
*/

SELECT * FROM tPLDmatrizConfiguracionGenero

