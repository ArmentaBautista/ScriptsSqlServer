

/********  JCA.25/4/2024.01:43 Info: TIPOS DE SOCIOS  ********/

DELETE FROM tPLDmatrizConfiguracionTipoSocio
GO

INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(1,'Menor',1)
GO
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(2,'Mayor (PF)',1)
GO
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(3,'Moral',1)
GO
INSERT INTO tPLDmatrizConfiguracionTipoSocio(TipoSocio,Descripcion,Puntos) VALUES(4,'PF Act. Empresarial',1)
GO

SELECT * FROM tPLDmatrizConfiguracionTipoSocio
GO





/* INSERT DUMMY DE EDADES */

TRUNCATE table dbo.tPLDmatrizconfiguracionEdades
GO 
/********  JCA.25/4/2024.01:45 Info: PF  ********/
DECLARE @contador AS INT=0
WHILE @contador<=110 
BEGIN	
	INSERT INTO dbo.tPLDmatrizconfiguracionEdades (tipo,edad,puntos) VALUES (2,@contador,1)
	SET @contador=@contador+1
END
GO

/********  JCA.25/4/2024.01:46 Info: PM  ********/
DECLARE @contador AS INT=0
WHILE @contador<=110 
BEGIN	
	INSERT INTO dbo.tPLDmatrizconfiguracionEdades (tipo,edad,puntos) VALUES (3,@contador,1)
	SET @contador=@contador+1
END
GO

SELECT * FROM tPLDmatrizconfiguracionEdades
GO 


 /* INSERT DUMMY DE GÉNEROS*/

DELETE FROM tPLDmatrizConfiguracionGenero
GO

INSERT INTO tPLDmatrizConfiguracionGenero(Genero,Descripcion,Puntos) VALUES('M','Masculino',1)
GO

INSERT INTO tPLDmatrizConfiguracionGenero(Genero,Descripcion,Puntos) VALUES('F','Femenino',1)
GO

SELECT * FROM tPLDmatrizConfiguracionGenero
GO 

