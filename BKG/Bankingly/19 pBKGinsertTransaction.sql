
-- pBKGinsertTransaction


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGinsertTransaction')
BEGIN
	DROP PROC pBKGinsertTransaction
	SELECT 'pBKGinsertTransaction BORRADO' AS info
END
GO

CREATE PROC dbo.pBKGinsertTransaction
@SubTransactionTypeId					INT,
@CurrencyId								VARCHAR(8),
@ValueDate								DATE,
@TransactionTypeId						INT,
@TransactionStatusId					INT,	
@ClientBankIdentifier					VARCHAR(24),
@DebitProductBankIdentifier				VARCHAR(32),
@DebitProductTypeId						INT,
@DebitCurrencyId						VARCHAR(8),	
@CreditProductBankIdentifier			VARCHAR(32),	
@CreditProductTypeId					INT,	
@CreditCurrencyId						VARCHAR(8),
@Amount									NUMERIC(18,2),
@NotifyTo								VARCHAR(64),
@NotificationChannelId					INT,
@TransactionId							INT,
@DestinationDocumentId					VARCHAR(24),
@DestinationName						VARCHAR(32),	
@DestinationBank						VARCHAR(32),	
@Description							VARCHAR(32),	
@BankRoutingNumber						VARCHAR(32),
@SourceName								VARCHAR(32),
@SourceBank								VARCHAR(32),
@SourceDocumentId						VARCHAR(32),
@RegulationAmountExceeded				BIT,
@SourceFunds							VARCHAR(32),	
@DestinationFunds						VARCHAR(32),
@UserDocumentId							VARCHAR(32),
@TransactionCost						NUMERIC(18,2),	
@TransactionCostCurrencyId				VARCHAR(8),
@ExchangeRate							NUMERIC(4,2),
@CountryIntermediaryInstitution			VARCHAR(32),
@IntermediaryInstitution				VARCHAR(32),	
@RouteNumberIntermediaryInstitution		VARCHAR(32)		
AS
BEGIN
	
