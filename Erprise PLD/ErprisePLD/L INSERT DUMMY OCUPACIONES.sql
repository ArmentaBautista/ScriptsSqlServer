

/* INSERT DUMMY OCUPACIONES */
-- SELECT FLOOR(rand()*101)
-- -- Ocupacion = 1
-- SELECT * FROM tPLDmatrizConfiguracionOcupaciones
 TRUNCATE TABLE dbo.tPLDmatrizConfiguracionOcupaciones
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
	INSERT INTO dbo.tPLDmatrizConfiguracionOcupaciones (Tipo,IdValor,ValorDescripcion,Puntos) VALUES(1,@idValor,@ValorDescripcion,1)

    FETCH NEXT FROM miCursor INTO @idValor,@ValorDescripcion
END
CLOSE miCursor
DEALLOCATE miCursor
GO


SELECT * FROM tPLDmatrizConfiguracionOcupaciones
GO

