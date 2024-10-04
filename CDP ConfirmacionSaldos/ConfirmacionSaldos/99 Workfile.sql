

SELECT TOP 1000 sc.IdSocio, sc.Codigo, p.Nombre, c.IdCuenta, c.Codigo, c.Descripcion
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdSocio = sc.IdSocio
		AND c.IdTipoDProducto IN (144,143,398)
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
WHERE EsSocioValido=1 AND c.IdEstatus=1
ORDER BY IdSocio desc
GO

DECLARE @pIdConfirmacionSaldos INT,
        @pFechaCorte DATE;
SELECT
		@pIdConfirmacionSaldos,
		c.IdCuenta,
		c.IdTipoDProducto,
		IIF(c.IdTipoDProducto=143,ct.CapitalAlDia,c.SaldoCapital),
		ct.InteresOrdinarioTotalAtrasado,
		ct.InteresMoratorioTotal,
		IIF(c.IdTipoDProducto=143,ct.CapitalAlDia,c.SaldoCapital)
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		LEFT JOIN dbo.tAYCcartera ct  WITH(NOLOCK) 
			ON ct.IdCuenta=c.IdCuenta
				AND ct.FechaCartera=@pFechaCorte
		WHERE c.IdEstatus=1 
			AND c.IdTipoDProducto IN (144,143,398)
			AND c.IdSocio=85990


GO



DECLARE @pIdConfirmacionSaldos INT,
        @pFechaCorte DATE;

EXEC dbo.pAYCconfirmacionSaldos @TipoOperacion = 'C',                                    -- varchar(24)
                                @pIdSocio = 85990,                                          -- int
                                @pIdConfirmacionSaldos = @pIdConfirmacionSaldos OUTPUT, -- int
                                @pFechaTrabajo = '2023-07-25',                          -- date
                                @pFechaCorte = @pFechaCorte OUTPUT 

SELECT @pIdConfirmacionSaldos, @pFechaCorte



SELECT * FROM dbo.tAYCconfirmacionSaldosE
SELECT * FROM dbo.tAYCconfirmacionSaldosD


EXEC dbo.pAYCconfirmacionSaldos @TipoOperacion = 'F3_FOLIO', @pCadenaBusqueda='altam'

-- 0001-085642


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
		FROM dbo.fnAYCconfirmacionSaldosD(5) csd


EXEC dbo.pAYCconfirmacionSaldos @pTipoOperacion = 'OBT',
                                @pIdConfirmacionSaldos=5

