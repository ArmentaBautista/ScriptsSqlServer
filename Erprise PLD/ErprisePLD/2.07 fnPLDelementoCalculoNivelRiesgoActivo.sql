
IF(object_id('fnPLDelementoCalculoNivelRiesgoActivo') is not null)
BEGIN
	DROP FUNCTION fnPLDelementoCalculoNivelRiesgoActivo
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnPLDelementoCalculoNivelRiesgoActivo(@idElemento int)
RETURNS BIT
AS
BEGIN
    DECLARE @ret BIT;
	IF EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionFactoresParaNivelRiesgo e  WITH(NOLOCK) 
				WHERE e.idestatus=1 
					AND e.IdElemento = @idElemento)
		SET @ret=1
	ELSE
		SET @ret=0

    RETURN @ret;
END;
GO