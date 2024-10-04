

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDmatrizEvaluacionNivelDeRiesgo')
BEGIN
	DROP PROC pCnPLDmatrizEvaluacionNivelDeRiesgo
	SELECT 'pCnPLDmatrizEvaluacionNivelDeRiesgo BORRADO' AS info
END
GO

CREATE PROC pCnPLDmatrizEvaluacionNivelDeRiesgo
@tipoOperacion VARCHAR(24),
@fechaInicial DATE='19000101',
@fechaFinal DATE='19000101',
@NoSocio VARCHAR(32)=''
AS
BEGIN
	IF @tipoOperacion='EVAL'
	BEGIN
		SELECT eval.Fecha, eval.IdEvaluacionRiesgo AS Folio, eval.Agrupador AS Referencia, eval.Individual, eval.Masiva 
		FROM tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
		WHERE eval.Fecha BETWEEN @fechaInicial AND @fechaFinal ORDER BY eval.IdEvaluacionRiesgo DESC
		
		RETURN 0
	END

	IF @tipoOperacion='DETALLE'
	BEGIN
		SELECT eval.Fecha, eval.IdEvaluacionRiesgo AS Folio, eval.Agrupador AS Referencia, eval.Individual, eval.Masiva 
		, sc.Codigo AS NoSocio, p.Nombre AS Socio
		, cal.Factor,cal.Elemento,cal.Valor,cal.ValorDescripcion,cal.Puntos
		FROM tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones cal  WITH(NOLOCK) ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo AND cal.IdEstatus=1
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = cal.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		WHERE eval.IdEstatus=1 AND eval.Fecha BETWEEN @fechaInicial AND @fechaFinal ORDER BY eval.IdEvaluacionRiesgo DESC

		RETURN 0
	END

	IF @tipoOperacion='RESUMEN'
	BEGIN
		SELECT eval.Fecha, eval.IdEvaluacionRiesgo AS Folio, eval.Agrupador AS Referencia, eval.Individual, eval.Masiva 
		, sc.Codigo AS NoSocio, p.Nombre AS Socio
		, cal.Factor,cal.SumaFactor,cal.PonderacionFactor,cal.PuntajeFactor
		FROM tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas cal  WITH(NOLOCK) ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo AND cal.IdEstatus=1
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = cal.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		WHERE eval.IdEstatus=1 AND eval.Fecha BETWEEN @fechaInicial AND @fechaFinal ORDER BY eval.IdEvaluacionRiesgo DESC

		RETURN 0
	END

	IF @tipoOperacion='NIVELES'
	BEGIN
		SELECT eval.Fecha, eval.IdEvaluacionRiesgo AS Folio, eval.Agrupador AS Referencia, eval.Individual, eval.Masiva 
		, sc.Codigo AS NoSocio, p.Nombre AS Socio
		, cal.Calificacion, cal.NivelDeRiesgo, cal.NivelDeRiesgoDescripcion AS Descripción
		FROM tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales cal  WITH(NOLOCK) ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo AND cal.IdEstatus=1
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = cal.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		WHERE eval.IdEstatus=1 AND eval.Fecha BETWEEN @fechaInicial AND @fechaFinal ORDER BY eval.IdEvaluacionRiesgo DESC

		RETURN 0
	END

	IF @tipoOperacion='SOCIO'
	BEGIN
		SELECT eval.Fecha, eval.IdEvaluacionRiesgo AS Folio, eval.Agrupador AS Referencia, eval.Individual, eval.Masiva 
		, fin.Calificacion, fin.NivelDeRiesgo, fin.NivelDeRiesgoDescripcion AS Descripción
		, sc.Codigo AS NoSocio, p.Nombre AS Socio
		, cal.Factor,cal.SumaFactor,cal.PonderacionFactor,cal.PuntajeFactor
		FROM tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas cal  WITH(NOLOCK) ON cal.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo 
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = cal.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona																					
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales fin  WITH(NOLOCK) ON fin.IdEvaluacionRiesgo = eval.IdEvaluacionRiesgo AND fin.IdSocio = cal.IdSocio
		WHERE eval.IdEstatus=1 AND sc.Codigo=@NoSocio ORDER BY eval.IdEvaluacionRiesgo DESC

		RETURN 0
	END

END