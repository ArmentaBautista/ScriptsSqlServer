

/* INSERT DUMMY INGRESOS */
-- SELECT FLOOR(rand()*101)
-- -- Ocupacion = 1, RangoPF=2, RangoPM=3
-- SELECT * FROM tPLDmatrizConfiguracionIngresos
 TRUNCATE TABLE tPLDmatrizConfiguracionIngresos

 /* RANGOS PF*/
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,1,5000,'Ingresos PF',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,5001,15000,'Ingresos PF',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,15001,50000,'Ingresos PF',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(2,50001,100000,'Ingresos PF',FLOOR(rand()*101))
 GO

  /* RANGOS PM*/
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,1,30000,'Ingresos PM',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,30001,100000,'Ingresos PM',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,100001,500000,'Ingresos PM',FLOOR(rand()*101))
 GO
 INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos) VALUES(3,500001,3000000,'Ingresos PM',FLOOR(rand()*101))
 GO


/* OCUPACIONES */
DECLARE @idValor INT
DECLARE @ValorDescripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR SELECT ld.IdListaD,ld.Descripcion from dbo.tCATlistasD ld  WITH(NOLOCK) 
															INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = ld.IdEstatusActual AND ea.IdEstatus=1
															WHERE ld.IdTipoE=36

OPEN miCursor
FETCH NEXT FROM miCursor INTO @idValor,@ValorDescripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionIngresos (Tipo,IdValor1,ValorDescripcion,Puntos) VALUES(1,@idValor,@ValorDescripcion,FLOOR(rand()*101))

    FETCH NEXT FROM miCursor INTO @idValor,@ValorDescripcion
END
CLOSE miCursor
DEALLOCATE miCursor
GO



