
USE iERP_DRA_TEST
go

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDmatrizEvaluacionEdades')
BEGIN
	DROP FUNCTION fnPLDmatrizEvaluacionEdades
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDmatrizEvaluacionEdades(
@fechaTrabajo DATE,
@idSocio int
)
RETURNS TABLE
AS
RETURN(
	SELECT pf.IdPersona, sc.IdSocio, edad.Edad, edad.puntos
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
	INNER JOIN dbo.tPLDmatrizConfiguracionEdades edad ON edad.Edad = DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo)
	WHERE sc.IdEstatus=1
	AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))
)

