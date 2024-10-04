

/* INSERT DUMMY LISTAS Y TERCEROS */
-- SELECT FLOOR(rand()*101)
-- PropietarioReal=1, ProveedorRecursos=2, PEP=3, PEP Asimilado=4, ListarRIESGO=5, ListaBloqueada=6

-- SELECT * FROM tPLDmatrizConfiguracionListas
 TRUNCATE TABLE tPLDmatrizConfiguracionListas


INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(1,1,'Propietario Real',FLOOR(rand()*101))
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(2,1,'Proveedor Recursos',FLOOR(rand()*101))
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(3,1,'PEP',FLOOR(rand()*101))
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(4,1,'PEP Asimilado',FLOOR(rand()*101))
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(5,1,'ListarRIESGO',FLOOR(rand()*101))
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(6,1,'ListaBloqueada',FLOOR(rand()*101))
GO
   