
/* INSERT DUMMY GEOGRAFÍA */
-- SELECT FLOOR(rand()*101)
-- Asentamiento=1, Ciudad=2, Municipio=3, Estado=4, País=5
-- SELECT * FROM tPLDmatrizConfiguracionGeografia
 TRUNCATE TABLE tPLDmatrizConfiguracionGeografia

/* ASENTAMIENTOS */
DECLARE @IdAsentamiento INT
DECLARE @descripcion VARCHAR(128)
DECLARE asentamientos CURSOR local FAST_FORWARD READ_ONLY FOR SELECT a.IdAsentamiento,a.Descripcion FROM dbo.tCTLasentamientos a  WITH(NOLOCK) WHERE a.IdEstatus=1
OPEN asentamientos
FETCH NEXT FROM asentamientos INTO @IdAsentamiento,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(1,@IdAsentamiento,@descripcion,FLOOR(rand()*101))

    FETCH NEXT FROM asentamientos INTO @IdAsentamiento,@descripcion
END
CLOSE asentamientos
DEALLOCATE asentamientos
GO

/* Ciudades */
DECLARE @IdUbicacion INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR SELECT a.IdCiudad,a.Descripcion FROM dbo.tCTLciudades a  WITH(NOLOCK) WHERE a.IdEstatus=1
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(2,@IdUbicacion,@descripcion,FLOOR(rand()*101))

    FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor
GO

/* Municipios */
DECLARE @IdUbicacion INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR SELECT a.IdMunicipio,a.Descripcion FROM dbo.tCTLmunicipios a  WITH(NOLOCK) WHERE a.IdEstatus=1
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(3,@IdUbicacion,@descripcion,FLOOR(rand()*101))

    FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor
GO

/* Estados */
DECLARE @IdUbicacion INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR SELECT a.IdEstado,a.Descripcion FROM dbo.tCTLestados a  WITH(NOLOCK) WHERE a.IdEstatus=1
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(4,@IdUbicacion,@descripcion,FLOOR(rand()*101))

    FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor
GO


