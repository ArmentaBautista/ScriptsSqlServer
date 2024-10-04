
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
	SubTransactionTypeId					int			Identificador del subtipo de transacci�n seg�n TransactionSubTypes.
	CurrencyId								string		Identificador de la moneda de la transacci�n seg�n Currencies.
	ValueDate								DateTime?	Fecha valor de la transacci�n.
	TransactionTypeId						int			Identificador del tipo de transacci�n seg�n TransactionTypes.
	TransactionStatusId						int			Identificador del estado de la transacci�n seg�n TransactionStatus.
	ClientBankIdentifier					string		Identificador del Cliente en el Core asociado al producto origen o el producto a debitar.
	DebitProductBankIdentifier				string		Identificador del producto en el Core en el cual se realiza el d�bito de la transacci�n.
	DebitProductTypeId						int			Tipo del producto (seg�n ProductTypes) en el cual se debita
	DebitCurrencyId							string		Identificador de la moneda del d�bito seg�n Currencies.
	CreditProductBankIdentifier				string		Identificador del producto en el Core en el cual se acredita
	CreditProductTypeId						int			Tipo del producto (seg�n ProductTypes) en el cual se acredita
	CreditCurrencyId						string		Identificador de la moneda del cr�dito seg�n Currencies.
	Amount									decimal?	Monto de la transacci�n.
	NotifyTo								string		Destino de la notificaci�n.
	NotificationChannelId					int			Identificador del canal de notificaci�n seg�n NotificationChannels.
	TransactionId							int			Identificador de la transacci�n.
	DestinationDocumentId					DocumentId	Tipo (seg�n DocumentType) y n�mero de documento de identidad del titular de la cuenta destino de la transacci�n.
	DestinationName							string		Nombre completo del destinatario de la transacci�n
	DestinationBank							string		Nombre del banco o instituci�n destino de la transacci�n.
	Description								string		Descripci�n de la transacci�n.
	BankRoutingNumber						string		C�digo de ruta del banco destinatario de la transacci�n.
	SourceName								string		Nombre completo del origen de la transacci�n.
	SourceBank								string		Nombre del banco o instituci�n origen para recibir fondos desde otras instituciones
	SourceDocumentId						DocumentId	Tipo (seg�n DocumentType) y n�mero de documento de identidad del titular de la cuenta origen de la transacci�n, para recibir fondos desde otras instituciones. 
	RegulationAmountExceeded				Bool		Indica si se excedi� o no el monto regulatorio acumulado
	SourceFunds								string		Origen de los fondos, campo requerido si se excede el monto regulatorio acumulado
	DestinationFunds						string		Destino de los fondos, campo requerido si se excede el monto regulatorio acumulado
	UserDocumentId							DocumentId	Tipo (seg�n DocumentType) y n�mero de documento de identidad del Usuario que ejecuta la transacci�n.
	TransactionCost							decimal?	Monto indicando el costo de la transacci�n.
	TransactionCostCurrencyId				string		Identificador de la moneda (seg�n cat�logo Currencies), del monto que indica el costo de la transacci�n.
	ExchangeRate							decimal?	Cotizaci�n de la moneda desplegada al usuario en el paso de confirmaci�n
	CountryIntermediaryInstitution			string		Pa�s de la instituci�n intermediaria
	IntermediaryInstitution					string 		Instituci�n intermediaria
	RouteNumberIntermediaryInstitution		string		N�mero de ruta de la instituci�n intermediaria
	
	-- IntegrationParameters	Dictionary<string,
	-- ExtendedPropertyValue>	Ver Extensibilidad.
	-- Propiedades extendidas particulares para este m�todo:
	�	Para transacciones LBTR se env�a TransferExecutionType: inmediata o posterior input.IntegrationParameters.TryGetValue(ExtendedPropertyKeys.Transaction.TransferExecutionType, out transferExecutionType);
	�	Para el pago de pr�stamos se env�a LoanPaymentType: Tipo de pago de pr�stamos -cancelaci�n, pago de cuota, otro monto-input.IntegrationParameters.TryGetValue(ExtendedPropertyKeys.LoanPayment.LoanPaymentType, out loanPaymentType);
	�	Para los pagos con Wallet: SourceMobileNumber y PaymentIdentifier:
	AuthorizationCode	string	C�digo de autorizaci�n para acceder a la tasa de cambio diferencial en caso de que corresponda. Este c�digo podr� ser ingresado por el usuario en las transferencias cuando el par�metro de configuraci�n Framework.AuthorizationCodeEnabled tenga valor true.

	*/
--#endregion Documentacion INPUT

--#region Documentacion OUTPUT
	/*
	BackendOperationResult
	IsError				bool?	Existe un inconveniente al ejecutar la operaci�n o los controles de validaci�n son no satisfactorios. True = Si; False = No.
	BackendMessage		string	Mensaje del backend que se despliega al usuario final. El idioma del mensaje debe estar de acuerdo al par�metro de entrada UserLanguage.
	BackendReference	string	Referencia del backend. Se despliega al usuario final en caso de que TransactionIdentity no tenga un valor (sea nulo).
	BackendCode			string	C�digo de respuesta del backend. Ejemplo c�digo 1 = Satifactorio, c�digo 2 Error en � Este c�digo se despliega al usuario final
	TransactionIdentity	string	Identificador de la operaci�n en el backend, se despliega al usuario final.
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

			SELECT 0 IsError,'Operaci�n exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;
			
			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operaci�n exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;
		END

		IF(@SubTransactionTypeId=2) -- 2	Transferencias a cuentas de terceros en la instituci�n
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

			SELECT 0 IsError,'Operaci�n exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;
			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operaci�n exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

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

			SELECT 0 IsError,'Operaci�n exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;

			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operaci�n exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;
		END

		IF(@SubTransactionTypeId=10) -- 10	Pago de pr�stamo de terceros
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

			SELECT 0 IsError,'Operaci�n exitosa' BackendMessage,'' BackendReference, '0001' BackendCode,@Folio TransactionIdentity;

			INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operaci�n exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

			RETURN;

		END

    END TRY	
	BEGIN CATCH

		ROLLBACK;
		
		SELECT 1 IsError,'Operaci�n erronea' BackendMessage,ERROR_MESSAGE() BackendReference, '0099' BackendCode,-1 TransactionIdentity;
		
		INSERT INTO dbo.tBKGbackendOperationItemResult	(IdOperacionPadre,IdOperacion,TransactionItemId,IsError,BackendMessage,BackendReference,BackendCode,TransactionIdentity,Alta,IdEstatus,IdPeticion)
			VALUES(   0,@IdOperacion,0,0,'Operaci�n exitosa','','0001',@TransactionId,GETDATE(),1,@IdPeticion)

		RETURN 
	
	END CATCH	
END

GO