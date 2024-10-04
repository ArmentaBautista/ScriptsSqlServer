
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCRUDoperaciones')
BEGIN
	DROP PROC pCRUDoperaciones
	SELECT 'pCRUDoperaciones BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE Proc dbo.pCRUDoperaciones 
/***********************************************************
* Procedure description:
* Date:   30/03/2015 
* Author: Ivan.Meza
*
* Changes
* Date       Modified By                Comments
************************************************************
*
************************************************************/
    @TipoOperacion VARCHAR(5) ,
    @IdOperacion AS INT = 0 OUTPUT ,
    @IdRecurso AS INT = 0 ,
    @Serie AS VARCHAR(10) = '' ,
    @Folio AS INT = 0 OUTPUT ,
    @IdTipoOperacion AS INT = 0 ,
    @IdComprobante AS INT = 0 ,
    @Comprobante AS VARCHAR(30) = '' ,
    @Fecha AS DATE = '19000101' ,
    @IdCondicionPago AS INT = 0 ,
    @Vencimiento AS DATE = '19000101' ,
    @Concepto AS VARCHAR(80) = '' ,
    @IdPersona AS INT = 0 ,
    @IdCliente AS INT = 0 ,
    @IdClienteFiscal AS INT = 0 ,
    @IdEmisorProveedor AS INT = 0 ,
    @IdProveedorFiscal AS INT = 0 ,
    @IdSocio AS INT = 0 ,
    @IdGrupo AS INT = 0 ,
    @IdPeriodo AS INT = 0 ,
    @IdPolizaE AS INT = 0 ,
    @IdSucursal AS INT = 0 ,
    @IdPersonaVendedor AS INT = 0 ,
    @IdCuentaABCDretiro AS INT = 0 ,
    @IdCuentaABCDdeposito AS INT = 0 ,
    @IdMetodoPago AS INT = 0 ,
    @IdAlmacenSalida AS INT = 0 ,
    @IdAlmacenEntrada AS INT = 0 ,
    @IdDivisa AS INT = 0 ,
    @FactorDivisa AS NUMERIC(23, 8) = 0 ,
    @Importe AS NUMERIC(23, 8) = 0 ,
    @DescuentoPorcentaje AS NUMERIC(23, 8) = 0 ,
    @Descuento AS NUMERIC(23, 8) = 0 ,
    @SubTotal AS NUMERIC(23, 8) = 0 ,
    @Impuestos AS NUMERIC(23, 8) = 0 ,
    @Total AS NUMERIC(23, 8) = 0 ,
    @Saldo AS NUMERIC(23, 8) = 0 ,
    @ImporteLocal AS NUMERIC(23, 8) = 0 ,
    @DescuentoLocal AS NUMERIC(23, 8) = 0 ,
    @SubTotalLocal AS NUMERIC(23, 8) = 0 ,
    @ImpuestosLocal AS NUMERIC(23, 8) = 0 ,
    @TotalLocal AS NUMERIC(23, 8) = 0 ,
    @SaldoLocal AS NUMERIC(23, 8) = 0 ,
    @RelOperacionesD AS INT = 0 ,
    @RelOperaciones AS INT = 0 ,
    @RelTransacciones AS INT = 0 ,
    @RelTransaccionesFinancieras AS INT = 0 ,
    @IdRelValoresCampos AS INT = 0 ,
    @IdContactoAsignado AS INT = 0 ,
    @IdDomicilioEntrega AS INT = 0 ,
    @IdListaDLAB AS INT = 0 ,
    @IdEmpleadoComprador AS INT = 0 ,
    @IdTipoDcomprobante AS INT = 0 ,
    @IdCheque AS INT = 0 ,
    @IdEmpleadoSolicitante AS INT = 0 ,
    @IdCuentaABCD AS INT = 0 ,
    @IdCierre AS INT = 0 ,
    @IdCorte AS INT = 0 ,
    @TienePoliza AS BIT = 0 ,
    @IdListaDPoliza AS INT = 0 ,
    @IdEstatus AS INT = 0 ,
    @IdUsuarioAlta AS INT = 0 ,
    @IdUsuarioCambio AS INT = 0 ,
    @IdTipoDdominio AS INT = 0 ,
    @IdObservacionE AS INT = 0 ,
    @IdObservacionEDominio AS INT = 0 ,
    @IdSesion AS INT = 0 ,
    @RequierePoliza AS BIT = 0 ,
    @IdImpuesto AS INT = 0 ,
    @BaseExenta AS NUMERIC(23, 8) = 0 ,
    @BaseExentaLocal AS NUMERIC(23, 8) = 0 ,
    @BaseIVACero AS NUMERIC(23, 8) = 0 ,
    @BaseIVACeroLocal AS NUMERIC(23, 8) = 0 ,
    @BaseIVA AS NUMERIC(23, 8) = 0 ,
    @BaseIVALocal AS NUMERIC(23, 8) = 0 ,
    @IVA AS NUMERIC(23, 8) = 0 ,
    @IVALocal AS NUMERIC(23, 8) = 0 ,
    @RetencionIVA AS NUMERIC(23, 8) = 0 ,
    @RetencionIVALocal AS NUMERIC(23, 8) = 0 ,
    @ISR AS NUMERIC(23, 8) = 0 ,
    @ISRLocal AS NUMERIC(23, 8) = 0 ,
    @RetencionISR AS NUMERIC(23, 8) = 0 ,
    @RetencionISRLocal AS NUMERIC(23, 8) = 0 ,
    @IEPS AS NUMERIC(23, 8) = 0 ,
    @IEPSLocal AS NUMERIC(23, 8) = 0 ,
    @Impuesto1 AS NUMERIC(23, 8) = 0 ,
    @Impuesto1Local AS NUMERIC(23, 8) = 0 ,
    @RetencionImpuesto1 AS NUMERIC(23, 8) = 0 ,
    @RetencionImpuesto1Local AS NUMERIC(23, 8) = 0 ,
    @Impuesto2 AS NUMERIC(23, 8) = 0 ,
    @Impuesto2Local AS NUMERIC(23, 8) = 0 ,
    @RetencionImpuesto2 AS NUMERIC(23, 8) = 0 ,
    @RetencionImpuesto2Local AS NUMERIC(23, 8) = 0 ,
    @IdDominioPrincipal AS INT = 0 ,
    @IdOperacionOrigen AS INT = 0 ,
    @IdTipoDregistro AS INT = 0 ,
    @IdTipoDdominioOrigen AS INT = 0 ,
    @IdTipoDdominioDestino AS INT = 0 ,
    @NumeroMovimiento AS INT = 0 ,
    @FormaPago AS VARCHAR(150) = '' ,
    @MotivoDescuento AS VARCHAR(80) = '' ,
    @Email AS VARCHAR(150) = '' ,
    @NumeroCuentaPago AS VARCHAR(20) = '' ,
    @Referencia AS VARCHAR(30) = '' ,
    @IdAuxiliar AS INT = 0 ,
    @AfectarAuxiliarRetenciones AS BIT = 0 ,
    @IdPeticion AS INT = 0 ,
    @EsPDA AS BIT = 0 ,
    @IdPersonaMovimiento AS INT = 0 ,
    @EsBasica AS BIT = 0,
	@IdFormaPagoSat INT = 0,
	@IdMetodoPagoSat INT = 0,
	@IdUsoCFDI INT = 0,
	--------------------GJM-------------------------
	@IdTipoDCategoria INT  = 0
	--------------------------------------------
	
