

BEGIN TRY
        if not exists(select 1
                     from dbo.tCTLInformes i WITH (NOLOCK)
                     where i.idInforme=-166)
        BEGIN
            SET IDENTITY_INSERT tCTLInformes ON

            INSERT INTO dbo.tCTLInformes (IdInforme, Descripcion, Reporte, IdTipoDdominio, Orientacion, Copias, Papel,
                                          ImpresoraDefault, FormatoPrincipal, ActivarImprimir, ActivarExportar, ActivarEnviar,
                                          FormatoExcel, FormatoPDF, FormatoImagen, FormatoDefaultArchivo, SalidaDefault, EsFormato,
                                          IdEstatus, EsCheque, Paginas, PermiteVistaPrevia, ImpresionDoble, PermiteFirma,
                                          ImpresionesPermitidas)
            VALUES (-166, N'Confirmación de Saldos', N'FmtConfirmacionDeSaldos.repx', 2973, N'Vertical', 1, N'DefaultPaperSize',
                    N'DefaultPaperSize', 0, 0, 0, 0, 0, 0, 0, N'', N'', 1, 1, 0, 1, 1, 0, 0, 1);

            SET IDENTITY_INSERT tCTLInformes OFF
        END

END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER()    AS ErrorNumber,
           ERROR_STATE()     AS ErrorState,
           ERROR_SEVERITY()  AS ErrorSeverity,
           ERROR_PROCEDURE() AS ErrorProcedure,
           ERROR_LINE()      AS ErrorLine,
           ERROR_MESSAGE()   AS ErrorMessage;
END CATCH;
GO


