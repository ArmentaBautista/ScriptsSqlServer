

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


alter PROCEDURE [dbo].[pCTLvalidacionesOperacionCuentas]
    ----Parametros de procedimiento--------------
    @IdCuenta AS INT = 0,
    @IdTipoSuboperacion AS SMALLINT = 0,
    @MontoAplicar AS NUMERIC(23, 8) = 0,
    @FechaTrabajo AS DATE = '19000101',
    @ValidarMonto AS BIT = 0,
    --parametro que se devuelve conun valor según la validación realizada
    @CodigoExcepcion AS VARCHAR(10) OUTPUT,
    --parametro que regresa un valor según el resultado de las validaciones que se realizaron en el procedimiento
    @Resultado AS BIT OUTPUT,
    @Mensaje AS VARCHAR(MAX) OUTPUT,
    @PagoAportacionSocialTotal AS BIT = 0,
    @IdSolicitudOperacion AS INTEGER
AS
BEGIN

    ----se establece el valor de resultado si se cumple alguna de las validaciones este cambiara 0
    SET @Resultado = 1;
    SET @CodigoExcepcion = ' ';
    SET @Mensaje = ' ';

    --variables que se llena atravez de la consulta de saldo, cuenta y cuentas estadisticas
    DECLARE @IdTipoDproducto AS INT = 0;
    DECLARE @Saldo AS NUMERIC(23, 8) = 0;
    DECLARE @InteresPendienteCapitalizar AS NUMERIC(23, 8) = 0;
    DECLARE @Vencimiento AS DATE = '19000101';
    DECLARE @FechaCorte AS DATE = '19000101';
    DECLARE @UltimoPagoInteres AS DATE = '19000101';
    DECLARE @IdEstatus AS INT = '';
    DECLARE @PermiteDepositosFueraVencimiento AS BIT = 0;
    DECLARE @FechaActivacion AS DATE = '19000101';
    DECLARE @MontoSolicitado AS NUMERIC(23, 8) = 0;
    DECLARE @PermiteRetiroAportacion AS NUMERIC(23, 8) = 0;
    DECLARE @IdDivision AS INT = 0;
    DECLARE @DescripcionProducto AS VARCHAR(100) = '';
	DECLARE @IdSocio AS INT = 0;
	-- JCA 20200206
	DECLARE @CodigoProducto AS VARCHAR(20)=''
	
	DECLARE @MontoAportacionSocial AS NUMERIC(23,8)=0
			SET @MontoAportacionSocial=(SELECT  REPLACE(valor,',','') FROM tCTLconfiguracion tc WHERE tc.IdConfiguracion=80);

    SELECT @CodigoProducto=tacf.Codigo,
		   @IdTipoDproducto = tac.IdTipoDProducto,
           @Saldo = tso.Saldo,
           @InteresPendienteCapitalizar = tso.InteresPendienteCapitalizar,
           @Vencimiento = tac.Vencimiento,
           @FechaCorte = tac.FechaCorte,
           @UltimoPagoInteres = tace.UltimoPagoInteres,
           @IdEstatus = tac.IdEstatus,
           @PermiteDepositosFueraVencimiento = tacf.PermiteDepositosFueraVencimiento,
           @FechaActivacion = tac.FechaActivacion,
           @MontoSolicitado = tac.MontoSolicitado,
           @PermiteRetiroAportacion = tss.PermiteRetiroAportacion,
           @IdDivision = tac.IdDivision,
           @DescripcionProducto = tacf.Descripcion,
		   @IdSocio = tac.IdSocio
    FROM dbo.tAYCcuentas AS tac WITH (NOLOCK)
        INNER JOIN dbo.tSCSsocios AS tss WITH (NOLOCK)
            ON tss.IdSocio = tac.IdSocio
        INNER JOIN dbo.tSDOsaldos AS tso WITH (NOLOCK)
            ON tso.IdCuenta = tac.IdCuenta
        INNER JOIN dbo.tAYCcuentasEstadisticas AS tace WITH (NOLOCK)
            ON tace.IdCuenta = tac.IdCuenta
        INNER JOIN dbo.tAYCproductosFinancieros AS tacf WITH (NOLOCK)
            ON tacf.IdProductoFinanciero = tac.IdProductoFinanciero
    WHERE tac.IdCuenta = @IdCuenta;

	
	-- JCA 20200206 VALIDACIÓN DE UN SOLO RETIRO POR EL MONTO TOTAL DE LA CUENTA EN PRODUCO EX SOCIOS, PARA CPA
	--DECLARE @msg AS nVARCHAR(50)
	----SET @msg = CONCAT(@CodigoProducto,@IdTipoSuboperacion,@MontoAplicar,@Saldo)
	--RAISERROR(@IdTipoSuboperacion,15,1)
	--RETURN;
    
	IF @CodigoProducto = 'HEXS'
    BEGIN
        IF @IdTipoSuboperacion = 501
        BEGIN
            IF @MontoAplicar != @Saldo
            BEGIN
                SET @CodigoExcepcion = '02003';
                SET @Mensaje = CONCAT('Se debe retirar el total del saldo', ' de la cuenta ', @Saldo);
                SET @Resultado = 0;
                RETURN 0;
            END;
			ELSE
            BEGIN
				SET @CodigoExcepcion = '02003';
                SET @Mensaje = CONCAT('JCA Se debe retirar el total del saldo', ' de la cuenta ', @MontoAplicar,@Saldo);
                SET @Resultado = 0;
                RETURN;
			END
        END;
		ELSE
			BEGIN
				SET @CodigoExcepcion = '02003';
                SET @Mensaje = CONCAT('JCA2 Se debe retirar el total del saldo', ' de la cuenta ', @IdTipoSuboperacion,@Saldo);
                SET @Resultado = 0;
                RETURN;
			END;
			END;
	ELSE
    BEGIN
				SET @CodigoExcepcion = '02003';
                SET @Mensaje = CONCAT('JCA3 Se debe retirar el total del saldo', ' de la cuenta ', @CodigoProducto,@Saldo);
                SET @Resultado = 0;
                RETURN;
	END
   



    --validar operación valida

    IF @IdTipoDproducto = 144
    BEGIN
        IF dbo.fAYCesOperacionValida(@IdCuenta, @IdTipoSuboperacion, @IdSolicitudOperacion) = 0
        BEGIN
            SET @Resultado = 0;
            SET @CodigoExcepcion = '02321';
            RETURN;
        END;
    END;


    IF @IdTipoSuboperacion = 500
       AND @PermiteRetiroAportacion = 1
    BEGIN
        SET @Resultado = 0;
        SET @CodigoExcepcion = '01641';
        RETURN;
    END;



    ------validaciones para inversión-----
    IF @IdTipoDproducto = 398 ---Inversión
    BEGIN

        --validar la operacion que se quiere realizar
        IF @IdTipoSuboperacion = 500 ---Deposito
        BEGIN

            --Validar si es la fecha de activación o vencimineto de la cuenta para permitir depósitos
            IF @PermiteDepositosFueraVencimiento = 0
               AND
               (
                   @FechaActivacion != @FechaTrabajo
                   AND @Vencimiento != @FechaTrabajo
               )
            BEGIN
                SET @Resultado = 0;
                SET @CodigoExcepcion = '00778'; --solo se pueden hacer depositos en la fecha de vencimiento o activación de la cuenta
                RETURN;
            END;

            ---Validar depósitos en la fecha de activación de las cuentas de inversión
            IF @FechaActivacion = @FechaTrabajo
               AND @ValidarMonto = 1
            BEGIN
                DECLARE @sumaDepositos AS NUMERIC(23, 8) =
                (
                    SELECT dbo.fObtenerSumaDepositos(@IdCuenta, @FechaActivacion)
                ) + @MontoAplicar;

                ----obtener el valor de la configuración para validar las acciones en el primer deposito de las cuentas de invesión------
                DECLARE @ValorConfiguracionPrimerDepositoPlazoFijo AS INT = CONVERT(   INT,
                                                                            (
                                                                                SELECT TOP 1
                                                                                    tcl.Valor
                                                                                FROM dbo.tCTLconfiguracion AS tcl
                                                                                WHERE tcl.IdConfiguracion = 141
                                                                            )
                                                                                   );

                SET @Resultado = CASE @ValorConfiguracionPrimerDepositoPlazoFijo
                                     WHEN 1 THEN --Menor o igual al monto Contratado
                                         CASE
                                             WHEN @sumaDepositos > @MontoSolicitado THEN
                                                 0
                                             ELSE
                                                 1
                                         END
                                     WHEN 2 THEN --Igual al monto Contratado
                                         CASE
                                             WHEN @sumaDepositos != @MontoSolicitado THEN
                                                 0
                                             ELSE
                                                 1
                                         END
                                     WHEN 3 THEN --Al menos igual al monto contratado
                                         CASE
                                             WHEN @sumaDepositos < @MontoSolicitado THEN
                                                 0
                                             ELSE
                                                 1
                                         END
                                     WHEN 4 THEN
                                         1
                                 END;

                SET @CodigoExcepcion = CASE @ValorConfiguracionPrimerDepositoPlazoFijo
                                           WHEN 1 THEN --Menor o igual al monto Contratado
                                               CASE
                                                   WHEN @sumaDepositos > @MontoSolicitado THEN
                                                       '01947'
                                                   ELSE
                                                       ''
                                               END
                                           WHEN 2 THEN --Igual al monto Contratado
                                               CASE
                                                   WHEN @sumaDepositos != @MontoSolicitado THEN
                                                       '01948'
                                                   ELSE
                                                       ''
                                               END
                                           WHEN 3 THEN --Al menos igual al monto contratado
                                               CASE
                                                   WHEN @sumaDepositos < @MontoSolicitado THEN
                                                       '01949'
                                                   ELSE
                                                       ''
                                               END
                                           WHEN 4 THEN
                                               ''
                                       END;
                IF @Resultado = 0
                    RETURN;
            END; --fin de validaciones sobre montos de depositos en la fecha de activacion de la cuenta de inversión        

        END; ---fin de validaciones para depositos de cuentas de inversion


        IF @IdTipoSuboperacion = 501 ---validaciones para retiro de cuentas de inversion
        BEGIN
            IF @FechaActivacion = @FechaTrabajo
               OR @Vencimiento != @FechaTrabajo --validaciones para retiros en la fecha de activacion de la cuenta o fuera del vencimiento de la cuenta
            BEGIN
                SET @Resultado = 0;
                SET @CodigoExcepcion = '00779';
                RETURN;
            END; --fin validaciones para retiros en la fecha de activacion de la cuenta o fuera de la fecha de vencimiento



        END; ---fin de validaciones para retiros de cuentas de inversion


    END; ----fin de las validaciones para productos de inversión

    IF @IdTipoDproducto = 716 ----Validaciones para el tipo de producto aportacion social
    BEGIN
        --validar el tipo de suboperacion 
        IF @IdTipoSuboperacion = 501
        BEGIN
            IF @IdDivision = -24
               AND @PagoAportacionSocialTotal = 0
               AND @PermiteRetiroAportacion = 0
            BEGIN
                SET @CodigoExcepcion = '02003';
                SET @Mensaje = CONCAT('No se puede realizar el retiro del producto ', @DescripcionProducto);
                SET @Resultado = 0;
                RETURN;
            END;

            IF @IdDivision = -24
               AND @PagoAportacionSocialTotal = 1
            BEGIN
                SET @CodigoExcepcion = '02003';
                SET @Mensaje
                    = CONCAT(
                                'No se puede modificar el monto a retirar del producto ',
                                @DescripcionProducto,
                                ' si se esta realizando el pago de aportación social'
                            );
                SET @Resultado = 0;
                RETURN;
            END;


			IF @IdDivision = -21 AND @Saldo < @MontoAportacionSocial
			RETURN


            IF @IdDivision != 24
               AND @PermiteRetiroAportacion = 0
            BEGIN
                SET @CodigoExcepcion = '01633';
                SET @Resultado = 0;
                RETURN;
            END;

        END;

    END;

    --------inicia la validación para el tipo de productos de cuentas sin movimientos
    IF @IdTipoDproducto = 1570
    BEGIN
        IF @IdTipoSuboperacion = 500
        BEGIN
            IF @IdDivision = -25
            BEGIN
                SET @CodigoExcepcion = '02003';
                SET @Mensaje
                    = CONCAT('No se pueden realizar depósitos para las cuentas de ', '"ADOLESCENTES INACTIVOS"');
                SET @Resultado = 0;
                RETURN;
            END;
        END;

        IF @IdTipoSuboperacion = 501
        BEGIN
            IF @ValidarMonto = 1
               AND @MontoAplicar != @Saldo
            BEGIN
                SET @CodigoExcepcion = '02003';
                SET @Mensaje = CONCAT('JCA Se debe retirar el total del saldo', ' de la cuenta ', @Saldo);
                SET @Resultado = 0;
                RETURN;
            END;
        END;

    END;




    ----SI ES TIPO DE PRODUCTO ES AHORRO Y ES DEPÓSITO
    IF @IdTipoDproducto = 144
       AND @IdTipoSuboperacion = 500
    BEGIN

        IF @ValidarMonto = 1
        BEGIN
            --validar primer depósito			
            IF EXISTS
            (
                SELECT 1
                FROM dbo.fAYCobtenerDatosPrimerDeposito(@IdCuenta)
                WHERE @MontoAplicar < MontoPrimerDeposito
                      AND MontoPrimerDeposito != 0
                      AND ExisteMovimiento = 0
            )
            BEGIN
                 SET @CodigoExcepcion = '02003';
                SET @Mensaje
                    = CONCAT(
                                'El primer monto debe ser mayor o igual al monto de primer depósito especificado en el producto',
                                ''
                            );
                SET @Resultado = 0;
                RETURN;
            END;
        END;


        --Validar Monto permitido para Menores de acuerdo al valor equivalente de UDIS por la CNBV
        EXEC dbo.pCTLvalidaOperacionMenores @FechaTrabajo = @FechaTrabajo,                          -- date
                                            @Monto = @MontoAplicar,                                 -- numeric(23, 8)
                                            @IdCuenta = @IdCuenta,                                  -- int
                                            @PermiteDepositoMenorIndependiente = @Resultado OUTPUT, -- bit
                                            @CodigoExcepcion = @CodigoExcepcion OUTPUT;             -- varchar(max)
        -- varchar(max)
        IF @CodigoExcepcion IS NOT NULL
           AND @Resultado = 0
        BEGIN
            RETURN;
        END;
    END;

    IF @IdTipoDproducto = 2196 --productos Acreedores
       AND @IdTipoSuboperacion = 500
    BEGIN
        IF @ValidarMonto = 1
        BEGIN
            --validar primer depósito			
            IF EXISTS
            (
                SELECT 1
                FROM dbo.fAYCobtenerDatosPrimerDeposito(@IdCuenta)
                WHERE @MontoAplicar < MontoPrimerDeposito
                      AND MontoPrimerDeposito != 0
                      AND ExisteMovimiento = 0
            )
            BEGIN
                SET @CodigoExcepcion = '02003';
                SET @Mensaje
                    = CONCAT(
                                'El primer monto debe ser mayor o igual al monto de primer depósito especificado en el producto',
                                ''
                            );
                SET @Resultado = 0;
                RETURN;
            END;
        END;
    END;


	


END;

GO



