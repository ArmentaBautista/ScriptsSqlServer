


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBURobtenerIdPeticionConsultaPersonaBuro')
BEGIN
	DROP PROC pBURobtenerIdPeticionConsultaPersonaBuro
	SELECT 'pBURobtenerIdPeticionConsultaPersonaBuro BORRADO' AS info
END
GO

CREATE PROC pBURobtenerIdPeticionConsultaPersonaBuro
@IdConsultaBuroCredito AS INT,
@IdPeticionConsultaPersonaBuro AS INT OUTPUT
AS
BEGIN
		SELECT TOP 1 @IdPeticionConsultaPersonaBuro=eb.IdPeticionConsultaPersonaBuro
		FROM dbo.tBURpeticionConsultaPersonaBuro p 
		INNER JOIN dbo.tBURConsultaBuroCreditoE cb  WITH(NOLOCK)
			ON cb.IdConsultaBuroCredito = p.IdConsultaBuroCredito
		INNER JOIN dbo.tBURrespuestaConsultaEncabezado eb
			ON eb.IdPeticionConsultaPersonaBuro = p.IdPeticionConsultaPersonaBuro
		WHERE cb.IdConsultaBuroCredito=@IdConsultaBuroCredito
		ORDER BY eb.IdPeticionConsultaPersonaBuro DESC
END