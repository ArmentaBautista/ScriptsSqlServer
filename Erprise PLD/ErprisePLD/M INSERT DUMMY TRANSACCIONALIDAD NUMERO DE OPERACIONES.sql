



/* INSERT DUMMY TRANSACCIONALIDAD NUMERO DE OPERACIONES */
-- SELECT FLOOR(rand()*101)
-- Numero Dep Mes Menores = 1,  Numero Ret Mes Menores = 2,
-- Numero Dep Mes Mayores = 3,  Numero Ret Mes Mayores = 4,
-- Numero Dep Mes Morales = 5,  Numero Ret Mes Morales = 6

-- SELECT * FROM tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
 TRUNCATE TABLE tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
GO

 /* RANGOS MENORES*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,1,5,'Número Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,6,10,'Número Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,11,15,'Número Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,16,1000,'Número Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,1,5,'Número Ret Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,6,10,'Número Ret Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,11,15,'Número Ret Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,16,1000,'Número Ret Mes Menores',0)
 GO

  /* RANGOS MAYOR*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,1,20,'Número Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,21,30,'Número Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,31,40,'Número Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,41,1000,'Número Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,1,20,'Número Ret Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,21,30,'Número Ret Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,31,40,'Número Ret Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,41,1000,'Número Ret Mes Mayores',0)
 GO

   /* RANGOS MORAL*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,1,30,'Número Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,31,60,'Número Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,61,80,'Número Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,81,1000,'Número Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,1,30,'Número Ret Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,31,60,'Número Ret Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,61,80,'Número Ret Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,81,1000,'Número Ret Mes Morales',0)
 GO


  SELECT * FROM tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
  GO

