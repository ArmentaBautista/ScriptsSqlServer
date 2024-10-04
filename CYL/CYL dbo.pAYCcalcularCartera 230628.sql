SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO







ALTER PROCEDURE [dbo].[pAYCcalcularCartera] 
	-- Add the parameters for the stored procedure here
    @FechaCartera AS DATE ,
    @Idusuario AS INT ,
    @SobreEscribirDatos AS BIT = 0 ,
    @EsCarteraSistema AS BIT = 0 ,
    @CodigoOperacion AS VARCHAR(20) = 'DevPag' ,
    @EsRPT AS BIT = 0--este parametro determina si el calculo de cartera se enviara a la base de datos RPT
AS
    BEGIN
	--RETURN;

        SET NOCOUNT ON;

        DECLARE @Usuario AS VARCHAR(100);
        DECLARE @FechaHora AS DATETIME;


		
	--se reemplaza la siguiente linea de codigo por la funcionalidad del procedimiento de avales en cartera
	--EXECUTE pAYCCavalesCartera
	
        DELETE  FROM tAYCavalesCartera;	

        INSERT  INTO tAYCavalesCartera
                ( RelAvales ,
                  Aval1 ,
                  Aval2 ,
                  Aval3
                )
                SELECT  x.RelAvales ,
                        Aval1 = ISNULL(MAX(Aval1), '') ,
                        Aval2 = ISNULL(MAX(Aval2), '') ,
                        Aval3 = ISNULL(MAX(Aval3), '')
                FROM    ( SELECT    av.RelAvales ,
                                    Aval1 = CASE WHEN ROW_NUMBER() OVER ( PARTITION BY av.RelAvales ORDER BY IdAval ) = 1
                                                      AND IdAval > 0
                                                 THEN p.[Nombre] + ' - '
                                                      + p.Domicilio + ' - '
                                                      + ISNULL(tel.Telefonos,
                                                              '')
                                                 ELSE NULL
                                            END ,
                                    Aval2 = CASE WHEN ROW_NUMBER() OVER ( PARTITION BY av.RelAvales ORDER BY IdAval ) = 2
                                                      AND IdAval > 0
                                                 THEN p.[Nombre] + ' - '
                                                      + p.Domicilio + ' - '
                                                      + ISNULL(tel.Telefonos,
                                                              '')
                                                 ELSE NULL
                                            END ,
                                    Aval3 = CASE WHEN ROW_NUMBER() OVER ( PARTITION BY av.RelAvales ORDER BY IdAval ) = 3
                                                      AND IdAval > 0
                                                 THEN p.[Nombre] + ' - '
                                                      + p.Domicilio + ' - '
                                                      + ISNULL(tel.Telefonos,
                                                              '')
                                                 ELSE NULL
                                            END
                          FROM      tAYCavalesAsignados av WITH ( NOLOCK )
                                    JOIN tGRLpersonas p WITH ( NOLOCK ) ON av.IdPersona = p.IdPersona
                                    LEFT JOIN vCATtelefonosAgrupados tel WITH ( NOLOCK ) ON p.IdRelTelefonos = tel.IdRel
                          WHERE     av.EsAval = 1
                                    AND av.IdEstatus = 1
                                    AND av.IdPersona != 0
                        ) x
                GROUP BY x.RelAvales;

        IF @FechaCartera < CAST (GETDATE() AS DATE)
            AND @EsCarteraSistema = 0 AND @EsRPT = 0
            BEGIN
                SELECT TOP 1
                        @Usuario = u.Usuario ,
                        @FechaHora = c.FechaHora
                FROM    tAYCcartera c WITH ( NOLOCK )
                        JOIN tCTLusuarios u WITH ( NOLOCK ) ON c.IdUsuario = u.IdUsuario
                WHERE   c.FechaCartera = @FechaCartera;
                SELECT  Usuario = @Usuario ,
                        FechaHora = @FechaHora ,
                        Mensaje = 'No es posible calcular una cartera con fecha inferior a la Fecha Actual';
                RETURN;
            END;


        IF @SobreEscribirDatos = 0 AND @EsRPT = 0
            BEGIN 
                IF @EsCarteraSistema = 1
                    SELECT TOP 1
                            @Usuario = u.Usuario ,
                            @FechaHora = c.FechaHora
                    FROM    tAYCcarteraSistema c WITH ( NOLOCK )
                            JOIN tCTLusuarios u WITH ( NOLOCK ) ON c.IdUsuario = u.IdUsuario
                    WHERE   c.FechaCartera = @FechaCartera;
                ELSE
                    SELECT TOP 1
                            @Usuario = u.Usuario ,
                            @FechaHora = c.FechaHora
                    FROM    tAYCcartera c WITH ( NOLOCK )
                            JOIN tCTLusuarios u WITH ( NOLOCK ) ON c.IdUsuario = u.IdUsuario
                    WHERE   c.FechaCartera = @FechaCartera;
                IF NOT @Usuario IS NULL
                    BEGIN
                        SELECT  Usuario = @Usuario ,
                                FechaHora = @FechaHora; 
                    END;
                ELSE
                    SET @SobreEscribirDatos = 1;
            END;
		
		--se valida si se insertara en a base de RPT
        IF @EsRPT = 0
            BEGIN				
    
                IF @SobreEscribirDatos = 1
				--IF OBJECT_ID('tempdb..#tmpCartera')  IS NOT NULL
					BEGIN TRY
						DROP TABLE  #tmpCartera;
					END TRY
					BEGIN CATCH
					END CATCH
	
                    SELECT  *
                    INTO    #tmpCartera
                    FROM    fAYCcalcularCarteraOperacion(@FechaCartera, 2, 0,
                                                         0, @CodigoOperacion) f;


                IF @SobreEscribirDatos = 1
                    AND @EsCarteraSistema = 0 -- Se almacena en la tabla de Carteras del Usuario
                    BEGIN
                        DELETE  tAYCcartera
                        WHERE   FechaCartera = @FechaCartera;
                        INSERT  INTO dbo.tAYCcartera
                                ( FechaCartera ,
                                  IdUsuario ,
                                  FechaHora ,
                                  IdPeriodo ,
                                  IdCuenta ,
                                  Capital ,
                                  DiasMoraCapital ,
                                  DiasMoraInteres ,
                                  CapitalAtrasado ,
                                  ParcialidadesCapitalAtrasadas ,
                                  CapitalVigente ,
                                  CapitalVencido ,
                                  InteresOrdinarioVigente ,
                                  InteresOrdinarioVencido ,
                                  InteresOrdinarioCuentasOrden ,
                                  InteresMoratorioVigente ,
                                  InteresMoratorioVencido ,
                                  InteresMoratorioCuentasOrden ,
                                  InteresMoratorioTotal ,
                                  CapitalExigible ,
                                  DiasTranscurridos ,
                                  IdEstatusCartera ,
                                  ParteCubierta ,
                                  ProximoVencimiento ,
                                  Cargos ,
                                  CargosImpuestos ,
                                  CargosTotal ,
                                  InteresOrdinarioPeriodo,
								  IVAInteresOrdinario,
								  IVAInteresMoratorio,
								  InteresOrdinarioTotalAtrasado,
								  InteresOrdinarioIVAAtrasado,
								  InteresOrdinarioAtrasado,
								  CapitalAlDia,
								  MoraPromedio,
								  PagosRealizados,
								  PagosAnticipados,
								  PagosAtrasados,
								  PagosPuntuales,
								  InteresOrdinarioPagado,
								  InteresMoratorioPagado                          
                                )
                                SELECT  @FechaCartera ,
                                        @Idusuario ,
                                        CURRENT_TIMESTAMP ,
                                        dbo.fObtenerIdPeriodo(@FechaCartera) ,
                                        f.IdCuenta ,
                                        f.Capital ,
                                        f.DiasMoraCapital ,
                                        f.DiasMoraInteres ,
                                        f.CapitalAtrasado ,
                                        f.ParcialidadesCapitalAtrasadas ,
                                        f.CapitalVigente ,
                                        f.CapitalVencido ,
                                        f.InteresOrdinarioVigente ,
                                        f.InteresOrdinarioVencido ,
                                        f.InteresOrdinarioCuentasOrden ,
                                        ISNULL(f.InteresMoratorioVigente,0) ,
                                        ISNULL(f.InteresMoratorioVencido,0) ,
                                        f.InteresMoratorioCuentasOrden ,
                                        ISNULL(f.InteresMoratorioTotal,0) ,
                                        f.CapitalExigible ,
                                        f.DiasTranscurridos ,
                                        f.IdEstatusCartera ,
                                        f.ParteCubierta ,
                                        f.ProximoVencimiento ,
                                        f.Cargos ,
                                        f.CargosImpuestos ,
                                        CargosTotal = f.Cargos
                                        + f.CargosImpuestos ,
                                        f.InteresOrdinarioPeriodo,
										f.IVAInteresOrdinario,
								        f.IVAInteresMoratorio,
										f.InteresOrdinarioTotalAtrasado ,
										f.InteresOrdinarioIVAAtrasado,
										f.InteresOrdinarioAtrasado,
										f.CapitalAlDia,
										Parcialidades.[Mora Promedio],
										Parcialidades.PagosRealizados,
										Parcialidades.[Pagos Anticipados],
										Parcialidades.[Pagos Atrasados],
										Parcialidades.[Pagos Puntuales],
										[Parcialidades].[IOP],
										[Parcialidades].[IMP] 
                                FROM    #tmpCartera f
                                LEFT JOIN (
											SELECT parcialidad.IdCuenta,
											[Mora Promedio]=AVG(CASE WHEN parcialidad.CapitalPagado<parcialidad.Capital AND parcialidad.PagadoCapital='1900-01-01' AND parcialidad.Vencimiento<=GETDATE()
															 THEN DATEDIFF(DAY,parcialidad.Vencimiento,GETDATE())
															WHEN parcialidad.Vencimiento> GETDATE()
																 THEN 0
															WHEN parcialidad.CapitalPagado>=parcialidad.Capital AND parcialidad.PagadoCapital != '1900-01-01' AND parcialidad.Vencimiento>=parcialidad.PagadoCapital
																 THEN 0
															WHEN parcialidad.CapitalPagado>=parcialidad.Capital AND parcialidad.PagadoCapital = '1900-01-01'
																 THEN 0
															ELSE 
															 DATEDIFF(DAY,parcialidad.Vencimiento,parcialidad.PagadoCapital)
													END ),
											[PagosRealizados]=SUM(IIF(parcialidad.EstaPagada=1 AND parcialidad.CapitalPagado>=parcialidad.Capital ,1,0)),
											[Pagos Anticipados]=SUM(IIF(parcialidad.PagadoCapital<parcialidad.Vencimiento AND parcialidad.PagadoCapital != '1900-01-01',1,0)),
											[Pagos Atrasados]=SUM(IIF(parcialidad.PagadoCapital>parcialidad.Vencimiento AND parcialidad.PagadoCapital != '1900-01-01',1,0)),
											[Pagos Puntuales]=SUM(IIF(parcialidad.PagadoCapital=parcialidad.Vencimiento AND parcialidad.PagadoCapital != '1900-01-01',1,0)),
											[IOP]=SUM(parcialidad.InteresOrdinarioPagado),
											[IMP]=SUM(parcialidad.InteresMoratorioPagado)
											FROM dbo.tAYCparcialidades parcialidad WITH (NOLOCK)
											WHERE parcialidad.IdEstatus=1
											GROUP BY parcialidad.IdCuenta				
								)Parcialidades ON Parcialidades.IdCuenta = f.IdCuenta
                                
                                
                                
                                UPDATE car SET car.FechaUltimoPagoInteres=fPagInt.Fecha,car.MontoUltimoPagoInteres=fPagInt.InteresPagado
								from dbo.tAYCcartera car With(Nolock)
								INNER JOIN dbo.fAYCultimoPagoInteresPorFecha(@FechaCartera) fPagInt ON fPagInt.IdCuenta = car.IdCuenta

								UPDATE car SET car.FechaUltimoPagoCapital=fPagCap.Fecha,car.MontoUltimoPagoCapital=fPagCap.CapitalPagado
								from dbo.tAYCcartera car With(Nolock)
								INNER JOIN dbo.fAYCultimoPagoCapitalPorFecha(@FechaCartera) fPagCap ON fPagCap.IdCuenta = car.IdCuenta
                    END;
                ELSE
                    IF @SobreEscribirDatos = 1
                        AND @EsCarteraSistema = 1 -- Se almacena en la tabla de Carteras del Sistema
                        BEGIN
                            DELETE  tAYCcarteraSistema
                            WHERE   FechaCartera = @FechaCartera;

                            INSERT  INTO dbo.tAYCcarteraSistema
                                    ( FechaCartera ,
                                      IdUsuario ,
                                      FechaHora ,
                                      IdPeriodo ,
                                      IdCuenta ,
                                      Capital ,
                                      DiasMoraCapital ,
                                      DiasMoraInteres ,
                                      CapitalAtrasado ,
                                      ParcialidadesCapitalAtrasadas ,
                                      CapitalVigente ,
                                      CapitalVencido ,
                                      InteresOrdinarioVigente ,
                                      InteresOrdinarioVencido ,
                                      InteresOrdinarioCuentasOrden ,
                                      InteresMoratorioVigente ,
                                      InteresMoratorioVencido ,
                                      InteresMoratorioCuentasOrden ,
                                      InteresMoratorioTotal ,
                                      CapitalExigible ,
                                      DiasTranscurridos ,
                                      IdEstatusCartera ,
                                      ParteCubierta ,
                                      ProximoVencimiento ,
                                      Cargos ,
                                      CargosImpuestos ,
                                      CargosTotal ,
                                      InteresOrdinarioPeriodo,
									  IVAInteresOrdinario,
								      IVAInteresMoratorio,
									  InteresOrdinarioTotalAtrasado,
									  InteresOrdinarioAtrasado,
									  CapitalAlDia                                       
                                    )
                                    SELECT  @FechaCartera ,
                                            @Idusuario ,
                                            CURRENT_TIMESTAMP ,
                                            dbo.fObtenerIdPeriodo(@FechaCartera) ,
                                            f.IdCuenta ,
                                            f.Capital ,
                                            f.DiasMoraCapital ,
                                            f.DiasMoraInteres ,
                                            f.CapitalAtrasado ,
                                            f.ParcialidadesCapitalAtrasadas ,
                                            f.CapitalVigente ,
                                            f.CapitalVencido ,
                                            f.InteresOrdinarioVigente ,
                                            f.InteresOrdinarioVencido ,
                                            f.InteresOrdinarioCuentasOrden ,
                                            ISNULL(f.InteresMoratorioVigente,0) ,
                                            ISNULL(f.InteresMoratorioVencido,0) ,
                                            f.InteresMoratorioCuentasOrden ,
                                            ISNULL(f.InteresMoratorioTotal,0) ,
                                            f.CapitalExigible ,
                                            f.DiasTranscurridos ,
                                            f.IdEstatusCartera ,
                                            f.ParteCubierta ,
                                            f.ProximoVencimiento ,
                                            f.Cargos ,
                                            f.CargosImpuestos ,
                                            CargosTotal = f.Cargos
                                            + f.CargosImpuestos ,
                                            f.InteresOrdinarioPeriodo,
											f.IVAInteresOrdinario,
								            f.IVAInteresMoratorio,
											f.InteresOrdinarioTotalAtrasado,
											f.InteresOrdinarioAtrasado,
											f.CapitalAlDia

                                    FROM    #tmpCartera f;
                        END;	  
            END;
        ELSE
            IF @EsRPT = 1
                BEGIN					
					--IF OBJECT_ID('tempdb..#tmpCartera')  IS NOT NULL
					BEGIN TRY
						DROP TABLE  #tmpCarteraRPT;
					END TRY
					BEGIN CATCH
					END CATCH	

                    SELECT  *
                    INTO    #tmpCarteraRPT
                    FROM    fAYCcalcularCarteraOperacion(@FechaCartera, 2, 0,
                                                         0, @CodigoOperacion) f;

                    DECLARE @SQL AS VARCHAR(MAX) = CONCAT('INSERT INTO ',DB_NAME(),'_RPT.dbo.tAYCcartera
											( FechaCartera ,
											  IdUsuario ,          
											  IdPeriodo ,
											  IdCuenta ,
											  Capital ,
											  DiasMoraCapital ,
											  DiasMoraInteres ,
											  CapitalAtrasado ,
											  ParcialidadesCapitalAtrasadas ,
											  CapitalVigente ,
											  CapitalVencido ,
											  InteresOrdinarioVigente ,
											  InteresOrdinarioVencido ,
											  InteresOrdinarioCuentasOrden ,
											  InteresMoratorioVigente ,
											  InteresMoratorioVencido ,
											  InteresMoratorioCuentasOrden ,
											  InteresMoratorioTotal ,
											  CapitalExigible ,
											  DiasTranscurridos ,
											  IdEstatusCartera ,
											  ParteCubierta ,
											  ProximoVencimiento ,
											  Cargos ,
											  CargosImpuestos ,
											  CargosTotal ,
											  InteresOrdinarioPeriodo,
											  CapitalAlDia 
											)
											  SELECT ''', CONVERT(VARCHAR(10), @FechaCartera, 112), ''' ,
																			', @Idusuario,
																							  ' ,                                        
																			dbo.fObtenerIdPeriodo(''',
																							  CONVERT(VARCHAR(10), @FechaCartera, 112),
																							  ''') ,
																			f.IdCuenta ,
																			f.Capital ,
																			f.DiasMoraCapital ,
																			f.DiasMoraInteres ,
																			f.CapitalAtrasado ,
																			f.ParcialidadesCapitalAtrasadas ,
																			f.CapitalVigente ,
																			f.CapitalVencido ,
																			f.InteresOrdinarioVigente ,
																			f.InteresOrdinarioVencido ,
																			f.InteresOrdinarioCuentasOrden ,
																			isnull(f.InteresMoratorioVigente,0) ,
																			isnull(f.InteresMoratorioVencido,0 ),
																			f.InteresMoratorioCuentasOrden ,
																			isnullf.InteresMoratorioTotal,0) ,
																			f.CapitalExigible ,
																			f.DiasTranscurridos ,
																			f.IdEstatusCartera ,
																			f.ParteCubierta ,
																			f.ProximoVencimiento ,
																			f.Cargos ,
																			f.CargosImpuestos ,
																			CargosTotal = f.Cargos
																			+ f.CargosImpuestos ,
																			f.InteresOrdinarioPeriodo,
																			f.CapitalAlDia
																	FROM    #tmpCarteraRPT f;');
					EXEC (@SQL);

			
                END;
			
		
	
    END;







GO

