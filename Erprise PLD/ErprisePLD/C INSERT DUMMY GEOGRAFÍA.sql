



/* INSERT DUMMY GEOGRAFIA */
-- SELECT FLOOR(rand()*101)
-- Asentamiento=1, Ciudad=2, Municipio=3, Estado=4, Pa�s=5, Nacionalidad = 6
-- SELECT * FROM tPLDmatrizConfiguracionGeografia
 TRUNCATE TABLE tPLDmatrizConfiguracionGeografia
 GO
 
/* INFO (⊙_☉) JCA.17/08/2023.09:43 a. m. 
Nota: Tabla para almacenar los asentamientos de socios activos del sistema, serviran de eje para los llenados */

DECLARE @AsentamientosSociosActivos TABLE(
	IdAsentamiento INT PRIMARY KEY
 )

INSERT INTO @AsentamientosSociosActivos
SELECT dom.IdAsentamiento
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) 
	ON dom.IdRel=p.IdRelDomicilios
		AND dom.IdAsentamiento<>0
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = dom.IdEstatusActual
		AND ea.IdEstatus=1
WHERE sc.IdEstatus=1 AND sc.EsSocioValido=1
GROUP BY dom.IdAsentamiento


 /*
--- ASENTAMIENTOS 
DECLARE @IdAsentamiento INT
DECLARE @descripcion VARCHAR(128)
DECLARE asentamientos CURSOR local FAST_FORWARD READ_ONLY FOR SELECT dom.IdAsentamiento, CONCAT(a.Descripcion,' - ',cd.Descripcion,' - ',mun.Descripcion,' - ',edo.Descripcion)
																FROM @AsentamientosSociosActivos dom
																INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento
																LEFT JOIN dbo.tCTLciudades cd  WITH(NOLOCK) ON cd.IdCiudad = a.IdCiudad
																LEFT JOIN dbo.tCTLmunicipios mun  WITH(NOLOCK) ON mun.IdMunicipio = a.IdMunicipio
																LEFT JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = mun.IdEstado

OPEN asentamientos
FETCH NEXT FROM asentamientos INTO @IdAsentamiento,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionGeografia  WITH(NOLOCK) 
					WHERE Tipo=1 AND IdUbicacion=@IdAsentamiento)
		INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(1,@IdAsentamiento,@descripcion,1)

    FETCH NEXT FROM asentamientos INTO @IdAsentamiento,@descripcion
END
CLOSE asentamientos
DEALLOCATE asentamientos


-- Ciudades
DECLARE @IdUbicacionCd INT
DECLARE @descripcionCd VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR	SELECT a.IdCiudad, CONCAT('Cd: ',cd.Descripcion,' - ',edo.Descripcion)
															FROM (
																	SELECT a.IdCiudad
																	FROM @AsentamientosSociosActivos dom
																	INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento 
																	WHERE a.IdCiudad<>0
																	GROUP BY a.IdCiudad
															) a
															LEFT JOIN dbo.tCTLciudades cd  WITH(NOLOCK) ON cd.IdCiudad = a.IdCiudad 
															LEFT JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = cd.IdEstado

OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdUbicacionCd,@descripcionCd
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionGeografia  WITH(NOLOCK) 
					WHERE Tipo=2 AND IdUbicacion=@IdUbicacionCd)
		INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(2,@IdUbicacionCd,@descripcionCd,1)

    FETCH NEXT FROM miCursor INTO @IdUbicacionCd,@descripcionCd
END
CLOSE miCursor
DEALLOCATE miCursor

*/

/* Municipios */

DECLARE @IdUbicacion INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR 
														SELECT cd.IdMunicipio, CONCAT('Mun: ',cd.Descripcion,' - ',edo.Descripcion)
														FROM (
																SELECT a.IdMunicipio
																FROM @AsentamientosSociosActivos dom
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
	IF NOT EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionGeografia  WITH(NOLOCK) 
					WHERE Tipo=3 AND IdUbicacion=@IdUbicacion)
			INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(3,@IdUbicacion,@descripcion,1)

    FETCH NEXT FROM miCursor INTO @IdUbicacion,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor


/* Estados */
DECLARE @IdUbicacionEdo INT
DECLARE @descripcionEdo VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR 
														SELECT cd.IdEstado, edo.Descripcion
														FROM (
																SELECT a.IdMunicipio
																FROM @AsentamientosSociosActivos dom
																INNER JOIN dbo.tCTLasentamientos a  WITH(NOLOCK) ON a.IdAsentamiento = dom.IdAsentamiento 
																WHERE a.IdMunicipio<>0
																GROUP BY a.IdMunicipio
														) a
														INNER JOIN dbo.tCTLmunicipios cd  WITH(NOLOCK) ON cd.IdMunicipio=a.IdMunicipio
														INNER JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = cd.IdEstado
														GROUP BY cd.IdEstado, edo.Descripcion
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdUbicacionEdo,@descripcionEdo
WHILE @@FETCH_STATUS = 0
BEGIN    
	IF NOT EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionGeografia  WITH(NOLOCK) 
					WHERE Tipo=4 AND IdUbicacion=@IdUbicacionEdo)
			INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(4,@IdUbicacionEdo,@descripcionEdo,1)

    FETCH NEXT FROM miCursor INTO @IdUbicacionEdo,@descripcionEdo
END
CLOSE miCursor
DEALLOCATE miCursor
GO

/* Países */
DECLARE @IdUbicacionPais INT
DECLARE @descripcionPais VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR 
														SELECT pais.IdPais, pais.Descripcion
														FROM dbo.tCTLpaises pais  WITH(NOLOCK) WHERE pais.IdPais<>0
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdUbicacionPais,@descripcionPais
WHILE @@FETCH_STATUS = 0
BEGIN    
	IF NOT EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionGeografia  WITH(NOLOCK) 
					WHERE Tipo=5 AND IdUbicacion=@IdUbicacionPais)
			INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(5,@IdUbicacionPais,@descripcionPais,1)

    FETCH NEXT FROM miCursor INTO @IdUbicacionPais,@descripcionPais
END
CLOSE miCursor
DEALLOCATE miCursor
GO

/* Nacionalidad */
DECLARE @IdNacionalidad INT
DECLARE @descripcionNacionalidad VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR 
														SELECT nac.IdNacionalidad, nac.Descripcion
														FROM dbo.tCTLnacionalidades nac  WITH(NOLOCK)
														WHERE nac.IdNacionalidad<>0
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdNacionalidad,@descripcionNacionalidad
WHILE @@FETCH_STATUS = 0
BEGIN    
	IF NOT EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionGeografia  WITH(NOLOCK) 
					WHERE Tipo=6 AND IdUbicacion=@IdNacionalidad)
			INSERT INTO dbo.tPLDmatrizConfiguracionGeografia (Tipo,IdUbicacion,Descripcion,Puntos) VALUES(6,@IdNacionalidad,@descripcionNacionalidad,1)

    FETCH NEXT FROM miCursor INTO @IdNacionalidad,@descripcionNacionalidad
END
CLOSE miCursor
DEALLOCATE miCursor
GO

 SELECT * FROM tPLDmatrizConfiguracionGeografia
 GO
 

 