
/* JCA.19/4/2024.01:56 
Nota: Riesgo Operativo. Procedimiento de consulta para los reportes y sus incidencias. Puede ser por fecha de registro o de actualización.
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAIReventosPorFecha')
BEGIN
	DROP PROC pCnAIReventosPorFecha
	SELECT 'pCnAIReventosPorFecha BORRADO' AS info
END
GO

CREATE PROC pCnAIReventosPorFecha
@pTipoOperacion		VARCHAR(16),
@pFechaInicial		DATE='19000101',
@pFechaFinal		DATE='19000101'
AS
BEGIN
	DECLARE @Where NVARCHAR(MAX)=''
	DECLARE @query NVARCHAR(MAX)='
		SELECT
		[CODIGO]						= ''' + @pTipoOperacion  + ''',
		[Periodo]						= per.Codigo, 
		usr.Usuario,
		[UsuarioNombre]					= pUsr.Nombre,
		[Puesto]						= pto.Descripcion,
		[Departamento]					= depto.Descripcion,
		[FechaReporte]					= re.Fecha,
		[FechaRegistroEvento]			= rd.Fecha,
		rd.FechaIdentificacionEvento,		
		rd.FechaEvento,						
		rd.Evento,							
		rd.EventoDescripcion,				
		rd.ActividadOrigen,				
		rd.AreaActividadOrigen,
		-- clasificacion
		[Categoria] =cat.Descripcion,
		[Tipo] = tip.Descripcion,
		[Subtipo] = sub.Descripcion,
		-- Acciones
		rd.AccionImplementada,			
		rd.PerdidaOcasionadaEsperada,	
		rd.AccionDescripcion,			
		rd.Recomendaciones,				
		rd.Comentarios,					
		rd.ExisteControlImplementado,
		-- Control
		[UsuarioUltimaActualizacion]		= ua.Usuario,
		[UsuarioUltActNombre]				= pUltUser.Nombre,
		rd.FechaUltimaModificacion
		FROM dbo.tAIRreporteMensualE re  WITH(NOLOCK)
		INNER JOIN dbo.tCTLperiodos per  WITH(NOLOCK) 
			ON per.IdPeriodo = re.IdPeriodo
		INNER JOIN dbo.tCTLusuarios usr  WITH(NOLOCK) 
			ON usr.IdUsuario = re.IdUsuario		
		INNER JOIN dbo.tGRLpersonas pUsr  WITH(NOLOCK) 
			ON pUsr.IdPersonaFisica = usr.IdPersonaFisica
		INNER JOIN dbo.tPERpuestos pto  WITH(NOLOCK) 
			ON pto.IdPuesto = re.IdPuesto
		INNER JOIN dbo.tPERdepartamentos depto  WITH(NOLOCK) 
			on depto.IdDepartamento = re.IdDepartamento
		INNER JOIN  dbo.tAIRreporteMensualD rd  WITH(NOLOCK)
			ON re.IdReporteMensualE = rd.IdReporteMensualE
				AND re.IdEstatus=1
		INNER JOIN dbo.tAIRclasificacionRiesgoCategoria cat  WITH(NOLOCK) 
			ON cat.IdClasificacionRiesgoCategoria = rd.IdClasificacionRiesgoCategoria
		INNER JOIN dbo.tAIRclasificacionRiesgoTipo tip  WITH(NOLOCK) 
			ON tip.IdClasificacionRiesgoTipo=rd.IdClasificacionRiesgoTipo
		INNER JOIN dbo.tAIRclasificacionRiesgoSubtipo sub  WITH(NOLOCK) 
			ON sub.IdClasificacionRiesgoSubtipo = rd.IdClasificacionRiesgoSubtipo
		INNER JOIN dbo.tCTLusuarios ua  WITH(NOLOCK) 
			ON ua.IdUsuario = rd.IdUsuarioUltimaModificacion
		INNER JOIN dbo.tGRLpersonas pUltUser  WITH(NOLOCK) 
			ON pUltUser.IdPersonaFisica=ua.IdPersonaFisica
		'

	IF @pTipoOperacion='EVT'
	BEGIN
		SET @Where=' WHERE rd.Fecha between ''' + CAST(@pFechaInicial AS VARCHAR(10)) + ''' AND ''' + CAST(@pFechaFinal AS VARCHAR(10)) + ''''			
	END 
	IF @pTipoOperacion='UPC'
	BEGIN
		SET @Where=' WHERE rd.FechaUltimaModificacion between ''' + CAST(@pFechaInicial AS VARCHAR(10)) + ''' AND ''' + CAST(@pFechaFinal  AS VARCHAR(10)) + ''''
	END 

	SET @query= @query + @Where 
	--PRINT @query

	EXEC sys.sp_executesql @query
END
GO


