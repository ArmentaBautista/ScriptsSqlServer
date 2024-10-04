



/* INSERT DUMMY INSTRUMENTOS */
-- SELECT FLOOR(rand()*101)
-- 1: Instrumentos 2: Canales
-- SELECT * FROM tPLDmatrizConfiguracionInstrumentosCanales
 TRUNCATE TABLE tPLDmatrizConfiguracionInstrumentosCanales



 /* PRODUCTOS */

-- cursor de inserci�n para generar el puntaje  dummy
DECLARE @IdRegistro INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT mp.IdMetodoPago, mp.Descripcion FROM dbo.tCATmetodosPago mp  WITH(NOLOCK) WHERE mp.IdMetodoPago<>0
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdRegistro,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionInstrumentosCanales (Tipo,IdValor1,ValorDescripcion,Puntos) VALUES(1,@IdRegistro,@descripcion,FLOOR(RAND()*101))

    FETCH NEXT FROM miCursor INTO @IdRegistro,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor

GO
     

SELECT * FROM tPLDmatrizConfiguracionInstrumentosCanales

