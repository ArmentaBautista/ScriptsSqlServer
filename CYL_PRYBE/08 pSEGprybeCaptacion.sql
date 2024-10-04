IF OBJECT_ID('pSEGprybeCaptacion') IS NOT NULL
    DROP PROCEDURE pSEGprybeCaptacion;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[pSEGprybeCaptacion] @Periodo AS VARCHAR (20)
AS
BEGIN
	
	EXEC dbo.pSEGllenadoProductosDias
	EXEC dbo.pSEGllenadoProductos144
	EXEC dbo.pSEGllenadoProductos398


    DECLARE @CuentasReportePrybe AS TABLE
    (
        IdCuenta INT
       ,IdSocio INT
       ,Dias INT
       ,SaldoTotal NUMERIC (18, 2)
    );

    DECLARE
        @IdPeriodo AS INT
       ,@FechaFin  AS DATE;

    SELECT
        @IdPeriodo = periodo.IdPeriodo
       ,@FechaFin  = periodo.Fin
    FROM
        dbo.tCTLperiodos periodo
    WHERE
        periodo.Codigo = @Periodo;


    --insertar cuentas de  pa, pp
    INSERT INTO
        @CuentasReportePrybe ( IdSocio, IdCuenta, Dias, SaldoTotal )
    SELECT
        IdSocio  = cuenta.IdSocio
       ,IdCuenta = cuenta.IdCuenta
       ,Dias     = 30
       ,Saldo    = SUM(ISNULL(tFinanciera.CapitalGenerado, 0) - ISNULL(tFinanciera.CapitalPagado, 0))
    FROM
        dbo.tSDOtransaccionesFinancieras tFinanciera WITH ( NOLOCK )
        INNER JOIN dbo.tAYCcuentas       cuenta WITH ( NOLOCK )
            ON cuenta.IdCuenta           = tFinanciera.IdCuenta
        INNER JOIN dbo.tCTLsucursales    sucursal WITH ( NOLOCK )
            ON sucursal.IdSucursal       = cuenta.IdSucursal
               AND cuenta.IdDivision IN ( -21, -24 )
               AND tFinanciera.IdEstatus = 1
               AND tFinanciera.Fecha     <= @FechaFin
    GROUP BY
        cuenta.IdSocio
       ,cuenta.IdCuenta
       ,sucursal.Descripcion
    HAVING
        SUM(ISNULL(tFinanciera.CapitalGenerado, 0) - ISNULL(tFinanciera.CapitalPagado, 0)) > 0;

    --insertar cuentas de p3
    INSERT INTO
        @CuentasReportePrybe ( IdSocio, IdCuenta, Dias, SaldoTotal )
    SELECT
        IdSocio  = cuenta.IdSocio
       ,IdCuenta = cuenta.IdCuenta
       ,30
       ,Saldo    = SUM(ISNULL(tFinanciera.CapitalGenerado, 0) - ISNULL(tFinanciera.CapitalPagado, 0))
    FROM
        dbo.tSDOtransaccionesFinancieras tFinanciera WITH ( NOLOCK )
        INNER JOIN dbo.tAYCcuentas       cuenta WITH ( NOLOCK )
            ON cuenta.IdCuenta            = tFinanciera.IdCuenta
        INNER JOIN dbo.tCTLsucursales    sucursal WITH ( NOLOCK )
            ON sucursal.IdSucursal        = cuenta.IdSucursal
               AND cuenta.IdTipoDProducto = 2621
               AND tFinanciera.IdEstatus  = 1
               AND tFinanciera.Fecha      <= @FechaFin
    GROUP BY
        cuenta.IdSocio
       ,cuenta.IdCuenta
    HAVING
        SUM(ISNULL(tFinanciera.CapitalGenerado, 0) - ISNULL(tFinanciera.CapitalPagado, 0)) > 0;

    INSERT INTO
        @CuentasReportePrybe ( IdCuenta, IdSocio, Dias, SaldoTotal )
    SELECT
        cuenta.IdCuenta
       ,cuenta.IdSocio
       ,Dias      = IIF(cuenta.IdTipoDProducto = 398, cuenta.Dias, 30)
       ,hAcreedora.SaldoFinal
    FROM
        dbo.tSDOhistorialAcreedoras hAcreedora
        INNER JOIN dbo.tAYCcuentas  cuenta
            ON cuenta.IdCuenta = hAcreedora.IdCuenta
    WHERE
        hAcreedora.IdPeriodo     = @IdPeriodo
        AND hAcreedora.IdEstatus = 1;


    SELECT
        Socio         = socio.Codigo
       --,productoRangos.IdProducto
       ,persona.Nombre
       ,Cuenta        = cuenta.Codigo
       ,Producto      = pFinanciero.Descripcion
       ,Dias          = IIF(cuenta.IdTipoDProducto = 398, cuenta.Dias, 0)
       ,Rango         = IIF(cuenta.IdTipoDProducto = 398
                           ,CONCAT('DE ', productoRangos.LimiteInferior, ' A ', productoRangos.LimiteSuperior)
                           ,'')
       ,[Saldo total] = IIF(hAcreedora.IdCuenta IS NULL, cuentasReporte.SaldoTotal, hAcreedora.SaldoFinal)
    FROM
        dbo.tAYCcuentas                         cuenta
        INNER JOIN @CuentasReportePrybe         cuentasReporte
            ON cuenta.IdCuenta                     = cuentasReporte.IdCuenta
        LEFT JOIN dbo.tSDOhistorialAcreedoras   hAcreedora
            ON hAcreedora.IdCuenta                 = cuentasReporte.IdCuenta
               AND hAcreedora.IdPeriodo            = @IdPeriodo
        INNER JOIN dbo.tSCSsocios               socio
            ON socio.IdSocio                       = cuenta.IdSocio
        INNER JOIN dbo.tGRLpersonas             persona
            ON persona.IdPersona                   = socio.IdPersona
        INNER JOIN dbo.tAYCproductosFinancieros pFinanciero
            ON pFinanciero.IdProductoFinanciero    = cuenta.IdProductoFinanciero
        LEFT JOIN tSEGproductos                 AS productoRangos
            ON productoRangos.IdProductoFinanciero = cuenta.IdProductoFinanciero
               AND cuenta.Dias                     = productoRangos.Dias
               AND cuentasReporte.SaldoTotal
               BETWEEN productoRangos.LimiteInferior AND productoRangos.LimiteSuperior;


END;
GO
