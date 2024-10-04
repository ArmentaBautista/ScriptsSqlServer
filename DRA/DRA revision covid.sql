


SELECT p.IdPersona, sc.IdSocio, c.IdCuenta 
, sc.Codigo AS NoSocio, p.Nombre, c.Codigo AS NoCuenta, c.Descripcion, c.FechaAlta, c.Vencimiento, c.TasaIva, c.InteresOrdinarioAnual, c.SaldoCapital
FROM tayccuentas c  WITH(nolock) 
INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio
INNER JOIN dbo.tGRLpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
WHERE sc.Codigo='010200001159'
AND c.Codigo='01020000115900022'

SELECT * 
FROM dbo.tAYCparcialidadesInteresPeriodosGracia ppg  WITH(nolock) 


EXEC dbo.pOBTparcialidadesAsignacionPeriodosGracia @TipoOperacion='OBT',@IdCuenta=89918

EXEC dbo.pAYCgenerarPlanPagosBaseDatos @TipoOperacion = '',               -- varchar(20)
                                       @IdCuenta = 0,                     -- int
                                       @IdSucursal = 0,                   -- int
                                       @FechaCuenta = '2020-10-21',       -- date
                                       @IdTipoParcialidad = 0,            -- int
                                       @DiasTipoAnio = 0,                 -- int
                                       @Monto = NULL,                     -- numeric(23, 8)
                                       @Ahorro = NULL,                    -- numeric(23, 8)
                                       @TasaInteresAnual = NULL,          -- numeric(23, 8)
                                       @TasaIVA = NULL,                   -- numeric(23, 8)
                                       @NumeroParcialidades = 0,          -- int
                                       @NumeroDias = 0,                   -- int
                                       @VenceMismoDia = NULL,             -- bit
                                       @EsPrimerVencimientoManual = NULL, -- bit
                                       @PrimerVencimiento = '2020-10-21', -- date
                                       @TieneMinistraciones = NULL,       -- bit
                                       @Ministraciones = '',              -- varchar(max)
                                       @TieneCargos = NULL,               -- bit
                                       @Cargos = '',                      -- varchar(max)
                                       @TienePagosProgramados = NULL,     -- bit
                                       @PagosProgramados = '',            -- varchar(max)
                                       @IdProductoFinanciero = 0,         -- int
                                       @IdTipoDplazo = 0,                 -- int
                                       @IdTipoDDiaPrimeraQuincena = 0,    -- int
                                       @IdTipoDDiaSegundaQuincena = 0,    -- int
                                       @IncluirDiasInhabiles = NULL,      -- bit
                                       @Debut = 0                         -- int



