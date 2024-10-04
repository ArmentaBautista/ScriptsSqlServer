

USE ErpriseExpediente
GO

SELECT * FROM dbo.tDIGexpediente ex  WITH(NOLOCK) 

SELECT * FROM dbo.vDIGrequisitosAgrupador ex  WITH(NOLOCK) 

SELECT * FROM dbo.tDIGrequisitos

SELECT
ra.agrupador,
ra.Requisito,
ra.AgrupadorObligatorio,
ra.RequisitoObligatorio,
ex.IdExpediente,
ex.IdTipoDdominio,
ex.IdRegistro,
ex.IdRequisito,
ex.EsDocumental,
ex.EstaCubiertoNoDocumental,
p.NumeroSocio,
ra.*
FROM dbo.tDIGexpediente ex  WITH(NOLOCK) 
INNER JOIN dbo.vDIGrequisitosAgrupador ra  WITH(NOLOCK) ON ra.IdRequisito = ex.IdRequisito
LEFT JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdSocio = ex.IdRegistro


EXEC dbo.pDIGrequisitosIngreso @tipoOperacion = 'OBTREQ', -- varchar(24)
                               @numeroSocio = '18148001',   -- varchar(24)
                               @idSesion = 0        -- int

-- 6413001  18148001


SELECT * FROM dbo.tDIGarchivos a  WITH(NOLOCK) 
WHERE a.IdExpediente=1


DECLARE @IdArchivo INT=20,
        @Resultado INT;
EXEC dbo.pDIGarchivos @tipoOperacion = 'UPD_SYNC',            -- varchar(32)
                      @IdArchivo = @IdArchivo OUTPUT, -- int
                      @idExpediente = 0,              -- int
                      @IdRequisito = 0,               -- int
                      @Nombre = '',                   -- varchar(256)
                      @Referencia = '',               -- varchar(256)
                      @Descripcion = '',              -- varchar(256)
                      @EsAutogenerado = NULL,         -- bit
                      @EstaSincronizado = NULL,       -- bit
                      @Fecha = '2023-04-28',          -- date
                      @IdSesion = 0,                  -- int
                      @Resultado = @Resultado OUTPUT  -- int

SELECT @Resultado


DECLARE @IdArchivo INT=20,
        @Resultado INT;
EXEC dbo.pDIGarchivos @tipoOperacion = 'UPD_SYNC',    
                      @IdArchivo = @IdArchivo OUTPUT, 
                      @Resultado = @Resultado OUTPUT, 
                      @UpdateCampo = 'EstaSincronizado',      
                      @UpdateValor = '0'               

SELECT @Resultado

SELECT * FROM dbo.tDIGarchivos  WITH(NOLOCK) 


EXEC sys.sp_help @objname = N'tdigexpediente' -- nvarchar(776)


SELECT * FROM dbo.tDIGexpediente
-- DELETE FROM dbo.tDIGexpediente
SELECT * FROM dbo.tDIGarchivos
-- DELETE FROM dbo.tDIGarchivos


SELECT * FROM dbo.tGRLpersonas

