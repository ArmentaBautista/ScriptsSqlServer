


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO










create PROC [dbo].[pATMdisposicion]
@TipoOperacion AS VARCHAR(10)='',
@Codigo AS VARCHAR(30)='',
@Cod_Trans AS VARCHAR(5)='',
@MontoTransaccion AS NUMERIC(23,8)=0,
@NumTarjeta as  varchar(19)='',
@Num_Referencia AS VARCHAR(12)='',
@Id_socio_terminal AS VARCHAR(20)='',
@Num_Cta_terminal AS VARCHAR(28)='',
@Comision AS NUMERIC(23,8)=0

AS
SET NOCOUNT ON
	SET XACT_ABORT ON	

	BEGIN
		
		DECLARE @NumeroCuenta AS VARCHAR(28)=''
		
		--DECLARE @IdPeticion AS INT=0
		--SET @IdPeticion=(SELECT TOP 1 ta.IdPeticion FROM tATMpeticiones ta WHERE ta.Num_Ref=@Num_Referencia AND Num_Tarjeta=@NumTarjeta )
				
		IF @TipoOperacion='DISP' AND NOT @Codigo=''
		BEGIN
			----Valida si existe la tarjeta ,obtener la cuenta en base a la tarjeta
			SET @NumeroCuenta=(SELECT dbo.fATMexisteTarjeta (@NumTarjeta))
			IF @NumeroCuenta!=@Codigo
			BEGIN
			---se manda el mensaje de Cuenta no existe, cuando la cuenta no esta vinculada a la tarjeta
				DECLARE @m1 AS VARCHAR(MAX)=N'CodEx|214|trValidarNumeroCuenta'
				RAISERROR(@m1,16,8)
				RETURN
            END


			IF @NumeroCuenta!=''
			BEGIN
				--IF  @Codigo LIKE '%-%'
				--BEGIN
				--	SET @NumeroCuenta=@Codigo
				--END
				--ELSE
				--	BEGIN
				--		----validar que la cuenta que se obtiene sea la misma que a cuenta que llega de la trama
				--		DECLARE @cadena AS VARCHAR(28)=@codigo
				--		DECLARE @num AS VARCHAR(5)=''
				--		DECLARE @num1 AS VARCHAR(4)=''
				--		DECLARE @num2 AS VARCHAR(5)=''
				--		DECLARE @Cuenta AS VARCHAR(60)=''		
						
				--		SET @num=SUBSTRING(@cadena,2,7)
				--		SET @num1=SUBSTRING(@cadena,8,11)
				--		SET @num2=SUBSTRING(@cadena,15,20)				
				--		set @num2 =iif(SUBSTRING(@num2,1,1)=0,SUBSTRING(@num2,2,5),@num2)
				--		SET @Cuenta=isnull(CONCAT(@num,'-',@num1,'-',@num2),'')
				--		--SET @Codigo=@Cuenta
				--		IF (@Cuenta<>@NumeroCuenta)
				--		BEGIN
				--			--se manda mensaje de error de Cuenta no existe
				--				DECLARE @msgTarjeta AS VARCHAR(MAX)=N'CodEx|214|fATMexisteCuenta'
				--				RAISERROR(@msgTarjeta,16,8)
				--				RETURN
				--		END
				--	END
				
				
				--Valida si existe la Cuenta con el Codigo indicado con la función fExisteCuenta
				if (SELECT dbo.fATMexisteCuenta(@Codigo))=1
				BEGIN
					----Si existe la cuenta se valida el estatus de la tarejeta , si es inactiva ,baja o bloqueada manda un mensaje de error
					DECLARE @EstatusTarjeta AS INT=0
					SET @EstatusTarjeta=(SELECT dbo.fATMestatusTarjeta (@NumTarjeta))
					if (@EstatusTarjeta IN (0,2,3,61))
					BEGIN
						--se manda mensaje de error de Cuenta bloqueada
						DECLARE @msgTj AS VARCHAR(MAX)=N'CodEx|216|trValidarEStatusTarjeta'
						RAISERROR(@msgTj,16,8)
						RETURN 	
					END

					if ( @EstatusTarjeta IN (7,18))
					BEGIN
						--se manda mensaje de error de Cuenta bloqueada
						DECLARE @m2 AS VARCHAR(MAX)=N'CodEx|215|trValidarEStatusTarjeta'
						RAISERROR(@m2,16,8)
						RETURN 	
					END
						    ---si el estatus de la tarejeta es activa se sigue con el procedimiento normal
							--Si la cuenta existe, valida que el monto Disponible sea mayor o igual que al monto de la transacción con la función fValidarSaldoDisponible
							if (SELECT dbo.fATMvalidarSaldoDisponible(@NumeroCuenta,@MontoTransaccion,0))=1
							BEGIN
								---Devuelve el registro  dependiendo del codigo de la Cuenta
							--	Realizar el proceso de descontar al saldo disponible y al saldo contable  el monto dependiendo del codigo de la transacción
																		
								IF (@Cod_Trans IN ('01','02','03','04','17'))
								BEGIN		
								
									--Descontar al saldo disponible y al saldo contable el monto de la transacción
									EXEC pSDOrealizarBloqueoATM
										@TipoOperacion='DESCONTAR',
										@CodigoCuenta = @numeroCuenta,
										@Monto = @MontoTransaccion
									
									IF (@Id_socio_terminal!='')
									BEGIN
									DECLARE @montoAplicar AS NUMERIC(23,8)=(@MontoTransaccion- @Comision)
										---Abonar a la cuenta del comercio,al saldo disponible y al saldo contable el monto de la transacción
										EXEC pSDOrealizarBloqueoATM
											@TipoOperacion='ABONAR',
											@CodigoCuenta = @Num_Cta_terminal,
											@Monto = @montoAplicar
                                    END
																							
								END
								IF (@Cod_Trans='05')
								BEGIN
									--Descontar al saldo disponible el monto de la transacción
				
									EXEC pSDOrealizarBloqueoATM
										@TipoOperacion='DESCMB',
										@CodigoCuenta = @numeroCuenta,
										@Monto = @MontoTransaccion
															
								END
							 
							 --DECLARE @msgF AS VARCHAR(MAX)=concat(N'CodEx|116|trValidarFondos',@IdPeticion)
								--	RAISERROR(@msgF,16,8)
								--	RETURN 
							SELECT vac.IdSaldo,vac.MontoDisponible ,(vac.Saldo-vac.MontoBloqueadoATM) AS Saldo, vac.IdCuenta, vac.CuentaCodigo, vac.CuentaDescripcion,@NumTarjeta AS NumTarjeta,@Num_Referencia AS NumReferencia
							      FROM vATMsaldoCuenta vac
							 WHERE vac.CuentaCodigo=@numeroCuenta
							 
							
							 --PROCESAR LA PETICION DESDE BASE DE DATOS
							-- BEGIN TRY
								  	--EXEC pATMejecutarPeticion
								  	--	@IdPeticion = @IdPeticion
								  --END TRY
								  --BEGIN CATCH
								  
								  	/* 
								  		SELECT
								  			ERROR_NUMBER() AS ErrorNumber,
								  			ERROR_SEVERITY() AS ErrorSeverity,
								  			ERROR_STATE() AS ErrorState,
								  			ERROR_PROCEDURE() AS ErrorProcedure,
								  			ERROR_LINE() AS ErrorLine,
								  			ERROR_MESSAGE() AS ErrorMessage
								  	*/
								 -- END CATCH
							
							END	
							ELSE
								--Si el saldo disponible es menor a la comisión , regresa un mensaje de error informando que existen saldos insuficientes
							BEGIN
									DECLARE @msgFonInsF AS VARCHAR(MAX)=N'CodEx|116|trValidarFondos'
									RAISERROR(@msgFonInsF,16,8)
									RETURN 
							END	
				
									
				END
			ELSE
					---Valida si la Cuenta para ese codigo no existe ,entonces manda un mensaje de Error
				BEGIN
						DECLARE @msgExtCta AS VARCHAR(MAX)=N'CodEx|214|trValidarExistenciaCuenta'
						RAISERROR(@msgExtCta,16,8)
						RETURN 	
				END
				
			END
			ELSE
				BEGIN
					DECLARE @msgTB AS VARCHAR(MAX)=N'CodEx|114|fATMexisteTarjeta'
					RAISERROR(@msgTB,16,8)
					RETURN 
				END
				
		END
		
	END









GO




