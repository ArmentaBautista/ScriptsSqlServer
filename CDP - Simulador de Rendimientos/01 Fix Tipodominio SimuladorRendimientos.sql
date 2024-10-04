/********  JCA.. Info: Creación del tipo de dominio para la extensión "simulador de rendimientos"  ********/
if not exists(SELECT 1
            FROM tCTLtiposD d WITH (NOLOCK)
            WHERE IdEstatus = 1
                AND IdTipoD = 2972)
begin
    INSERT INTO dbo.tCTLtiposD (IdTipoD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdTipoDPadre, RangoInicio,
                            RangoFin, PermiteHistorial, PermiteCambios, TipoDivisaDivision, UsaEstructuraCatalogo,
                            IdEstatus, IdTipoDestatus, IdEstatusPrincipal, IdCuentaABCDacreedor, UsaEstructuraContable,
                            Valor, Naturaleza, Factor, Orden, ValorSimple, IdCatalogoSITI, Valor5C)
    VALUES (2972, N'SMDR', N'Simulador de Rendimientos', N'Simulador de Rendimientos', 13, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0,
            0, 0.00000000, 0, 0, 0, 0.00000000, 0, 0);

    select 'Tipo de dominio Simulador de Rendimientos creado' AS Info
END
ELSE
BEGIN
    select 'Tipo de dominio ya existe' AS Info
END
GO


