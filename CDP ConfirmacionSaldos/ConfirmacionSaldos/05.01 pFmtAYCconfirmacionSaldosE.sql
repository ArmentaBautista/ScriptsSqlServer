IF (OBJECT_ID('pFmtAYCconfirmacionSaldosE') IS NOT NULL)
    BEGIN
        DROP PROC pFmtAYCconfirmacionSaldosE
        SELECT 'pFmtAYCconfirmacionSaldosE BORRADO' AS info
    END
GO

CREATE PROC pFmtAYCconfirmacionSaldosE
@pIdConfirmacionSaldos	INT
AS
BEGIN
    SELECT
		cse.IdConfirmacionSaldos,
		cse.IdSocio,
		[NoSocio]	= sc.Codigo,
		p.Nombre,
		cse.FechaCorte,
		cse.FechaTrabajo,
		cse.YaImpreso,
		cse.IdEstatus
		FROM dbo.tAYCconfirmacionSaldosE cse  WITH(NOLOCK)
	 	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK)
			ON sc.IdSocio = cse.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK)
			ON p.IdPersona = sc.IdPersona
		WHERE cse.IdConfirmacionSaldos = @pIdConfirmacionSaldos
END
GO