--#region Documentacion INPUT
	/*
	SubTransactionTypeId					int			Identificador del subtipo de transacción según TransactionSubTypes.
	CurrencyId								string		Identificador de la moneda de la transacción según Currencies.
	ValueDate								DateTime?	Fecha valor de la transacción.
	TransactionTypeId						int			Identificador del tipo de transacción según TransactionTypes.
	TransactionStatusId						int			Identificador del estado de la transacción según TransactionStatus.
	ClientBankIdentifier					string		Identificador del Cliente en el Core asociado al producto origen o el producto a debitar.
	DebitProductBankIdentifier				string		Identificador del producto en el Core en el cual se realiza el débito de la transacción.
	DebitProductTypeId						int			Tipo del producto (según ProductTypes) en el cual se debita
	DebitCurrencyId							string		Identificador de la moneda del débito según Currencies.
	CreditProductBankIdentifier				string		Identificador del producto en el Core en el cual se acredita
	CreditProductTypeId						int			Tipo del producto (según ProductTypes) en el cual se acredita
	CreditCurrencyId						string		Identificador de la moneda del crédito según Currencies.
	Amount									decimal?	Monto de la transacción.
	NotifyTo								string		Destino de la notificación.
	NotificationChannelId					int			Identificador del canal de notificación según NotificationChannels.
	TransactionId							int			Identificador de la transacción.
	DestinationDocumentId					DocumentId	Tipo (según DocumentType) y número de documento de identidad del titular de la cuenta destino de la transacción.
	DestinationName							string		Nombre completo del destinatario de la transacción
	DestinationBank							string		Nombre del banco o institución destino de la transacción.
	Description								string		Descripción de la transacción.
	BankRoutingNumber						string		Código de ruta del banco destinatario de la transacción.
	SourceName								string		Nombre completo del origen de la transacción.
	SourceBank								string		Nombre del banco o institución origen para recibir fondos desde otras instituciones
	SourceDocumentId						DocumentId	Tipo (según DocumentType) y número de documento de identidad del titular de la cuenta origen de la transacción, para recibir fondos desde otras instituciones. 
	RegulationAmountExceeded				Bool		Indica si se excedió o no el monto regulatorio acumulado
	SourceFunds								string		Origen de los fondos, campo requerido si se excede el monto regulatorio acumulado
	DestinationFunds						string		Destino de los fondos, campo requerido si se excede el monto regulatorio acumulado
	UserDocumentId							DocumentId	Tipo (según DocumentType) y número de documento de identidad del Usuario que ejecuta la transacción.
	TransactionCost							decimal?	Monto indicando el costo de la transacción.
	TransactionCostCurrencyId				string		Identificador de la moneda (según catálogo Currencies), del monto que indica el costo de la transacción.
	ExchangeRate							decimal?	Cotización de la moneda desplegada al usuario en el paso de confirmación
	CountryIntermediaryInstitution			string		País de la institución intermediaria
	IntermediaryInstitution					string 		Institución intermediaria
	RouteNumberIntermediaryInstitution		string		Número de ruta de la institución intermediaria
	
	-- IntegrationParameters	Dictionary<string,
	-- ExtendedPropertyValue>	Ver Extensibilidad.
	-- Propiedades extendidas particulares para este método:
	•	Para transacciones LBTR se envía TransferExecutionType: inmediata o posterior input.IntegrationParameters.TryGetValue(ExtendedPropertyKeys.Transaction.TransferExecutionType, out transferExecutionType);
	•	Para el pago de préstamos se envía LoanPaymentType: Tipo de pago de préstamos -cancelación, pago de cuota, otro monto-input.IntegrationParameters.TryGetValue(ExtendedPropertyKeys.LoanPayment.LoanPaymentType, out loanPaymentType);
	•	Para los pagos con Wallet: SourceMobileNumber y PaymentIdentifier:
	AuthorizationCode	string	Código de autorización para acceder a la tasa de cambio diferencial en caso de que corresponda. Este código podrá ser ingresado por el usuario en las transferencias cuando el parámetro de configuración Framework.AuthorizationCodeEnabled tenga valor true.

	*/
--#endregion Documentacion INPUT

--#region Documentacion OUTPUT
	/*
	BackendOperationResult
	IsError				bool?	Existe un inconveniente al ejecutar la operación o los controles de validación son no satisfactorios. True = Si; False = No.
	BackendMessage		string	Mensaje del backend que se despliega al usuario final. El idioma del mensaje debe estar de acuerdo al parámetro de entrada UserLanguage.
	BackendReference	string	Referencia del backend. Se despliega al usuario final en caso de que TransactionIdentity no tenga un valor (sea nulo).
	BackendCode			string	Código de respuesta del backend. Ejemplo código 1 = Satifactorio, código 2 Error en … Este código se despliega al usuario final
	TransactionIdentity	string	Identificador de la operación en el backend, se despliega al usuario final.
	*/
