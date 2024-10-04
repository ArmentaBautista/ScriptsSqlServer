


SELECT * 
FROM dbo.tPLDmatrizConfiguracionInstrumentosCanales cn  WITH(NOLOCK) 
WHERE cn.Tipo=2


SELECT * FROM dbo.tCTLtiposOperacion toper  WITH(NOLOCK) 

SELECT * FROM dbo.tCTLtiposD d  WITH(NOLOCK) WHERE d.Descripcion LIKE '%multicanal%'

SELECT * FROM dbo.tCATlistasD d  WITH(NOLOCK) WHERE d.IdTipoE=181



SELECT sc.IdSocio, * 
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdPersona = p.IdPersona
WHERE p.IdPersona=50500



DECLARE @nombreBuscado AS VARCHAR(64)='sergio cervantes '

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE p.Nombre LIKE '%' + @nombreBuscado + '%'



SELECT * FROM dbo.fnPLDdestinosRecursosSocios(9)

SELECT * FROM dbo.fnPLDorigenesRecursosSocios(9)


SELECT * FROM dbo.tPLDmatrizConfiguracionNivelesRiesgo


-- 001-000068

/*

EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = 0,                 -- int
                                @pNoSocio = '',                -- varchar(24)
                                @pEvaluacionMasiva = 1,     -- bit
                                @pFechaTrabajo = '2023-11-30', -- date
                                @pDEBUG = 1                 -- bit

EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = 0,                 -- int
                                @pNoSocio = '001-000068',                -- varchar(24)
                                @pEvaluacionMasiva = 0,     -- bit
                                @pFechaTrabajo = '2024-02-08', -- date
                                @pDEBUG = 1                 -- bit

EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'EVALUACIONES_POR_SOCIO_FECHA',          -- varchar(128)
                                             @fechaInicial = '2024-01-01', -- date
                                             @fechaFinal = '2024-02-10',   -- date
                                             @NoSocio = '001-000068'               

EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'SOCIO_RESUMEN_EVALUACION',          -- varchar(128)
                                             @fechaInicial = '2024-01-01', -- date
                                             @fechaFinal = '2024-02-10',   -- date
                                             @NoSocio = '001-000068',                -- varchar(32)
                                             @folioEvaluacion = 56          -- int


EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'SOCIO_DETALLE_EVALUACION',          -- varchar(128)
                                             @fechaInicial = '2024-02-01', -- date
                                             @fechaFinal = '2024-02-01',   -- date
                                             @NoSocio = '0000000051',                -- varchar(32)
                                             @folioEvaluacion = 10          -- int

*/


EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'DETALLE',          
                                              @fechaInicial = '2024-02-01', 
                                             @fechaFinal = '2024-02-08',           
                                             @folioEvaluacion = 56         


SELECT TOP 5
		*
		FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales fin  WITH(NOLOCK) 
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = fin.IdSocio
				AND sc.Codigo='001-000068'
		WHERE fin.IdEstatus=1
		ORDER BY fin.IdEvaluacionRiesgo DESC


EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'SOCIO_RESUMEN_EVALUACION',          -- varchar(128)
                                             @fechaInicial = '2024-01-01', -- date
                                             @fechaFinal = '2024-02-10',   -- date
                                             @NoSocio = '001-000068',                -- varchar(32)
                                             @folioEvaluacion = 56          -- int

EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'SOCIO_DETALLE_EVALUACION',          -- varchar(128)
                                             @fechaInicial = '2024-01-01', -- date
                                             @fechaFinal = '2024-02-10',   -- date
                                             @NoSocio = '001-000068',                -- varchar(32)
                                             @folioEvaluacion = 57          -- int


SELECT sc.IdListaDnivelRiesgo,sc.DescripcionNivelRiesgo ,sc.CalificacionNivelRiesgo
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
WHERE sc.IdSocio=23825

