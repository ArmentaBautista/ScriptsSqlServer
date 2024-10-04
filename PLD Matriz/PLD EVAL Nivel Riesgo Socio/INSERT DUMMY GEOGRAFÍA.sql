
/* INSERT DUMMY GEOGRAFÍA */
-- SELECT FLOOR(rand()*101)
-- Asentamiento=1, Ciudad=2, Municipio=3, Estado=4, País=5
-- SELECT * FROM tPLDmatrizConfiguracionGeografia
 TRUNCATE TABLE tPLDmatrizConfiguracionGeografia

/* ASENTAMIENTOS */
DECLARE @IdAsentamiento INT
DECLARE @descripcion VARCHAR(128)
DECLARE asentamientos CURSOR local FAST_FORWARD READ_ONLY FOR SELECT dom.IdAsentamiento, CONCAT(a.Descripcion,' - ',cd.Descripcion,' - ',mun.Descripcion,' - ',edo.Descripcion)
																FROM (
																		SELECT dom.IdAsentamiento FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
																		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
																		WHERE dom.IdAsentamiento<>0
																		GROUP BY dom.IdAsentamiento
																	) dom
																INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento
																LEFT JOIN dbo.tCTLciudades cd  WITH(NOLOCK) ON cd.IdCiudad = a.IdCiudad
																LEFT JOIN dbo.tCTLmunicipios mun  WITH(NOLOCK) ON mun.IdMunicipio = a.IdMunicipio
																LEFT JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = mun.IdEstado

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
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR	SELECT a.IdCiudad, CONCAT('Cd: ',cd.Descripcion,' - ',edo.Descripcion)
															FROM (
																	SELECT a.IdCiudad
																	FROM (
																			SELECT dom.IdAsentamiento FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
																			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
																			WHERE dom.IdAsentamiento<>0
																			GROUP BY dom.IdAsentamiento
																		) dom
																	INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento 
																	WHERE a.IdCiudad<>0
																	GROUP BY a.IdCiudad
															) a
															LEFT JOIN dbo.tCTLciudades cd  WITH(NOLOCK) ON cd.IdCiudad = a.IdCiudad 
															LEFT JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = cd.IdEstado

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
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR 
														SELECT cd.IdMunicipio, CONCAT('Mun: ',cd.Descripcion,' - ',edo.Descripcion)
														FROM (
																SELECT a.IdMunicipio
																FROM (
																		SELECT dom.IdAsentamiento FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
																		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
																		WHERE dom.IdAsentamiento<>0
																		GROUP BY dom.IdAsentamiento
																	) dom
																INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento 
																WHERE a.IdMunicipio<>0
																GROUP BY a.IdMunicipio
														) a
														INNER JOIN  dbo.tCTLmunicipios cd  WITH(NOLOCK) ON cd.IdMunicipio=a.IdMunicipio
														LEFT JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = cd.IdEstado
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
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR 
														SELECT cd.IdEstado, edo.Descripcion
														FROM (
																SELECT a.IdMunicipio
																FROM (
																		SELECT dom.IdAsentamiento FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
																		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
																		WHERE dom.IdAsentamiento<>0
																		GROUP BY dom.IdAsentamiento
																	) dom
																INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento 
																WHERE a.IdMunicipio<>0
																GROUP BY a.IdMunicipio
														) a
														INNER JOIN dbo.tCTLmunicipios cd  WITH(NOLOCK) ON cd.IdMunicipio=a.IdMunicipio
														INNER JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = cd.IdEstado
														GROUP BY cd.IdEstado, edo.Descripcion
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


