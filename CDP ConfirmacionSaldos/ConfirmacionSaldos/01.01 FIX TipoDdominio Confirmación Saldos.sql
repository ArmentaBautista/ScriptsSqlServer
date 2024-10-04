
/* Tipo de Dominio para la Ventana de Confirmaci�n de Saldos, especificamente se crea para habilitar la impresi�n de documentos           [JCA.15/8/2024.11:56]*/
IF NOT EXISTS(SELECT IdTipoD
              FROM tCTLtiposd
              WHERE IdTipoD = 2973)
    INSERT INTO dbo.tCTLtiposD (IdTipoD, Codigo, Descripcion, DescripcionLarga, IdTipoE, IdTipoDPadre, RangoInicio,
                                RangoFin, PermiteHistorial, PermiteCambios, TipoDivisaDivision, Valor,
                                UsaEstructuraCatalogo, IdEstatus, IdTipoDestatus, IdEstatusPrincipal)
    VALUES (2973, 'CONFSDOS', 'Confirmaci�n de Saldos', 'Confirmaci�n de Saldos', 13, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1)
GO



