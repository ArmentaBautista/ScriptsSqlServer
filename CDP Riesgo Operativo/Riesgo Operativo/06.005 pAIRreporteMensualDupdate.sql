

/* JCA.19/4/2024.01:47 
Nota: Riesgo Operativo. Prodedimiento para editar una incidencia previamente registrada
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRreporteMensualDupdate')
BEGIN
	DROP PROC pAIRreporteMensualDupdate
	SELECT 'pAIRreporteMensualDupdate BORRADO' AS info
END
GO

CREATE PROC pAIRreporteMensualDupdate
@pIdReporteMensualD INT,
@pAccionImplementada				VARCHAR(128),
@pPerdidaOcasionadaEsperada			VARCHAR(128),
@pAccionDescripcion					VARCHAR(1024),
@pRecomendaciones					VARCHAR(1024),
@pComentarios						VARCHAR(1024),
@pExisteControlImplementado			BIT
AS
BEGIN
	DECLARE @IdSesion  INT = (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD()) 
	DECLARE @IdUsuario INT = (SELECT ISNULL(s.IdUsuario,0) FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
								INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK)
									ON s.IdUsuario = u.IdUsuario
										AND s.IdSesion=@IdSesion)

	UPDATE rd
	SET 
		AccionImplementada = @pAccionImplementada,
	    PerdidaOcasionadaEsperada = @pPerdidaOcasionadaEsperada,
	    AccionDescripcion = @pAccionDescripcion,
	    Recomendaciones = @pRecomendaciones,
	    Comentarios = @pComentarios,
	    ExisteControlImplementado = @pExisteControlImplementado,
		rd.IdUsuarioUltimaModificacion= @IdUsuario,
		rd.FechaUltimaModificacion=CURRENT_TIMESTAMP
	FROM dbo.tAIRreporteMensualD rd
	WHERE rd.IdReporteMensualD=@pIdReporteMensualD

	RETURN 1
END
GO