--#endregion Documentacion OUTPUT
	DECLARE @IdOperacion INT = 0,
				@Folio INT = 0;

	DECLARE @IsError BIT,
	        @BackendMessage VARCHAR(1024),
	        @BackendReference VARCHAR(1024),
	        @BackendCode VARCHAR(10),
	        @IdCuentaDeposito INT,
	        @IdCuentaRetiro INT;
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
	
	INSERT INTO dbo.tBKGpeticionesInsertMasiveTransaction
	(Referencia,TransactionId,TransactionItemId,SubTransactionTypeId,TransactionFeatureId,CurrencyId,ValueDate,TransactionTypeId,TransactionStatusId,ClientBankIdentifier,DebitProductBankIdentifier,DebitProductTypeId,DebitCurrencyId,
		CreditProductBankIdentifier,CreditProductTypeId,CreditCurrencyId,Amount,NotifyTo,NotificationChannelId,DestinationDocumentType,DestinationDocumentId,DestinationName,DestinationBank,
		Description,BankRoutingNumber,SourceName,SourceBank,SourceDocumentType,SourceDocumentId,RegulationAmountExceeded,SourceFunds,DestinationFunds,UserDocumentType,UserDocumentId,
		TransactionCost,TransactionCostCurrencyId,ExchangeRate,IsValid,ValidationMessage,Alta,IdEstatus	)
	VALUES	('',@TransactionId,0,@SubTransactionTypeId,0,@CurrencyId,@ValueDate,@TransactionTypeId,@TransactionStatusId,@ClientBankIdentifier,@DebitProductBankIdentifier,@DebitProductTypeId,@DebitCurrencyId,@CreditProductBankIdentifier,@CreditProductTypeId,
			@CreditCurrencyId,@Amount,@NotifyTo,@NotificationChannelId,0,@DestinationDocumentId,@DestinationName,@DestinationBank,@Description,@BankRoutingNumber,@SourceName,@SourceBank,0,@SourceDocumentId,@RegulationAmountExceeded,@SourceFunds,@DestinationFunds,
			0,@UserDocumentId,@TransactionCost,@TransactionCostCurrencyId,@ExchangeRate,1,'',GETDATE(),13)

	DECLARE @IdPeticion INT = SCOPE_IDENTITY();

	IF(@IsError = 1)
	BEGIN
		SELECT @IsError IsError,@BackendMessage BackendMessage,@BackendReference BackendReference,@BackendCode BackendCode, -1 TransactionIdentity;
		
		INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,0,0,1,@BackendMessage,@BackendReference,@BackendCode,@TransactionId,GETDATE(),1,@IdPeticion)

		RETURN;
	END

	BEGIN TRY

		BEGIN TRANSACTION

		IF(@SubTransactionTypeId=1) -- 1	Transferencias cuentas propias
		BEGIN
			-- 144 a 144
		
			EXECUTE dbo.pBKGTransferenciaCuentasPropiasAhorro @IdOperacion = @IdOperacion OUTPUT, -- int
															  @Folio = @Folio OUTPUT,
															  @Fecha = @ValueDate,              -- date
															  @Monto = @Amount,                      -- numeric(23, 2)
															  @MontoComision = @TransactionCost,              -- numeric(23, 2)
															  @IdCuentaRetiro = @IdCuentaRetiro,                -- int
															  @IdCuentaDeposito = @IdCuentaDeposito,              -- int
															  @Concepto = @Description,                     -- varchar(80)
															  @IdOperacionPadre = 0,
															  @AfectaSaldo = 1
		
			COMMIT

			SELECT 0 IsError,'Operación exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;
			
			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operación exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;
		END

		IF(@SubTransactionTypeId=2) -- 2	Transferencias a cuentas de terceros en la institución
		BEGIN
		
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

			COMMIT

			SELECT 0 IsError,'Operación exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;
			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operación exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;
		END

		IF(@SubTransactionTypeId=7) -- 7	Pago de servicios
		BEGIN
		COMMIT
		RETURN 1
		END

		IF(@SubTransactionTypeId=9) -- 9	Pago de prestamo
		BEGIN
	
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
			
			COMMIT

			SELECT 0 IsError,'Operación exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;

			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operación exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;
		END

		IF(@SubTransactionTypeId=10) -- 10	Pago de préstamo de terceros
		BEGIN
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
			
			COMMIT

			SELECT 0 IsError,'Operación exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;

			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operación exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;

		END

    END TRY	
	BEGIN CATCH

		ROLLBACK;
		
		SELECT 1 IsError,'Operación erronea' BackendMessage,ERROR_MESSAGE() BackendReference, '0099' BackendCode,-1 TransactionIdentity;
		
		INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operación exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

		RETURN 
	
	END CATCH	
END

GO