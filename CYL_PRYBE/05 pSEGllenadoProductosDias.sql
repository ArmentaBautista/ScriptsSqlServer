IF OBJECT_ID('pSEGllenadoProductosDias') IS NOT NULL
    DROP PROCEDURE pSEGllenadoProductosDias;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[pSEGllenadoProductosDias]
AS
BEGIN

    INSERT INTO
        dbo.tSEGproductosDias ( IdProductoFinanciero, Dias )
    SELECT
        cuenta.IdProductoFinanciero
       ,cuenta.Dias
    FROM
        dbo.fAYCsaldo(0)           fSaldo
        INNER JOIN dbo.tAYCcuentas cuenta
            ON cuenta.IdCuenta = fSaldo.IdCuenta
    WHERE
        cuenta.IdCuenta    > 0
        AND fSaldo.Capital > 0
        AND cuenta.IdTipoDProducto IN ( 398 )
        AND NOT EXISTS
        (
            SELECT
                1
            FROM
                tSEGproductosDias productosDias
            WHERE
                productosDias.IdProductoFinanciero = cuenta.IdProductoFinanciero
                AND productosDias.Dias             = cuenta.Dias
        )
    GROUP BY
        cuenta.IdProductoFinanciero
       ,cuenta.Dias;


END;
GO
