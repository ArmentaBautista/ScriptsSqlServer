
/* Tipo de Dominio para la Ventana de Confirmación de Saldos, especificamente se crea para habilitar la impresión de documentos           [JCA.15/8/2024.11:56]*/
IF NOT EXISTS(SELECT IdTipoD
              FROM tCTLtiposd
              WHERE IdTipoD = 2973)
    INSERT INTO dbo.tCTLtiposD (IdTipoD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdTipoDPadre, RangoInicio,
                                RangoFin, PermiteHistorial, PermiteCambios, TipoDivisaDivision, Valor,
                                UsaEstructuraCatalogo, IdEstatus, IdTipoDestatus, IdEstatusPrincipal)
    VALUES (2973, 'CONFSDOS', 'Confirmación de Saldos', 'Confirmación de Saldos', 13, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1)
GO



