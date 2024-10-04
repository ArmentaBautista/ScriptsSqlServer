
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGpeticionesInsertMasiveTransaction')
BEGIN
	CREATE TABLE [dbo].[tBKGpeticionesInsertMasiveTransaction]
	(
		IdPeticion 							INT NOT NULL PRIMARY KEY IDENTITY,
		Referencia							VARCHAR(64),
		-- Identificador de la Transacción Padre
		TransactionId						INT,
		--BEGIN Entidad InsertMassiveTransactionItemInput
		TransactionItemId					INT,
		SubTransactionTypeId				INT,
		TransactionFeatureId				INT,
		CurrencyId							VARCHAR(8),
		ValueDate							DATE,
		TransactionTypeId					INT,
		TransactionStatusId					INT,	
		ClientBankIdentifier				VARCHAR(24),
		DebitProductBankIdentifier			VARCHAR(32),
		DebitProductTypeId					INT,
		DebitCurrencyId						VARCHAR(8),	
		CreditProductBankIdentifier			VARCHAR(32),	
		CreditProductTypeId					INT,	
		CreditCurrencyId					VARCHAR(8),
		Amount								NUMERIC(18,2),
		NotifyTo							VARCHAR(64),
		NotificationChannelId				INT,		
		--BEGIN DestinationDocumentId				
		DestinationDocumentType				INT,
		DestinationDocumentId				VARCHAR(24),
		--END DestinationDocumentId
		DestinationName						VARCHAR(32),	
		DestinationBank						VARCHAR(32),	
		Description							VARCHAR(32),	
		BankRoutingNumber					VARCHAR(32),
		SourceName							VARCHAR(32),
		SourceBank							VARCHAR(32),
		--BEGIN SourceDocumentId					
		SourceDocumentType					INT,
		SourceDocumentId					VARCHAR(24),
		--END SourceDocumentId
		RegulationAmountExceeded			BIT,
		SourceFunds							VARCHAR(32),	
		DestinationFunds					VARCHAR(32),
		--BEGIN UserDocumentId		
		UserDocumentType					INT,
		UserDocumentId						VARCHAR(24),
		--END UserDocumentId
		TransactionCost						NUMERIC(18,2),	
		TransactionCostCurrencyId			VARCHAR(8),
		ExchangeRate						NUMERIC(4,2),
		IsValid								BIT,
		ValidationMessage					VARCHAR(32),
		--END Entidad InsertMassiveTransactionItemInput
		Fecha								DATE DEFAULT GETDATE(),
		Alta								DATETIME DEFAULT GETDATE(),
		IdEstatus 							INT NOT NULL
	) ON [PRIMARY]
	SELECT 'Tabla Creada tBKGpeticionesInsertMasiveTransaction' AS info
	
END
ELSE 
	-- DROP TABLE tBKGpeticionesInsertMasiveTransaction
	SELECT 'tBKGpeticionesInsertMasiveTransaction Existe'
GO

