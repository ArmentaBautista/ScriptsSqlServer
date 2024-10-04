

/* INSERT DUMMY SUCURSALES */
-- SELECT FLOOR(rand()*101)
-- Sucursal del Socio=1

-- SELECT * FROM tPLDmatrizConfiguracionSucursales
TRUNCATE TABLE tPLDmatrizConfiguracionSucursales
GO

 /* declare variables */
 DECLARE @IdSucursal INT
 DECLARE @Sucursal VARCHAR(64)=''
 
 DECLARE curSuc CURSOR FAST_FORWARD READ_ONLY FOR 
						SELECT suc.IdSucursal, suc.Descripcion from dbo.tCTLsucursales suc  WITH(NOLOCK) WHERE suc.IdSucursal<>0 
 OPEN curSuc
 FETCH NEXT FROM curSuc INTO @IdSucursal, @Sucursal
 WHILE @@FETCH_STATUS = 0
 BEGIN
     
	 INSERT INTO dbo.tPLDmatrizConfiguracionSucursales(Tipo,IdValor,ValorDescripcion,Puntos) VALUES(1, @IdSucursal,@Sucursal,1)

     FETCH NEXT FROM curSuc INTO @IdSucursal, @Sucursal
 END
 
 CLOSE curSuc
 DEALLOCATE curSuc
 GO



 SELECT * FROM tPLDmatrizConfiguracionSucursales
GO






   