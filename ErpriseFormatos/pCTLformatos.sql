IF (OBJECT_ID('pCTLformatos') IS NOT NULL)
    BEGIN
        DROP PROC pCTLformatos
        SELECT 'pCTLformatos BORRADO' AS info
    END
GO

CREATE PROC pCTLformatos
@pTipoOperacion VARCHAR(16)='',
@pIdTipoDdominio INT=0,
@pNombreFormato VARCHAR(32)='',
@pRfcCliente VARCHAR(13)='' OUTPUT
AS
BEGIN
    if(@pTipoOperacion='')
        return -1;

    if(@pTipoOperacion='TODOS')
    begin
        select IdInforme,
               Descripcion,
               Reporte,
               IdTipoDdominio,
               Orientacion,
               Copias,
               Papel,
               ImpresoraDefault,
               FormatoPrincipal,
               ActivarImprimir,
               ActivarExportar,
               ActivarEnviar,
               FormatoExcel,
               FormatoPDF,
               FormatoImagen,
               FormatoDefaultArchivo,
               SalidaDefault,
               EsFormato,
               IdEstatus,
               EsCheque,
               Paginas,
               PermiteVistaPrevia,
               ImpresionDoble,
               PermiteFirma,
               ImpresionesPermitidas
        from dbo.tCTLInformes i WITH (NOLOCK)
        where IdEstatus=1

        RETURN 0;
    END
    if(@pTipoOperacion='TipoDominio')
    begin
        select IdInforme,
               Descripcion,
               Reporte,
               IdTipoDdominio,
               Orientacion,
               Copias,
               Papel,
               ImpresoraDefault,
               FormatoPrincipal,
               ActivarImprimir,
               ActivarExportar,
               ActivarEnviar,
               FormatoExcel,
               FormatoPDF,
               FormatoImagen,
               FormatoDefaultArchivo,
               SalidaDefault,
               EsFormato,
               IdEstatus,
               EsCheque,
               Paginas,
               PermiteVistaPrevia,
               ImpresionDoble,
               PermiteFirma,
               ImpresionesPermitidas
        from dbo.tCTLInformes i WITH (NOLOCK)
        where IdEstatus=1
            and IdTipoDdominio=@pIdTipoDdominio

        RETURN 0;
    END
    if(@pTipoOperacion='rfc')
    BEGIN
        select
        top 1
        @pRfcCliente=p.RFC
        from tCTLempresas e WITH (NOLOCK)
        INNER JOIN tGRLpersonas p WITH (NOLOCK)
            ON e.IdPersona = p.IdPersona
        where e.IdEmpresa<>0

        RETURN 0;
    END

END
GO
SELECT 'pCTLformatos CREADO' AS info
GO