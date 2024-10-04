
/* JCA.18/4/2024.21:20 
Nota: Obtiene las preguntas y respuestas de un Cuestionario de erprise
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnEBSpreguntasYrespuestasEncuestaBajaSocio')
BEGIN
	DROP FUNCTION dbo.fnEBSpreguntasYrespuestasEncuestaBajaSocio
	SELECT 'fnEBSpreguntasYrespuestasEncuestaBajaSocio BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnEBSpreguntasYrespuestasEncuestaBajaSocio(
@pIdCuestionario INT
)
RETURNS TABLE
RETURN(
		SELECT 
		reac.IdCuestionario,
		reac.IdReactivo,
		reac.IdTipoDreactivo,
		[TipoReactivo]	= d.Descripcion,
		reac.Enunciado,
		[IdRespuesta]	= ISNULL(resp.IdRespuesta,0),
		[Respuesta]		= ISNULL(resp.Descripcion,''),
		[Elegida]		= ISNULL(resp.FueElegida,0)
		FROM dbo.tGRLreactivos reac WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposD d  WITH(NOLOCK) 
			ON d.IdTipoD = reac.IdTipoDreactivo
		LEFT JOIN dbo.tGRLrespuestas resp WITH(NOLOCK) 
			ON reac.IdReactivo = resp.IdReactivo
				AND  resp.IdEstatus=1
		WHERE reac.IdEstatus=1
			AND reac.IdCuestionario=@pIdCuestionario
)
GO
SELECT 'fnEBSpreguntasYrespuestasEncuestaBajaSocio CREADO' as Info
GO



