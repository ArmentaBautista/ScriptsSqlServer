

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pBiOBTrfcEmpresa')
BEGIN
	DROP PROC pBiOBTrfcEmpresa
END
GO

CREATE PROC pBiOBTrfcEmpresa
@rfc VARCHAR(14) OUTPUT
AS
BEGIN
	SELECT @rfc=persona.RFC
	FROM dbo.tCTLempresas empresa  WITH(nolock) 
	INNER JOIN dbo.tGRLpersonas persona  WITH(nolock) ON persona.IdPersona = empresa.IdPersona
	WHERE empresa.IdEmpresa=1 AND persona.IdPersona!=0

	-- SELECT @rfc AS RFC
END
GO



