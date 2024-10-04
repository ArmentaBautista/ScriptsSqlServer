
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGRLprocesarNotificaciones')
BEGIN
	DROP PROC pGRLprocesarNotificaciones
	SELECT 'pGRLprocesarNotificaciones BORRADO' AS info
END
GO


CREATE PROCEDURE [dbo].[pGRLprocesarNotificaciones] @IdOperacion AS INT
AS
BEGIN

    DECLARE @RetirosCuentasAhorro AS TABLE
    (
        IdCuenta INT
       ,IdSocio INT
       ,Concepto VARCHAR (80)
       ,Monto NUMERIC (18, 2)
    );

    BEGIN TRY
        --se llena la tabla de retiros de cuentas de ahorro para procesar en un cursos posteriormente y se manden la notificaciones
        INSERT INTO
            @RetirosCuentasAhorro ( IdCuenta, IdSocio, Concepto, Monto )
        SELECT
            cuentas.IdCuenta
           ,cuentas.IdSocio
           ,tFinanciera.Concepto
           ,tFinanciera.CapitalPagado
        FROM
            dbo.tGRLoperaciones                         operacion  WITH(NOLOCK) 
            INNER JOIN dbo.tSDOtransaccionesFinancieras tFinanciera  WITH(NOLOCK) 
                ON tFinanciera.IdOperacion = operacion.IdOperacion
            INNER JOIN dbo.tAYCcuentas                  cuentas	 WITH(NOLOCK) 
                ON cuentas.IdCuenta        = tFinanciera.IdCuenta
        WHERE
            operacion.IdOperacionPadre         = @IdOperacion
            AND tFinanciera.IdEstatus          = 1
            AND tFinanciera.IdTipoSubOperacion = 501
            AND cuentas.IdTipoDProducto        = 144;

        --se procesan los movimientos que se guardan en la tabla de retiros de centas de ahorro
        /* declare variables */
        DECLARE
            @IdCuenta INT
           ,@IdSocio  INT
           ,@Concepto VARCHAR (80)
           ,@Monto    NUMERIC (18, 2);

        DECLARE cursorRetirosCuentasAhorro CURSOR FAST_FORWARD READ_ONLY FOR
            SELECT
                IdCuenta
               ,IdSocio
               ,Concepto
               ,Monto
            FROM
                @RetirosCuentasAhorro;

        OPEN cursorRetirosCuentasAhorro;

        FETCH NEXT FROM cursorRetirosCuentasAhorro
        INTO
            @IdCuenta
           ,@IdSocio
           ,@Concepto
           ,@Monto;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC dbo.pSMSmovimientoCuenta
                @pIdCuenta = @IdCuenta     -- int
               ,@pIdTipoSubOperacion = 501 -- int
               ,@pConcepto = @Concepto     -- varchar(80)
               ,@pMonto = @Monto;          -- numeric(12, 2)

            FETCH NEXT FROM cursorRetirosCuentasAhorro
            INTO
                @IdCuenta
               ,@IdSocio
               ,@Concepto
               ,@Monto;
        END;

        CLOSE cursorRetirosCuentasAhorro;
        DEALLOCATE cursorRetirosCuentasAhorro;
    END TRY
    BEGIN CATCH
        PRINT 'ocurrio un error al procesar las notificaciones';
    END CATCH;

END;
GO