AS
    BEGIN 

        SET NOCOUNT ON; 
        SET XACT_ABORT ON;
        Set Transaction Isolation Level Read Uncommitted; 

        DECLARE @Alta DATETIME= CURRENT_TIMESTAMP;
        DECLARE @UltimoCambio DATETIME= CURRENT_TIMESTAMP;
        DECLARE @AltaLocal AS  DATETIME = CURRENT_TIMESTAMP ;
		SET @AltaLocal  = dbo.fnObtenerZonaHorariaActual(@IdSucursal);
        IF ( @TipoOperacion = 'C' )
            BEGIN
    
                --Generacion y obtención del folio.	
				--Estatus 106 VISTA PREVIA DE CFDIS
				IF (@IdTipoOperacion != 510 OR (@IdTipoOperacion = 510 AND @IdEstatus != 106))
				BEGIN
					EXECUTE [dbo].[pLSTseriesRangosFolios] 'LST', @IdTipoOperacion, @Serie, 1, @Fecha, @Folio OUTPUT;    
				END
				
				SET @RequierePoliza=ISNULL((SELECT TOP 1 GeneraPoliza FROM dbo.tCTLseries WITH(NOLOCK) WHERE Serie=@Serie AND IdTipoOperacion=@IdTipoOperacion),1)
				
				if (@IdTipoOperacion = 15)
				BEGIN				   
					Set @RequierePoliza = 0				    
				END

				DECLARE @AccionContable int	 =0;		
				SELECT @AccionContable = CAST(Valor AS int)
				FROM dbo.tCTLconfiguracion
				WHERE IdConfiguracion=280

				SET @RequierePoliza = IIF(@AccionContable=3,0,@RequierePoliza)
				
                IF @EsBasica = 1
                    BEGIN
						INSERT INTO dbo.tGRLoperaciones(IdRecurso, Serie, Folio, IdTipoOperacion, IdComprobante, Comprobante, Fecha, IdCondicionPago, Vencimiento, Concepto, IdPersona, IdCliente, IdClienteFiscal, IdEmisorProveedor, IdProveedorFiscal, IdSocio, IdGrupo, IdPeriodo, IdPolizaE, IdSucursal, IdPersonaVendedor, IdCuentaABCDretiro, IdCuentaABCDdeposito, IdMetodoPago, IdDivisa, FactorDivisa, Importe, SubTotal, Impuestos, Total, IdCheque, IdCuentaABCD, IdCierre, IdCorte, TienePoliza, IdListaDPoliza, IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio, IdTipoDdominio, IdObservacionE, IdObservacionEDominio, IdSesion, RequierePoliza, AltaLocal, IdListaDCategoria)
						VALUES(@IdRecurso, @Serie, @Folio, @IdTipoOperacion, @IdComprobante, @Comprobante, @Fecha, @IdCondicionPago, @Vencimiento, @Concepto, @IdPersona, @IdCliente, @IdClienteFiscal, @IdEmisorProveedor, @IdProveedorFiscal, @IdSocio, @IdGrupo, @IdPeriodo, @IdPolizaE, @IdSucursal, @IdPersonaVendedor, @IdCuentaABCDretiro, @IdCuentaABCDdeposito, @IdMetodoPago, @IdDivisa, @FactorDivisa, @Importe, @SubTotal, @Impuestos, @Total, @IdCheque, @IdCuentaABCD, @IdCierre, @IdCorte, @TienePoliza, @IdListaDPoliza, @IdEstatus, @IdUsuarioAlta, @Alta, @IdUsuarioCambio, @UltimoCambio, @IdTipoDdominio, @IdObservacionE, @IdObservacionEDominio, @IdSesion, @RequierePoliza, @AltaLocal, @IdTipoDCategoria);                       
						SET @IdOperacion = SCOPE_IDENTITY();   
					
						--actualizacion de IdOPeracionPadre
                        UPDATE  Operacion
                        SET     IdOperacionPadre = IIF(Operacion.IdOperacion = Operacion.RelOperaciones OR Operacion.RelOperaciones = 0, Operacion.IdOperacion, Operacion.RelOperaciones)
                        FROM    tGRLoperaciones Operacion
                        WHERE   Operacion.IdOperacion = @IdOperacion;

						EXEC dbo.pGRLinsertarOperacionsPadreHijas @idOperacion = @IdOperacion,                -- int
						                                          @idOperacionPadre = @IdOperacion,           -- int
						                                          @RelOperaciones = 0,             -- int
						                                          @RelOperacionesD = 0,            -- int
						                                          @RelTransacciones = 0,           -- int
						                                          @RelTransaccionesFinancieras = 0 -- int
						

                        RETURN;
                    END;    
    
				INSERT INTO [dbo].[tGRLoperaciones](IdRecurso, Serie, Folio, [IdTipoOperacion], IdComprobante, Comprobante, Fecha, IdCondicionPago, Vencimiento, Concepto, IdPersona, IdCliente, IdClienteFiscal, IdEmisorProveedor, IdProveedorFiscal, [IdSocio], [IdGrupo], IdPeriodo, IdPolizaE, IdSucursal, IdPersonaVendedor, IdCuentaABCDretiro, IdCuentaABCDdeposito, IdMetodoPago, IdAlmacenSalida, IdAlmacenEntrada, IdDivisa, FactorDivisa, Importe, DescuentoPorcentaje, Descuento, SubTotal, Impuestos, Total, Saldo, DescuentoLocal, TotalLocal, RelOperacionesD, RelOperaciones, RelTransacciones, RelTransaccionesFinancieras, IdRelValoresCampos, IdContactoAsignado, IdDomicilioEntrega, IdListaDLAB, IdEmpleadoComprador, IdTipoDcomprobante, IdCheque, IdEmpleadoSolicitante, [IdCuentaABCD], [IdCierre], IdCorte, TienePoliza, IdListaDPoliza, IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio, IdTipoDdominio, IdObservacionE, IdObservacionEDominio, IdSesion, RequierePoliza, IdImpuesto, BaseExenta, BaseExentaLocal, BaseIVACero, BaseIVACeroLocal, BaseIVA, BaseIVALocal, IVA, IVALocal, RetencionIVA, RetencionIVALocal, ISR, ISRLocal, RetencionISR, RetencionISRLocal, IEPS, IEPSLocal, Impuesto1, Impuesto1Local, RetencionImpuesto1, RetencionImpuesto1Local, Impuesto2, Impuesto2Local, RetencionImpuesto2, RetencionImpuesto2Local, IdDominioPrincipal, IdOperacionOrigen, IdTipoDregistro, IdTipoDdominioOrigen, IdTipoDdominioDestino, NumeroMovimiento, FormaPago, MotivoDescuento, Email, NumeroCuentaPago, Referencia, IdAuxiliar, IdPersonaMovimiento, IdSATformaPago, IdSATmetodoPago, IdUsoCFDI, AltaLocal, IdListaDCategoria)
				VALUES(@IdRecurso, @Serie, @Folio, @IdTipoOperacion, @IdComprobante, @Comprobante, @Fecha, @IdCondicionPago, @Vencimiento, @Concepto, @IdPersona, @IdCliente, @IdClienteFiscal, @IdEmisorProveedor, @IdProveedorFiscal, @IdSocio, @IdGrupo, @IdPeriodo, @IdPolizaE, @IdSucursal, @IdPersonaVendedor, @IdCuentaABCDretiro, @IdCuentaABCDdeposito, @IdMetodoPago, @IdAlmacenSalida, @IdAlmacenEntrada, @IdDivisa, @FactorDivisa, @Importe, @DescuentoPorcentaje, @Descuento, @SubTotal, @Impuestos, @Total, @Saldo, @DescuentoLocal, @TotalLocal, @RelOperacionesD, @RelOperaciones, @RelTransacciones, @RelTransaccionesFinancieras, @IdRelValoresCampos, @IdContactoAsignado, @IdDomicilioEntrega, @IdListaDLAB, @IdEmpleadoComprador, @IdTipoDcomprobante, @IdCheque, @IdEmpleadoSolicitante, @IdCuentaABCD, @IdCierre, @IdCorte, @TienePoliza, @IdListaDPoliza, @IdEstatus, @IdUsuarioAlta, @Alta, @IdUsuarioCambio, @UltimoCambio, @IdTipoDdominio, @IdObservacionE, @IdObservacionEDominio, @IdSesion, @RequierePoliza, @IdImpuesto, @BaseExenta, @BaseExentaLocal, @BaseIVACero, @BaseIVACeroLocal, @BaseIVA, @BaseIVALocal, @IVA, @IVALocal, @RetencionIVA, @RetencionIVALocal, @ISR, @ISRLocal, @RetencionISR, @RetencionISRLocal, @IEPS, @IEPSLocal, @Impuesto1, @Impuesto1Local, @RetencionImpuesto1, @RetencionImpuesto1Local, @Impuesto2, @Impuesto2Local, @RetencionImpuesto2, @RetencionImpuesto2Local, @IdDominioPrincipal, @IdOperacionOrigen, @IdTipoDregistro, @IdTipoDdominioOrigen, @IdTipoDdominioDestino, @NumeroMovimiento, @FormaPago, @MotivoDescuento, @Email, @NumeroCuentaPago, @Referencia, @IdAuxiliar, @IdPersonaMovimiento, @IdFormaPagoSat, @IdMetodoPagoSat, @IdUsoCFDI, @AltaLocal, @IdTipoDCategoria);
                SET @IdOperacion = SCOPE_IDENTITY();   
        
                IF @RelOperaciones = -1
                    SET @RelOperaciones = @IdOperacion;
        
                IF @RelTransacciones = -1
                    SET @RelTransacciones = @IdOperacion;
        
                IF @RelTransaccionesFinancieras = -1
                    SET @RelTransaccionesFinancieras = @IdOperacion;
        
                IF @RelOperacionesD = -1
                    SET @RelOperacionesD = @IdOperacion;
        
                UPDATE  [dbo].[tGRLoperaciones]
                SET     [RelOperaciones] = @RelOperaciones ,
                        [RelTransacciones] = @RelTransacciones ,
                        [RelTransaccionesFinancieras] = @RelTransaccionesFinancieras ,
                        [RelOperacionesD] = @RelOperacionesD
                WHERE   [IdOperacion] = @IdOperacion;
                    
                    --actualizacion de IdOPeracionPadre
                UPDATE  g
                SET     IdOperacionPadre = IIF(g.IdOperacion = g.RelOperaciones
                        OR g.RelOperaciones = 0, g.IdOperacion, g.RelOperaciones)
                FROM    tGRLoperaciones g
                WHERE   g.IdOperacion = @IdOperacion;
                   
				DECLARE @IdOperacionPadre AS INT=IIF(@IdOperacion = @RelOperaciones OR @RelOperaciones = 0, @IdOperacion, @RelOperaciones)
				  
				EXEC dbo.pGRLinsertarOperacionsPadreHijas @idOperacion = @IdOperacion,               
						                                          @idOperacionPadre = @IdOperacionPadre,         
						                                          @RelOperaciones = @RelOperaciones,             
						                                          @RelOperacionesD = @RelOperacionesD,           
						                                          @RelTransacciones = @RelTransacciones,           
						                                          @RelTransaccionesFinancieras = @RelTransaccionesFinancieras 

                IF @IdTipoOperacion = 9
                    AND @IdCorte > 0  -- Corte de Caja
                    BEGIN
                        UPDATE  tVENcortes
                        SET     IdOperacion = @IdOperacion
                        WHERE   IdCorte = @IdCorte;
                    END;

                DECLARE @Err AS VARCHAR(MAX)= '';
                IF @IdPeticion > 0
                    BEGIN
                                   	
                        IF ( @EsPDA = 0 )
                            BEGIN
									-----valida que la peticion no tenga ya una operacion asignada
                                IF ( SELECT ta.IdOperacion
                                     FROM   tATMpeticiones ta WITH ( NOLOCK )
                                     WHERE  ta.IdPeticion = @IdPeticion
                                   ) != 0
                                    BEGIN
										 
                                        SET @Err = CONCAT('CodEx|01938|CRUDoperaciones|La petición ya tiene asignada una operación------',
                                                          @IdPeticion);
                                        RAISERROR(@Err,16,8);
                                        RETURN;
                                    END;
										 
                                UPDATE  ta
                                SET     ta.IdOperacion = @IdOperacion
                                FROM    tATMpeticiones ta
                                WHERE   ta.IdPeticion = @IdPeticion;
                                        
                                        
                                UPDATE  ti
                                SET     ti.IdOperacion = @IdOperacion
                                FROM    tINTpeticiones ti
                                WHERE   ti.IdPeticion = @IdPeticion
                                        AND ti.IdTipoDinterfaz = 1431;----interfaz ATM
                                        
                            END;
                        ELSE
                            BEGIN
                                   		---valida que la peticion PDA no tenga ya una operacion asignada
                                IF ( SELECT ti.IdOperacion
                                     FROM   tINTpeticiones ti WITH ( NOLOCK )
                                     WHERE  ti.IdPeticion = @IdPeticion
                                            AND ti.IdTipoDinterfaz = 1432
                                   ) != 0
                                    BEGIN
                                        SET @Err = CONCAT('CodEx|01938|CRUDoperaciones|La petición ya tiene asignada una operación------',
                                                          @IdPeticion);
                                        RAISERROR(@Err,16,8);
                                        RETURN;
                                    END;
                                   							 
                                UPDATE  ti
                                SET     ti.IdOperacion = @IdOperacion
                                FROM    tINTpeticiones ti
                                WHERE   ti.IdPeticion = @IdPeticion
                                        AND ti.IdTipoDinterfaz = 1432;----interfaz PDA
                            END;
                                       
                    END;                      
        
            END;
       
        IF ( @TipoOperacion = 'R' )
        BEGIN
            EXECUTE dbo.pCRUDoperacionesR @IdTipoOperacion = @IdTipoOperacion, @IdSucursal = @IdSucursal, @Folio = @Folio, @Serie = @Serie, @IdCuentaABCD = @IdCuentaABCD
        END

        IF ( @TipoOperacion = 'U' )
            BEGIN
                UPDATE  [dbo].[tGRLoperaciones]
                SET     IdRecurso = @IdRecurso ,
                        Serie = @Serie ,
                        Folio = @Folio ,
                        [IdTipoOperacion] = @IdTipoOperacion ,
                        IdComprobante = @IdComprobante ,
                        Comprobante = @Comprobante ,
                        Fecha = @Fecha ,
                        IdCondicionPago = @IdCondicionPago ,
                        Vencimiento = @Vencimiento ,
                        Concepto = @Concepto ,
                        IdPersona = @IdPersona ,
                        IdCliente = @IdCliente ,
                        IdClienteFiscal = @IdClienteFiscal ,
                        IdEmisorProveedor = @IdEmisorProveedor ,
                        IdProveedorFiscal = @IdProveedorFiscal ,
                        [IdSocio] = @IdSocio ,
                        [IdGrupo] = @IdGrupo ,
                        IdPeriodo = @IdPeriodo ,
                        IdPolizaE = @IdPolizaE ,
                        IdSucursal = @IdSucursal ,
                        IdPersonaVendedor = @IdPersonaVendedor ,
                        IdCuentaABCDretiro = @IdCuentaABCDretiro ,
                        IdCuentaABCDdeposito = @IdCuentaABCDdeposito ,
                        IdMetodoPago = @IdMetodoPago ,
                        IdAlmacenSalida = @IdAlmacenSalida ,
                        IdAlmacenEntrada = @IdAlmacenEntrada ,
                        IdDivisa = @IdDivisa ,
                        FactorDivisa = @FactorDivisa ,
                        Importe = @Importe ,
                        DescuentoPorcentaje = @DescuentoPorcentaje ,
                        Descuento = @Descuento ,
                        SubTotal = @SubTotal ,
                        Impuestos = @Impuestos ,
                        Total = @Total ,
                        Saldo = @Saldo ,
                        DescuentoLocal = @DescuentoLocal ,
                        TotalLocal = @TotalLocal ,
                        RelOperacionesD = @RelOperacionesD ,
                        RelOperaciones = @RelOperaciones ,
                        RelTransacciones = @RelTransacciones ,
                        RelTransaccionesFinancieras = @RelTransaccionesFinancieras ,
                        IdRelValoresCampos = @IdRelValoresCampos ,
                        IdContactoAsignado = @IdContactoAsignado ,
                        IdDomicilioEntrega = @IdDomicilioEntrega ,
                        IdListaDLAB = @IdListaDLAB ,
                        IdEmpleadoComprador = @IdEmpleadoComprador ,
                        IdTipoDcomprobante = @IdTipoDcomprobante ,
                        IdCheque = @IdCheque ,
                        IdEmpleadoSolicitante = @IdEmpleadoSolicitante ,
                        [IdCuentaABCD] = @IdCuentaABCD ,
                        [IdCierre] = @IdCierre ,
                        IdCorte = @IdCorte ,
                        TienePoliza = @TienePoliza ,
                        IdListaDPoliza = @IdListaDPoliza ,
                        IdEstatus = @IdEstatus ,
                        IdUsuarioCambio = @IdUsuarioCambio ,
                        UltimoCambio = @UltimoCambio ,
                        IdTipoDdominio = @IdTipoDdominio ,
                        IdObservacionE = @IdObservacionE ,
                        IdObservacionEDominio = @IdObservacionEDominio ,
                        IdSesion = @IdSesion ,
                        RequierePoliza = @RequierePoliza ,
                        IdAuxiliar = @IdAuxiliar,
						IdSATmetodoPago = @IdMetodoPagoSat,
						IdSATformaPago	= @IdFormaPagoSat,
						AltaLocal = @AltaLocal,
						--------------------------------------
						IdListaDCategoria = @IdTipoDCategoria
                WHERE   ( IdOperacion = @IdOperacion );
            END;
       
        IF ( @TipoOperacion = 'CNL' )--Cancelación
            BEGIN
                UPDATE  tGRLoperaciones
                SET     IdEstatus = 18
                WHERE   IdOperacion = @IdOperacion;                                            
            END;
             
        IF ( @TipoOperacion = 'D' )--borrar
            BEGIN
                EXEC pCTLeliminarOperacion @IdOperacion = @IdOperacion;                                           
            END;

    END;



GO