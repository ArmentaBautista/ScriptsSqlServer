

USE iERP_CYL
GO



EXEC dbo.pPLDgenerarReporteOperaciones @TipoOperacion = 'INU-XLS',          -- varchar(10)
                                       @FechaInicial = '2024-03-01', -- date
                                       @fechaFinal = '2024-03-31',   -- date
                                       @IdSocio = 0,                 -- int
                                       @Fecha = '2024-04-04',        -- date
                                       @IdEmpresa = 1,               -- int
                                       @IdPeriodo = 315                -- int

