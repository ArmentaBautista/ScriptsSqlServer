-- 05.01 pCnAUDsociosConsultados.sql
IF (OBJECT_ID('pCnAUDsociosConsultados') IS NOT NULL)
        BEGIN
            DROP PROC pCnAUDsociosConsultados
            SELECT 'pCnAUDsociosConsultados BORRADO' AS info
        END
GO

CREATE PROC pCnAUDsociosConsultados
    @pTipoOperacion AS VARCHAR(24)='',
    @pFechaInicial AS DATE='19000101',
    @pFechaFinal AS DATE = '19000101',
    @pUsuario AS VARCHAR(24)='',
    @pNoSocio AS VARCHAR(24)=''
AS
BEGIN
    IF @pTipoOperacion=''
    BEGIN
        SELECT 'Debe indicar un tipo de operación válido' AS Info
        RETURN -1
    END

    DECLARE @Dias AS INT = (SELECT datediff(DAY,@pFechaInicial,@pFechaFinal))
    IF @Dias>180
    BEGIN
        SELECT 'El rango de fechas no puede ser mayor a 180 días' AS Info
        RETURN -1
    END

    IF @pTipoOperacion='FECHA'
    BEGIN
        SELECT
            *
        FROM dbo.tfAUDsociosConsultadosPorFecha(@pFechaInicial,@pFechaFinal) t

        RETURN 0
    END

    IF @pTipoOperacion='USUARIO'
    BEGIN
        IF @pUsuario=''
        BEGIN
            SELECT 'El Usuario es obligatorio' AS Info
            RETURN -1
        END

        SELECT
            *
        FROM dbo.tfAUDsociosConsultadosPorUsuario(@pFechaInicial,@pFechaFinal,@pUsuario) t

        RETURN 0
    END

    IF @pTipoOperacion='SOCIO'
    BEGIN
         IF @pNoSocio=''
        BEGIN
            SELECT 'El Usuario es obligatorio' AS Info
            RETURN -1
        END

        SELECT
            *
        FROM dbo.tfAUDsociosConsultadosPorSocio(@pFechaInicial,@pFechaFinal,@pNoSocio) t

        RETURN 0
    END

END
GO












END
GO