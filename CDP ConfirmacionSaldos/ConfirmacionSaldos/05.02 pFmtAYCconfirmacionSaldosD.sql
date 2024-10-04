IF (OBJECT_ID('pFmtAYCconfirmacionSaldosD') IS NOT NULL)
    BEGIN
        DROP PROC pFmtAYCconfirmacionSaldosD
        SELECT 'pFmtAYCconfirmacionSaldosD BORRADO' AS info
    END
GO

CREATE PROC pFmtAYCconfirmacionSaldosD
@pIdConfirmacionSaldos	INT
AS
BEGIN
    SELECT
		csd.IdConfirmacionSaldosD,
		csd.IdConfirmacionSaldos,
        csd.Tipo,
        csd.Producto,
        csd.NoCuenta,
        csd.Capital,
        csd.InteresOrdinarioAlDia,
        csd.InteresMoratorio,
        csd.Saldo,
        csd.EstaConforme
		FROM dbo.fnAYCconfirmacionSaldosD(@pIdConfirmacionSaldos) csd
END
GO