

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCmdCTLactualizarConfiguracionFechaVencimientoParaFiltroDeSaldos')
BEGIN
	DROP PROC pCmdCTLactualizarConfiguracionFechaVencimientoParaFiltroDeSaldos
	SELECT 'pCmdCTLactualizarConfiguracionFechaVencimientoParaFiltroDeSaldos BORRADO' AS info
END
GO

CREATE PROC dbo.pCmdCTLactualizarConfiguracionFechaVencimientoParaFiltroDeSaldos
@Fecha DATE='19000101'
AS
BEGIN
	
	IF @Fecha='19000101' OR @Fecha IS NULL OR @Fecha>GETDATE()
	BEGIN
		SELECT ' >"."< Fecha NO válida' AS info
		RETURN 0
	END
		

	DECLARE @valor AS VARCHAR(250) = STUFF(STUFF(CONVERT(VARCHAR(8), @fecha, 112), 5, 0, '/'), 8, 0, '/');
	
	UPDATE cfg SET cfg.Valor=@valor, cfg.ValorCodigo=@valor, cfg.ValorDescripcion=@valor
	FROM dbo.tCTLconfiguracion cfg WHERE cfg.IdConfiguracion=435 AND cfg.Valor<>@valor

	SELECT 
	 cf.Descripcion AS Parametro 
	,cf.Valor
	FROM dbo.tCTLconfiguracion cf  WITH(NOLOCK) 
	WHERE cf.IdConfiguracion=435 
	
END
GO



	
