
/* JCA.19/4/2024.01:45 
Nota: Riesgo Operativo. Devuelve el listado de incidencias de un reporte mensual
*/
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAIRreporteMensualDlist')
BEGIN
	DROP PROC pAIRreporteMensualDlist
	SELECT 'pAIRreporteMensualDlist BORRADO' AS info
END
GO

CREATE PROC pAIRreporteMensualDlist
@pTipoOperacion VARCHAR(20),
@pIdReporteMensualE INT=0 OUTPUT,
@pIdUsuario INT=0,
@pIdPeriodo INT=0
AS
BEGIN
	select top 1 @pIdReporteMensualE=isnull(re.IdReporteMensualE,0)
	from tAIRreporteMensualE re WITH (NOLOCK)
	where re.IdPeriodo=@pIdPeriodo
	 and re.IdUsuario=@pIdUsuario
	     and re.IdEstatus=1
	ORDER BY re.IdReporteMensualE DESC

	if @pIdReporteMensualE is null
	    set @pIdReporteMensualE=0;

	PRINT @pTipoOperacion
	PRINT @pIdReporteMensualE
	PRINT @pIdUsuario
	PRINT @pIdPeriodo

	DECLARE @Query NVARCHAR(max)='SELECT
									rd.IdReporteMensualD, 				
									rd.IdReporteMensualE,				
									rd.FechaIdentificacionEvento,		
									rd.FechaEvento,						
									rd.Evento,							
									rd.EventoDescripcion,				
									rd.ActividadOrigen,				
									rd.AreaActividadOrigen,
									-- clasificacion
									cat.IdClasificacionRiesgoCategoria,
									[CodigoCategoria] = cat.Codigo,
									[DescripcionCategoria] =cat.Descripcion,
									tip.IdClasificacionRiesgoTipo,
									[CodigoTipo] = tip.Codigo,
									[DescripcionTipo] = tip.Descripcion,
									sub.IdClasificacionRiesgoSubtipo,
									[CodigoSubtipo] = sub.Codigo,
									[DescripcionSubtipo] = sub.Descripcion,
									-- Acciones
									rd.AccionImplementada,			
									rd.PerdidaOcasionadaEsperada,	
									rd.AccionDescripcion,			
									rd.Recomendaciones,				
									rd.Comentarios,					
									rd.ExisteControlImplementado,
									-- Control
									rd.Fecha,
									rd.Alta,
									rd.IdEstatus,
									rd.IdSesion,
									ua.IdUsuario,
									ua.Usuario,
									[IdUsuarioUltimamodificacion]= uc.IdUsuario,
									uc.Usuario,
									rd.FechaUltimaModificacion,
									re.IdPeriodo
									FROM dbo.tAIRreporteMensualD rd  WITH(NOLOCK)
									INNER JOIN dbo.tAIRreporteMensualE re  WITH(NOLOCK) 
										ON re.IdReporteMensualE = rd.IdReporteMensualE
									INNER JOIN dbo.tAIRclasificacionRiesgoCategoria cat  WITH(NOLOCK) 
										ON cat.IdClasificacionRiesgoCategoria = rd.IdClasificacionRiesgoCategoria
									INNER JOIN dbo.tAIRclasificacionRiesgoTipo tip  WITH(NOLOCK) 
										ON tip.IdClasificacionRiesgoTipo=rd.IdClasificacionRiesgoTipo
									INNER JOIN dbo.tAIRclasificacionRiesgoSubtipo sub  WITH(NOLOCK) 
										ON sub.IdClasificacionRiesgoSubtipo = rd.IdClasificacionRiesgoSubtipo
									INNER JOIN dbo.tCTLusuarios ua  WITH(NOLOCK) 
										ON ua.IdUsuario = rd.IdUsuario
									INNER JOIN dbo.tCTLusuarios uc  WITH(NOLOCK) 
										ON uc.IdUsuario = rd.IdUsuario
									';
	DECLARE @Where NVARCHAR(max)='';

	IF @pTipoOperacion='RE'
	BEGIN
		SET @Where ='WHERE (' + CAST(@pIdReporteMensualE AS NVARCHAR(9)) + '=0 OR rd.IdReporteMensualE=' + CAST(@pIdReporteMensualE AS NVARCHAR(9)) + ')';
	END
 	IF @pTipoOperacion='USER_PER'
	BEGIN
	    SET @Where =' WHERE re.IdReporteMensualE =' + CAST(@pIdReporteMensualE AS NVARCHAR(9)) + '';
	END
	
	SET @Query=CONCAT(@Query,@Where)
	--PRINT @Query
	EXEC sys.sp_executesql @Query

END
GO