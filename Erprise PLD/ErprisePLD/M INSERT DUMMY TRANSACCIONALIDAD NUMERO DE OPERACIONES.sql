



/* INSERT DUMMY TRANSACCIONALIDAD NUMERO DE OPERACIONES */
-- SELECT FLOOR(rand()*101)
-- Numero Dep Mes Menores = 1,  Numero Ret Mes Menores = 2,
-- Numero Dep Mes Mayores = 3,  Numero Ret Mes Mayores = 4,
-- Numero Dep Mes Morales = 5,  Numero Ret Mes Morales = 6

-- SELECT * FROM tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
 TRUNCATE TABLE tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
GO

 /* RANGOS MENORES*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,1,5,'N�mero Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,6,10,'N�mero Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,11,15,'N�mero Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(1,16,1000,'N�mero Dep Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,1,5,'N�mero Ret Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,6,10,'N�mero Ret Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,11,15,'N�mero Ret Mes Menores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,16,1000,'N�mero Ret Mes Menores',0)
 GO

  /* RANGOS MAYOR*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,1,20,'N�mero Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,21,30,'N�mero Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,31,40,'N�mero Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,41,1000,'N�mero Dep Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,1,20,'N�mero Ret Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,21,30,'N�mero Ret Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,31,40,'N�mero Ret Mes Mayores',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(4,41,1000,'N�mero Ret Mes Mayores',0)
 GO

   /* RANGOS MORAL*/
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,1,30,'N�mero Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,31,60,'N�mero Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,61,80,'N�mero Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(5,81,1000,'N�mero Dep Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,1,30,'N�mero Ret Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,31,60,'N�mero Ret Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,61,80,'N�mero Ret Mes Morales',0)
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(6,81,1000,'N�mero Ret Mes Morales',0)
 GO


  SELECT * FROM tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones
  GO

