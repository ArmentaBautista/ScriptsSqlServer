

DECLARE @pOutIdEvaluacionRiesgo1 INT,
        @pOutCalificacion1 NUMERIC(10, 2),
        @pOutNivelRiesgo1 INT,
        @pOutNivelRiesgoDescripcion1 VARCHAR(16);

EXEC dbo.pPLDevaluacionDeRiesgo @pIdSocio = 825,                                                    -- int
                                @pFechaTrabajo = '20220131',                                    -- date
                                @pOutIdEvaluacionRiesgo = @pOutIdEvaluacionRiesgo1 OUTPUT,        -- int
                                @pOutCalificacion = @pOutCalificacion1 OUTPUT,                    -- numeric(10, 2)
                                @pOutNivelRiesgo = @pOutNivelRiesgo1 OUTPUT,                      -- int
                                @pOutNivelRiesgoDescripcion = @pOutNivelRiesgoDescripcion1 OUTPUT -- varchar(16)

SELECT @pOutIdEvaluacionRiesgo1 ,@pOutCalificacion1 ,@pOutNivelRiesgo1 , @pOutNivelRiesgoDescripcion1


SELECT * FROM tPLDmatrizEvaluacionesRiesgo
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificaciones --ORDER BY IdEvaluacionRiesgo, IdSocio, IdFactor
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas --WHERE IdFactor=3
SELECT * FROM tPLDmatrizEvaluacionesRiesgoCalificacionesFinales



/*

TRUNCATE TABLE tPLDmatrizEvaluacionesRiesgoCalificaciones
TRUNCATE TABLE tPLDmatrizEvaluacionesRiesgoCalificacionesAgrupadas
TRUNCATE TABLE tPLDmatrizEvaluacionesRiesgoCalificacionesFinales
delete from tPLDmatrizEvaluacionesRiesgo

*/

