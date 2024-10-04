
-- 72 pBKGinsertMassiveTransaction

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGinsertMassiveTransaction')
BEGIN
	DROP PROC pBKGinsertMassiveTransaction
	SELECT 'pBKGinsertMassiveTransaction BORRADO' AS info
END
GO

CREATE PROC pBKGinsertMassiveTransaction
@TransactionId			INT,
@Referencia				VARCHAR(64),
@AuthorizationCode		VARCHAR(32)
AS
BEGIN
	
	DECLARE @IdPeticion INT = 0,@TransactionItemId INT = 0,@ValueDate DATE = '19000101',@Description VARCHAR(32) = '',@SubTransactionTypeId INT = 0,@DebitProductBankIdentifier VARCHAR(32) = '',@CreditProductBankIdentifier VARCHAR(32) = '',@Amount NUMERIC(8,2) = 0,
			@TransactionCost NUMERIC(18,2)

	INSERT INTO dbo.tBKGbackendOperationItemResult
	(IdPeticion,IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus)	
	SELECT imt.IdPeticion,0,0,imt.TransactionItemId,1,'No procesada','No procesada','0099',0,'19000101',13 
	FROM dbo.tBKGpeticionesInsertMasiveTransaction imt  WITH(NOLOCK) 
	LEFT JOIN dbo.tBKGbackendOperationItemResult oir  WITH(NOLOCK)  ON oir.IdPeticion = imt.IdPeticion
	WHERE imt.TransactionId = @TransactionId AND imt.Referencia = @Referencia AND oir.IdPeticion IS NULL

	DECLARE MovimientosBKG CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
    SELECT IdPeticion,TransactionItemId,ValueDate,Description,SubTransactionTypeId,DebitProductBankIdentifier,CreditProductBankIdentifier,Amount,TransactionCost 
	FROM dbo.tBKGpeticionesInsertMasiveTransaction  WITH(NOLOCK) 
	WHERE TransactionId = @TransactionId AND Referencia = @Referencia AND IdEstatus = 1


	OPEN MovimientosBKG;
        FETCH NEXT FROM MovimientosBKG
        INTO @IdPeticion,@TransactionItemId,@ValueDate,@Description,@SubTransactionTypeId,@DebitProductBankIdentifier,@CreditProductBankIdentifier,@Amount,@TransactionCost

	WHILE @@FETCH_STATUS = 0
    BEGIN


			DECLARE @IdOperacion INT = 0,
			@Folio INT = 0

			DECLARE @IsError BIT = 0,
	        @BackendMessage VARCHAR(1024) = '',
	        @BackendReference VARCHAR(1024) = '',
	        @BackendCode VARCHAR(10) = '',
	        @IdCuentaDeposito INT = 0,
	        @IdCuentaRetiro INT = 0;
			EXECUTE dbo.pBKGValidacionesCuentas @TipoOperacion = @SubTransactionTypeId,                           -- int
												@IsError = @IsError OUTPUT,                   -- bit
												@BackendMessage = @BackendMessage OUTPUT,     -- varchar(1024)
												@BackendReference = @BackendReference OUTPUT, -- varchar(1024)
												@BackendCode = @BackendCode OUTPUT,           -- varchar(10)
												@IdCuentaDeposito = @IdCuentaDeposito OUTPUT, -- int
												@IdCuentaRetiro = @IdCuentaRetiro OUTPUT,     -- int
												@DebitProductBankIdentifier = @DebitProductBankIdentifier,             -- varchar(50)
												@CreditProductBankIdentifier = @CreditProductBankIdentifier,            -- varchar(50)
												@Amount = @Amount,                               -- decimal(23, 8)
												@ValueDate = @ValueDate                     -- date


			IF(@IsError = 1)
			BEGIN

				
				UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = @BackendMessage, BackendReference = @BackendReference, BackendCode =@BackendCode, TransactionIdentity = -1,Alta =GETDATE(),IdEstatus = 13 WHERE IdPeticion = @IdPeticion
				
				FETCH NEXT FROM MovimientosBKG
				INTO @IdPeticion,@TransactionItemId,@ValueDate,@Description,@SubTransactionTypeId,@DebitProductBankIdentifier,@CreditProductBankIdentifier,@Amount,@TransactionCost
				CONTINUE
				
			
			END			

			IF(@SubTransactionTypeId=6) -- 6	Pago de servicios
			BEGIN
	
				DECLARE @IdTipoDProductoDestino INT = 0,
						@IdsocioOrgien INT = 0,
						@IdSocioDestino INT = 0

				SELECT @IdsocioOrgien = c.IdSocio FROM dbo.tAYCcuentas c  WITH(NOLOCK)  WHERE c.IdCuenta = @IdCuentaRetiro
				SELECT @IdTipoDProductoDestino=c.IdTipoDProducto,@IdSocioDestino = c.IdSocio FROM dbo.tAYCcuentas c  WITH(NOLOCK)  WHERE c.IdCuenta = @IdCuentaDeposito

				IF(@IdTipoDProductoDestino = 143)
				BEGIN	
					IF(@IdsocioOrgien = @IdSocioDestino)
					BEGIN
						SET @SubTransactionTypeId = 9	--Pago de prestamo
					END

					IF(@IdsocioOrgien <> @IdSocioDestino)
					BEGIN
						SET @SubTransactionTypeId = 10	--Pago de prestamo Terceros
					END
				END 

				IF(@IdTipoDProductoDestino = 144)
				BEGIN	
					IF(@IdsocioOrgien = @IdSocioDestino)
					BEGIN
						SET @SubTransactionTypeId = 1	--Transferencias cuentas propias
					END

					IF(@IdsocioOrgien <> @IdSocioDestino)
					BEGIN
						SET @SubTransactionTypeId = 2	--Transferencias a cuentas de terceros en la institución
					END
				END 				
			END

			IF(@SubTransactionTypeId=1) -- 1	Transferencias cuentas propias
			BEGIN
			-- 144 a 144

				BEGIN TRY 
					
					BEGIN TRANSACTION
		
					SET @IdOperacion = 0;
					SET @Folio = 0;

					EXECUTE dbo.pBKGTransferenciaCuentasPropiasAhorro  @IdOperacion = @IdOperacion OUTPUT, -- int
																	  @Folio = @Folio OUTPUT,
																	  @Fecha = @ValueDate,              -- date
																	  @Monto = @Amount,                      -- numeric(23, 2)
																	  @MontoComision = @TransactionCost,              -- numeric(23, 2)
																	  @IdCuentaRetiro = @IdCuentaRetiro,                -- int
																	  @IdCuentaDeposito = @IdCuentaDeposito,              -- int
																	  @Concepto = @Description,                     -- varchar(80)
																	  @IdOperacionPadre = 0,
																	  @AfectaSaldo = 1
				

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operación Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion
				
					COMMIT TRAN 

				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operación Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion

				END CATCH				
			END

			IF(@SubTransactionTypeId=2) -- 2	Transferencias a cuentas de terceros en la institución
			BEGIN
				BEGIN TRY	

					BEGIN TRANSACTION

					
					SET @IdOperacion = 0;
					SET @Folio = 0;

					EXECUTE dbo.pBKGTransferenciaCuentasTerceroAhorro @IdOperacion = @IdOperacion OUTPUT, -- int
																	  @Folio = @Folio OUTPUT,
																	  @Fecha = @ValueDate,              -- date
																	  @Monto = @Amount,                      -- numeric(23, 2)
																	  @MontoComision = @TransactionCost,              -- numeric(23, 2)
																	  @IdCuentaRetiro = @IdCuentaRetiro,                -- int
																	  @IdCuentaDeposito = @IdCuentaDeposito,              -- int
																	  @Concepto = @Description,                     -- varchar(80)
																	  @IdOperacionPadre = 0,
																	  @AfectaSaldo = 1


					PRINT CONCAT(@IdOperacion,' @IdOperacion ',@Folio,' @Folio ', @IdCuentaRetiro,' @IdCuentaRetiro ',@IdCuentaDeposito,' @IdCuentaDeposito')

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operación Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion

					COMMIT TRAN

				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operación Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion


				END CATCH	
			END			

			IF(@SubTransactionTypeId=7) -- 7	Pago de servicios
			BEGIN
	
			RETURN 1
			END

			IF(@SubTransactionTypeId=9) -- 9	Pago de prestamo
			BEGIN
				
				BEGIN TRY	

					BEGIN TRANSACTION

					SET @IdOperacion = 0;
					SET @Folio = 0;

					EXECUTE dbo.pBKGTransferenciaPagoCredito @IdOperacion = @IdOperacion OUTPUT, -- int
															 @Folio = @Folio OUTPUT,             -- int
															 @Fecha = @ValueDate,               -- date
															 @Monto = @Amount,                       -- numeric(23, 2)
															 @MontoComision = @TransactionCost,               -- numeric(23, 2)
															 @IdCuentaRetiro = @IdCuentaRetiro,                 -- int
															 @IdCuentaDeposito = @IdCuentaDeposito,               -- int
															 @Concepto = @Description,                     -- varchar(80)
															 @IdOperacionPadre = 0,
															 @AfectaSaldo = 1

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operación Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion
				
					COMMIT TRAN 

				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN 

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operación Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion
			
				END CATCH	
			END

			IF(@SubTransactionTypeId=10) -- 10	Pago de préstamo de terceros
			BEGIN
				BEGIN TRY

					BEGIN TRANSACTION
				
					SET @IdOperacion = 0;
					SET @Folio = 0;

					EXECUTE dbo.pBKGTransferenciaPagoCredito @IdOperacion = @IdOperacion OUTPUT, -- int
																 @Folio = @Folio OUTPUT,             -- int
																 @Fecha = @ValueDate,               -- date
																 @Monto = @Amount,                       -- numeric(23, 2)
																 @MontoComision = @TransactionCost,               -- numeric(23, 2)
																 @IdCuentaRetiro = @IdCuentaRetiro,                 -- int
																 @IdCuentaDeposito = @IdCuentaDeposito,               -- int
																 @Concepto = @Description,                     -- varchar(80)
																 @IdOperacionPadre = 0,
																 @AfectaSaldo = 1


					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operación Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion
				
					COMMIT TRAN 

					
				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN 

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operación Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion

				END CATCH	
			END

			FETCH NEXT FROM MovimientosBKG
			INTO @IdPeticion,@TransactionItemId,@ValueDate,@Description,@SubTransactionTypeId,@DebitProductBankIdentifier,@CreditProductBankIdentifier,@Amount,@TransactionCost

    END
    CLOSE MovimientosBKG;
    DEALLOCATE MovimientosBKG;
	
	DECLARE @TotalPeticiones INT = 0;
	DECLARE @PeticionesProcesadas INT = 0;
	DECLARE @PeticionesNoProcesadas INT = 0;


	SELECT @TotalPeticiones = COUNT(IdPeticion) FROM dbo.tBKGpeticionesInsertMasiveTransaction 
	WHERE TransactionId = @TransactionId AND Referencia = @Referencia

	SELECT @PeticionesProcesadas = COUNT(pimt.IdPeticion) FROM dbo.tBKGpeticionesInsertMasiveTransaction pimt  WITH(NOLOCK) 
	INNER JOIN  dbo.tBKGbackendOperationItemResult oir  WITH(NOLOCK)  ON oir.IdPeticion = pimt.IdPeticion
	WHERE pimt.TransactionId = @TransactionId AND pimt.Referencia = @Referencia AND oir.IdEstatus = 82

	SELECT @PeticionesNoProcesadas = COUNT(pimt.IdPeticion) FROM dbo.tBKGpeticionesInsertMasiveTransaction pimt  WITH(NOLOCK) 
	INNER JOIN  dbo.tBKGbackendOperationItemResult oir  WITH(NOLOCK)  ON oir.IdPeticion = pimt.IdPeticion
	WHERE pimt.TransactionId = @TransactionId AND pimt.Referencia = @Referencia AND oir.IdEstatus =  13

	IF(@PeticionesNoProcesadas > 0)
		SELECT 0 IsError,'Aplicación de movimientos parcial' BackendMessage,CONCAT('Se aplicaron ',@PeticionesProcesadas, ' de ', @TotalPeticiones) BackendReference, '0001' BackendCode,@TransactionId TransactionIdentity;

	IF(@PeticionesProcesadas = 0)
		SELECT 1 IsError,'Movimientos No Aplicados' BackendMessage,CONCAT('Se aplicaron ',@PeticionesProcesadas, ' de ', @TotalPeticiones) BackendReference, '0001' BackendCode,-1 TransactionIdentity;

END
GO