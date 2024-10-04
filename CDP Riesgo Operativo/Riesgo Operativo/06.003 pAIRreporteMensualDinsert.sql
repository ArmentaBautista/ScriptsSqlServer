
--
/* JCA.19/4/2024.01:41 
Nota: Riesgo Operativo. Procedimiento para la inserción individual de las incidencias, se afectan en bd al momento de la operación
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRreporteMensualDinsert')
BEGIN
	DROP PROC pAIRreporteMensualDinsert
	SELECT 'pAIRreporteMensualDinsert BORRADO' AS info
END
GO

CREATE PROC pAIRreporteMensualDinsert
@pIdReporteMensualD 				INT = 0 OUTPUT,
@pIdReporteMensualE					INT,
@pFechaIdentificacionEvento			DATE,
@pFechaEvento						DATE,
@pEvento							VARCHAR(128),
@pEventoDescripcion					VARCHAR(128),
@pActividadOrigen					VARCHAR(128),
@pAreaActividadOrigen				VARCHAR(128),
-- Clasificacion
@pIdClasificacionRiesgoCategoria	INT,
@pIdClasificacionRiesgoTipo			INT,
@pIdClasificacionRiesgoSubtipo		INT,
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

	DECLARE @IdSesion  INT = @pIdSesion
	if @IdSesion=0
	    set @IdSesion=(SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD())

	DECLARE @IdUsuario INT = (SELECT ISNULL(s.IdUsuario,0) FROM dbo.tCTLusuarios u  WITH(NOLOCK)
								INNER JOIN dbo.tCTLsesiones s  WITH(NOLOCK)
									ON s.IdUsuario = u.IdUsuario
										AND s.IdSesion=@IdSesion)

	INSERT INTO dbo.tAIRreporteMensualD
	(
	    IdReporteMensualE,
	    FechaIdentificacionEvento,
	    FechaEvento,
	    Evento,
	    EventoDescripcion,
	    ActividadOrigen,
	    AreaActividadOrigen,
	    IdClasificacionRiesgoCategoria,
	    IdClasificacionRiesgoTipo,
	    IdClasificacionRiesgoSubtipo,
	    AccionImplementada,
	    PerdidaOcasionadaEsperada,
	    AccionDescripcion,
	    Recomendaciones,
	    Comentarios,
	    ExisteControlImplementado,
	    Fecha,
		IdSesion,
		IdUsuario,
	    IdUsuarioUltimaModificacion,
	    FechaUltimaModificacion
	)
	SELECT
	@pIdReporteMensualE,				
	@pFechaIdentificacionEvento,		
	@pFechaEvento,					
	@pEvento,						
	@pEventoDescripcion,				
	@pActividadOrigen,				
	@pAreaActividadOrigen,			
	@pIdClasificacionRiesgoCategoria,
	@pIdClasificacionRiesgoTipo,		
	@pIdClasificacionRiesgoSubtipo,	
	@pAccionImplementada,			
	@pPerdidaOcasionadaEsperada,		
	@pAccionDescripcion,				
	@pRecomendaciones,				
	@pComentarios,					
	@pExisteControlImplementado,		
	CURRENT_TIMESTAMP,
	@IdSesion,
	@IdUsuario,
	@IdUsuario,
	CURRENT_TIMESTAMP

	SET @pIdReporteMensualD = SCOPE_IDENTITY();

	/* ?^•?•^?   JCA.31/08/2023.10:56 p. m. Nota: Devolver todos los detalles del reporte   */
	EXEC dbo.pAIRreporteMensualDlist @pTipoOperacion = 'RE',
	                                 @pIdReporteMensualE = @pIdReporteMensualE
	                                 
	



	
END
GO