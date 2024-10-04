/********  JCA.. Info: Registro del format para la extensión "Simulador de Rendimientos"  ********/
if not exists(select 1
            from dbo.tCTLInformes WITH (NOLOCK)
            where IdEstatus=1
                and IdInforme=-165)
begin
    SET IDENTITY_INSERT tCTLInformes ON;

    INSERT INTO tCTLInformes (IdInforme, Descripcion, Reporte, IdTipoDdominio, Orientacion, Copias, Papel,
                                         ImpresoraDefault, FormatoPrincipal, ActivarImprimir, ActivarExportar,
                                         ActivarEnviar, FormatoExcel, FormatoPDF, FormatoImagen, FormatoDefaultArchivo,
                                         SalidaDefault, EsFormato, IdEstatus, EsCheque,  Paginas,
                                         PermiteVistaPrevia, ImpresionDoble, PermiteFirma, ImpresionesPermitidas)
    VALUES (-165, N'Simulador de Rendimientos', N'FmtSimuladorRendimientos.repx', 208, N'Vertical', 1, N'DefaultPaperSize',
            N'DefaultPaperSize', 0, 0, 0, 0, 0, 0, 0, N'', 1, 1, 1, N'', 1, 1, 0, 0, 1);

    SET IDENTITY_INSERT tCTLInformes OFF;

    SELECT 'Formato -165 insertado' AS Info
END
ELSE
BEGIN
    SELECT 'Formato -165 ya existía' AS Info
END
GO






