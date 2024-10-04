



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDobtenerUltimoPerfilSocios')
BEGIN
	DROP FUNCTION dbo.fnPLDobtenerUltimoPerfilSocios
	SELECT 'fnPLDobtenerUltimoPerfilSocios BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDobtenerUltimoPerfilSocios(
@pIdSocio			INT
)
RETURNS @perfiles TABLE(
	IdEvaluacionRiesgo	INT,
	IdPersona			INT,
	IdSocio				INT,
	IdFactor			INT,
	Factor				VARCHAR(64),
	Elemento			VARCHAR(128),
	Valor				VARCHAR(10),
	ValorDescripcion	VARCHAR(256)

)
BEGIN
	DECLARE @IdUltimaEvaluacion INT=0
	DECLARE @IdPenultimaEvaluacion INT=0

	DECLARE @evals TABLE(
		IdSocio	INT,
		Numero INT,
		IdEvaluacionRiesgo INT,
		INDEX IxIdSocio(IdSocio),
		INDEX IxNumero(Numero),
		INDEX IxIdEvaluacionRiesgo(IdEvaluacionRiesgo)
	)

	INSERT @evals
	SELECT 
	 e.IdSocio
	,ROW_NUMBER() OVER(PARTITION BY IdSocio ORDER BY e.IdEvaluacionRiesgo DESC) AS Numero
	,e.IdEvaluacionRiesgo
	FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales e WITH(NOLOCK) 
	WHERE e.IdEstatus=1 AND (@pIdSocio=0 OR e.IdSocio=@pIdSocio)
	GROUP BY e.IdSocio, e.IdEvaluacionRiesgo ORDER BY Numero ASC

	INSERT @perfiles
	SELECT cal.IdEvaluacionRiesgo,
           cal.IdPersona,
           cal.IdSocio,
           cal.IdFactor,
           cal.Factor,
           cal.Elemento,
           cal.Valor,
           cal.ValorDescripcion
	FROM @evals e
	INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones cal  WITH(NOLOCK) 
		ON cal.IdEvaluacionRiesgo = e.IdEvaluacionRiesgo
	WHERE e.Numero=1 
		AND e.IdSocio=cal.IdSocio

	RETURN
END
GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='fnPLDobtenerUltimoPerfilSocios')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('fnPLDobtenerUltimoPerfilSocios')
END
GO