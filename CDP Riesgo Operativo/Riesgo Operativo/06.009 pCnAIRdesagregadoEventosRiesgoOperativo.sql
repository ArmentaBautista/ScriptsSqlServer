

/* JCA.19/4/2024.01:58 
Nota: Riesgo Operativo. Encapsula la llamada al procedimiento de consulta de reportes e incidencias por fecha.
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAIRdesagregadoEventosRiesgoOperativo')
BEGIN
	DROP PROC pCnAIRdesagregadoEventosRiesgoOperativo
	SELECT 'pCnAIRdesagregadoEventosRiesgoOperativo BORRADO' AS info
END
GO

CREATE PROC pCnAIRdesagregadoEventosRiesgoOperativo
@pFechaInicial		DATE='19000101',
@pFechaFinal		DATE='19000101'
AS
BEGIN

	DECLARE @result TABLE(
	    CODIGO							VARCHAR(16),
		[Periodo]						varchar(16),
		Usuario							varchar(128),
		[UsuarioNombre]					varchar(128),
		[Puesto]						varchar(128),
		[Departamento]					varchar(128),
		[FechaReporte]					DATE,
		[FechaRegistroEvento]			DATE,
		FechaIdentificacionEvento		DATE,
		FechaEvento						DATE,
		Evento							varchar(128),
		EventoDescripcion				varchar(128),
		ActividadOrigen					varchar(128),
		AreaActividadOrigen				varchar(128),
		-- clasificacion				
		[Categoria]						varchar(128),
		[Tipo] 							varchar(128),
		[Subtipo]						varchar(128),
		-- Acciones						
		AccionImplementada				varchar(128),
		PerdidaOcasionadaEsperada		varchar(128),
		AccionDescripcion				varchar(128),
		Recomendaciones					varchar(128),
		Comentarios						varchar(128),
		ExisteControlImplementado		bit,
		-- Control						
		[UsuarioUltimaActualizacion]	varchar(128),	
		[UsuarioUltActNombre]			varchar(128),	
		FechaUltimaModificacion			DATE
)

	INSERT INTO @result
	EXECUTE dbo.pCnAIReventosPorFecha @pTipoOperacion = 'EVT',          
	                                  @pFechaInicial = @pFechaInicial, 
	                                  @pFEchaFinal = @pFEchaFinal    
	
	INSERT INTO @result
	EXECUTE dbo.pCnAIReventosPorFecha @pTipoOperacion = 'UPD',          
	                                  @pFechaInicial = @pFechaInicial, 
	                                  @pFEchaFinal = @pFEchaFinal 

	SELECT * FROM @result
END
GO