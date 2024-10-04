
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fAYCcuentasPersonas')
BEGIN
	DROP FUNCTION fAYCcuentasPersonas
	SELECT 'fAYCcuentasPersonas BORRADO' AS info
END
GO

CREATE FUNCTION [dbo].[fAYCcuentasPersonas]
(
    @IdPersona AS INT = 0,
    @Fecha AS DATE = '19000101'
)
RETURNS @CuentasPersona TABLE
(
    IdCuenta INT,
    [No.Cuenta] VARCHAR(100),
    Producto VARCHAR(1024),
    Tipo VARCHAR(1024),
    DiasMora INT,
    ParcialidadesVencidas INT,
    TotalAtrasado INT,
    SaldoTotal NUMERIC(18, 2),
    IdPersona INT,
    IdSocio INT,
    Estatus VARCHAR(1024),
    IdTipoDproducto INT,
    SaldoCapital NUMERIC(18, 2)
)
AS
BEGIN

    /*-----------------------------------------------------------------------
			Obtener el detalle de l as cuenta de cada persona.
-----------------------------------------------------------------------*/
    DECLARE @IdSocio AS INT;

    SELECT @IdSocio = IdSocio
    FROM tSCSsocios WITH ( NOLOCK )
    WHERE IdPersona = @IdPersona AND IdEstatus = 1;

    IF @IdSocio != 0
        IF EXISTS ( SELECT 1
                    FROM dbo.tAYCcuentas cuenta WITH ( NOLOCK )
                    INNER JOIN dbo.tSCSsocios socio WITH ( NOLOCK ) ON socio.IdSocio = cuenta.IdSocio AND cuenta.IdTipoDProducto = 143 AND cuenta.IdEstatus = 1 AND cuenta.SaldoCapital > 0 )
        BEGIN
            IF EXISTS ( SELECT 1
                        FROM dbo.tAYCcuentas cuenta WITH ( NOLOCK )
                        INNER JOIN dbo.tSCSsocios socio WITH ( NOLOCK ) ON socio.IdSocio = cuenta.IdSocio AND cuenta.IdTipoDProducto = 143 AND cuenta.IdEstatus = 1 AND cuenta.SaldoCapital > 0
                        INNER JOIN dbo.tSDOtransaccionesFinancieras tFinanciera WITH ( NOLOCK ) ON tFinanciera.IdOperacion > 0 AND tFinanciera.IdCuenta = cuenta.IdCuenta AND cuenta.IdEstatus = 1 AND tFinanciera.IdTipoSubOperacion = 500 AND tFinanciera.Fecha = @Fecha )
            BEGIN
                INSERT INTO @CuentasPersona ( IdCuenta, [No.Cuenta], Producto, Tipo, DiasMora, ParcialidadesVencidas, TotalAtrasado, SaldoTotal, IdPersona, IdSocio, Estatus, IdTipoDproducto, SaldoCapital )
                ---cuentas deudoras
                SELECT c.IdCuenta,
                       [No.Cuenta] = c.Codigo,
                       [Producto] = pf.Descripcion,
                       [Tipo] = tipo.Descripcion,
                       ISNULL (f.DiasMora, 0) AS DiasMora,
                       ISNULL (f.ParcialidadesVencidas, 0) AS ParcialidadesVencidas,
                       ISNULL (f.CapitalAtrasado, 0) AS TotalAtrasado,
                       ISNULL (f.SaldoTotal, 0) AS SaldoTotal,
                       p.IdPersona,
                       s.IdSocio,
                       e.Descripcion AS Estatus,
                       c.IdTipoDProducto,
                       ISNULL (f.Capital, 0) AS SaldoCapital
                FROM dbo.tAYCcuentas c WITH ( NOLOCK )
                JOIN dbo.tCTLestatus e WITH ( NOLOCK ) ON e.IdEstatus = c.IdEstatus AND e.IdEstatus IN (1)
                JOIN dbo.tCTLestatus ee WITH ( NOLOCK ) ON ee.IdEstatus = c.IdEstatusEntrega AND ee.IdEstatus = 20
                JOIN dbo.tCTLtiposD tipo WITH ( NOLOCK ) ON tipo.IdTipoD = c.IdTipoDAIC
                JOIN dbo.tAYCproductosFinancieros pf WITH ( NOLOCK ) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
                JOIN dbo.tSCSsocios s WITH ( NOLOCK ) ON s.IdSocio = c.IdSocio
                JOIN dbo.tGRLpersonas p WITH ( NOLOCK ) ON p.IdPersona = s.IdPersona
                LEFT JOIN dbo.fAYCcalcularSaldoDeudoras2 (0, @IdSocio, @Fecha, 2) f ON f.IdCuenta = c.IdCuenta
                WHERE p.IdPersona = @IdPersona AND c.IdTipoDProducto = 143;
            END;
            ELSE
            BEGIN
                INSERT INTO @CuentasPersona ( IdCuenta, [No.Cuenta], Producto, Tipo, DiasMora, ParcialidadesVencidas, TotalAtrasado, SaldoTotal, IdPersona, IdSocio, Estatus, IdTipoDproducto, SaldoCapital )

                ---cuentas deudoras
                SELECT c.IdCuenta,
                       [No.Cuenta] = c.Codigo,
                       [Producto] = pf.Descripcion,
                       [Tipo] = tipo.Descripcion,
                       dbo.fAYCmoraMaxima (@Fecha, c.PrimerVencimientoPendienteCapital, c.PrimerVencimientoPendienteInteres) AS DiasMora,
                       ISNULL (fParAtr.ParcialidadesAtrasadas, 0) AS ParcialidadesVencidas,
                       ISNULL (cartera.CapitalAtrasado, 0) AS TotalAtrasado,
                       ISNULL (c.SaldoCapital + cartera.InteresOrdinario + cartera.InteresMoratorioTotal + cartera.IVAInteresOrdinario + cartera.IVAinteresMoratorio, 0) AS SaldoTotal,
                       p.IdPersona,
                       s.IdSocio,
                       e.Descripcion AS Estatus,
                       c.IdTipoDProducto,
                       ISNULL (c.SaldoCapital, 0) AS SaldoCapital
                FROM dbo.tAYCcuentas c WITH ( NOLOCK )
                JOIN dbo.tCTLestatus e WITH ( NOLOCK ) ON e.IdEstatus = c.IdEstatus AND e.IdEstatus IN (1)
                JOIN dbo.tCTLestatus ee WITH ( NOLOCK ) ON ee.IdEstatus = c.IdEstatusEntrega AND ee.IdEstatus = 20
                JOIN dbo.tCTLtiposD tipo WITH ( NOLOCK ) ON tipo.IdTipoD = c.IdTipoDAIC
                JOIN dbo.tAYCproductosFinancieros pf WITH ( NOLOCK ) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
                JOIN dbo.tSCSsocios s WITH ( NOLOCK ) ON s.IdSocio = c.IdSocio
                JOIN dbo.tGRLpersonas p WITH ( NOLOCK ) ON p.IdPersona = s.IdPersona
                --LEFT JOIN dbo.fAYCcalcularSaldoDeudoras2(0,(ISNULL((SELECT IdSocio FROM tSCSsocios With (nolock)  WHERE idpersona=@IdPersona),0)),@Fecha,2) f ON f.IdCuenta = c.IdCuenta
                LEFT JOIN dbo.fGYCparcialidadesAtrazadas (@Fecha) fParAtr ON fParAtr.IdCuenta = c.IdCuenta
                LEFT JOIN dbo.tAYCcartera cartera WITH(NOLOCK) ON cartera.FechaCartera = @Fecha AND cartera.IdCuenta = c.IdCuenta
                WHERE p.IdPersona = @IdPersona AND c.IdTipoDProducto = 143;
            END;
        END;

    INSERT INTO @CuentasPersona ( IdCuenta, [No.Cuenta], Producto, Tipo, DiasMora, ParcialidadesVencidas, TotalAtrasado, SaldoTotal, IdPersona, IdSocio, Estatus, IdTipoDproducto, SaldoCapital )

    --Cuentas acreedoras
    SELECT c.IdCuenta,
           [No.Cuenta] = c.Codigo,
           [Producto] = pf.Descripcion,
           [Tipo] = tipo.Descripcion,
           0 AS DiasMora,
           0 AS ParcialidadesVencidas,
           0 AS TotalAtrasado,
           f.Saldo AS SaldoTotal,
           p.IdPersona,
           s.IdSocio,
           e.Descripcion AS Estatus,
           c.IdTipoDProducto,
           ISNULL (f.Capital, 0) AS SaldoCapital
    FROM dbo.tAYCcuentas c WITH ( NOLOCK )
    JOIN dbo.tCTLestatus e WITH ( NOLOCK ) ON e.IdEstatus = c.IdEstatus AND e.IdEstatus = 1
    JOIN dbo.tCTLtiposD tipo WITH ( NOLOCK ) ON tipo.IdTipoD = c.IdTipoDAIC
    JOIN dbo.tAYCproductosFinancieros pf WITH ( NOLOCK ) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
    JOIN dbo.tSCSsocios s WITH ( NOLOCK ) ON s.IdSocio = c.IdSocio
    JOIN dbo.tGRLpersonas p WITH ( NOLOCK ) ON p.IdPersona = s.IdPersona
    JOIN dbo.fAYCsaldo (0) f ON f.IdCuenta = c.IdCuenta
    WHERE p.IdPersona = @IdPersona AND c.IdTipoDProducto IN (144, 398);

    RETURN;
END;
GO

