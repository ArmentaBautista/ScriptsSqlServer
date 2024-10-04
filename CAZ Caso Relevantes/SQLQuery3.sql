

EXEC dbo.pPLDgenerarReporteOperaciones @TipoOperacion = '',          -- varchar(10)
                                       @FechaInicial = '2024-07-10', -- date
                                       @fechaFinal = '2024-07-10',   -- date
                                       @IdSocio = 0,                 -- int
                                       @Fecha = '2024-07-10',        -- date
                                       @IdEmpresa = 0,               -- int
                                       @IdPeriodo = 0                -- int


DECLARE @IdEstatus INT;
EXEC dbo.pSITreportesPeriodo @Operacion = '',                -- varchar(20)
                             @IdPeriodo = 0,                 -- int
                             @IdReporte = 0,                 -- int
                             @IdSesion = 0,                  -- int
                             @IdEstatus = @IdEstatus OUTPUT, -- int
                             @MSG = ''                       -- varchar(max)
