
USE intelixDEV
GO

DECLARE @nombreBuscado AS VARCHAR(64)='VERENICE I'

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE sc.Codigo LIKE '%' + @nombreBuscado + '%'
	OR p.Nombre LIKE '%' + @nombreBuscado + '%'


-- 010100025032



--DECLARE @pOutIdEvaluacionRiesgo1 INT,
--        @pOutCalificacion1 NUMERIC(10, 2),
--        @pOutNivelRiesgo1 INT,
--        @pOutNivelRiesgoDescripcion1 VARCHAR(16);

--EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = 0,                                                    -- int
--								@pnosocio = '010100037275',
--								@pEvaluacionMasiva=0,
--                                @pFechaTrabajo = '20220131',                                    -- date
--                                @pOutIdEvaluacionRiesgo = @pOutIdEvaluacionRiesgo1 OUTPUT,        -- int
--                                @pOutCalificacion = @pOutCalificacion1 OUTPUT,                    -- numeric(10, 2)
--                                @pOutNivelRiesgo = @pOutNivelRiesgo1 OUTPUT,                      -- int
--                                @pOutNivelRiesgoDescripcion = @pOutNivelRiesgoDescripcion1 OUTPUT -- varchar(16)

--SELECT @pOutIdEvaluacionRiesgo1 ,@pOutCalificacion1 ,@pOutNivelRiesgo1 , @pOutNivelRiesgoDescripcion1


DECLARE @Fecha AS DATE='20241016'
EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = 134917,                                                    
								@pnosocio = '',
								@pEvaluacionMasiva=0,
                                @pFechaTrabajo = @Fecha,
								@pDEBUG=1



DECLARE @Fecha AS DATE=GETDATE()
EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = 0,                                                    
								@pnosocio = '',
								@pEvaluacionMasiva=1,
                                @pFechaTrabajo = @Fecha,
								@pDEBUG=1
								
SELECT * FROM tPLDmatrizConfiguracionNivelesRiesgo

-- 10807-006360
EXEC dbo.pCnPLDmatrizEvaluacionNivelDeRiesgo @tipoOperacion = 'SOCIO_DETALLE_EVALUACION'          -- varchar(128)
                                           , @fechaInicial = '2024-04-06' -- date
                                           , @fechaFinal = '2024-04-08'   -- date
                                           , @NoSocio = 'H04-11458'                -- varchar(32)
                                           , @folioEvaluacion = 19         -- int




SELECT * FROM tPLDmatrizEvaluacionesRiesgo ORDER BY IdEvaluacionRiesgo DESC
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificaciones WHERE IdEvaluacionRiesgo=1 --ORDER BY IdEvaluacionRiesgo, IdSocio, IdFactor
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas WHERE IdEvaluacionRiesgo=1 --WHERE IdFactor=3
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificacionesFinales WHERE IdEvaluacionRiesgo=1


SELECT *
FROM tPLDmatrizEvaluacionesRiesgoCalificacionesFinales 
WHERE IdEvaluacionRiesgo=4


/*

SELECT * FROM tPLDmatrizEvaluacionesRiesgo 
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificaciones 
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas 
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificacionesFinales 


TRUNCATE TABLE tPLDmatrizEvaluacionesRiesgoCalificaciones
TRUNCATE TABLE tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas
TRUNCATE TABLE tPLDmatrizEvaluacionesRiesgoCalificacionesFinales
delete from tPLDmatrizEvaluacionesRiesgo

*/




DECLARE @nombreBuscado AS VARCHAR(64)='verenice i'

SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.IdPersona, p.Nombre
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
WHERE p.Nombre LIKE '%' + @nombreBuscado + '%'


/*
insert into dbo.tPLDmatrizConfiguracionNivelesRiesgo (
                                                      Tipo
                                                    , TipoDescripcion
                                                    , NivelRiesgo
                                                    , NivelRiesgoDescripcion
                                                    , Valor1
                                                    , Valor2
                                                    , IdEstatus)
select 4,'Nivel Riesgo - PF Act. Empresarial',NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2,IdEstatus 
from dbo.tPLDmatrizConfiguracionNivelesRiesgo where Tipo=3
*/


/*
SELECT 
'UPDATE c SET c.Categoria1='''', c.Categoria2='''' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=' + CAST(IdParametro AS VARCHAR(5))  + ';
-- ' + Descripcion + '

'
FROM dbo.tPLDconfiguracion  WITH(NOLOCK) WHERE IdEstatus=1
*/