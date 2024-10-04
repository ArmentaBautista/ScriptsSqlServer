-- pAYCvalidarTerceroAutorizado
IF (OBJECT_ID('pAYCvalidarTerceroAutorizado') IS NOT NULL)
        BEGIN
            DROP PROC pAYCvalidarTerceroAutorizado
            SELECT 'pAYCvalidarTerceroAutorizado BORRADO' AS info
        END
GO

CREATE PROC pAYCvalidarTerceroAutorizado
    @RETURN_MESSAGE VARCHAR(max)='' OUTPUT,
    @pIdCuenta INT,
    @pIdPersonaTercero INT,
    @pEsPorMonto BIT=0 OUTPUT,
    @pEsPorVigencia BIT=0 OUTPUT,
    @pMontoPermitido NUMERIC(11,2) =0 OUTPUT ,
    @pEstaVigente BIT=0 OUTPUT
AS
BEGIN
    -- Validar que sea socio
    IF exists(SELECT 1
              FROM tSCSsocios sc WITH (NOLOCK)
              WHERE sc.IdEstatus=1
                and sc.EsSocioValido=1
                    and sc.IdPersona=@pIdPersonaTercero)
    BEGIN
        SET @RETURN_MESSAGE = 'La Persona seleccionada no es un Socio Activo, no es posible continuar con la operaci?n'
        RETURN -1
    END

    DECLARE @pFechaTrabajo DATE=getdate();
    SELECT
        @pEsPorMonto=iif(tercero.Tipo=1,1,0),
        @pEsPorVigencia=iif(tercero.Tipo=2,1,0),
        @pMontoPermitido=tercero.Monto,
        @pEstaVigente=iif(@pFechaTrabajo BETWEEN tercero.VigenciaInicio AND tercero.VigenciaFin,1,0)
    FROM tAYCtercerosAutorizados tercero WITH (NOLOCK)
    WHERE tercero.IdCuenta=@pIdCuenta
        AND tercero.IdPersona=@pIdPersonaTercero

    RETURN 0;
END
GO

