
/* JCA.19/4/2024.01:52 
Nota: Riesgo Operativo. Procedimiento para completar los datos de una incidencia previamente registrada
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRreporteMensualDupdate')
BEGIN
	DROP PROC pAIRreporteMensualDupdate
	SELECT 'pAIRreporteMensualDupdate BORRADO' AS info
END
GO

CREATE PROC pAIRreporteMensualDupdate
@pIdReporteMensualE					INT, 
@pIdReporteMensualD 				INT,
-- Acciones
@pAccionImplementada				VARCHAR(128),
@pPerdidaOcasionadaEsperada			VARCHAR(128),
@pAccionDescripcion					VARCHAR(128),
@pRecomendaciones					VARCHAR(128),
@pComentarios						VARCHAR(128),
@pExisteControlImplementado			BIT,
-- Control
@pIdSesion							INT
AS
BEGIN

	DECLARE @IdSesion  INT = @pIdSesion -- (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD()) 
	DECLARE @IdUsuario INT = (SELECT ISNULL(s.IdUsuario,0) FROM dbo.tCTLusuarios u  WITH(NOLOCK) 
								INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK)
									ON s.IdUsuario = u.IdUsuario
										AND s.IdSesion=@IdSesion)
--

	PRINT @IdSesion
	PRINT @IdUsuario

	UPDATE d
	SET 
	    AccionImplementada=@pAccionImplementada,
	    PerdidaOcasionadaEsperada=@pPerdidaOcasionadaEsperada,
	    AccionDescripcion=@pAccionDescripcion,
	    Recomendaciones=@pRecomendaciones,
	    Comentarios=@pComentarios,
	    ExisteControlImplementado=@pExisteControlImplementado,
	    IdUsuarioUltimaModificacion=@IdUsuario,
	    FechaUltimaModificacion=CURRENT_TIMESTAMP
	FROM dbo.tAIRreporteMensualD d WHERE  d.IdReporteMensualD=@pIdReporteMensualD
	
	/* ?^•?•^?   JCA.31/08/2023.10:56 p. m. Nota: Devolver todos los detalles del reporte   */
	EXEC dbo.pAIRreporteMensualDlist @pTipoOperacion = 'RE',
	                                 @pIdReporteMensualE = @pIdReporteMensualE	
END
GO