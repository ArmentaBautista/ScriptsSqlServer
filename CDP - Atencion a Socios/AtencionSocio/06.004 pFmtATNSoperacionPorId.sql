IF (OBJECT_ID('pFmtATNSoperacionPorId') IS NOT NULL)
        BEGIN
            DROP PROC pFmtATNSoperacionPorId
            SELECT 'pFmtATNSoperacionPorId BORRADO' AS info
        END
GO

CREATE PROC pFmtATNSoperacionPorId
@RETURN_MESSAGE VARCHAR(MAX)='' OUTPUT,
@pIdOperacion INT=0
AS
BEGIN
    SELECT
        atn.IdOperacion AS Folio,
        atn.Fecha,
        emp.Codigo AS ClaveEmpleado,
        per.Nombre AS Empleado,
        suc.Descripcion AS Sucursal,
        aten.Descripcion AS TipoAtencion,
        sc.Codigo AS NoSocio,
        psc.Nombre AS Socio,
        isnull(cta.Codigo,'') AS NoCuenta,
        tip.Codigo AS TipoOperacion,
        oper.Folio AS FolioOperacion,
        FORMAT(atn.montoReclamado,'C','es-MX') AS MontoReportado,
        medio.Descripcion AS MedioNotificacion,
        atn.OtroMedioNotificacion,
        causa.Descripcion AS Causa,
        subcausa.Descripcion AS SubCausa,
        Declaracion,
        Captcha
    FROM tATNSoperaciones atn WITH (NOLOCK)
    INNER JOIN tPERempleados emp WITH (NOLOCK)
        ON atn.IdEmpleadoResponsable = emp.IdEmpleado
    INNER JOIN tGRLpersonas per WITH (NOLOCK)
        ON per.IdPersona = emp.IdPersonaFisica
    INNER JOIN tCTLsucursales suc WITH (NOLOCK)
        ON atn.IdSucursal = suc.IdSucursal
    INNER JOIN tATNStiposAtencion aten WITH (NOLOCK)
        ON atn.IdTipoAtencion = aten.IdTipoAtencion
    INNER JOIN tSCSsocios sc WITH (NOLOCK)
        ON atn.IdSocio = sc.IdSocio
    INNER JOIN tGRLpersonas psc WITH (NOLOCK)
        ON psc.IdPersona = sc.IdPersona
    INNER JOIN tATNSmediosNotificacion medio WITH (NOLOCK)
        ON atn.IdMedioNotificacion = medio.IdMedioNotificacion
    INNER JOIN tATNStiposCausa causa WITH (NOLOCK)
        ON atn.IdTipoCausa = causa.IdTipoCausa
    left JOIN tATNSsubtiposCausa subcausa WITH (NOLOCK)
        ON atn.IdSubtipoCausa = subcausa.IdSubtipoCausa
    LEFT JOIN tAYCcuentas cta WITH (NOLOCK)
        ON atn.IdCuenta = cta.IdCuenta
    left JOIN tgrloperaciones oper WITH (NOLOCK)
        ON oper.IdOperacion = atn.IdOperacionReportada
    left JOIN tCTLtiposOperacion tip WITH (NOLOCK)
        ON tip.IdTipoOperacion=oper.IdTipoOperacion
    WHERE atn.IdOperacion=@pIdOperacion
END
GO
SELECT 'pFmtATNSoperacionPorId CREADO' AS info
GO

