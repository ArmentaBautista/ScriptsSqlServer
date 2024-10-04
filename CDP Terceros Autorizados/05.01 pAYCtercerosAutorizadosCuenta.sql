IF (OBJECT_ID('pAYCtercerosAutorizadosCuenta') IS NOT NULL)
        BEGIN
            DROP PROC pAYCtercerosAutorizadosCuenta
            SELECT 'pAYCtercerosAutorizadosCuenta BORRADO' AS info
        END
GO

CREATE PROC pAYCtercerosAutorizadosCuenta
    @pIdCuenta as INT
AS
BEGIN
    SELECT
        per.IdPersona,
        per.Nombre,
        terc.Tipo,
        terc.Monto,
        terc.VigenciaInicio,
        terc.VigenciaFin
    FROM tAYCtercerosAutorizados terc WITH (NOLOCK)
    INNER JOIN tGRLpersonas per WITH (NOLOCK)
        ON per.IdPersona=terc.IdPersona
    WHERE terc.IdEstatus=1
        AND IdCuenta=@pIdCuenta

END
GO