
-- 3.02 pCnPLDmatrizEvaluacionNivelDeRiesgo

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDmatrizEvaluacionNivelDeRiesgo')
BEGIN
	DROP PROC pCnPLDmatrizEvaluacionNivelDeRiesgo
	SELECT 'pCnPLDmatrizEvaluacionNivelDeRiesgo BORRADO' AS info
END
GO

CREATE PROC pCnPLDmatrizEvaluacionNivelDeRiesgo
@tipoOperacion VARCHAR(128),
@fechaInicial DATE='19000101',
@fechaFinal DATE='19000101',
@NoSocio VARCHAR(32)='',
@folioEvaluacion INT=0
AS
BEGIN
	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	-- CONFIGURACION

	IF @tipoOperacion='TIPOS_OPERACION_SOCIO'
	BEGIN
		SELECT *
		FROM (VALUES ('SOCIO_RESUMEN_EVALUACION'), ('SOCIO_DETALLE_EVALUACION')) AS TiposOperacion (TipoOperacion)

		RETURN 0
	END

	IF @tipoOperacion='TIPOS_OPERACION_MASIVA'
	BEGIN
		SELECT *
		FROM (VALUES ('EVALUACIONES'),  ('RESUMEN'), ('DETALLE'), ('NIVELES_DE_RIESGO')) AS TiposOperacion (TipoOperacion)
		
		RETURN 0
	END

	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	-- Evaluaciones del Socio
	IF @tipoOperacion='EVALUACIONES_POR_SOCIO_FECHA'
	BEGIN
		SELECT 
		eval.IdEvaluacionRiesgo AS Folio,
		eval.Fecha,
		eval.Agrupador AS Referencia,
		eval.Individual,
		eval.Masiva
		FROM tPLDmatrizEvaluacionesRiesgo eval WITH (NOLOCK)
		INNER JOIN  dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas cal WITH (NOLOCK)
			ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo
				AND cal.IdEstatus = 1
		INNER JOIN tscssocios sc WITH (NOLOCK) 
			ON sc.idsocio=cal.IdSocio
				AND sc.Codigo=@NoSocio
		WHERE eval.Fecha BETWEEN @fechaInicial AND @fechaFinal
		GROUP BY 
			eval.Fecha,
			eval.IdEvaluacionRiesgo,
			eval.Agrupador,
			eval.Individual,
			eval.Masiva
		ORDER BY eval.IdEvaluacionRiesgo DESC;

		RETURN 0
	END	
	
	IF @tipoOperacion='SOCIO_RESUMEN_EVALUACION'
	BEGIN
		SELECT eval.Fecha,
			   eval.IdEvaluacionRiesgo AS Folio,
			   eval.Agrupador AS Referencia,
			   eval.Individual,
			   eval.Masiva,
			   fin.Calificacion,
			   fin.NivelDeRiesgo,
			   fin.NivelDeRiesgoDescripcion AS Descripcion,
			   sc.Codigo AS NoSocio,
			   p.Nombre AS Socio,
			   cal.Factor,
			   cal.SumaFactor,
			   cal.PonderacionFactor,
			   cal.PuntajeFactor
		FROM tPLDmatrizEvaluacionesRiesgo eval WITH (NOLOCK)
			INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas cal WITH (NOLOCK)
				ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo
			INNER JOIN dbo.tSCSsocios sc WITH (NOLOCK)
				ON sc.IdSocio = cal.IdSocio
				AND sc.Codigo = @NoSocio
			INNER JOIN dbo.tGRLpersonas p WITH (NOLOCK)
				ON p.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales fin WITH (NOLOCK)
				ON fin.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo
				   AND fin.IdSocio = cal.IdSocio
		WHERE eval.IdEstatus = 1
			AND eval.IdEvaluacionRiesgo=@folioEvaluacion
		ORDER BY Socio,cal.Factor

		RETURN 0
	END

	IF @tipoOperacion='SOCIO_DETALLE_EVALUACION'
	BEGIN
		SELECT eval.Fecha,
			   eval.IdEvaluacionRiesgo AS Folio,
			   eval.Agrupador AS Referencia,
			   eval.Individual,
			   eval.Masiva,
			   fin.Calificacion,
			   fin.NivelDeRiesgo,
			   fin.NivelDeRiesgoDescripcion AS Descripcion,
			   sc.Codigo AS NoSocio,
			   p.Nombre AS Socio,
			   cal.Factor
			,cal.Elemento
			,cal.Valor
			,cal.ValorDescripcion
			,cal.Puntos
		FROM tPLDmatrizEvaluacionesRiesgo eval WITH (NOLOCK)
			INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones cal  WITH(NOLOCK) 
				ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo 
					AND cal.IdEstatus=1
			INNER JOIN dbo.tSCSsocios sc WITH (NOLOCK)
				ON sc.IdSocio = cal.IdSocio
				AND sc.Codigo = @NoSocio
			INNER JOIN dbo.tGRLpersonas p WITH (NOLOCK)
				ON p.IdPersona = sc.IdPersona
			INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales fin WITH (NOLOCK)
				ON fin.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo
				   AND fin.IdSocio = cal.IdSocio
		WHERE eval.IdEstatus = 1
			AND eval.IdEvaluacionRiesgo=@folioEvaluacion
		ORDER BY Socio ASC,cal.Factor ASC,cal.Elemento ASC

		RETURN 0
	END

	/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	-- MASIVAS

	IF @tipoOperacion='EVALUACIONES'
	BEGIN
		SELECT 
		eval.IdEvaluacionRiesgo AS Folio,
		eval.Fecha,
		eval.Agrupador AS Referencia,
		eval.Individual,
		eval.Masiva
		FROM tPLDmatrizEvaluacionesRiesgo eval WITH (NOLOCK)
		WHERE eval.Fecha
		BETWEEN @fechaInicial AND @fechaFinal
		ORDER BY eval.IdEvaluacionRiesgo DESC;

		RETURN 0
	END

	IF @tipoOperacion='RESUMEN'
	BEGIN
			SELECT eval.Fecha,
				   eval.IdEvaluacionRiesgo AS Folio,
				   eval.Agrupador AS Referencia,
				   eval.Individual,
				   eval.Masiva,
				   sc.Codigo AS NoSocio,
				   p.Nombre AS Socio,
				   cal.Factor,
				   cal.SumaFactor,
				   cal.PonderacionFactor,
				   cal.PuntajeFactor
			FROM tPLDmatrizEvaluacionesRiesgo eval WITH (NOLOCK)
				INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas cal WITH (NOLOCK)
					ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo
					   AND cal.IdEstatus = 1
				INNER JOIN dbo.tSCSsocios sc WITH (NOLOCK)
					ON sc.IdSocio = cal.IdSocio
				INNER JOIN dbo.tGRLpersonas p WITH (NOLOCK)
					ON p.IdPersona = sc.IdPersona
			WHERE eval.IdEstatus = 1
				  AND eval.Fecha BETWEEN @fechaInicial AND @fechaFinal
				  AND eval.IdEvaluacionRiesgo=@folioEvaluacion
			ORDER BY eval.IdEvaluacionRiesgo DESC, Socio,cal.Factor

		RETURN 0
	END

	IF @tipoOperacion='DETALLE'
	BEGIN
		SELECT eval.Fecha
			, eval.IdEvaluacionRiesgo AS Folio
			, eval.Agrupador AS Referencia
			, eval.Individual
			, eval.Masiva 
			, sc.Codigo AS NoSocio
			, p.Nombre AS Socio
			, cal.Factor
			,cal.Elemento
			,cal.Valor
			,cal.ValorDescripcion
			,cal.Puntos
		FROM tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones cal  WITH(NOLOCK)
			ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo 
				AND cal.IdEstatus=1
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = cal.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		WHERE eval.IdEstatus=1 
			AND eval.Fecha BETWEEN @fechaInicial AND @fechaFinal 
			AND eval.IdEvaluacionRiesgo=@folioEvaluacion
		ORDER BY eval.IdEvaluacionRiesgo DESC, Socio,cal.Factor,cal.Elemento

		RETURN 0
	END

	IF @tipoOperacion='NIVELES_DE_RIESGO'
	BEGIN
				SELECT 
				eval.Fecha,
			   eval.IdEvaluacionRiesgo AS Folio,
			   eval.Agrupador AS Referencia,
			   eval.Individual,
			   eval.Masiva,
			   sc.Codigo AS NoSocio,
			   p.Nombre AS Socio,
			   cal.Calificacion,
			   cal.NivelDeRiesgo,
			   cal.NivelDeRiesgoDescripcion AS Descripcion
		FROM tPLDmatrizEvaluacionesRiesgo eval WITH (NOLOCK)
			INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales cal WITH (NOLOCK)
				ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo
				   AND cal.IdEstatus = 1
			INNER JOIN dbo.tSCSsocios sc WITH (NOLOCK)
				ON sc.IdSocio = cal.IdSocio
			INNER JOIN dbo.tGRLpersonas p WITH (NOLOCK)
				ON p.IdPersona = sc.IdPersona
		WHERE eval.IdEstatus = 1
			  AND eval.Fecha BETWEEN @fechaInicial AND @fechaFinal
			  AND eval.IdEvaluacionRiesgo=@folioEvaluacion
		ORDER BY eval.IdEvaluacionRiesgo DESC, p.Nombre

		RETURN 0
	END



END
GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pCnPLDmatrizEvaluacionNivelDeRiesgo')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pCnPLDmatrizEvaluacionNivelDeRiesgo')
END
GO

