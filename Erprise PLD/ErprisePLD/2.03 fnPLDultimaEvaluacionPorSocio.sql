 
 IF EXISTS(SELECT name FROM sys.objects o WHERE o.name=N'fnPLDultimaEvaluacionPorSocio')
 BEGIN
 	DROP FUNCTION fnPLDultimaEvaluacionPorSocio
 	SELECT 'fnPLDultimaEvaluacionPorSocio BORRADO' AS info
 END
 GO
 
 CREATE FUNCTION fnPLDultimaEvaluacionPorSocio(@pIdSocio INT)
 RETURNS @eval TABLE(
	IdSocio						INT PRIMARY KEY,
	IdEvaluacionRiesgo			INT, 
	Calificacion				NUMERIC(10,2), 
	NivelDeRiesgo				SMALLINT, 
	NivelDeRiesgoDescripcion	VARCHAR(32),

	INDEX IX_IdEvaluacionRiesgo (IdEvaluacionRiesgo),
	INDEX IX_NivelDeRiesgo (NivelDeRiesgo),
	INDEX IX_NivelDeRiesgoDescripcion (NivelDeRiesgoDescripcion)
 )
 AS
 BEGIN
	DECLARE @ultimas TABLE(
		IdSocio			INT PRIMARY KEY,
		IdEvaluacion	INT,

		INDEX IX_IdEval (IdEvaluacion)
	)

	INSERT INTO @ultimas(IdSocio,IdEvaluacion)
	SELECT r.IdSocio, MAX(r.IdEvaluacionRiesgo)  
	FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales r  WITH(NOLOCK) 
	WHERE r.IdEstatus=1
		AND (@pIdSocio=0 OR r.IdSocio=@pIdSocio)
	GROUP BY r.IdSocio
	
	INSERT INTO @eval
	SELECT r.IdSocio, r.IdEvaluacionRiesgo, r.Calificacion, r.NivelDeRiesgo, r.NivelDeRiesgoDescripcion
	FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales r  WITH(NOLOCK)
	INNER JOIN @ultimas u 
		ON u.IdSocio = r.IdSocio
			AND r.IdEvaluacionRiesgo=u.IdEvaluacion

	RETURN
 END
 GO

 
IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='fnPLDultimaEvaluacionPorSocio')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('fnPLDultimaEvaluacionPorSocio')
END
GO

