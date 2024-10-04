


/* INSERT DUMMY ACTIVIDAD */
-- SELECT FLOOR(rand()*101)
-- Actividad=1

-- SELECT * FROM tPLDmatrizConfiguracionActividade
TRUNCATE TABLE tPLDmatrizConfiguracionActividad
GO

 /* declare variables */
 DECLARE @IdListaDactividad INT
 DECLARE @Actividad VARCHAR(64)=''
 
 DECLARE curSuc CURSOR FAST_FORWARD READ_ONLY FOR 
									 SELECT 
										ld.IdListaD, 
										ld.Descripcion 
									 FROM dbo.tCATlistasD ld  WITH(NOLOCK) 
									 INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
										ON ea.IdEstatusActual = ld.IdEstatusActual
											AND ea.IdEstatus=1
									 WHERE ld.IdTipoE=185 
 OPEN curSuc
 FETCH NEXT FROM curSuc INTO @IdListaDactividad, @Actividad
 WHILE @@FETCH_STATUS = 0
 BEGIN
     
	 INSERT INTO dbo.tPLDmatrizConfiguracionActividad(Tipo,IdValor,ValorDescripcion,Puntos) VALUES(1, @IdListaDactividad,@Actividad,1)

     FETCH NEXT FROM curSuc INTO @IdListaDactividad, @Actividad
 END
 
 CLOSE curSuc
 DEALLOCATE curSuc
 GO



 SELECT * FROM tPLDmatrizConfiguracionActividad
GO




