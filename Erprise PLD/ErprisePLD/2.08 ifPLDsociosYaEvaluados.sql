
/********  JCA.14/8/2024.04:23 Info: Devuelve los socios que han tenido por lo menos una evaluación  ********/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='ifPLDsociosYaEvaluados')
BEGIN
	DROP FUNCTION dbo.ifPLDsociosYaEvaluados
	SELECT 'ifPLDsociosYaEvaluados BORRADO' AS info
END
GO

CREATE FUNCTION dbo.ifPLDsociosYaEvaluados()
RETURNS TABLE
AS
RETURN (
    SELECT IdSocio 
	FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales  WITH(NOLOCK)
	WHERE IdEstatus=1
	GROUP BY IdSocio
)
GO



