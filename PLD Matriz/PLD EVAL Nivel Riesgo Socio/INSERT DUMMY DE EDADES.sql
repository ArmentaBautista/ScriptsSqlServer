


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
delete from tPLDmatrizConfiguracionTipoSocio
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(1,'Menor',30)
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(2,'Mayor (PF)',20)
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(3,'Moral',10)
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(4,'PF Act. Empresarial',10)
*/

SELECT * FROM tPLDmatrizConfiguracionTipoSocio

/*
DELETE FROM tPLDmatrizConfiguracionGenero
INSERT INTO tPLDmatrizConfiguracionGenero(Genero,Descripcion,Puntos) VALUES('M','Masculino',20)
INSERT INTO tPLDmatrizConfiguracionGenero(Genero,Descripcion,Puntos) VALUES('F','Femenino',10)
*/

SELECT * FROM tPLDmatrizConfiguracionGenero

