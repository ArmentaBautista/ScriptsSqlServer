


/* INSERT DUMMY LISTAS Y TERCEROS */
-- SELECT FLOOR(rand()*101)
-- PropietarioReal=1, ProveedorRecursos=2, PEP=3, PEP Asimilado=4, ListarRIESGO=5, ListaBloqueada=6

-- SELECT * FROM tPLDmatrizConfiguracionListas
 TRUNCATE TABLE tPLDmatrizConfiguracionListas
GO

INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(1,1,'Propietario Real',1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(2,1,'Proveedor Recursos',1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(3,1,'PEP',1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(4,1,'PEP Asimilado',1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(5,1,'ListaRIESGO',1)
GO
INSERT INTO dbo.tPLDmatrizConfiguracionListas (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(6,1,'ListaBloqueada',1)
GO
   