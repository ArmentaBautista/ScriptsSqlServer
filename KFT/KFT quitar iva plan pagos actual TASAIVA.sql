
    BEGIN 

        DECLARE @Cad AS VARCHAR(MAX) = ''
        DECLARE @Resultado AS INT = 1;
        DECLARE @Codigo AS VARCHAR(MAX) = '';
        DECLARE @Mensaje AS VARCHAR(MAX) = '';
		DECLARE @IdCuenta AS INT=1838933
		DECLARE @Fecha AS DATE = GETDATE()

        BEGIN TRY 

            IF @IdCuenta = 0
                BEGIN
                    SET @Codigo = '02028';
                    SET @Mensaje = 'Debe especificar la cuenta a cancelar';
                    SET @Resultado = 0;
                    RETURN;
                END

            IF @Fecha = '19000101'
                BEGIN
                    SET @Codigo = '02028';
                    SET @Mensaje = 'Debe especificar la fecha en la que se desea cancelar el IVA';
                    SET @Resultado = 0;
                    RETURN;
                END


            DECLARE @AjustarCuenta AS BIT = 0


            SELECT  p.IVAInteresOrdinarioEstimado ,
                    p.IVAInteresOrdinario ,
                    p.IVAInteresOrdinarioPagado ,
                    p.IVAInteresMoratorio ,
                    p.IVAInteresMoratorioPagado ,
                    *
            FROM    dbo.tAYCparcialidades p
            WHERE   p.IdCuenta = @IdCuenta
            ORDER BY p.Orden;

            SELECT  @AjustarCuenta = IIF(( s.IVAInteresOrdinarioDevengado
                                           - s.IVAInteresOrdinarioPagado
                                           - s.IVAInteresOrdinarioCondonado ) != 0
                    OR ( s.IVAInteresMoratorioDevengado
                         - s.IVAInteresMoratorioPagado
                         - s.IVAInteresMoratorioCondonado ) != 0, 1, 0)
            FROM    dbo.tSDOsaldos s
            WHERE   s.IdCuenta = @IdCuenta;

            BEGIN TRANSACTION;
		-------------------------Actualizar parcialidades------------------------------------------------------------------
            UPDATE  p
            SET     IVAInteresOrdinario = IIF(( p.IVAInteresOrdinarioPagado
                                                + p.IVAInteresOrdinarioCondonado ) != 0, p.IVAInteresOrdinario
                    - ( p.IVAInteresOrdinario - ( p.IVAInteresOrdinarioPagado
                                                  + p.IVAInteresOrdinarioCondonado ) ), 0) ,
                    p.IVAInteresOrdinarioEstimado = 0 ,
                    p.IVAInteresMoratorio = IIF(( p.IVAInteresMoratorioPagado
                                                  + p.IVAInteresMoratorioCondonado ) != 0, p.IVAInteresMoratorio
                    - ( p.IVAInteresMoratorio - ( p.IVAInteresMoratorioPagado
                                                  + p.IVAInteresMoratorioCondonado ) ), 0)
            FROM    dbo.tAYCparcialidades p
            WHERE   p.IdCuenta = @IdCuenta
                    AND p.EstaPagada = 0;

            UPDATE  c
            SET     TasaIva = 0
            FROM    dbo.tAYCcuentas c
            WHERE   c.IdCuenta = @IdCuenta;

            IF @AjustarCuenta = 0
                RETURN;
            ELSE
                BEGIN 

                    DECLARE @idperiodo INT = dbo.fObtenerIdPeriodo(@Fecha)
	
		
                    DECLARE @idoperacion_output INT = 0 ,
                        @idcuenta_output INT = @IdCuenta ,
                        @idsocio INT = 0 ,
                        @idpersona INT = 0 ,
                        @idsucursal INT = 0 ,
                        @folio_output INT = 0 ,
                        @folio_input INT = 0;


		-------------------------obtener siguiente folio------------------------------------------------------------------
                    SET @folio_output = 0;
                    EXECUTE [dbo].[pLSTseriesRangosFolios] 'LST', 26, '', 1,
                        @fecha, @folio_output OUTPUT;
	
                    INSERT  INTO dbo.tGRLoperaciones
                            ( Serie ,
                              Folio ,
                              IdTipoOperacion ,
                              Fecha ,
                              Concepto ,
                              Referencia ,
                              IdPersona ,
                              IdSocio ,
                              IdPeriodo ,
                              IdSucursal ,
                              IdDivisa ,
                              FactorDivisa ,
                              IdListaDPoliza ,
                              IdEstatus ,
                              IdUsuarioAlta ,
                              Alta ,
                              IdTipoDdominio ,
                              IdSesion ,
                              RequierePoliza
                            )
                            SELECT  Serie = '' ,
                                    Folio = @folio_output ,
                                    IdTipoOperacion = 46 ,
                                    Fecha = @Fecha ,
                                    Concepto = '' ,
                                    Referencia = '' ,
                                    IdPersona = @idpersona ,
                                    IdSocio = @idsocio ,
                                    IdPeriodo = @idperiodo ,
                                    IdSucursal = 1 ,
                                    IdDivisa = 1 ,
                                    FactorDivisa = 1 ,
                                    IdListaDPoliza = -1 ,
                                    Idestatus = 1 ,
                                    IdUsuarioAlta = -1 ,
                                    Alta = @Fecha ,
                                    IdTipoDdominio = 727 ,
                                    idsesion = 0 ,
                                    RequierePoliza = 1;
                    SET @idoperacion_output = SCOPE_IDENTITY();

                    UPDATE  dbo.tGRLoperaciones
                    SET     IdOperacionPadre = @idoperacion_output ,
                            RelTransaccionesFinancieras = @idoperacion_output
                    WHERE   IdOperacion > 0
                            AND IdOperacion = @idoperacion_output;	
	
	
                    INSERT  INTO dbo.tSDOtransaccionesFinancieras
                            ( IdOperacion ,
                              IdTipoSubOperacion ,
                              Fecha ,
                              IdSaldoDestino ,
                              IdAuxiliar ,
                              IdCuenta ,
                              TipoMovimiento ,
                              MontoSubOperacion ,
                              Naturaleza ,
                              TotalGenerado ,
                              IdSaldoPrincipal ,
                              EsPrincipal ,
                              EsVisible ,
                              IdSucursal ,
                              IdEstructuraContableE ,
                              IdCentroCostos ,
                              IdDivisa ,
                              IdDivision ,
                              IdEstatus ,
                              IdUsuarioAlta ,
                              Alta ,
                              IdUsuarioCambio ,
                              UltimoCambio ,
                              IdImpuesto ,
                              FactorDivisa ,
                              IdEstatusDominio ,
                              IVAInteresOrdinarioDevengado ,
                              IVAInteresMoratorioDevengado
			                )
                            SELECT --'Devengamiento de Interes'								
                                    IdOperacion = @idoperacion_output ,
                                    IdTipoSubOperacion = 500 ,
                                    FechaCalculo = @Fecha ,
                                    s.IdSaldo AS IdSaldo ,
                                    s.IdAuxiliar AS IdAuxiliar ,
                                    s.IdCuenta AS IdCuenta ,
                                    TipoMovimiento = 2 ,
                                    MontoSubOperacion = 0 ,
                                    Naturaleza = 1 ,
                                    TotalGenerado = ( s.IVAInteresOrdinarioDevengado
                                                      - s.IVAInteresOrdinarioPagado
                                                      - s.IVAInteresOrdinarioCondonado )
                                    * -1 ,
                                    idSaldoPrincipal = s.IdSaldo ,
                                    EsPrincipal = 1 ,
                                    EsVisible = 1 ,
                                    s.IdSucursal AS IdSucursal ,
                                    s.IdEstructuraContable AS IdEstructuraContableE ,
                                    suc.IdCentroCostos AS IdCentroCostos ,
                                    IdDivisa = 1 ,
                                    IdDivision = s.IdDivision ,
                                    IdEstatus = 1 ,
                                    IdUsuarioAlta = -1 ,
                                    Alta = GETDATE() ,
                                    IdUsuarioCambio = -1 ,
                                    UltimoCambio = GETDATE() ,
                                    IdImpuesto = c.IdImpuesto ,
                                    FactorDivisa = 1 ,
                                    IdEstatusDominio = s.IdEstatus ,
                                    IVAInteresOrdinarioDevengado = ( s.IVAInteresOrdinarioDevengado
                                                              - s.IVAInteresOrdinarioPagado
                                                              - s.IVAInteresOrdinarioCondonado )
                                    * -1 ,
                                    IVAInteresMoratorioDevengado = ( s.IVAInteresMoratorioDevengado
                                                              - s.IVAInteresMoratorioPagado
                                                              - s.IVAInteresMoratorioCondonado )
                                    * -1
                            FROM    dbo.tSDOsaldos s
                                    INNER JOIN dbo.tCTLsucursales suc ON suc.IdSucursal = s.IdSucursal
                                    INNER JOIN dbo.tAYCcuentas c ON c.IdCuenta = s.IdCuenta
                            WHERE   s.IdCuenta = @IdCuenta;

	
                    UPDATE  s
                    SET     IVAInteresOrdinarioDevengado = s.IVAInteresOrdinarioDevengado
                            - ( s.IVAInteresOrdinarioDevengado
                                - s.IVAInteresOrdinarioPagado
                                - s.IVAInteresOrdinarioCondonado ) ,
                            IVAInteresMoratorioDevengado = s.IVAInteresMoratorioDevengado
                            - ( s.IVAInteresMoratorioDevengado
                                - s.IVAInteresMoratorioPagado
                                - s.IVAInteresMoratorioCondonado )
                    FROM    dbo.tSDOsaldos s
                    WHERE   s.IdCuenta = @IdCuenta;


                    --EXEC dbo.pCNTrecontabilizacionOperacion @IdOperacion = @idoperacion_output;


                    COMMIT;
                END
        END TRY
        BEGIN CATCH
            BEGIN TRY 
                ROLLBACK;
            END TRY
            BEGIN CATCH
            END CATCH

            SET @Cad = ( SELECT CONCAT('pAYCcancelarIVA|', ' ERROR_NUMBER: ',
                                       ERROR_NUMBER(), ' ERROR_SEVERITY: ',
                                       ERROR_SEVERITY(), ' ERROR_STATE: ',
                                       ERROR_STATE(), ' ERROR_PROCEDURE: ',
                                       ERROR_PROCEDURE(), ' ERROR_LINE: ',
                                       ERROR_LINE(), ' ERROR_MESSAGE',
                                       ERROR_MESSAGE())
                       );		         

            RAISERROR(@Cad,16,8);


        END CATCH

    END
	



GO

-- commit