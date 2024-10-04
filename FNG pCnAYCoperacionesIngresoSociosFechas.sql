

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCoperacionesIngresoSociosFechas')
BEGIN
	DROP PROC pCnAYCoperacionesIngresoSociosFechas
	SELECT 'pCnAYCoperacionesIngresoSociosFechas BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROC pCnAYCoperacionesIngresoSociosFechas
    @fechaInicial AS DATE,
    @fechaFinal AS DATE
AS
-- Ingreso de Socios por Fechas}
SELECT suc.Descripcion AS Sucursal,
       sc.Codigo AS NoSocio,
       p.Nombre,
       c.Codigo AS NoCuenta,
       c.Descripcion AS Producto,
       c.SaldoCapital,
	   usr.Usuario AS UsuarioAltaSocio,
	   CAST(sc.Alta AS DATE) AS FechaRegistro,
       c.FechaAlta AS PagoAportacion,
	   c.IdDivision
FROM dbo.tSCSsocios sc WITH (NOLOCK)
    INNER JOIN dbo.tGRLpersonas p WITH (NOLOCK)
        ON p.IdPersona = sc.IdPersona
    INNER JOIN dbo.tAYCcuentas c WITH (NOLOCK)
        ON c.IdSocio = sc.IdSocio
           AND c.IdDivision = -21
           AND c.FechaAlta
           BETWEEN @fechaInicial AND @fechaFinal
	INNER JOIN dbo.tCTLusuarios usr  WITH(NOLOCK) ON usr.IdUsuario = sc.IdUsuarioAlta
	LEFT JOIN dbo.tCTLsucursales suc WITH (NOLOCK)
        ON suc.IdSucursal = c.IdSucursal   
ORDER BY Sucursal;

GO

