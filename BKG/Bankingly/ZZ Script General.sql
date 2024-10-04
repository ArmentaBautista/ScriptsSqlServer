
/* FILE: 00.1 Type BKGaccountMovements.sql    */


IF EXISTS (SELECT 1 FROM sys.types WHERE name = 'BKGaccountMovements')
    DROP TYPE BKGaccountMovements

GO

/* FILE: 00.1 Type BKGaccountMovements.sql    */

CREATE TYPE BKGaccountMovements AS TABLE(
		MovementId 				INT ,
		AccountBankIdentifier	VARCHAR(30),
		MovementDate 			DATE,	
		Description 			VARCHAR(80),
		Amount 					NUMERIC(18,2),
		isDebit 				BIT,
		Balance 				NUMERIC(18,2),
		MovementTypeId 			INT,
		TypeDescription 		VARCHAR(24),
		CheckId					INT,
		VoucherId				VARCHAR(20)
)

GO

/* FILE: 00.1 Type BKGaccountMovements.sql    */


GO

/* FILE: 00.2 Type BKGgetLoan.sql    */



IF EXISTS (SELECT 1 FROM sys.types WHERE name = 'BKGgetLoan')
    DROP TYPE BKGgetLoan

GO

/* FILE: 00.2 Type BKGgetLoan.sql    */

CREATE TYPE BKGgetLoan AS TABLE(
		AccountBankIdentifier		VARCHAR(32),		
		CurrentBalance				NUMERIC(23,8),
		CurrentRate  				NUMERIC(18,2),
		FeesDue						INT,
		-- BEGIN FeesDueData		
		FeesDueInterestAmount		NUMERIC(18,2),
		FeesDueOthersAmount			NUMERIC(23,8),
		FeesDueOverdueAmount		NUMERIC(23,8),
		FeesDuePrincipalAmount		NUMERIC(23,8),
		FeesDueTotalAmount			NUMERIC(23,8),
		-- END FeesDueData
		LoanStatusId				INT,
		-- BEGIN NextFee - LoanFee
		CapitalBalance				NUMERIC(23,8),
		FeeNumber					INT,
		PrincipalAmount				NUMERIC(23,8),
		DueDate						DATE,
		InterestAmount				NUMERIC(23,8),
		OverdueAmount				NUMERIC(23,8),
		FeeStatusId					INT,
		OthersAmount				NUMERIC(23,8),
		TotalAmount					NUMERIC(23,8),
		-- END NextFee - LoanFee
		OriginalAmount				NUMERIC(18,2),
		OverdueDays					INT,
		PaidFees					INT,
		PayoffBalance				NUMERIC(23,8),
		PrepaymentAmount			NUMERIC(23,8),
		ProducttBankIdentifier		VARCHAR(32),
		Term						int,
		ShowPrincipalInformation	bit
)

GO

/* FILE: 00.2 Type BKGgetLoan.sql    */


GO

/* FILE: 00A tAYCcaptacion.sql    */


IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCcaptacion')
BEGIN
	-- DROP TABLE tAYCcaptacion
	
	CREATE TABLE [dbo].[tAYCcaptacion](
		[Fecha]								DATE,
		IdTipoDproducto						INT,
		[IdCuenta]							[int] NOT NULL,
		[IdSaldo]							[INT] NOT NULL,
		[Capital]							[NUMERIC](25, 8) NULL,
		[InteresOrdinario]					[NUMERIC](25, 8) NULL,
		[InteresPendienteCapitalizar]		[NUMERIC](23, 8) NOT NULL,
		[MontoBloqueado]					[NUMERIC](23, 8) NOT NULL,
		[MontoDisponible]					[NUMERIC](38, 8) NULL,
		[Saldo]								[NUMERIC](38, 8) NULL,
		[SaldoBalanceCuentasOrden]			[NUMERIC](38, 8) NULL,
		[IdEstatus]							[INT] NOT NULL,
		[Alta]								DATETIME	
	)

	SELECT 'OBJETO tAYCcaptacion Creado' AS info

END

GO

/* FILE: 00A tAYCcaptacion.sql    */

SELECT 'OBJETO tAYCcaptacion Existente' AS info

GO

/* FILE: 00A tAYCcaptacion.sql    */

GO

/* FILE: 00B tBKGcatalogoCanTransactType.sql    */


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoCanTransactType')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoCanTransactType]
	(
		CanTransactType		INT NOT NULL PRIMARY KEY,	
		CanTransctName		VARCHAR(24) NOT NULL,
		Descripcion			VARCHAR(64) NOT NULL 
	) ON [PRIMARY]
	
	SELECT 'Tabla Creada tBKGcatalogoCanTransactType' AS info
	
END
ELSE 
	-- DROP TABLE tBKGcatalogoCanTransactType
	SELECT 'tBKGcatalogoCanTransactType Existe'

GO

/* FILE: 00B tBKGcatalogoCanTransactType.sql    */


GO

/* FILE: 00C tBKGcatalogoDocumentType.sql    */



IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tBKGcatalogoDocumentType')
BEGIN
	CREATE TABLE tBKGcatalogoDocumentType
	(
		IdDocumentType			INT NOT NULL PRIMARY KEY,
		DocumentType			VARCHAR(24) NOT NULL,
		IdListaDidentificacion	INT NOT NULL,
		IdEstatus				INT NOT NULL
	)	

	ALTER TABLE dbo.tBKGcatalogoDocumentType ADD CONSTRAINT FK_tBKGcatalogoDocumentType_IdListaDidentificacion
	FOREIGN KEY (IdListaDidentificacion) REFERENCES dbo.tCATlistasD (IdListaD)

	ALTER TABLE dbo.tBKGcatalogoDocumentType ADD CONSTRAINT DF_tBKGcatalogoDocumentType_IdEstatus DEFAULT 1 FOR IdEstatus

END
ELSE
	SELECT 'tBKGcatalogoDocumentType ya existe'
	-- DROP TABLE tBKGcatalogoDocumentType

GO

/* FILE: 00C tBKGcatalogoDocumentType.sql    */




GO

/* FILE: 00D tBKGbackendOperationItemResult.sql    */

--  tBKGbackendOperationItemResult
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGbackendOperationItemResult')
BEGIN
	CREATE TABLE [dbo].[tBKGbackendOperationItemResult]
	(
		Id 					INT NOT NULL PRIMARY KEY IDENTITY,
		IdOperacionPadre	INT,
		IdOperacion			INT,
		TransactionItemId	INT,
		--BEGIN Entidad BackendOperationResult
		IsError				BIT,
		BackendMessage		VARCHAR(128),
		BackendReference	varchar(64),
		BackendCode			VARCHAR(8),
		TransactionIdentity	VARCHAR(24),
		--END Entidad BackendOperationResult
		Alta				DATETIME DEFAULT GETDATE(),
		IdEstatus 			INT NOT NULL,
		IdPeticion			INT NULL
	) ON [PRIMARY]
	SELECT 'Tabla Creada tBKGbackendOperationItemResult' AS info
	
END
ELSE 
	-- DROP TABLE tBKGbackendOperationItemResult
	SELECT 'tBKGbackendOperationItemResult Existe'

GO

/* FILE: 00D tBKGbackendOperationItemResult.sql    */


GO

/* FILE: 00E tBKGcatalogoLoanFeeStatus.sql    */


-- LoanFeeStatus


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoLoanFeeStatus')
BEGIN
	CREATE TABLE tBKGcatalogoLoanFeeStatus
	(
		Id						INT PRIMARY KEY,
		Description				VARCHAR(128) NOT NULL,
		Descripcion				VARCHAR(128) NOT NULL,
		IdEstatus				INT NOT NULL FOREIGN KEY REFERENCES dbo.tCTLestatus(IdEstatus)
	) 

	SELECT 'Tabla Creada tBKGcatalogoLoanFeeStatus' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoLoanFeeStatus
	SELECT 'tBKGcatalogoLoanFeeStatus Existe'

GO

/* FILE: 00E tBKGcatalogoLoanFeeStatus.sql    */

-- Registros iniciales
IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoLoanFeeStatus t  WITH(NOLOCK) 
			WHERE t.id IN (0,1,2,3))
BEGIN	

	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (0,'Undefined', 'Indefinido',0)
	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (1,'Active', 'Activo',1)
	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (2,'Expired', 'Vencido',29)
	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (3,'Paid', 'Pagado',7)
END

GO

/* FILE: 00E tBKGcatalogoLoanFeeStatus.sql    */


SELECT * FROM dbo.tBKGcatalogoLoanFeeStatus

GO

/* FILE: 00E tBKGcatalogoLoanFeeStatus.sql    */


GO

/* FILE: 00F tBKGcatalogoMovementTypes.sql    */


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoMovementTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoMovementTypes]
	(
		Id				INT NOT NULL PRIMARY KEY,	
		Descripcion		VARCHAR(24) NOT NULL
	) 
	
	SELECT 'Tabla Creada tBKGcatalogoMovementTypes' AS info
	
END
ELSE 
	-- DROP TABLE tBKGcatalogoMovementTypes
	SELECT 'tBKGcatalogoMovementTypes Existe'

GO

/* FILE: 00F tBKGcatalogoMovementTypes.sql    */

IF NOT EXISTS(SELECT 1 FROM tBKGcatalogoMovementTypes WHERE id IN (0,1,2,3,4))
BEGIN	

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(0,'Undefined');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(1,'Credit/Debit');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(2,'Credit');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(3,'Debit');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(4,'Balance');

END

GO

/* FILE: 00F tBKGcatalogoMovementTypes.sql    */

SELECT * FROM dbo.tBKGcatalogoMovementTypes


GO

/* FILE: 00F tBKGcatalogoMovementTypes.sql    */





GO

/* FILE: 00G tBKGcatalogoProductStatus.sql    */

-- ProductStatus

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoProductStatus')
BEGIN
	CREATE TABLE dbo.tBKGcatalogoProductStatus
	(
	ProductStatusId INT NOT NULL PRIMARY KEY,
	Description VARCHAR (128) NOT NULL,
	Descripcion VARCHAR (128) NOT NULL,
	IdEstatus INT NOT NULL
	) 

	ALTER TABLE dbo.tBKGcatalogoProductStatus ADD CONSTRAINT FK_tBKGcatalogoProductStatus_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
	SELECT 'Tabla Creada tBKGcatalogoProductStatus' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoProductStatus
	SELECT 'tBKGcatalogoProductStatus Existe'

GO

/* FILE: 00G tBKGcatalogoProductStatus.sql    */



-- Registros iniciales
IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoProductStatus t  WITH(NOLOCK) WHERE t.ProductStatusId IN (0,1,2,3))
BEGIN	
		INSERT INTO tBKGcatalogoProductStatus (ProductStatusId, Description, Descripcion, IdEstatus)
		VALUES
		( 0, 'Undefined', 'Indefinido', 0 ), 
		( 1, 'Active', 'Activo', 1 ), 
		( 2, 'Deleted', 'Eliminado', 7 ), 
		( 3, 'Inactive', 'Inactivo', 3 )	
END
GO	

SELECT * FROM dbo.tBKGcatalogoProductStatus
GO	



GO

/* FILE: 00H tBKGcatalogoProductTypes.sql    */

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoProductTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoProductTypes]
	(
		ProductTypeId		INT NOT NULL PRIMARY KEY,
		ProductTypeName		VARCHAR(32) NOT NULL,
		Descripcion			VARCHAR(64) NOT NULL,
		IdTipoDproducto		INT NOT NULL,
		Revolvente			BIT NOT NULL,
		LineaCredito		BIT NOT NULL,
		IdEstatus 			INT NOT NULL
	) ON [PRIMARY]

	ALTER TABLE dbo.tBKGcatalogoProductTypes ADD CONSTRAINT DF_tBKGcatalogoProductTypes_IdEstatus DEFAULT 1 FOR IdEstatus
	ALTER TABLE dbo.tBKGcatalogoProductTypes ADD CONSTRAINT DF_tBKGcatalogoProductTypes_Revolvente DEFAULT 0 FOR Revolvente
	ALTER TABLE dbo.tBKGcatalogoProductTypes ADD CONSTRAINT DF_tBKGcatalogoProductTypes_LineaCredito DEFAULT 0 FOR LineaCredito

	SELECT 'Tabla Creada tBKGcatalogoProductTypes' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoProductTypes
	SELECT 'tBKGcatalogoProductTypes Existe'

GO

/* FILE: 00H tBKGcatalogoProductTypes.sql    */


/*
SELECT * from tBKGcatalogoProductTypes

*/


GO

/* FILE: 00H tBKGcatalogoProductTypes.sql    */

		

GO

/* FILE: 00I tBKGcatalogoThirdPartyProductTypes.sql    */

-- Select * from tBKGcatalogoThirdPartyProductTypes

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoThirdPartyProductTypes')
BEGIN
	CREATE TABLE tBKGcatalogoThirdPartyProductTypes
	(
		ProductTypeId		INT				PRIMARY KEY,
		ProductTypeName		VARCHAR(64)		NOT NULL,
		Descripcion			VARCHAR(128)	NOT NULL
	) 

	SELECT 'Tabla Creada tBKGcatalogoThirdPartyProductTypes' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoThirdPartyProductTypes
	SELECT 'tBKGcatalogoThirdPartyProductTypes Existe'

GO

/* FILE: 00I tBKGcatalogoThirdPartyProductTypes.sql    */

IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoThirdPartyProductTypes t  WITH(NOLOCK) 
			WHERE t.ProductTypeId IN (1,2,3,4,5))
BEGIN	
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   1,  'Local', 'Dentro de la instituci�n')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   2,  'Country', 'Fuera de la instituci�n y dentro del pa�s')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   3,  'Foreign', 'Fuera de la instituci�n y fuera del pa�s')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   4,  'LBTR', 'Para operaciones a trav�s del Banco Central (LBTR, SINPE)')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   5,  'Wallet (de uso interno)', 'Para Billetera Electr�nica')
		
END

GO

/* FILE: 00I tBKGcatalogoThirdPartyProductTypes.sql    */

SELECT * FROM dbo.tBKGcatalogoThirdPartyProductTypes

GO

/* FILE: 00I tBKGcatalogoThirdPartyProductTypes.sql    */


GO

/* FILE: 00J tBKGcatalogoTransactionTypes.sql    */
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoTransactionTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoTransactionTypes]
	(
	[TransactionTypeId] [INT] NOT NULL,
	[Descripcion] [VARCHAR] (128) COLLATE Modern_Spanish_CI_AI NOT NULL,
	[Description] [VARCHAR] (128) COLLATE Modern_Spanish_CI_AI NOT NULL
	)

	ALTER TABLE [dbo].[tBKGcatalogoTransactionTypes] ADD CONSTRAINT [PK_tBKGcatalogoTransactionTypes_TransactionTypeId] PRIMARY KEY CLUSTERED ([TransactionTypeId])

END
ELSE 
	-- DROP TABLE tBKGcatalogoTransactionTypes
	SELECT 'tBKGcatalogoTransactionTypes Existe'

GO

/* FILE: 00J tBKGcatalogoTransactionTypes.sql    */



GO

/* FILE: 00K tBKGcatalogoTransactionSubTypes.sql    */

-- TransactionSubTypes


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoTransactionSubTypes')
BEGIN
	CREATE TABLE tBKGcatalogoTransactionSubTypes
	(
		SubTransactionTypeId	INT PRIMARY KEY,
		Descripcion				VARCHAR(128) NOT NULL,
		Description				VARCHAR(128) NOT NULL
	) 

	SELECT 'Tabla Creada tBKGcatalogoTransactionSubTypes' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoTransactionSubTypes
	SELECT 'tBKGcatalogoTransactionSubTypes Existe'

GO

/* FILE: 00K tBKGcatalogoTransactionSubTypes.sql    */

-- Registros iniciales
IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoTransactionSubTypes t  WITH(NOLOCK) 
			WHERE t.SubTransactionTypeId IN (0,1,2,3,4,6,7,8,9,10,12,15,16,17,18,19,30,31,32,33,38,43,53,54))
BEGIN	

	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (0,'Indefinido', 'Undefined' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (1,'Transferencias cuentas propias', 'Transfer between my accounts' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (2,'Transferencias a cuentas de terceros en la instituci�n', 'Transfer to other accounts' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (3,'Transferencias a otras instituciones', 'Transfer to other institution' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (4,'Transferencias internacionales', 'Wire transfer' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (6,'Transferencias masivas dentro de la instituci�n', 'Bulk transfer' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (7,'Pago de servicios', 'Bill payment' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (8,'Pago de tarjetas de cr�dito', 'Credict card payment' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (9,'Pago de pr�stamo', 'Loan Payment' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (10,'Pago de pr�stamo de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (12,'Pago de tarjeta de cr�dito de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (15,'Transferencias masivas a cuentas de otras instituciones', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (16,'Transferencias directas LBTR o SINPE: Enviar Fondos', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (17,'Transferencias directas LBTR o SINPE: Recibir Fondos', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (18,'Pago de pr�stamos propios con cuentas de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (19,'Pago de pr�stamos de terceros con cuentas de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (30,'Adelanto en efectivo a cuentas propias', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (31,'Adelanto en efectivo a cuentas dentro de la instituci�n', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (32,'Adelanto en efectivo a cuentas LBTR o SINPE', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (33,'Transferencias masivas a cuentas LBTR o SINPE', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (38,'Transferencias con Billetera Electr�nica', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (43,'Pago de servicios con Tarjeta de cr�dito', 'Bill payment with Credit Card' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (53,'Administraci�n de tarjetas', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (54,'Administraci�n de cheques', '' )

END
go


SELECT * FROM dbo.tBKGcatalogoTransactionSubTypes
go

GO

/* FILE: 00L tBKGproductosCanTransactType.sql    */

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGproductosCanTransactType')
BEGIN
	CREATE TABLE [dbo].[tBKGproductosCanTransactType]
	(
		IdProducto 			INT NOT NULL,
		CanTransactType		INT NOT NULL, 
		IdEstatus 			INT NOT NULL
	) ON [PRIMARY]
	SELECT 'Tabla Creada tBKGproductosCanTransactType' AS info
	
	ALTER TABLE dbo.tBKGproductosCanTransactType ADD CONSTRAINT DF_tBKGproductosCanTransactType_IdEstatus DEFAULT 1 FOR IdEstatus	
	ALTER TABLE dbo.tBKGproductosCanTransactType ADD FOREIGN KEY (IdProducto) REFERENCES dbo.tAYCproductosFinancieros(IdProductoFinanciero)
	ALTER TABLE dbo.tBKGproductosCanTransactType ADD FOREIGN KEY(CanTransactType) REFERENCES dbo.tBKGcatalogoCanTransactType(CanTransactType)
END
ELSE 
	-- DROP TABLE tBKGproductosCanTransactType
	SELECT 'tBKGproductosCanTransactType Existe'

GO

/* FILE: 00L tBKGproductosCanTransactType.sql    */






GO

/* FILE: 00M tBKGtipoMovimientoMovementTypes.sql    */

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGtipoMovimientoMovementTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGtipoMovimientoMovementTypes]
	(
		IdMovementType 			INT,
		IdTipoMovimiento		INT
	) 

	ALTER TABLE dbo.tBKGtipoMovimientoMovementTypes ADD FOREIGN KEY (IdMovementType) REFERENCES dbo.tBKGcatalogoMovementTypes(Id);

	SELECT 'Tabla Creada tBKGtipoMovimientoMovementTypes' AS info
	
END
ELSE 
	-- DROP TABLE tBKGtipoMovimientoMovementTypes
	SELECT 'tBKGtipoMovimientoMovementTypes Existe'

GO

/* FILE: 00M tBKGtipoMovimientoMovementTypes.sql    */


GO

/* FILE: 00N tBKGpeticionesInsertMasiveTransaction.sql    */

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGpeticionesInsertMasiveTransaction')
BEGIN
	CREATE TABLE [dbo].[tBKGpeticionesInsertMasiveTransaction]
	(
		IdPeticion 							INT NOT NULL PRIMARY KEY IDENTITY,
		Referencia							VARCHAR(64),
		-- Identificador de la Transacci�n Padre
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

/* FILE: 00N tBKGpeticionesInsertMasiveTransaction.sql    */


GO

/* FILE: 00Ñ tBKGcatalogoDocumentType_DummyData.sql    */

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--  tBKGcatalogoDocumentType_DummyData

TRUNCATE TABLE dbo.tBKGcatalogoDocumentType
GO	

IF DB_NAME()='iERP_KFT'
begin

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 1, 'INE',-1357,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 2, 'IFE',-31,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 3, 'C�dula de Identidad',-32,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 10, 'Pasaporte',-33,1)

END

GO

/* FILE: 00Ñ tBKGcatalogoDocumentType_DummyData.sql    */

IF DB_NAME()='iERP_DRA'
BEGIN

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 101, 'INE',-1357,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 102, 'IFE',-31,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 103, 'C�DULA PROFESIONAL',-34,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 104, 'LICENCIA',-32,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 105, 'PASAPORTE',-33,1)

END

GO

/* FILE: 00Ñ tBKGcatalogoDocumentType_DummyData.sql    */


SELECT * FROM dbo.tBKGcatalogoDocumentType

--SELECT * FROM dbo.tCATlistasD ld  WITH(NOLOCK) WHERE ld.IdTipoE=173


GO

/* FILE: 00Ñ tBKGcatalogoDocumentType_DummyData.sql    */

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- select * from tBKGcatalogoProductTypes
--  tBKGcatalogoProductTypes_DummyData
-- 

TRUNCATE TABLE dbo.tBKGcatalogoProductTypes

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */

INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(0,'Undefined','Indefini',0)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(1,'CurrentAccount','Cuenta corriente',144)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(2,'SavingsAccount','Cuenta o caja de ahorros',0)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(3,'CreditCard','Tarjeta de cr�dito',0)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(4,'FixedTermDeposit','Certificado de dep�sito a plazo fijo',398)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(5,'Loan','Pr�stamo',143)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(6,'CreditLine','L�nea de cr�dito',0)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(7,'Investment','Inversi�n o fondeo',0)

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */




SELECT * FROM dbo.tBKGcatalogoProductTypes

GO

/* FILE: 00O tBKGcatalogoProductTypes_DummyData.sql    */

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- select * from tBKGcatalogoCanTransactType 
-- tBKGcatalogoCanTransactType_DummyData
 DELETE FROM dbo.tBKGcatalogoCanTransactType
 
GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */

INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (0,'NoTransactions','Solo consulta, ninguna transacci�n habilitada')

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (1,'AllTransactions','Todas las transacciones habilitadas')

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (2,'OnlyCredits','Solo cr�ditos.')

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (3,'OnlyDebits','Solo d�bitos')

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (4,'InternalNoTransactions','Interno, solo consulta')

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */

select * from tBKGcatalogoCanTransactType 

GO

/* FILE: 00P tBKGcatalogoCanTransactType_DummyData.sql    */

GO

/* FILE: 00Q tBKGproductosCanTransactType_DummyData.sql    */

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- tBKGproductosCanTransactType_DummyData
 TRUNCATE TABLE dbo.tBKGproductosCanTransactType
 
GO

/* FILE: 00Q tBKGproductosCanTransactType_DummyData.sql    */
/*
	SELECT
	'INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) ' + 
	CONCAT('VALUES (',pf.IdProductoFinanciero,',)'), pf.Descripcion, c.IdTipoDProducto
	FROM dbo.tAYCproductosFinancieros pf 
	INNER JOIN dbo.tAYCcuentas c ON c.IdProductoFinanciero = pf.IdProductoFinanciero AND c.IdEstatus=1
	GROUP BY pf.IdProductoFinanciero, pf.Descripcion,c.IdTipoDProducto
	ORDER BY c.IdTipoDProducto
*/


SELECT * FROM dbo.tBKGproductosCanTransactType

GO

/* FILE: 00Q tBKGproductosCanTransactType_DummyData.sql    */
/*
SELECT
pf.IdProductoFinanciero, pf.Descripcion, ct.CanTransactType, ct.CanTransctName, ct.Descripcion, pf.IdTipoDDominioCatalogo
FROM dbo.tAYCproductosFinancieros pf 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK)  ON c.IdProductoFinanciero = pf.IdProductoFinanciero AND c.IdEstatus=1
INNER JOIN tBKGproductosCanTransactType pct WITH(NOLOCK) ON pct.IdProducto = pf.IdProductoFinanciero
INNER JOIN tBKGcatalogoCanTransactType ct  WITH(NOLOCK) ON ct.CanTransactType = pct.CanTransactType
GROUP BY pf.IdProductoFinanciero, pf.Descripcion, ct.CanTransactType, ct.CanTransctName, ct.Descripcion, pf.IdTipoDDominioCatalogo
ORDER BY pf.IdTipoDDominioCatalogo
*/

IF DB_NAME()='iERP_KFT'
BEGIN

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (7,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (13,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (11,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (6,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (10,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (41,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (8,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (14,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (9,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (12,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (2,1)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (1,0)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (45,1)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (3,1)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (4,0)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (27,0)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (28,0)

END

IF DB_NAME()='iERP_DRA'
BEGIN

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (1,2) 
 
INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (2,2) 
 
INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (3,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (4,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (5,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (6,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (7,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (9,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (10,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (11,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (12,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (18,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (20,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (21,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (26,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (37,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (40,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (43,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (45,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (48,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (49,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (50,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (54,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (59,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (70,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (74,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (75,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (102,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (104,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (106,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (131,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (142,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (143,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (145,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (101,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (144,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (133,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (134,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (138,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (92,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (93,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (94,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (95,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (96,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (97,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (98,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (99,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (140,0) 

END

GO

/* FILE: 00Q tBKGproductosCanTransactType_DummyData.sql    */

GO

/* FILE: 00R tBKGtipoMovimientoMovementTypes_DummyData.sql    */

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- tBKGtipoMovimientoMovementTypes
 TRUNCATE TABLE dbo.tBKGtipoMovimientoMovementTypes
 
GO

/* FILE: 00R tBKGtipoMovimientoMovementTypes_DummyData.sql    */
/*
	SELECT * from tBKGtipoMovimientoMovementTypes	
*/


IF NOT EXISTS(SELECT 1 FROM tBKGtipoMovimientoMovementTypes t  WITH(NOLOCK) WHERE t.IdMovementType=0 AND t.IdTipoMovimiento=500)
	INSERT INTO tBKGtipoMovimientoMovementTypes(IdMovementType,IdTipoMovimiento) VALUES(2,500)

GO

/* FILE: 00R tBKGtipoMovimientoMovementTypes_DummyData.sql    */

IF NOT EXISTS(SELECT 1 FROM tBKGtipoMovimientoMovementTypes t  WITH(NOLOCK) WHERE t.IdMovementType=0 AND t.IdTipoMovimiento=501)
	INSERT INTO tBKGtipoMovimientoMovementTypes(IdMovementType,IdTipoMovimiento) VALUES(3,501)

GO

/* FILE: 00R tBKGtipoMovimientoMovementTypes_DummyData.sql    */

SELECT * from tBKGtipoMovimientoMovementTypes	

GO

/* FILE: 00R tBKGtipoMovimientoMovementTypes_DummyData.sql    */

GO

/* FILE: 01 pBKGgetClientsByDocument.sql    */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetClientsByDocument')
BEGIN
	DROP PROC pBKGgetClientsByDocument
	SELECT 'pBKGgetClientsByDocument BORRADO' AS info
END

GO

/* FILE: 01 pBKGgetClientsByDocument.sql    */

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON

GO

/* FILE: 01 pBKGgetClientsByDocument.sql    */

CREATE PROC pBKGgetClientsByDocument
@DocumentType INT=0,
@DocumentId VARCHAR(24)='',
@Name AS VARCHAR(32)='',
@LastName AS VARCHAR(64)='',
@Mail AS VARCHAR(128)='',
@CellPhone AS VARCHAR(10)='',
@NoSocio AS VARCHAR(32)=''
AS
BEGIN

/*
	DECLARE @emails AS TABLE
	(
		IdRel INT,
		IdMail INT,
		IdListaD INT,
		Tipo VARCHAR(24),
		Email VARCHAR(128)
	)

	INSERT INTO @emails (IdRel, IdMail, IdListaD, Tipo, Email)
	SELECT m.IdRel, m.IdEmail, ld.IdListaD, ld.Descripcion, m.email 
	FROM dbo.tCATemails m  WITH(NOLOCK) 
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = m.IdListaD
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = m.IdEstatusActual AND ea.IdEstatus=1
	WHERE m.email=@mail

	DECLARE @telefonos AS TABLE
	(
		IdRel	INT, 
		IdTelefono	INT,
		IdListaD	INT,
		Tipo		VARCHAR(24),
		Telefono	VARCHAR(10)
	)

	INSERT INTO @telefonos (IdRel,IdTelefono,IdListaD,Tipo,Telefono)
	SELECT t.IdRel, t.IdTelefono, t.IdListaD, ld.Descripcion, t.Telefono
	FROM dbo.tCATtelefonos t  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = t.IdListaD
	WHERE t.IdListaD=-1339 AND t.Telefono = @cellPhone

	DECLARE @nombreBuscado AS VARCHAR(64)= CONCAT(@name, ' ', @lastName);
*/	

	SELECT 
	ClientBankIdentifier			= sc.Codigo,
	ClientName						= p.Nombre,
	ClientType						= 1,
	DocumentType					= @DocumentType,
	DocumentId						= @DocumentId
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonasFisicas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	AND p.IFE=@DocumentId
	INNER JOIN dbo.tBKGcatalogoDocumentType dt  WITH(NOLOCK) ON dt.IdListaDidentificacion=p.IdTipoDidentificacion 
	AND dt.IdDocumentType=@DocumentType
	AND sc.Codigo=@NoSocio

	

END


GO
GO

/* FILE: 01.0 pBKGparseOrderBy.sql    */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGparseOrderBy')
BEGIN
	DROP PROC pBKGparseOrderBy
	SELECT 'pBKGparseOrderBy BORRADO' AS info
END

GO

/* FILE: 01.0 pBKGparseOrderBy.sql    */

CREATE PROC pBKGparseOrderBy
@pOrderByField AS VARCHAR(128),
@pCampoOrden VARCHAR(128) OUTPUT,
@pTipoOrden VARCHAR(128) OUTPUT
AS
BEGIN

	DECLARE @camposOrden TABLE(
		Id		INT PRIMARY KEY IDENTITY,
		Valor	NVARCHAR(max)
	)

	if EXISTS(SELECT 1 FROM STRING_SPLIT(@pOrderByField,' ') HAVING COUNT(1)>1)
	BEGIN
		INSERT INTO @camposOrden (Valor)
		SELECT value FROM STRING_SPLIT(@pOrderByField,' ')

		SELECT @pcampoOrden=Valor FROM @camposOrden where Id=1
		SELECT @ptipoOrden=Valor FROM @camposOrden WHERE Id=2
	END

	--SELECT @campoOrden
	--SELECT @tipoOrden 
END

GO

/* FILE: 01.0 pBKGparseOrderBy.sql    */


GO

/* FILE: 01.1 pBKGTransferenciaCuentasPropiasAhorro.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGTransferenciaCuentasPropiasAhorro')
BEGIN
	DROP PROC pBKGTransferenciaCuentasPropiasAhorro
	SELECT 'pBKGTransferenciaCuentasPropiasAhorro BORRADO' AS info
END

GO

/* FILE: 01.1 pBKGTransferenciaCuentasPropiasAhorro.sql    */

CREATE PROCEDURE dbo.pBKGTransferenciaCuentasPropiasAhorro
@IdOperacion INT = 0 OUTPUT,
@Folio INT = 0 OUTPUT,
@Fecha DATE = '19000101', --ValueDate
@Monto NUMERIC (23,2) = 0, --Amount
@MontoComision NUMERIC(23,2) = 0, --TransactionCost
@IdCuentaRetiro INT = 0, --DebitProductBankIdentifier
@IdCuentaDeposito  INT = 0, --CreditProductBankIdentifier
@Concepto VARCHAR(80),--Description
@IdOperacionPadre INT = 0,
@AfectaSaldo BIT = 0
AS 
BEGIN

	DECLARE @IdSocioOperacion INT = 0;
	
	SELECT @IdSocioOperacion = IdSocio FROM dbo.tAYCcuentas WHERE IdCuenta = @IdCuentaRetiro
	
	EXECUTE dbo.pGRLgenerarOperacionPadre @IdTipoOperacion =  1021,               -- int
	                                  @IdOperacion = @IdOperacion OUTPUT, -- int
	                                  @IdOperacionPadre = @IdOperacionPadre,              -- int 
	                                  @FechaTrabajo = @Fecha,      -- date 
	                                  @Serie = '',                        -- varchar(10)
	                                  @IdSucursal = 1,                    -- int		
	                                  @IdSesion = 0,     -- int  
	                                  @Folio = @Folio OUTPUT,             -- int	
	                                  @Concepto = @Concepto,     -- varchar(80) 
	                                  @Referencia = 'Operaci�n Bankingly',     -- varchar(30)
	                                  @IdPersona = 0,                     -- int
	                                  @IdRecurso = 0,                     -- int
	                                  @IdSocio = @IdSocioOperacion        -- int
	
	DECLARE @IdTransaccionFinanciera INT;
	EXECUTE dbo.pSDOgenerarTransaccionFinancieraDepositoAcreedora @IdCuenta = @IdCuentaDeposito,          -- int
	                                                              @IdOperacion = @IdOperacion,                                          -- int
	                                                              @GeneraTransaccion = 1,         -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR TRANSACCION
	                                                              @ConsultarTransaccion = 0,                              -- bit
	                                                              @Monto = @Monto,                                             -- numeric(18, 2)
	                                                              @Concepto = @Concepto,                                            -- varchar(80)
	                                                              @Referencia = 'Operaci�n Bankingly',             -- varchar(30)
	                                                              @IdTransaccionFinanciera = @IdTransaccionFinanciera OUTPUT -- int
	
	

	EXECUTE dbo.pSDOgenerarTransaccionFinancieraRetiroAcreedora @IdCuenta = @IdCuentaRetiro,                -- int
	                                                            @IdOperacion = @IdOperacion,             -- int
	                                                            @GeneraTransaccion = 1,    -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR LA TRANSACCION
	                                                            @ConsultarTransaccion = 0, -- bit
	                                                            @Monto = @Monto,                -- numeric(18, 2)
	                                                            @Concepto = @Concepto,               -- varchar(80)
	                                                            @Referencia = 'Operaci�n Bankingly'              -- varchar(30)

	IF(@AfectaSaldo = 1)
	BEGIN	
		EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @TipoOperacion = '', -- varchar(10)
	                                                          @IdOperacion = @IdOperacion,    -- int
	                                                          @Factor = 1       -- decimal(23, 8)
	
		EXEC dbo.pIMPgenerarTransaccionesImpuestos @IdOperacionPadre = @IdOperacion; -- int
	END


END 

GO

/* FILE: 01.1 pBKGTransferenciaCuentasPropiasAhorro.sql    */


GO

/* FILE: 01.2 pBKGTransferenciaCuentasTerceroAhorro.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGTransferenciaCuentasTerceroAhorro')
BEGIN
	DROP PROC pBKGTransferenciaCuentasTerceroAhorro
	SELECT 'pBKGTransferenciaCuentasTerceroAhorro BORRADO' AS info
END

GO

/* FILE: 01.2 pBKGTransferenciaCuentasTerceroAhorro.sql    */

CREATE PROCEDURE dbo.pBKGTransferenciaCuentasTerceroAhorro
@IdOperacion INT = 0 OUTPUT,
@Folio INT = 0 OUTPUT,
@Fecha DATE = '19000101', --ValueDate
@Monto NUMERIC (23,2) = 0, --Amount
@MontoComision NUMERIC(23,2) = 0, --TransactionCost
@IdCuentaRetiro INT = 0, --DebitProductBankIdentifier
@IdCuentaDeposito  INT = 0, --CreditProductBankIdentifier
@Concepto VARCHAR(80),--Description
@IdOperacionPadre INT = 0,
@AfectaSaldo BIT = 0 --Description
AS 
BEGIN

	
	EXECUTE dbo.pGRLgenerarOperacionPadre @IdTipoOperacion =  1021,               -- int
	                                  @IdOperacion = @IdOperacion OUTPUT, -- int
	                                  @IdOperacionPadre = @IdOperacionPadre,              -- int 
	                                  @FechaTrabajo = @Fecha,      -- date 
	                                  @Serie = '',                        -- varchar(10)
	                                  @IdSucursal = 1,                    -- int		
	                                  @IdSesion = 0,     -- int  
	                                  @Folio = @Folio OUTPUT,             -- int	
	                                  @Concepto = @Concepto,     -- varchar(80) 
	                                  @Referencia = 'Operaci�n Bankingly',     -- varchar(30)
	                                  @IdPersona = 0,                     -- int
	                                  @IdRecurso = 0,                     -- int
	                                  @IdSocio = 0        -- int
	
	DECLARE @IdTransaccionFinanciera INT;
	EXECUTE dbo.pSDOgenerarTransaccionFinancieraDepositoAcreedora @IdCuenta = @IdCuentaDeposito,          -- int
	                                                              @IdOperacion = @IdOperacion,                                          -- int
	                                                              @GeneraTransaccion = 1,         -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR TRANSACCION
	                                                              @ConsultarTransaccion = 0,                              -- bit
	                                                              @Monto = @Monto,                                             -- numeric(18, 2)
	                                                              @Concepto = @Concepto,                                            -- varchar(80)
	                                                              @Referencia = 'Operaci�n Bankingly',             -- varchar(30)
	                                                              @IdTransaccionFinanciera = @IdTransaccionFinanciera OUTPUT -- int
	
	

	EXECUTE dbo.pSDOgenerarTransaccionFinancieraRetiroAcreedora @IdCuenta = @IdCuentaRetiro,                -- int
	                                                            @IdOperacion = @IdOperacion,             -- int
	                                                            @GeneraTransaccion = 1,    -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR LA TRANSACCION
	                                                            @ConsultarTransaccion = 0, -- bit
	                                                            @Monto = @Monto,                -- numeric(18, 2)
	                                                            @Concepto = @Concepto,               -- varchar(80)
	                                                            @Referencia = 'Operaci�n Bankingly'              -- varchar(30)

	IF(@AfectaSaldo = 1)
	BEGIN	
		EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @TipoOperacion = '', -- varchar(10)
	                                                          @IdOperacion = @IdOperacion,    -- int
	                                                          @Factor = 1       -- decimal(23, 8)
	
		EXEC dbo.pIMPgenerarTransaccionesImpuestos @IdOperacionPadre = @IdOperacion; -- int
	END


END 

GO

/* FILE: 01.2 pBKGTransferenciaCuentasTerceroAhorro.sql    */


GO

/* FILE: 01.3 pBKGTransferenciaPagoCredito.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGTransferenciaPagoCredito')
BEGIN
	DROP PROC pBKGTransferenciaPagoCredito
	SELECT 'pBKGTransferenciaPagoCredito BORRADO' AS info
END

GO

/* FILE: 01.3 pBKGTransferenciaPagoCredito.sql    */

CREATE PROCEDURE dbo.pBKGTransferenciaPagoCredito
@IdOperacion INT = 0 OUTPUT,
@Folio INT = 0 OUTPUT,
@Fecha DATE = '19000101', --ValueDate
@Monto NUMERIC (23,2) = 0, --Amount
@MontoComision NUMERIC(23,2) = 0, --TransactionCost
@IdCuentaRetiro INT = 0, --DebitProductBankIdentifier
@IdCuentaDeposito  INT = 0, --CreditProductBankIdentifier
@Concepto VARCHAR(80),--Description
@IdOperacionPadre INT = 0,
@AfectaSaldo BIT = 0 --Description
AS 
BEGIN

	
	EXECUTE dbo.pGRLgenerarOperacionPadre @IdTipoOperacion =  1021,               -- int
	                                  @IdOperacion = @IdOperacion OUTPUT, -- int
	                                  @IdOperacionPadre = @IdOperacionPadre,              -- int 
	                                  @FechaTrabajo = @Fecha,      -- date 
	                                  @Serie = '',                        -- varchar(10)
	                                  @IdSucursal = 1,                    -- int		
	                                  @IdSesion = 0,     -- int  
	                                  @Folio = @Folio OUTPUT,             -- int	
	                                  @Concepto = @Concepto,     -- varchar(80) 
	                                  @Referencia = 'Operaci�n Bankingly',     -- varchar(30)
	                                  @IdPersona = 0,                     -- int
	                                  @IdRecurso = 0,                     -- int
	                                  @IdSocio = 0        -- int
	


	EXECUTE dbo.pSDOgenerarTransaccionFinancieraRetiroAcreedora @IdCuenta = @IdCuentaRetiro,                -- int
	                                                            @IdOperacion = @IdOperacion,             -- int
	                                                            @GeneraTransaccion = 1,    -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR LA TRANSACCION
	                                                            @ConsultarTransaccion = 0, -- bit
	                                                            @Monto = @Monto,                -- numeric(18, 2)
	                                                            @Concepto = @Concepto,               -- varchar(80)
	                                                            @Referencia = 'Operaci�n Bankingly'              -- varchar(30)


	EXEC dbo.pAYCaplicacionPagoCredito @IdCuenta = @IdCuentaDeposito,                      -- int
	                                   @IdSocio = 0,                       -- int
	                                   @FechaTrabajo = @Fecha,       -- date
	                                   @Decimales = 2,                     -- int
	                                   @CodigoOperacion = 'DevPAg',              -- varchar(20)
	                                   @MontoAplicacion = @Monto,            -- numeric(18, 2)
	                                   @GenerarMovimiento = 1,          -- bit
	                                   @GenerarOperacion = 0,           -- bit
	                                   @IdOperacion = @IdOperacion, -- int
	                                   @IdTipoOperacion = 500,               -- int
	                                   @Concepto = @Concepto,                     -- varchar(80)
	                                   @Referencia = 'Operaci�n Bankingly',                   -- varchar(30)
	                                   @IdSesion = 0,                      -- int
	                                   @ConsultarFinancierasD = 0
	 
        --Afectacion de saldos
	IF(@AfectaSaldo = 1)
	BEGIN
		EXEC dbo.pAYCactualizarSaldoParcialidades @IdOperacion = @IdOperacion; -- int

		EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @TipoOperacion = '', -- varchar(10)
																  @IdOperacion = @IdOperacion,    -- int
																  @Factor = 1       -- decimal(23, 8)

		EXEC dbo.pAYCactualizarPrimerVencimientoPendiente @IdOperacion = @IdOperacion; -- int


		EXEC dbo.pCTLvalidarAplicacionPlanPagosSaldo @TipoOperacion = 'PROVCART', -- varchar(20)
													 @IdCuenta = 0,               -- int
													 @IdOperacion = @IdOperacion; -- int
    END
	

	IF @IdOperacion!=0 
	BEGIN
		DECLARE @SaldoCredito AS NUMERIC(23,2)=(SELECT Capital+IIF(c.IdEstatusCartera=28,f.InteresOrdinario+f.InteresMoratorio,0) FROM dbo.fAYCsaldo(@IdCuentaDeposito) f INNER JOIN dbo.tAYCcuentas c WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta WHERE c.IdCuenta=@IdCuentaDeposito);
		EXEC dbo.pAYCDesbloqueoGarantiaCredito @IdCuentaCredito = @IdCuentaDeposito, -- int
		                                       @SaldoCuenta = @SaldoCredito,  -- numeric(23, 2)
		                                       @AfectaSaldo = 0,  -- bit
		                                       @IdOperacion = @IdOperacion      -- int
		

	END

    EXEC dbo.pIMPgenerarTransaccionesImpuestos @IdOperacionPadre = @IdOperacion; -- int


END 

GO

/* FILE: 01.3 pBKGTransferenciaPagoCredito.sql    */


GO

/* FILE: 01.4 pBKGTransferenciaPagoCredito.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGTransferenciaPagoCredito')
BEGIN
	DROP PROC pBKGTransferenciaPagoCredito
	SELECT 'pBKGTransferenciaPagoCredito BORRADO' AS info
END

GO

/* FILE: 01.4 pBKGTransferenciaPagoCredito.sql    */

CREATE PROCEDURE dbo.pBKGTransferenciaPagoCredito
@IdOperacion INT = 0 OUTPUT,
@Folio INT = 0 OUTPUT,
@Fecha DATE = '19000101', --ValueDate
@Monto NUMERIC (23,2) = 0, --Amount
@MontoComision NUMERIC(23,2) = 0, --TransactionCost
@IdCuentaRetiro INT = 0, --DebitProductBankIdentifier
@IdCuentaDeposito  INT = 0, --CreditProductBankIdentifier
@Concepto VARCHAR(80),--Description
@IdOperacionPadre INT = 0,
@AfectaSaldo BIT = 0 --Description
AS 
BEGIN

	
	EXECUTE dbo.pGRLgenerarOperacionPadre @IdTipoOperacion =  1021,               -- int
	                                  @IdOperacion = @IdOperacion OUTPUT, -- int
	                                  @IdOperacionPadre = @IdOperacionPadre,              -- int 
	                                  @FechaTrabajo = @Fecha,      -- date 
	                                  @Serie = '',                        -- varchar(10)
	                                  @IdSucursal = 1,                    -- int		
	                                  @IdSesion = 0,     -- int  
	                                  @Folio = @Folio OUTPUT,             -- int	
	                                  @Concepto = @Concepto,     -- varchar(80) 
	                                  @Referencia = 'Operaci�n Bankingly',     -- varchar(30)
	                                  @IdPersona = 0,                     -- int
	                                  @IdRecurso = 0,                     -- int
	                                  @IdSocio = 0        -- int
	


	EXECUTE dbo.pSDOgenerarTransaccionFinancieraRetiroAcreedora @IdCuenta = @IdCuentaRetiro,                -- int
	                                                            @IdOperacion = @IdOperacion,             -- int
	                                                            @GeneraTransaccion = 1,    -- bit SE PONE EN UNO PORQUE VAMOS A GENERAR LA TRANSACCION
	                                                            @ConsultarTransaccion = 0, -- bit
	                                                            @Monto = @Monto,                -- numeric(18, 2)
	                                                            @Concepto = @Concepto,               -- varchar(80)
	                                                            @Referencia = 'Operaci�n Bankingly'              -- varchar(30)


	EXEC dbo.pAYCaplicacionPagoCredito @IdCuenta = @IdCuentaDeposito,                      -- int
	                                   @IdSocio = 0,                       -- int
	                                   @FechaTrabajo = @Fecha,       -- date
	                                   @Decimales = 2,                     -- int
	                                   @CodigoOperacion = 'DevPAg',              -- varchar(20)
	                                   @MontoAplicacion = @Monto,            -- numeric(18, 2)
	                                   @GenerarMovimiento = 1,          -- bit
	                                   @GenerarOperacion = 0,           -- bit
	                                   @IdOperacion = @IdOperacion, -- int
	                                   @IdTipoOperacion = 500,               -- int
	                                   @Concepto = @Concepto,                     -- varchar(80)
	                                   @Referencia = 'Operaci�n Bankingly',                   -- varchar(30)
	                                   @IdSesion = 0,                      -- int
	                                   @ConsultarFinancierasD = 0
	 
        --Afectacion de saldos
	IF(@AfectaSaldo = 1)
	BEGIN
		EXEC dbo.pAYCactualizarSaldoParcialidades @IdOperacion = @IdOperacion; -- int

		EXEC dbo.pSDOafectaSaldoTransaccionesFinancierasOperacion @TipoOperacion = '', -- varchar(10)
																  @IdOperacion = @IdOperacion,    -- int
																  @Factor = 1       -- decimal(23, 8)

		EXEC dbo.pAYCactualizarPrimerVencimientoPendiente @IdOperacion = @IdOperacion; -- int


		EXEC dbo.pCTLvalidarAplicacionPlanPagosSaldo @TipoOperacion = 'PROVCART', -- varchar(20)
													 @IdCuenta = 0,               -- int
													 @IdOperacion = @IdOperacion; -- int
    END
	

	IF @IdOperacion!=0 
	BEGIN
		DECLARE @SaldoCredito AS NUMERIC(23,2)=(SELECT Capital+IIF(c.IdEstatusCartera=28,f.InteresOrdinario+f.InteresMoratorio,0) FROM dbo.fAYCsaldo(@IdCuentaDeposito) f INNER JOIN dbo.tAYCcuentas c WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta WHERE c.IdCuenta=@IdCuentaDeposito);
		EXEC dbo.pAYCDesbloqueoGarantiaCredito @IdCuentaCredito = @IdCuentaDeposito, -- int
		                                       @SaldoCuenta = @SaldoCredito,  -- numeric(23, 2)
		                                       @AfectaSaldo = 0,  -- bit
		                                       @IdOperacion = @IdOperacion      -- int
		

	END

    EXEC dbo.pIMPgenerarTransaccionesImpuestos @IdOperacionPadre = @IdOperacion; -- int


END 

GO

/* FILE: 01.4 pBKGTransferenciaPagoCredito.sql    */


GO

/* FILE: 01.5 pBKGValidacionesCuentas.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGValidacionesCuentas')
BEGIN
	DROP PROC pBKGValidacionesCuentas
	SELECT 'pBKGValidacionesCuentas BORRADO' AS info
END

GO

/* FILE: 01.5 pBKGValidacionesCuentas.sql    */

CREATE PROCEDURE dbo.pBKGValidacionesCuentas
@TipoOperacion INT = 0,
@IsError bit = 0 OUTPUT,
@BackendMessage VARCHAR(1024) = '' OUTPUT,
@BackendReference VARCHAR(1024) = '' OUTPUT,
@BackendCode VARCHAR(10) = '' OUTPUT,
@IdCuentaDeposito INT = 0 OUTPUT,
@IdCuentaRetiro INT = 0 OUTPUT,
@DebitProductBankIdentifier VARCHAR(50) = '',
@CreditProductBankIdentifier VARCHAR(50) = '',
@Amount DECIMAL(23,8) = 0,
@ValueDate DATE = '19000101'
AS 
BEGIN

	DECLARE @IdSocioDeposito INT = 0,
			@IdSocioRetiro INT = 0,
			@SaldoMinimo DECIMAL(23,8) = 0,
			@IdTipoDproductoRetiro INT = 0,
			@SaldoDisponible INT = 0,
			@IdEstatusRetiro INT = 0,
			@IdEstatusDeposito INT = 0,
			@IdEstatusSocioRetiro INT = 0,
			@IdEstatusSocioDeposito INT = 0;

	SET @IsError = 0;

	SELECT @IdSocioRetiro = c.IdSocio,@IdCuentaRetiro = c.IdCuenta,@SaldoMinimo = pff.SaldoMinimo,@IdTipoDproductoRetiro = c.IdTipoDProducto,@SaldoDisponible = fs.MontoDisponible - pff.SaldoMinimo,
	@IdEstatusRetiro = c.IdEstatus,@IdEstatusSocioRetiro = s.IdEstatus FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN  dbo.tAYCproductosFinancieros pff  WITH(NOLOCK)  ON pff.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK)  ON s.IdSocio = c.IdSocio
	INNER JOIN dbo.fAYCsaldo(0) fs ON fs.IdCuenta = c.IdCuenta
	WHERE c.Codigo = @DebitProductBankIdentifier
	
	SELECT @IdSocioDeposito = c.IdSocio,@IdCuentaDeposito = c.IdCuenta,@IdEstatusDeposito = c.IdEstatus,@IdEstatusSocioDeposito = s.IdEstatus FROM dbo.tAYCcuentas c  WITH(NOLOCK)
	INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdSocio = c.IdSocio 
	WHERE c.Codigo = @CreditProductBankIdentifier

	IF(@TipoOperacion NOT IN (1,2,6,7,9,10))
	BEGIN	
		SET @IsError = 1;
		SET @BackendMessage = 'Operaci�n no soportada';
		SET @BackendReference = 'Operaci�n no admitida';
		SET @BackendCode = '0098';
		RETURN;
	END 

	IF(@IdTipoDproductoRetiro = 143) --Validacion de retiro a productos de credito
	BEGIN
		SET @IsError = 1;
		SET @BackendMessage = CONCAT('La cuenta ',@DebitProductBankIdentifier,' no admite operaciones de retiro');
		SET @BackendReference = 'Operaci�n no admitida';
		SET @BackendCode = '1';
		RETURN;
	END 

	IF(@SaldoDisponible < @Amount) --Validacion de saldo a cuenta de retiro
	BEGIN		
		SET @IsError = 1;
		SET @BackendMessage = 'No cuenta con saldo suficiente para realizar la operaci�n';
		SET @BackendReference = 'Saldo insuficiente';
		SET @BackendCode = '2';
		RETURN;
	END 

	IF(@IdEstatusRetiro <> 1) --Validacion del estatus a cuenta de retiro
	BEGIN	
		SET @IsError = 1;
		SET @BackendMessage = 'La cuenta de retiro no se encuentra Activa';
		SET @BackendReference = 'Estatus de la cuenta incorrecto';
		SET @BackendCode = '3';
		RETURN;
	END

	IF(@IdEstatusDeposito <> 1) --Validacion del estatus a cuenta de deposito
	BEGIN	
		SET @IsError = 1;
		SET @BackendMessage = CONCAT('La cuenta de deposito no se encuentra Activa ',@IdEstatusDeposito);
		SET @BackendReference = 'Estatus de la cuenta incorrecto';
		SET @BackendCode = '4';
		RETURN;
	END

	IF(@TipoOperacion = 1) -- 1	Transferencias cuentas propias
	BEGIN
		IF(@IdSocioRetiro <> @IdSocioDeposito)
		BEGIN
			SET @IsError = 1;
			SET @BackendMessage = 'Las cuentas no pertenecen al mismo socio';
			SET @BackendReference = 'Tipo de operacion incorrecta';
			SET @BackendCode = '5';
			RETURN;
        END
	END
END

GO

/* FILE: 01.5 pBKGValidacionesCuentas.sql    */


GO

/* FILE: 01.6 fnBKGobtenerBeneficiarioMayorPorcentaje.sql    */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnBKGobtenerBeneficiarioMayorPorcentaje')
BEGIN
	DROP FUNCTION fnBKGobtenerBeneficiarioMayorPorcentaje
	SELECT 'fnBKGobtenerBeneficiarioMayorPorcentaje BORRADO' AS info
END

GO

/* FILE: 01.6 fnBKGobtenerBeneficiarioMayorPorcentaje.sql    */

CREATE FUNCTION dbo.fnBKGobtenerBeneficiarioMayorPorcentaje(
@IdCuenta AS INT
)
RETURNS VARCHAR(128)
AS
BEGIN
/* INFO (⊙_☉) 
Solo usar cuando se esta filtrando una sola cuenta en la consulta llamante
NO SE USE PARA CONSULTAS QUE DEVUELVEN MÁS DE UNA CUENTA
*/
	DECLARE @Beneficiario AS VARCHAR(128)=''

		SELECT TOP 1 
		 @Beneficiario = p.nombre
		FROM tayccuentas c  WITH(NOLOCK) 
		INNER JOIN tAYCreferenciasAsignadas ref  WITH(NOLOCK) 
			ON ref.relreferenciasAsignadas=c.relreferenciasAsignadas
				AND ref.idestatus=1
		INNER JOIN dbo.tSCSpersonasFisicasReferencias pr  WITH(NOLOCK) 
			ON pr.IdReferenciaPersonal = ref.IdReferenciaPersonal
		INNER JOIN tgrlpersonas p  WITH(NOLOCK) 
			ON p.idpersona=pr.IdPersona
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = c.IdSocio
		WHERE c.IdCuenta=@IdCuenta

		RETURN @Beneficiario
END
GO	




GO

/* FILE: 02 pBKGgetProducts.sql    */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProducts')
BEGIN
	DROP PROC pBKGgetProducts
	SELECT 'pBKGgetProducts BORRADO' AS info
END

GO

/* FILE: 02 pBKGgetProducts.sql    */

CREATE PROC pBKGgetProducts
@ClientBankIdentifiers AS VARCHAR(24),
@ProductTypes AS VARCHAR(7)=''
AS
BEGIN
	
	
SELECT 
	ClientBankIdentifier			= sc.Codigo, 
	ProductBankIdentifier			= c.Codigo,
	ProductNumber					= c.Codigo,
	ProductStatusId					= c.IdEstatus,
	ProductTypeId					= pt.ProductTypeId,
	ProductAlias					= pf.Descripcion,
	CanTransact						= t.CanTransactType,
	CurrencyId						= '484'
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdEstatus=1 and sc.Codigo= @ClientBankIdentifiers
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = pf.IdProductoFinanciero
	WHERE c.IdEstatus=1 AND c.IdSocio=sc.idSocio
	order by ProductTypeId 
END

GO

/* FILE: 02 pBKGgetProducts.sql    */


GO

/* FILE: 04 pBKGgetProductsConsolidatedPosition.sql    */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductsConsolidatedPosition')
BEGIN
	DROP PROC pBKGgetProductsConsolidatedPosition
	SELECT 'pBKGgetProductsConsolidatedPosition BORRADO' AS info
END

GO

/* FILE: 04 pBKGgetProductsConsolidatedPosition.sql    */

CREATE PROC pBKGgetProductsConsolidatedPosition
@ClientBankIdentifiers AS VARCHAR(24),
@ProductTypes AS VARCHAR(7)=''
AS
BEGIN

	

	DECLARE @cuentas AS TABLE
	(
		IdSocio					INT,
		NoSocio					VARCHAR(24),
		Nombre					VARCHAR(250),
		ProductoDescripcion		VARCHAR(80),
		IdCuenta				INT,
		NoCuenta				VARCHAR(30),
		Tasa					NUMERIC(8,5),
		Vencimiento				DATE,
		NumeroParcialidades		INT,
		IdTipoDProducto			INT,
		IdProductoFinanciero	INT,
		IdSucursal				INT,
		IdApertura				INT,
		SaldoCapital			NUMERIC(18,2),
		SaldoDisponible			NUMERIC(18,2)
	)

	INSERT INTO @cuentas (IdSocio,NoSocio,Nombre,ProductoDescripcion,IdCuenta,NoCuenta,Tasa,Vencimiento,NumeroParcialidades,IdTipoDProducto,IdProductoFinanciero,IdSucursal,IdApertura,SaldoCapital,SaldoDisponible)
	SELECT sc.IdSocio,sc.Codigo,p.Nombre,pf.Descripcion,c.IdCuenta,c.Codigo,c.InteresOrdinarioAnual,c.Vencimiento,c.NumeroParcialidades,c.IdTipoDProducto,pf.IdProductoFinanciero,c.IdSucursal,c.IdApertura, c.SaldoCapital
	,fs.MontoDisponible
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio 
												AND sc.IdEstatus=1 
												AND sc.Codigo= @ClientBankIdentifiers
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.fAYCsaldo(0) fs ON fs.IdCuenta = c.IdCuenta
	WHERE c.IdEstatus=1

	DECLARE @parcialidades AS TABLE
	(
		IdParcialidad				INT,
		NumeroParcialidad			INT,
		DiasCalculados				INT,
		Inicio						DATE,
		Vencimiento					DATE,
		IdPeriodo					INT,
		IdCuenta					INT,
		EstaPagada					BIT,
		Fin							DATE,
		IdApertura					INT,
		IdEstatus					INT,
		FechaPago					DATE,
		EsPeriodoGracia				INT,
		EsPeriodoGraciaCapital		BIT
	)

	INSERT INTO @parcialidades
	(
	    IdParcialidad,
	    NumeroParcialidad,
	    DiasCalculados,
	    Inicio,
	    Vencimiento,
	    IdPeriodo,
	    IdCuenta,
	    EstaPagada,
	    Fin,
	    IdApertura,
	    IdEstatus,
	    FechaPago,
	    EsPeriodoGracia,
	    EsPeriodoGraciaCapital
	)
	SELECT p.IdParcialidad,
		   p.NumeroParcialidad,
		   p.DiasCalculados,
		   p.Inicio,
		   p.Vencimiento,
		   p.IdPeriodo,
		   p.IdCuenta,
		   p.EstaPagada,
		   p.Fin,
		   p.IdApertura,
		   p.IdEstatus,
		   p.FechaPago,
		   p.EsPeriodoGracia,
		   p.EsPeriodoGraciaCapital
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	INNER JOIN @cuentas c ON c.IdCuenta = p.IdCuenta
	AND c.IdApertura = p.IdApertura
	AND c.IdTipoDProducto=143
	WHERE p.IdEstatus=1 

	DECLARE @fechaCartera AS DATE=(SELECT MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(NOLOCK)
									INNER JOIN @cuentas c ON c.IdCuenta = cartera.IdCuenta)

	SELECT 
	ClientBankIdentifier				= c.NoSocio,
	ProductBankIdentifier				= c.NoCuenta,
	ProductTypeId						= pt.ProductTypeId,
	ProductAlias						= c.ProductoDescripcion,
	ProductNumber						= c.NoCuenta,
	LocalCurrencyId						= '484',
	LocalBalance						= CASE
											WHEN c.IdTipoDProducto=143
											THEN Capital + InteresOrdinario + InteresMoratorioVigente + InteresMoratorioVencido + InteresMoratorioCuentasOrden + IVAInteresOrdinario + IVAinteresMoratorio + Cargos + CargosImpuestos
											ELSE c.SaldoDisponible
											END ,
	InternationalCurrencyId				= '840',
	InternationalBalance				= CASE
											WHEN c.IdTipoDProducto=143
											THEN Capital + InteresOrdinario + InteresMoratorioVigente + InteresMoratorioVencido + InteresMoratorioCuentasOrden + IVAInteresOrdinario + IVAinteresMoratorio + Cargos + CargosImpuestos
											ELSE c.SaldoDisponible
											END ,
	Rate								= c.Tasa,
	ExpirationDate						= c.Vencimiento,
	PaidFees							= pagadas.ppagadas,
	Term								= c.NumeroParcialidades,
	NextFeeDueDate						= cartera.ProximoVencimiento,
	ProductOwnerName					= c.Nombre,
	ProductBranchName					= suc.Descripcion,
	CanTransact							= t.CanTransactType,
	SubsidiaryId						= '1', -- suc.Codigo,
	SubsidiaryName						= suc.Descripcion,
	BackendId							= c.IdCuenta
	FROM @cuentas c
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = c.IdProductoFinanciero
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
	LEFT JOIN dbo.tAYCcartera cartera  WITH(NOLOCK) ON cartera.IdCuenta = c.IdCuenta
	AND cartera.FechaCartera=@fechaCartera
	LEFT JOIN (
				SELECT IdCuenta, IdApertura, COUNT(1) ppagadas FROM @parcialidades 
				WHERE EstaPagada=1
				GROUP BY IdApertura, IdCuenta
				) pagadas ON pagadas.IdApertura = c.IdApertura AND pagadas.IdCuenta = c.IdCuenta
				

END

GO

/* FILE: 04 pBKGgetProductsConsolidatedPosition.sql    */


GO

/* FILE: 08 pBKGgetAccountDetails.sql    */

-- [8] Cuentas - GetAccountDetails


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetAccountDetails')
BEGIN
	DROP PROC pBKGgetAccountDetails
	SELECT 'pBKGgetAccountDetails BORRADO' AS info
END

GO

/* FILE: 08 pBKGgetAccountDetails.sql    */

CREATE PROC pBKGgetAccountDetails
@ProductBankIdentifier AS VARCHAR(32)
AS
BEGIN	

--#region  
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= 
--  DEFINICIONES
AccountBankIdentifier						string	Identificador de la cuenta
AccountOfficerName							String	Nombre del oficial de cuenta
AccountCountableBalance						Decimal	Saldo o balance contable de la cuenta
AccountAvailableBalance						Decimal	Saldo o balance disponible de la cuenta
AccountBalance24Hrs							Decimal	Saldo o balance hace 24 hs
AccountBalance48Hrs							Decimal	Saldo o balance hace 48 hs
AccountBalance48MoreHrs						Decimal	Saldo o balance hace m�s de 48 hs
MonthlyAverageBalance						Decimal	Saldo o balance promedio mensual
PendingChecks								Int		Cheques pendientes de acreditaci�n/d�bito de la cuenta
ChecksToReleaseToday						Int		Cheques a liberar en el d�a
ChecksToReleaseTomorrow						Int		Cheques a liberar en el d�a siguiente
CancelledChecks								Int		Cheques cancelados
CertifiedChecks								Int		Cheques certificados
RejectedChecks								Int		Cheques rechazados
BlockedAmount								Decimal	Monto bloqueado de uso
MovementsOfTheMonth							Int		Cantidad de movimientos del mes.
ChecksDrawn									Int		Cheques firmados
Overdrafts									Decimal	Sobregiro de la cuenta
ProductBranchName							string	Nombre de la sucursal de la cuenta
ProductOwnerName							string	Nombre del responsable de la cuenta
ShowCurrentAccountChecksInformation			bool	Despliega la informaci�n de cheques para las cuentas corrientes
*/
--#endregion

DECLARE @fechaActual AS DATE=GETDATE();
DECLARE @fechaHoy AS DATE=DATEADD(DAY,-1,@fechaActual);
DECLARE @fecha24antes AS DATE=DATEADD(DAY,-2,@fechaActual);
DECLARE @fecha48antes AS DATE=DATEADD(DAY,-3,@fechaActual);
DECLARE @fecha48mas AS DATE=DATEADD(DAY,-4,@fechaActual);
DECLARE @FechaInicioMes AS DATE= DATEADD(month, DATEDIFF(month, 0, @fechaActual), 0)

DECLARE @cuenta AS TABLE(
	IdCuenta			INT,
	Nocuenta			VARCHAR(30),
	IdSocio				INT,
	Nombre				VARCHAR(250),
	IdUsuarioAlta		INT,
	UsuarioAlta			VARCHAR(40),
	IdSucusal			INT,
	Sucursal			VARCHAR(80),
	IdEstatus			INT,
	IdTipoDproducto		INT
)

INSERT INTO @cuenta
(
    IdCuenta,
    Nocuenta,
    IdSocio,
    Nombre,
    IdUsuarioAlta,
    UsuarioAlta,
    IdSucusal,
    Sucursal,
	IdEstatus,
	IdTipoDproducto
)
SELECT c.IdCuenta,c.Codigo, sc.IdSocio, p.Nombre, u.IdUsuario, u.Usuario, suc.IdSucursal, suc.Descripcion, c.IdEstatus, c.IdTipoDProducto 
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = c.IdUsuarioAlta
WHERE c.Codigo=@ProductBankIdentifier

declare @saldos AS TABLE
(
	Fecha							DATE,
	IdCuenta						INT,
	IdTipoDproducto					INT,
	Capital							NUMERIC(18,2),
	InteresOrdinario 				NUMERIC(18,2),
	InteresMoratorioVigente 		NUMERIC(18,2),
	InteresMoratorioVencido 		NUMERIC(18,2),
	InteresMoratorioCuentasOrden 	NUMERIC(18,2),
	IVAInteresOrdinario 			NUMERIC(18,2),
	IVAinteresMoratorio 			NUMERIC(18,2),
	Cargos 							NUMERIC(18,2),
	CargosImpuestos					NUMERIC(18,2),
	SaldoTotalCredito				AS (Capital + InteresOrdinario + InteresMoratorioVigente + InteresMoratorioVencido + InteresMoratorioCuentasOrden + IVAInteresOrdinario + IVAinteresMoratorio + Cargos + CargosImpuestos),
	InteresPendienteCapitalizar		NUMERIC(18,2),
	MontoBloqueado					NUMERIC(18,2),
	MontoDisponible					NUMERIC(18,2),
	Saldo							NUMERIC(18,2),
	SaldoBalanceCuentasOrden		NUMERIC(18,2),
	IdEstatus						INT
)

	IF EXISTS(SELECT 1 FROM @cuenta WHERE IdTipoDproducto=143)
	BEGIN
		-- Cr�dito
		INSERT INTO @saldos
		(
			Fecha,
			IdCuenta,
			IdTipoDproducto,
			Capital,
			InteresOrdinario,
			InteresMoratorioVigente,
			InteresMoratorioVencido,
			InteresMoratorioCuentasOrden,
			IVAInteresOrdinario,
			IVAinteresMoratorio,
			Cargos,
			CargosImpuestos,
			IdEstatus
		)
		SELECT 
			cartera.FechaCartera,
			cartera.IdCuenta,
			143,
			cartera.Capital,
			cartera.InteresOrdinario,
			cartera.InteresMoratorioVigente,
			cartera.InteresMoratorioVencido,
			cartera.InteresMoratorioCuentasOrden,
			cartera.IVAInteresOrdinario,
			cartera.IVAinteresMoratorio,
			cartera.Cargos,
			cartera.CargosImpuestos,
			cta.IdEstatus
		FROM dbo.tAYCcartera cartera  WITH(NOLOCK) 
		INNER JOIN @cuenta cta ON cta.IdCuenta = cartera.IdCuenta
		WHERE cartera.FechaCartera IN (@fechaHoy,@fecha24antes,@fecha48antes)
	END
	ELSE	
	BEGIN
		-- Captaci�n
		INSERT INTO @saldos
		(
			Fecha,
			IdCuenta,
			IdTipoDproducto,
			Capital,
			InteresOrdinario,
			InteresPendienteCapitalizar,
			MontoBloqueado,
			MontoDisponible,
			Saldo,
			SaldoBalanceCuentasOrden,
			IdEstatus
		)
		SELECT 
			   c.fecha,
			   c.IdCuenta,
			   c.IdTipoDproducto,
			   c.Capital,
			   c.InteresOrdinario,
			   c.InteresPendienteCapitalizar,
			   c.MontoBloqueado,
			   c.MontoDisponible,
			   c.Saldo,
			   c.SaldoBalanceCuentasOrden,
			   c.IdEstatus 
		FROM dbo.tAYCcaptacion c  WITH(NOLOCK) 
		INNER JOIN @cuenta cta ON cta.IdCuenta = c.IdCuenta
		WHERE c.Fecha IN (@fecha24antes,@fecha48antes,@fecha48mas)

		-- Captaci�n Hoy
		INSERT INTO @saldos
		(
			Fecha,IdCuenta,IdTipoDproducto,Capital,InteresOrdinario,InteresPendienteCapitalizar,MontoBloqueado,MontoDisponible,Saldo,SaldoBalanceCuentasOrden,IdEstatus
		)
		SELECT 
		@fechaHoy,c.IdCuenta,c.IdTipoDproducto,fs.Capital,fs.InteresOrdinario,fs.InteresPendienteCapitalizar,fs.MontoBloqueado,fs.MontoDisponible,fs.Saldo,fs.SaldoBalanceCuentasOrden,c.IdEstatus FROM @cuenta c 
		INNER JOIN dbo.fAYCsaldo(0) fs ON fs.IdCuenta = c.IdCuenta AND c.IdTipoDproducto <> 143
	END

-- Saldo promedio
DECLARE @saldoPromedio AS NUMERIC(18,2)=0

IF EXISTS(SELECT 1 FROM @cuenta cta WHERE cta.IdTipoDproducto<>143)
BEGIN	
		SELECT @saldoPromedio=AVG(cap.Capital) 
		FROM dbo.tAYCcaptacion cap  WITH(NOLOCK)
		INNER JOIN @cuenta cta ON cta.IdCuenta = cap.IdCuenta
		WHERE cap.Fecha BETWEEN @FechaInicioMes AND @fechaHoy
END

-- Movimientos
DECLARE @movimientosDelMes INT;
SELECT @movimientosDelMes=COUNT(1) FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) 
									INNER JOIN @cuenta cta ON cta.IdCuenta = tf.IdCuenta
									WHERE tf.IdEstatus=1 AND tf.IdTipoSubOperacion IN (500,501) AND tf.Fecha BETWEEN @FechaInicioMes AND @fechaHoy


SELECT 
AccountBankIdentifier				= ctas.Nocuenta	,
AccountOfficerName					= ctas.UsuarioAlta	,
AccountCountableBalance				= IIF(sdoAct.IdTipoDproducto=143,sdoAct.SaldoTotalCredito,sdoAct.saldo),
AccountAvailableBalance				= IIF(sdoAct.IdTipoDproducto=143,0,sdoAct.MontoDisponible)	,
AccountBalance24Hrs					= IIF(sdo24.IdTipoDproducto=143,sdo24.SaldoTotalCredito,sdo24.saldo)	,
AccountBalance48Hrs					= IIF(sdo48.IdTipoDproducto=143,sdo48.SaldoTotalCredito,sdo48.saldo)	,
AccountBalance48MoreHrs				= IIF(sdo48ant.IdTipoDproducto=143,sdo48ant.SaldoTotalCredito,sdo48ant.saldo)	,
MonthlyAverageBalance				= @saldoPromedio	,
PendingChecks						= 0	,
ChecksToReleaseToday				= 0	,
ChecksToReleaseTomorrow				= 0	,
CancelledChecks						= 0	,
CertifiedChecks						= 0	,
RejectedChecks						= 0	,
BlockedAmount						= IIF(sdoAct.IdTipoDproducto=143,0,sdoAct.MontoBloqueado)	,
MovementsOfTheMonth					= @movimientosDelMes	,
ChecksDrawn							= 1	,
Overdrafts							= 1	,
ProductBranchName					= ctas.Sucursal	,
ProductOwnerName					= ctas.Nombre	,
ShowCurrentAccountChecksInformation	= 0	
FROM @cuenta ctas  
LEFT JOIN @saldos sdoAct  ON sdoAct.IdCuenta = ctas.IdCuenta AND sdoAct.Fecha=@fechaHoy
LEFT JOIN @saldos sdo24  ON sdo24.IdCuenta = ctas.IdCuenta AND sdo24.Fecha=@fecha24antes
LEFT JOIN @saldos sdo48  ON sdo48.IdCuenta = ctas.IdCuenta AND sdo48.Fecha=@fecha48antes
LEFT JOIN @saldos sdo48ant  ON sdo48ant.IdCuenta = ctas.IdCuenta AND sdo48ant.Fecha=@fecha48mas
WHERE ctas.Nocuenta=@ProductBankIdentifier

END
GO
GO

/* FILE: 09 pBKGgetAccountLast5Movements.sql    */

-- [9] GetAccountLast5Movements

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetAccountLast5Movements')
BEGIN
	DROP PROC pBKGgetAccountLast5Movements
	SELECT 'pBKGgetAccountLast5Movements BORRADO' AS info
END

GO

/* FILE: 09 pBKGgetAccountLast5Movements.sql    */

CREATE PROC pBKGgetAccountLast5Movements
@ProductBankIdentifier AS VARCHAR(32)
AS
BEGIN

--#region Definicion
/*
MovementId 						int 		Identificador del movimiento
AccountBankIdentifier			string 		Identificador interno de la cuenta
MovementDate 					dateTime 	Fecha del movimiento
Description 					string 		Descripci�n (que se muestra en posici�n consolidada)
Amount 							decimal 	Monto del movimiento
isDebit 						boolean 	True si es un movimiento de d�bito. False si es un movimiento de cr�dito
Balance 						decimal 	Saldo o balance de la cuenta luego de aplicado el movimiento.
MovementTypeId 					int 		Tipo de movimiento seg�n MovementTypes
TypeDescription 				string 		Descripci�n del tipo de movimiento
CheckId							string 		Identificador del cheque asociado al movimiento (si corresponde)
VoucherId						string		Identificador del comprobante asociado al movimiento (si corresponde)
*/
--#endregion Definicion

SELECT TOP 5
MovementId 				= o.IdOperacion,
AccountBankIdentifier	= c.Codigo,
MovementDate 			= o.Fecha,
Description 			= c.Descripcion,
Amount 					= tf.MontoSubOperacion,
isDebit 				= IIF(tf.IdTipoSubOperacion=500,0,1),
Balance 				= tf.SaldoCapital,
MovementTypeId 			= tm.IdMovementType,
TypeDescription 		= mov.Descripcion,
CheckId					= 1,
--VoucherId				= CONCAT(tipop.Codigo,'-', o.Folio)
VoucherId				= o.Folio
FROM dbo.tGRLoperaciones o  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposOperacion tipop  WITH(NOLOCK) ON tipop.IdTipoOperacion = o.IdTipoOperacion
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = o.IdOperacion
															AND tf.IdEstatus=1 
															AND tf.IdTipoSubOperacion IN (500,501)
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta 
											AND c.Codigo=@ProductBankIdentifier
INNER JOIN dbo.tBKGtipoMovimientoMovementTypes tm  WITH(NOLOCK) ON tm.IdTipoMovimiento=tf.IdTipoSubOperacion
INNER JOIN dbo.tBKGcatalogoMovementTypes mov  WITH(NOLOCK) ON mov.Id=tm.IdMovementType
WHERE o.IdTipoOperacion NOT IN (4) AND  o.IdEstatus=1 
ORDER BY o.IdOperacion DESC

END

GO

/* FILE: 09 pBKGgetAccountLast5Movements.sql    */

GO

/* FILE: 10 pBKGgetAccountMovements.sql    */

-- [10] GetAccountMovements

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetAccountMovements')
BEGIN
	DROP PROC pBKGgetAccountMovements
	SELECT 'pBKGgetAccountMovements BORRADO' AS info
END

GO

/* FILE: 10 pBKGgetAccountMovements.sql    */

CREATE PROC pBKGgetAccountMovements
@ProductBankIdentifier AS VARCHAR(32),
@DateFromFilter	AS DATE='19000101',
@DateToFilter AS DATE='19000101',
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=0,
@PageSize AS INT=0
AS
BEGIN
		DECLARE @fechaHoy AS DATE=GETDATE();
		IF @DateToFilter='19000101'
			SET @DateToFilter=@fechaHoy
		
		-- Establecer datos de la paginaci�n
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Dterminaci�n de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='MovementId DESC'

		-- Consulta en Inserci�n en la tabla
		DECLARE @tabla AS BKGaccountMovements

		INSERT INTO @tabla
		(
			MovementId,
			AccountBankIdentifier,
			MovementDate,
			Description,
			Amount,
			isDebit,
			Balance,
			MovementTypeId,
			TypeDescription,
			CheckId,
			VoucherId
		)
		SELECT 
		MovementId 				= o.IdOperacion,
		AccountBankIdentifier	= c.Codigo,
		MovementDate 			= o.Fecha,
		Description 			= c.Descripcion,
		Amount 					= tf.MontoSubOperacion,
		isDebit 				= IIF(tf.IdTipoSubOperacion=500,0,1),
		Balance 				= tf.SaldoCapital,
		MovementTypeId 			= tm.IdMovementType,
		TypeDescription 		= mov.Descripcion,
		CheckId					= 1,
		-- VoucherId				= CONCAT(tipop.Codigo,'-', o.Folio)
		VoucherId				= o.Folio
		FROM dbo.tGRLoperaciones o  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLtiposOperacion tipop  WITH(NOLOCK) ON tipop.IdTipoOperacion = o.IdTipoOperacion
		INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = o.IdOperacion
																	AND tf.IdEstatus=1 
																	AND tf.IdTipoSubOperacion IN (500,501)
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta 
																	AND c.Codigo=@ProductBankIdentifier
		INNER JOIN dbo.tBKGtipoMovimientoMovementTypes tm  WITH(NOLOCK) ON tm.IdTipoMovimiento=tf.IdTipoSubOperacion
		INNER JOIN dbo.tBKGcatalogoMovementTypes mov  WITH(NOLOCK) ON mov.Id=tm.IdMovementType
		WHERE o.IdTipoOperacion NOT IN (4) AND  o.IdEstatus=1 
		AND o.Fecha BETWEEN @DateFromFilter AND @DateToFilter 
		
		-- Implementaci�n de Ordenamiento din�mico
		DECLARE @query AS nVARCHAR(MAX)=CONCAT('SELECT * FROM @tabla ',
												'ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,'ROWS ONLY')
			
		EXEC sys.sp_executesql @query, N'@Tabla BKGaccountMovements readonly',@tabla	

END

GO

/* FILE: 10 pBKGgetAccountMovements.sql    */

GO

/* FILE: 11 pBKGgetProductOwnerAndCurrency.sql    */
-- 11 pBKGgetProductOwnerAndCurrency

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductOwnerAndCurrency')
BEGIN
	DROP PROC pBKGgetProductOwnerAndCurrency
	SELECT 'pBKGgetProductOwnerAndCurrency BORRADO' AS info
END

GO

/* FILE: 11 pBKGgetProductOwnerAndCurrency.sql    */

CREATE PROC pBKGgetProductOwnerAndCurrency
@ProductNumber VARCHAR(24),		-- Numero de Cuenta
@ProductTypeId INT = 1,				-- Tipo de producto
@DocumentType INT = 1,				-- Identificaci�n del socio
@DocumentId VARCHAR(24) = '',		-- N�mero de identificaci�n
@ThirdPartyProductType INT = 1		-- Tipo de Operaci�n 
AS
BEGIN

--#region
	/*		
	ClientBankIdentifiers				List<string>	Lista de identificadores del backend de Clientes para registrar el producto de terceros (solo aplica en caso de que la propiedad sea un par�metro de entrada)
	ThirdPartyProductNumber				string			N�mero de producto de terceros
	ThirdPartyProductBankIdentifier		string			Identificador interno del producto en caso de que el producto pertenezca a la propia organizaci�n
	Alias								string			Alias del producto de terceros
	CurrencyId							string			Identificador de la moneda del producto de terceros seg�n cat�logo Currencies.
	TransactionSubType					int				Sub tipo de la transacci�n para la cual el produco de terceros es registrado, seg�n cat�logo TransactionSubTypes
	ThirdPartyProductType				int				Tipo de producto de terceros seg�n cat�logo ThirdPartyProductTypes
	ProductType							int				Tipo de producto seg�n cat�logo ProductTypes
	OwnerName							string			Nombre completo del titular del producto de terceros.
	OwnerCountryId						string			Pais del titular del producto de terceros
	OwnerEmail							string			Correo electr�nico del titular del producto de terceros
	OwnerCity							string			Ciudad del titular del producto de terceros
	OwnerAddress						string			Direcci�n completa del titular del producto de terceros
	OwnerDocumentId						DocumentId		Tipo (seg�n DocumentType) y n�mero de documento de identidad del titular del producto de terceros.
	OwnerPhoneNumber					string			Tel�fono de contacto del titular del producto de terceros
	Bank								Bank			Banco del produco de terceros (ver entidad Bank). Solo se utiliza para productos de terceros fuera de la instituci�n.
	CorrespondentBank					Bank			Banco corresponsal (ver entidad Bank). Es opcional no es requerida.
	UserDocumentId						DocumentId		Tipo (seg�n DocumentType) y n�mero de documento de identidad del Usuario que ejecuta la operaci�n.
	*/
--#endregion


--  Variables
	DECLARE @idSocio INT;
	DECLARE @noSocio VARCHAR(24);
	DECLARE @idPersona INT;
	DECLARE @idCuenta INT;
	
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- JCA 20230505 Inicialmente este m�todo obten�a el socio y la persona por el documento de identidad y el n�mero de esta.
--				Posteriormente se toma la desici�n por BKG y KFT de buscar solo por el n�mero de cuenta.

-- 0. Cuenta
	DECLARE @cuenta AS TABLE
	(
		IdCuenta		INT,
		NoCuenta		VARCHAR(32),
		Alias			VARCHAR(80),
		ProductType		INT,
		IdSocio			INT
	)

	INSERT INTO @cuenta
	(
	    IdCuenta,
	    NoCuenta,
		Alias,
	    ProductType,
	    IdSocio
	)
	SELECT c.IdCuenta,c.Codigo, pf.Descripcion, pt.ProductTypeId, c.IdSocio
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	WHERE c.Codigo=@ProductNumber
	
	SET @idSocio= (SELECT TOP 1 c.IdSocio FROM @cuenta c)

-- 1. Validar socio, por documento y n�mero
		DECLARE @persona AS TABLE
		(
			IdPersona			INT,
			IdSocio				INT,
			NoSocio				VARCHAR(24),
			Nombre				VARCHAR(64),
			Domicilio			VARCHAR(256),
			IdRelDomicilios		INT,
			IdRelEmails			INT,
			IdRelTelefonos		INT,
			DocumentType		INT,
			DocumentId			VARCHAR(24)
		)

		INSERT INTO @persona
		(
		    IdPersona,
		    IdSocio,
		    NoSocio,
		    Nombre,
		    Domicilio,
		    IdRelDomicilios,
		    IdRelEmails,
		    IdRelTelefonos,
			DocumentType,
			DocumentId
		)
		SELECT sc.IdPersona, sc.IdSocio, sc.Codigo, p.Nombre, p.Domicilio, p.IdRelDomicilios, p.IdRelEmails, p.IdRelTelefonos, dt.IdDocumentType, pf.IFE
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
															-- AND pf.IFE=@DocumentId				-- Se suprime el filtro por acuerdo con la entidad
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = pf.IdPersona
		INNER JOIN dbo.tBKGcatalogoDocumentType dt  WITH(NOLOCK) ON dt.IdListaDidentificacion=pf.IdTipoDidentificacion 
															-- AND dt.IdDocumentType=@DocumentType  -- Se suprime el filtro por acuerdo con la entidad
		WHERE sc.IdEstatus=1 AND sc.IdSocio=@idSocio

		-- Variables de identificaci�n 
		SELECT TOP 1 @DocumentType=p.DocumentType, @DocumentId=p.DocumentId FROM @persona p

		IF NOT EXISTS(SELECT 1 FROM @persona)
		BEGIN
			RAISERROR ('Socio no encontrado con los datos de indentificaci�n proporcionados.', 1, 1);
			RETURN -1
		END
		--SELECT * FROM @persona

-- 1.1 Correos

		DECLARE @emails AS TABLE
		(
			IdPersona INT,
			IdRel INT,
			IdMail INT,
			IdListaD INT,
			Tipo VARCHAR(24),
			Email VARCHAR(128)
		)

		INSERT INTO @emails (idpersona,IdRel, IdMail, IdListaD, Tipo, Email)
		SELECT TOP 1 p.IdPersona,m.IdRel, m.IdEmail, ld.IdListaD, ld.Descripcion, m.email 
		FROM dbo.tCATemails m  WITH(NOLOCK) 
		INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = m.IdListaD
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = m.IdEstatusActual AND ea.IdEstatus=1
		INNER JOIN @persona p ON p.IdRelEmails=m.IdRel 

		--SELECT * FROM @emails

-- 1.2 Tel�fonos

		DECLARE @telefonos AS TABLE
		(
			IdPersona INT,
			IdRel	INT, 
			IdTelefono	INT,
			IdListaD	INT,
			Tipo		VARCHAR(24),
			Telefono	VARCHAR(10)
		)

		INSERT INTO @telefonos (IdPersona,IdRel,IdTelefono,IdListaD,Tipo,Telefono)
		SELECT TOP 1 p.IdPersona,t.IdRel, t.IdTelefono, t.IdListaD, ld.Descripcion, t.Telefono
		FROM dbo.tCATtelefonos t  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
		INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = t.IdListaD
		INNER JOIN @persona p ON p.IdRelTelefonos=t.IdRel 
		WHERE t.IdListaD=-1339 

		--SELECT * FROM @telefonos

-- 1.3 Domicilio
		
		DECLARE @domicilios AS TABLE
		(
			IdPersona		INT,
			IdRel			INT,
			IdDomicilio		INT,
			IdAsentamiento	INT,
			Asentamiento	VARCHAR(64),
			IdCiudad		INT,
			Ciudad			VARCHAR(64),
			IdPais			INT,
			Pais			VARCHAR(24)
		)

		INSERT INTO @domicilios
		(
		    IdPersona,
		    IdRel,
		    IdDomicilio,
		    IdAsentamiento,
		    Asentamiento,
		    IdCiudad,
		    Ciudad,
		    IdPais,
		    Pais
		)
		SELECT TOP 1 p.IdPersona, dom.IdRel, dom.IdDomicilio, dom.IdAsentamiento, dom.Asentamiento, dom.IdCiudad, dom.Ciudad, dom.IdPais, dom.Pais
		FROM @persona p 
		INNER JOIN dbo.tCATdomicilios dom  WITH(NOLOCK) ON dom.IdRel=p.IdRelDomicilios
														AND dom.IdTipoD=11
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual
														AND ea.IdEstatus=1

		--SELECT * FROM @domicilios

-- 2. Validar cuenta por n�mero y tipo
		
		--SELECT @idCuenta = c.IdCuenta
		--FROM dbo.tAYCcuentas c  WITH(NOLOCK)
		--INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
		--														AND pt.ProductTypeId=@ProductTypeId
		--WHERE c.Codigo=@ProductNumber
		--AND c.IdEstatus=1
		--AND c.IdSocio=@idSocio

		--IF @idCuenta=0
		--	RAISERROR ('El Socio y la Cuenta proporcionados no coinciden', 1, 1);

-- 3. Validar el tipo de operaci�n de terceros

		IF @ThirdPartyProductType IN (2,3,4,5)
		begin
			RAISERROR ('ThirdPartyProductType no permitido', 1, 1);
			RETURN -1
		END
-- 4. Consulta

SELECT 
	ClientBankIdentifiers				= p.NoSocio,
	ThirdPartyProductNumber				= c.NoCuenta,
	ThirdPartyProductBankIdentifier		= c.NoCuenta,
	Alias								= c.Alias,
	CurrencyId							= '484',
	TransactionSubType					= 2,
	ThirdPartyProductType				= 1,
	ProductType							= c.ProductType,
	OwnerName							= p.Nombre,
	OwnerCountryId						= dom.Pais,
	OwnerEmail							= m.Email,
	OwnerCity							= IIF(dom.Ciudad IS NULL,dom.Asentamiento,dom.Ciudad),
	OwnerAddress						= p.Domicilio,
	OwnerDocumentId						= @DocumentId,
	OwnerPhoneNumber					= t.Telefono
	FROM @persona p
	INNER JOIN @cuenta c ON c.IdSocio = p.IdSocio						
	LEFT JOIN @domicilios dom ON dom.IdRel=p.IdRelDomicilios
	LEFT JOIN @emails m on m.IdRel = p.IdRelEmails
	LEFT JOIN @telefonos t ON t.IdRel = p.IdRelTelefonos


END

GO

/* FILE: 11 pBKGgetProductOwnerAndCurrency.sql    */

GO

/* FILE: 12 pBKGgetFixedTermDeposit.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetFixedTermDeposit')
BEGIN
	DROP PROC pBKGgetFixedTermDeposit
	SELECT 'pBKGgetFixedTermDeposit BORRADO' AS info
END

GO

/* FILE: 12 pBKGgetFixedTermDeposit.sql    */

CREATE PROC pBKGgetFixedTermDeposit
AS
BEGIN

/* INFO (⊙_☉) 
Nombre del parámetro				Tipo de dato	Descripción
CdpName  							string			Nombre del certificado
CdpNumber  							string			Número del certificado
CurrentBalance  					decimal			Saldo o balance actual
DueDate  							DateTime?		Fecha de vencimiento
InterestEarned  					Decimal?		Intereses ganados
InterestPaid						Decimal?		Intereses pagados
InterestPayingAccount  				string			Cuenta pagadora de intereses
OriginalAmount  					Amount			Monto inicial del depósito
ProductBankIdentifier				string			Identificador interno del producto
Rate  								decimal			Tasa
RenewalDate  						DateTime		Fecha de renovación
StartDate  							DateTime?		Fecha de inicio
Term								string			Plazo
DebitProductBankIdentifier			string			Identificador interno del producto en el backend, donde ejecutar el débito del depósito a plazo
FixedTermDepositType				int				Identificador (interno del backend) del tipo de depósito a plazo
PaymentMethod						Catalog			Método de pago del depósito a plazo
TotalInterestAmount					Amount			Monto (y moneda) de los intereses del depósito a plazo
RenewalType							Catalog			Tipo de renovación
InterestCreditProductBankIdentifier	string			Identificador interno del producto en el backend, donde acreditar los intereses del depósito a plazo
DepositCreditProductBankIdentifier	string			Identificador interno del producto en el backend, donde se acredita el capital del depósito a plazo
FixedTermDepositBeneficiaries		List<FixedTermDepositBeneficiary>	Lista de beneficiarios

*/


SELECT 
 [CdpName]									= pf.codigo
,[CdpNumber]								= c.codigo
,[CurrentBalance]							= c.saldocapital
,[DueDate]									= c.vencimiento
,[InterestEarned]							= 0.0
,[InterestPaid]								= 0.0
,[InterestPayingAccount]					= ''
,[OriginalAmountCurrencyId]					= 40 -- MXP
,[OriginalAmountValue]						= c.monto
,[ProductBankIdentifier]					= pf.descripcion
,[Rate]										= c.interesordinarioanual
,[RenewalDate]								= ce.FechaUltimaReinversion
,[StartDate]								= c.FechaAlta
,[Term]										= c.Dias
,[DebitProductBankIdentifier]				= ''
,[FixedTermDepositType]						= 1
,[PaymentMethod]							= 'VARIOS'
,[TotalInterestAmountCurrencyId]			= 40 -- MXP
,[TotalInterestAmountValue]					= 0.0
,[RenewalType]								= 1
,[InterestCreditProductBankIdentifier]		= cInt.Codigo
,[DepositCreditProductBankIdentifier]		= cCap.Codigo
,[FixedTermDepositBeneficiaries]			= dbo.fnBKGobtenerBeneficiarioMayorPorcentaje(c.IdCuenta)	
,[NoSocio]									= sc.Codigo -- QUITAR
FROM tayccuentas c  WITH(NOLOCK)
INNER JOIN taycproductosfinancieros pf  WITH(NOLOCK)
	ON pf.idproductofinanciero=c.idproductofinanciero
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) 
	ON ce.IdCuenta = c.IdCuenta
INNER JOIN dbo.tAYCcuentas cInt  WITH(NOLOCK) 
	ON cInt.IdCuenta=c.IdCuentaInteres
INNER JOIN dbo.tAYCcuentas cCap  WITH(NOLOCK) 
	ON cCap.IdCuenta=c.IdCuentaCapital
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK)
	ON sc.IdSocio = c.IdSocio
WHERE c.idtipodproducto=398
	AND c.idestatus=1

END
GO
GO

/* FILE: 13 pBKGgetLoan.sql    */

-- [13] GetLoan

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoan')
BEGIN
	DROP PROC pBKGgetLoan
	SELECT 'pBKGgetLoan BORRADO' AS info
END

GO

/* FILE: 13 pBKGgetLoan.sql    */

CREATE PROC pBKGgetLoan
@ProductBankIdentifier AS VARCHAR(32),
@FeesStatus AS INT,
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=1,
@PageSize AS INT=999
AS
BEGIN

	DECLARE  @fechaTrabajo AS DATE=GETDATE();
	
	DECLARE @cuentas AS TABLE
	(
		IdSocio					INT,
		NoSocio					VARCHAR(24),
		Nombre					VARCHAR(250),
		ProductoDescripcion		VARCHAR(80),
		IdCuenta				INT,
		NoCuenta				VARCHAR(30),
		Monto					NUMERIC(18,2),
		Tasa					NUMERIC(18,2),
		Vencimiento				DATE,
		NumeroParcialidades		INT,
		IdTipoDProducto			INT,
		IdProductoFinanciero	INT,
		IdSucursal				INT,
		IdApertura				INT,
		SaldoCapital			NUMERIC(18,2),
		IdEstatus				INT
	)

	INSERT INTO @cuentas (IdSocio,NoSocio,Nombre,ProductoDescripcion,IdCuenta,NoCuenta,Monto,Tasa,Vencimiento,NumeroParcialidades,IdTipoDProducto,IdProductoFinanciero,IdSucursal,IdApertura,SaldoCapital,IdEstatus)
	SELECT sc.IdSocio,sc.Codigo,p.Nombre,pf.Descripcion,c.IdCuenta,c.Codigo,c.Monto,c.InteresOrdinarioAnual,c.Vencimiento,c.NumeroParcialidades,c.IdTipoDProducto,pf.IdProductoFinanciero,c.IdSucursal,c.IdApertura, c.SaldoCapital,c.IdEstatus
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	WHERE c.Codigo=@ProductBankIdentifier
	
	DECLARE @parcialidades AS TABLE
	(
		[IdParcialidad]					[INT], 
		[NumeroParcialidad]				[INT],
		[DiasCalculados]				[INT] ,
		[Inicio]						[DATE] ,
		[Vencimiento]					[DATE] ,
		[IdPeriodo]						[INT] ,
		[CapitalInicial]				[NUMERIC] (23, 8) ,
		[Capital]						[NUMERIC] (23, 8) ,
		[CapitalFinal]					[NUMERIC] (23, 8) ,
		[InteresOrdinarioEstimado]		[NUMERIC] (23, 8) ,
		[IVAInteresOrdinarioEstimado]	[numeric] (23, 8) ,
		[TotalSinAhorro]				[NUMERIC] (23, 8) ,
		[Ahorro]						[NUMERIC] (23, 8) ,
		[Total]							[numeric] (23, 8) ,
		[Notas]							[varchar] (1024) ,
		[IdCuenta]						[INT] ,
		[IdBloque]						[INT] ,
		[NumeroBloque]					[INT] ,
		[InteresOrdinario]				[NUMERIC] ,
		[InteresMoratorio]				[NUMERIC] ,
		[IVAInteresOrdinario]			[NUMERIC] ,
		[IVAInteresMoratorio]			[NUMERIC] ,
		[CapitalPagado]					[NUMERIC] (23, 8) ,
		[InteresOrdinarioPagado]		[NUMERIC] (23, 8) ,
		[InteresMoratorioPagado]		[NUMERIC] (23, 8) ,
		[IVAInteresOrdinarioPagado]		[NUMERIC] (23, 8) ,
		[IVAInteresMoratorioPagado]		[NUMERIC] (23, 8) ,
		[CapitalCondonado]				[NUMERIC] (23, 8) ,
		[InteresOrdinarioCondonado]		[NUMERIC] (23, 8) ,
		[InteresMoratorioCondonado]		[NUMERIC] (23, 8) ,
		[IVAInteresOrdinarioCondonado]	[NUMERIC] (23, 8) ,
		[IVAInteresMoratorioCondonado]	[NUMERIC] (23, 8) ,
		[PagadoInteresOrdinario]		[DATE] ,
		[PagadoInteresMoratorio]		[DATE] ,
		[PagadoCapital]					[DATE] ,
		[UltimoCalculoInteresMoratorio]	[DATE] ,
		[EstaPagada]					[BIT] ,
		[Orden]							[INT] ,
		[Ahorrado]						[NUMERIC] (23, 8) ,
		[RelParcialidades]				[INT] ,
		[InteresOrdinarioCuentasOrden]	[NUMERIC] (23, 8) ,
		[InteresMoratorioCuentasOrden]	[NUMERIC] (23, 8) ,
		[NumeroEntrega]					[INT] ,
		[CapitalGenerado]				[NUMERIC] (23, 8) ,
		[Fin]							[DATE] ,
		[IdApertura]					[INT] ,
		[IdEstatus]						[INT] ,
		[VencimientoOriginal]			[DATE] ,
		[SaldoCargo1]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo1]				[NUMERIC] (18, 2) ,
		[SaldoCargo2]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo2]				[NUMERIC] (18, 2) ,
		[SaldoCargo3]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo3]				[NUMERIC] (18, 2) ,
		[SaldoCargo4]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo4]				[NUMERIC] (18, 2) ,
		[SaldoCargo5]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo5]				[NUMERIC] (18, 2) ,
		[PagoProgramado]				[NUMERIC] (18, 2) ,
		[FechaPago]						[DATE] ,
		[EsPeriodoGracia]				[INT] ,
		[InteresOrdinarioCalculado]		[NUMERIC] (18, 2) ,-- AS ([InteresOrdinario]+[InteresOrdinarioCuentasOrden]), REVISAR CON IMM
		[InteresMoratorioCalculado]		[NUMERIC] (18, 2) ,-- AS ([InteresMoratorio]+[InteresMoratorioCuentasOrden]), REVISAR CON IMM
		[EsPeriodoGraciaCapital]		[BIT] ,
		[TieneInteresesAplazados]		[BIT]
	)

	INSERT INTO @parcialidades
	(
	    IdParcialidad,
		NumeroParcialidad,
		DiasCalculados,
		Inicio,
		Vencimiento,
		IdPeriodo,
		CapitalInicial,
		Capital,
		CapitalFinal,
		InteresOrdinarioEstimado,
		IVAInteresOrdinarioEstimado,
		TotalSinAhorro,
		Ahorro,
		Total,
		Notas,
		IdCuenta,
		IdBloque,
		NumeroBloque,
		InteresOrdinario,
		InteresMoratorio,
		IVAInteresOrdinario,
		IVAInteresMoratorio,
		CapitalPagado,
		InteresOrdinarioPagado,
		InteresMoratorioPagado,
		IVAInteresOrdinarioPagado,
		IVAInteresMoratorioPagado,
		CapitalCondonado,
		InteresOrdinarioCondonado,
		InteresMoratorioCondonado,
		IVAInteresOrdinarioCondonado,
		IVAInteresMoratorioCondonado,
		PagadoInteresOrdinario,
		PagadoInteresMoratorio,
		PagadoCapital,
		UltimoCalculoInteresMoratorio,
		EstaPagada,
		Orden,
		Ahorrado,
		RelParcialidades,
		InteresOrdinarioCuentasOrden,
		InteresMoratorioCuentasOrden,
		NumeroEntrega,
		CapitalGenerado,
		Fin,
		IdApertura,
		IdEstatus,
		VencimientoOriginal,
		SaldoCargo1,
		SaldoIVAcargo1,
		SaldoCargo2,
		SaldoIVAcargo2,
		SaldoCargo3,
		SaldoIVAcargo3,
		SaldoCargo4,
		SaldoIVAcargo4,
		SaldoCargo5,
		SaldoIVAcargo5,
		PagoProgramado,
		FechaPago,
		EsPeriodoGracia,
		InteresOrdinarioCalculado,
		InteresMoratorioCalculado,
		EsPeriodoGraciaCapital,
		TieneInteresesAplazados
	)
	SELECT 
		p.IdParcialidad,
		p.NumeroParcialidad,
		p.DiasCalculados,
		p.Inicio,
		p.Vencimiento,
		p.IdPeriodo,
		p.CapitalInicial,
		p.Capital,
		p.CapitalFinal,
		p.InteresOrdinarioEstimado,
		p.IVAInteresOrdinarioEstimado,
		p.TotalSinAhorro,
		p.Ahorro,
		p.Total,
		p.Notas,
		p.IdCuenta,
		p.IdBloque,
		p.NumeroBloque,
		p.InteresOrdinario,
		p.InteresMoratorio,
		p.IVAInteresOrdinario,
		p.IVAInteresMoratorio,
		p.CapitalPagado,
		p.InteresOrdinarioPagado,
		p.InteresMoratorioPagado,
		p.IVAInteresOrdinarioPagado,
		p.IVAInteresMoratorioPagado,
		p.CapitalCondonado,
		p.InteresOrdinarioCondonado,
		p.InteresMoratorioCondonado,
		p.IVAInteresOrdinarioCondonado,
		p.IVAInteresMoratorioCondonado,
		p.PagadoInteresOrdinario,
		p.PagadoInteresMoratorio,
		p.PagadoCapital,
		p.UltimoCalculoInteresMoratorio,
		p.EstaPagada,
		p.Orden,
		p.Ahorrado,
		p.RelParcialidades,
		p.InteresOrdinarioCuentasOrden,
		p.InteresMoratorioCuentasOrden,
		p.NumeroEntrega,
		p.CapitalGenerado,
		p.Fin,
		p.IdApertura,
		p.IdEstatus,
		p.VencimientoOriginal,
		p.SaldoCargo1,
		p.SaldoIVAcargo1,
		p.SaldoCargo2,
		p.SaldoIVAcargo2,
		p.SaldoCargo3,
		p.SaldoIVAcargo3,
		p.SaldoCargo4,
		p.SaldoIVAcargo4,
		p.SaldoCargo5,
		p.SaldoIVAcargo5,
		p.PagoProgramado,
		p.FechaPago,
		p.EsPeriodoGracia,
		p.InteresOrdinarioCalculado,
		p.InteresMoratorioCalculado,
		p.EsPeriodoGraciaCapital,
		p.TieneInteresesAplazados
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	INNER JOIN @cuentas c ON c.IdCuenta = p.IdCuenta
	AND c.IdApertura = p.IdApertura
	WHERE p.IdEstatus=1 

	DECLARE @fechaCartera AS DATE=(SELECT MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(NOLOCK)
									INNER JOIN @cuentas c ON c.IdCuenta = cartera.IdCuenta)

	-- Variables Calculadas
	DECLARE @parcialidadesVencidas AS INT=0
	DECLARE @parcialidadesPagadas AS INT=0

	SELECT @parcialidadesVencidas=COUNT(1) FROM @parcialidades p WHERE p.Fin<@fechaTrabajo AND p.EstaPagada=0
	SELECT @parcialidadesPagadas=COUNT(1) FROM @parcialidades p WHERE p.EstaPagada=1

--#region Definicion
	/*
		AccountBankIdentifier		string					Identificador interno de la cuenta asociada al pr�stamo
		CurrentBalance				decimal					Saldo o balance actual del pr�stamo
		CurrentRate  				decimal					Tasa de inter�s aplicada al pr�stamo
		FeesDue						int?					Cantidad de cuotas vencidas
		FeesDueData					FeesDueData				Informaci�n sobre los vencimientos de las cuotas
		LoanStatusId				byte					Estado del Pr�stamo (cat�logo ProductStatus)
		NextFee						LoanFee					Informaci�n de la pr�xima cuota
		OriginalAmount				decimal					Capital original del pr�stamo
		OverdueDays					int?					Cantidad de d�as de atraso
		PaidFees					int						Cuotas pagadas
		PayoffBalance				decimal					Monto para liquidar/cancelar el pr�stamo (no es un saldo)
		PrepaymentAmount			decimal?				Monto para pago anticipado (total o parcial)
		ProducttBankIdentifier		string					Identificador del pr�stamo en el Core o Backend
		Term						int						Cantidad de cuotas del pr�stamo
		ShowPrincipalInformation	bool					Muestra la tabla con la informaci�n principal del pr�stamo, en detalle de pr�stamo
		GetLoanFeesResult			GetLoanFeesResult		Informaci�n sobre el resultado de las cuotas
		GetLoanRatesResult			GetLoanRatesResult		Informaci�n sobre el resultado de las tasas de inter�s
		GetLoanPaymentsResult		GetLoanPaymentsResult	Informaci�n sobre el resultado de los pr�stamos
	*/
--#endregion Definicion


	--Tabla del tipo getLoan
	DECLARE @tabla AS BKGgetLoan;

	INSERT INTO @tabla
	(
	    AccountBankIdentifier,
	    CurrentBalance,
	    CurrentRate,
	    FeesDue,
	    FeesDueInterestAmount,
	    FeesDueOthersAmount,
	    FeesDueOverdueAmount,
	    FeesDuePrincipalAmount,
	    FeesDueTotalAmount,
	    LoanStatusId,
	    CapitalBalance,
	    FeeNumber,
	    PrincipalAmount,
	    DueDate,
	    InterestAmount,
	    OverdueAmount,
	    FeeStatusId,
	    OthersAmount,
	    TotalAmount,
	    OriginalAmount,
	    OverdueDays,
	    PaidFees,
	    PayoffBalance,
	    PrepaymentAmount,
	    ProducttBankIdentifier,
	    Term,
	    ShowPrincipalInformation
	)
	SELECT 
	AccountBankIdentifier				= c.NoCuenta,
	CurrentBalance						= cartera.Capital + cartera.InteresOrdinario 
											+ cartera.InteresMoratorioVigente + cartera.InteresMoratorioVencido + cartera.InteresMoratorioCuentasOrden 
											+ cartera.IVAInteresOrdinario + cartera.IVAinteresMoratorio + cartera.Cargos + cartera.CargosImpuestos,
	CurrentRate  						= c.Tasa,
	FeesDue								= @parcialidadesVencidas, 

	-- BEGIN FeesDueData						
	FeesDueInterestAmount				=cartera.InteresOrdinarioTotalAtrasado,
	FeesDueOthersAmount					=cartera.CargosTotal,
	FeesDueOverdueAmount				=cartera.InteresMoratorioTotal,
	FeesDuePrincipalAmount				=cartera.CapitalAtrasado,
	FeesDueTotalAmount					=cartera.CapitalAtrasado+cartera.InteresOrdinarioTotalAtrasado+cartera.InteresMoratorioTotal+cartera.CargosTotal,
	-- END FeesDueData

	LoanStatusId						= pe.ProductStatusId,

	-- BEGIN NextFee - LoanFee
	CapitalBalance						= cartera.Capital,
	FeeNumber							= NoPagadas.NumeroParcialidad,
	PrincipalAmount						= NoPagadas.Capital-NoPagadas.CapitalPagado,
	DueDate								= NoPagadas.Fin,
	InterestAmount						= NoPagadas.InteresOrdinario - NoPagadas.InteresOrdinarioCondonado - NoPagadas.InteresOrdinarioPagado,
	OverdueAmount						= NoPagadas.InteresMoratorio - NoPagadas.InteresMoratorioPagado - NoPagadas.InteresMoratorioCondonado,
	FeeStatusId							= IIF(NoPagadas.Fin<@fechaTrabajo AND NoPagadas.EstaPagada=0,2,3),
	OthersAmount						= NoPagadas.SaldoCargo1 + NoPagadas.SaldoCargo2 + NoPagadas.SaldoCargo3,
	TotalAmount							= NoPagadas.Total - NoPagadas.CapitalPagado - NoPagadas.InteresOrdinarioPagado - NoPagadas.InteresMoratorioPagado
											- NoPagadas.CapitalCondonado - NoPagadas.InteresOrdinarioCondonado - NoPagadas.InteresMoratorioPagado
											- NoPagadas.IVAInteresOrdinarioPagado - NoPagadas.IVAInteresMoratorioPagado,	
	-- END NextFee - LoanFee

	OriginalAmount						= c.Monto,
	OverdueDays							= IIF(cartera.DiasMoraCapital>cartera.DiasMoraInteres,cartera.DiasMoraCapital,cartera.DiasMoraInteres),
	PaidFees							= @parcialidadesPagadas,
	PayoffBalance						= cartera.Capital + cartera.InteresOrdinario 
											+ cartera.InteresMoratorioVigente + cartera.InteresMoratorioVencido + cartera.InteresMoratorioCuentasOrden 
											+ cartera.IVAInteresOrdinario + cartera.IVAinteresMoratorio + cartera.Cargos + cartera.CargosImpuestos,
	PrepaymentAmount					= 0, -- Preguntar
	ProducttBankIdentifier				= c.NoCuenta,
	Term								= c.NumeroParcialidades,
	ShowPrincipalInformation			= 1  -- Preguntar
	FROM @cuentas c
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductStatus pe  WITH(NOLOCK) ON pe.IdEstatus = c.idestatus
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
	LEFT JOIN dbo.tAYCcartera cartera  WITH(NOLOCK) ON cartera.IdCuenta = c.IdCuenta
													AND cartera.FechaCartera=@fechaCartera
	LEFT JOIN (
				SELECT IdCuenta, IdApertura, COUNT(1) ppagadas FROM @parcialidades 
				WHERE EstaPagada=1
				GROUP BY IdApertura, IdCuenta
				) pagadas ON pagadas.IdApertura = c.IdApertura AND pagadas.IdCuenta = c.IdCuenta
	LEFT JOIN (
				SELECT *
					FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY IdCuenta ORDER BY p.NumeroParcialidad ASC) AS Id, *
						FROM @parcialidades p  
						WHERE p.EstaPagada=0 AND p.IdParcialidad<>0
					) np WHERE np.Id=1
				) NoPagadas ON NoPagadas.IdApertura = c.IdApertura AND NoPagadas.IdCuenta = c.IdCuenta

		-- Establecer datos de la paginaci�n
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Determinaci�n de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='AccountBankIdentifier ASC'

	
		-- Implementaci�n de Ordenamiento din�mico
		DECLARE @query AS nVARCHAR(MAX) = CONCAT('SELECT * FROM @tabla ',
												'ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,' ROWS ONLY')
		--PRINT @query	

		EXEC sys.sp_executesql @query, N'@Tabla BKGgetLoan readonly',@tabla

	
END
GO
GO

/* FILE: 15 pBKGgetLoanFees.sql    */

-- 15 pBKGgetLoanFees


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoanFees')
BEGIN
	DROP PROC pBKGgetLoanFees
	SELECT 'pBKGgetLoanFees BORRADO' AS info
END

GO

/* FILE: 15 pBKGgetLoanFees.sql    */

CREATE PROC pBKGgetLoanFees
@ProductBankIdentifier  AS VARCHAR(32),			-- Identificador interno del producto 
@FeesStatus	INT,								-- 0 = Todas	1 = Pagadas	2 = No pagadas
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=1,
@PageSize AS INT=999
--
,@LoanFeesCountOut INT OUTPUT
AS
BEGIN
    
--#region Documentaci�n
	/*
	CapitalBalance		decimal?	Saldo o balance del capital del pr�stamo
	FeeNumber			int			Numero de cuota
	PrincipalAmount		decimal		Monto principal de la cuota
	DueDate				DateTime	Fecha de vencimiento de la cuota
	InterestAmount		decimal		Monto de inter�s
	OverdueAmount		decimal		Monto de mora
	FeeStatusId			byte		Estado de la cuota seg�n LoanFeeStatus
	OthersAmount		decimal		Otros conceptos asociados a la cuota
	TotalAmount			decimal		Monto total de la cuota
	*/
--#endregion Documentaci�n

	DECLARE @idCuenta AS INT=0
	DECLARE @LoanFeesCount AS INT=0
	SELECT @idcuenta=c.idcuenta, @LoanFeesCount=c.numeroparcialidades FROM dbo.tAYCcuentas c WITH(NOLOCK) WHERE c.Codigo=@ProductBankIdentifier
	SET @LoanFeesCountOut= @LoanFeesCount;

	DECLARE @CapitalBalance AS NUMERIC(23,8)
	
	SELECT TOP 1 @CapitalBalance = cartera.Capital FROM dbo.tAYCcartera cartera  WITH(NOLOCK) WHERE cartera.IdCuenta=@idCuenta ORDER BY cartera.FechaCartera DESC


DECLARE @query AS nVARCHAR(MAX) =''

SET @query = CONCAT('SELECT
    CapitalBalance  = ', @CapitalBalance,'
   ,FeeNumber       = p.NumeroParcialidad
   ,PrincipalAmount = CASE
                          WHEN ( p.CapitalPagado + p.CapitalCondonado ) > ( p.Capital ) THEN
                              p.Capital + (( p.CapitalPagado + p.CapitalCondonado ) - p.Capital )
                          ELSE
                              p.Capital
                      END
   ,DueDate         = p.Vencimiento
   ,InterestAmount  = p.InteresOrdinarioCalculado - p.InteresOrdinarioPagado - p.InteresOrdinarioCondonado
                      + p.IVAInteresOrdinario + ROUND(p.InteresOrdinarioCuentasOrden * cuenta.TasaIva, 2)
                      - p.IVAInteresOrdinarioPagado - p.IVAInteresOrdinarioCondonado
   ,OverdueAmount   = p.InteresMoratorioCalculado - p.InteresMoratorioPagado - p.InteresMoratorioCondonado
                      + p.IVAInteresMoratorio + ROUND(p.InteresMoratorioCuentasOrden * cuenta.TasaIva, 2)
                      - p.IVAInteresMoratorioPagado - p.IVAInteresMoratorioCondonado
   ,FeeStatusId     = IIF(p.EstaPagada = 0, 2, 3)
   ,OthersAmount    = p.SaldoCargo1 + p.SaldoIVAcargo1 + p.SaldoCargo2 + SaldoIVAcargo2 + p.SaldoCargo3 + SaldoIVAcargo3
   ,TotalAmount     = CASE
                          WHEN ( p.CapitalPagado + p.CapitalCondonado ) > ( p.Capital ) THEN
                              p.Capital + (( p.CapitalPagado + p.CapitalCondonado ) - p.Capital )
                          ELSE
                              p.Capital
                      END
                      + ( p.InteresOrdinarioCalculado - p.InteresOrdinarioPagado - p.InteresOrdinarioCondonado
                          + p.IVAInteresOrdinario + ROUND(p.InteresOrdinarioCuentasOrden * cuenta.TasaIva, 2)
                          - p.IVAInteresOrdinarioPagado - p.IVAInteresOrdinarioCondonado
                        )
                      + ( p.InteresMoratorioCalculado - p.InteresMoratorioPagado - p.InteresMoratorioCondonado )
                      + p.SaldoCargo1 + p.SaldoIVAcargo1 + p.SaldoCargo2 + SaldoIVAcargo2 + p.SaldoCargo3 + SaldoIVAcargo3
FROM
    dbo.tAYCparcialidades      p WITH ( NOLOCK )
    INNER JOIN dbo.tAYCcuentas cuenta WITH ( NOLOCK )
        ON cuenta.IdCuenta       = p.IdCuenta
           AND cuenta.IdApertura = p.IdApertura
           AND p.IdEstatus       = 1
WHERE
    p.IdCuenta =',@idCuenta)

	--PRINT @query

	-- Filtro adicional del estatus
	IF @FeesStatus=1
		SET @query=CONCAT(@query,' AND p.EstaPagada=1 ')

	IF @FeesStatus=2
		SET @query=CONCAT(@query,' AND p.EstaPagada=0 ')


	-- Establecer datos de la paginaci�n
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Determinaci�n de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='p.NumeroParcialidad ASC'

	
		-- Implementaci�n de Ordenamiento din�mico
		SET @query = CONCAT(@query,
												' ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,' ROWS ONLY')
		--PRINT @query	

		EXEC sys.sp_executesql @query

END

GO

/* FILE: 15 pBKGgetLoanFees.sql    */

GO

/* FILE: 16 pBKGgetLoanRates.sql    */

-- pBKGgetLoanRates


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoanRates')
BEGIN
	DROP PROC pBKGgetLoanRates
	SELECT 'pBKGgetLoanRates BORRADO' AS info
END

GO

/* FILE: 16 pBKGgetLoanRates.sql    */

CREATE PROC pBKGgetLoanRates
@ProductBankIdentifier AS VARCHAR(32)='',
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=0,
@PageSize AS INT=0
AS
BEGIN
	

--#region Documentacion
	/*
	InitialDate  	DateTime	Fecha inicio donde comienza a aplicarse dicha tasa
	Rate			decimal		Tasa de inter�s
	LoanRatesCount	int			Cantidad total de tasas de inter�s del pr�stamo
	*/
--#endregion Documentacion

	SELECT 
	InitialDate  	= c.Alta,
	Rate			= c.InteresOrdinarioAnual,
	LoanRatesCount	= 1
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	WHERE c.Codigo=@ProductBankIdentifier

END



GO

/* FILE: 16 pBKGgetLoanRates.sql    */



GO

/* FILE: 18 pBKGgetLoanPayments.sql    */

-- pBKGgetLoanPayments


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoanPayments')
BEGIN
	DROP PROC pBKGgetLoanPayments
	SELECT 'pBKGgetLoanPayments BORRADO' AS info
END

GO

/* FILE: 18 pBKGgetLoanPayments.sql    */

CREATE PROC pBKGgetLoanPayments
@ProductBankIdentifier AS VARCHAR(32),
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=1,
@PageSize AS INT=999
AS
BEGIN
	

--#region Documentacion
	/*
	CapitalBalance			decimal?	Saldo o balance del capital del pr�stamo
	FeeNumber				int			N�mero de cuota asociada al pago de pr�stamo
	MovementType 			int			Tipo de pago de pr�stamo seg�n LoanPaymentTypes			1	Payoff loan		2	Pay loan fee		3	Other value
	NormalInterestAmount	decimal?	Monto de inter�s normal
	OthersAmount			decimal?	Otros conceptos asociados al pago
	OverdueInterestAmount	decimal?	Monto de inter�s vencido
	PaymentDate				DateTime?	Fecha de pago
	PrincipalAmount			decimal?	Monto principal del pago
	TotalAmount				decimal?	Monto total del pago
	LoanPaymentsCount		int			Cantidad total de pagos
	*/
--#endregion Documentacion

	DECLARE @idCuenta AS INT;
	DECLARE @idApertura AS INT;
	DECLARE @NumCuotas AS INT;
	DECLARE @CapitalBalance AS NUMERIC(23,8);
	DECLARE @LoanPaymentsCount INT;
	
	SELECT @idCuenta=idcuenta, @NumCuotas=c.NumeroParcialidades, @idApertura=c.IdApertura FROM dbo.tAYCcuentas c WITH(NOLOCK) WHERE c.Codigo=@ProductBankIdentifier
	SELECT TOP 1 @CapitalBalance = cartera.Capital FROM dbo.tAYCcartera cartera  WITH(NOLOCK) WHERE cartera.IdCuenta=@idCuenta ORDER BY cartera.FechaCartera DESC

	SELECT @LoanPaymentsCount=COUNT(1) FROM dbo.tAYCparcialidades p  WITH(NOLOCK) WHERE p.IdCuenta=@idCuenta AND p.EstaPagada=1

	DECLARE @query AS nVARCHAR(MAX) =CONCAT('
	SELECT 
		CapitalBalance			= ',@CapitalBalance,',
		FeeNumber				= p.NumeroParcialidad,
		MovementType 			= IIF(p.NumeroParcialidad=',@NumCuotas,',1,2),	
		NormalInterestAmount	= p.InteresOrdinarioPagado,
		OthersAmount			= 0,
		OverdueInterestAmount	= p.InteresMoratorioPagado,
		PaymentDate				= IIF(p.PagadoCapital>p.PagadoInteresOrdinario,p.PagadoCapital,p.PagadoInteresOrdinario),
		PrincipalAmount			= p.CapitalPagado,
		TotalAmount				= p.CapitalPagado + p.InteresOrdinarioPagado + p.InteresMoratorioPagado,
		LoanPaymentsCount		= ', @LoanPaymentsCount,'
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	WHERE p.idapertura=',@idApertura ,' AND p.IdCuenta=',@idCuenta ,' AND p.EstaPagada=1 ')
	
	
	-- Establecer datos de la paginaci�n
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Determinaci�n de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='p.NumeroParcialidad ASC'

	
		-- Implementaci�n de Ordenamiento din�mico
		SET @query = CONCAT(@query,
												' ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,' ROWS ONLY')
		--PRINT @query	

		EXEC sys.sp_executesql @query

END

GO

/* FILE: 18 pBKGgetLoanPayments.sql    */



GO

/* FILE: 19 pBKGinsertTransaction.sql    */

-- pBKGinsertTransaction


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGinsertTransaction')
BEGIN
	DROP PROC pBKGinsertTransaction
	SELECT 'pBKGinsertTransaction BORRADO' AS info
END

GO

/* FILE: 19 pBKGinsertTransaction.sql    */

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
GO

/* FILE: 60 pBKGgetProductBankStatements.sql    */


-- 60 pBKGgetProductBankStatements


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductBankStatements')
BEGIN
	DROP PROC pBKGgetProductBankStatements
	SELECT 'pBKGgetProductBankStatements BORRADO' AS info
END

GO

/* FILE: 60 pBKGgetProductBankStatements.sql    */

CREATE PROC pBKGgetProductBankStatements
@ClientBankIdentifier	VARCHAR(24)='',
@ProductBankIdentifier	VARCHAR(24)='',
@ProductType			INT=0	
AS
BEGIN

--#region Documentaci�n  INPUT
	/*
	ClientBankIdentifier	string	Identificador del cliente en el backend.
	ProductBankIdentifier	string	Identificador del producto en el backend para el cual se est� solicitando la lista de estados de cuenta.
	ProductType				int		Tipo de producto seg�n cat�logo ProductTypes.
	*/
--#endregion Documentaci�n

--#region Documentaci�n  OUTPUT
	/*
	ProductBankIdentifier		string		Identificador interno del producto en el backend, asociado al archivo de estado de cuenta.
	ProductBankStatementDate	DateTime	Fecha del archivo de estado de cuenta. Esta fecha se despliega al usuario final para que poder seleccionar el estado de cuenta.
	ProductBankStatementId		string		Identificador del archivo de estado de cuenta en el backend.
	ProductType					int			Tipo de producto seg�n cat�logo ProductTypes.
	*/
--#endregion Documentaci�n

	DECLARE @fechaTrabajo AS DATE=GETDATE();
	DECLARE @fecha12mesesAntes AS DATE=DATEADD(YEAR,-1,@fechaTrabajo);

	SELECT 
	 ProductBankIdentifier		= @ProductBankIdentifier
	,ProductBankStatementDate	= per.Codigo
	,ProductBankStatementId		= CONCAT(per.Codigo,'-',@ProductBankIdentifier)
	,ProductType				= @ProductType
	FROM dbo.tCTLperiodos per  WITH(NOLOCK) 
	WHERE per.Inicio>=@fecha12mesesAntes AND per.Fin<=@fechaTrabajo
	AND per.EsAjuste=0


END

GO

/* FILE: 60 pBKGgetProductBankStatements.sql    */



GO

/* FILE: 61 pBKGgetProductBankStatementFile.sql    */

-- 61 pBKGgetProductBankStatementFile


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductBankStatementFile')
BEGIN
	DROP PROC pBKGgetProductBankStatementFile
	SELECT 'pBKGgetProductBankStatementFile BORRADO' AS info
END

GO

/* FILE: 61 pBKGgetProductBankStatementFile.sql    */

CREATE PROC pBKGgetProductBankStatementFile
@ProductBankIdentifier		VARCHAR(24)='',
@ProductBankStatementDate	VARCHAR(8)='',
@ProductBankStatementId		VARCHAR(128)='',
@ProductType				INT=0
AS
BEGIN

--#region Documentaci�n INPUT
	/*
		ProductBankIdentifier		string		Identificador interno del producto en el backend, asociado al archivo de estado de cuenta.
		ProductBankStatementDate	DateTime	Fecha del archivo de estado de cuenta.
		ProductBankStatementId		string		Identificador del archivo de estado de cuenta
		ProductType					int			Tipo de producto seg�n cat�logo ProductTypes.
	*/
--#endregion Documentaci�n

--#region Documentaci�n OUTPUT
	/*
		ProductBankStatementFile		byte[]	Archivo del estado de cuenta en formato pdf
		ProductBankStatementFileName	string	Nombre del archivo de estado de cuenta
	*/
--#endregion Documentaci�n OUTPUT

DECLARE @ProductBankStatementFileName AS VARCHAR(128);
SET @ProductBankStatementFileName=IIF(@ProductBankStatementId='',CONCAT(@ProductBankStatementDate,'-',@ProductBankIdentifier),@ProductBankStatementId)
SELECT @ProductBankStatementFileName

END

GO

/* FILE: 61 pBKGgetProductBankStatementFile.sql    */

GO

/* FILE: 62 pBKGgetTransactionCost.sql    */

-- 62 pBKGgetTransactionCost

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetTransactionCost')
BEGIN
	DROP PROC pBKGgetTransactionCost
	SELECT 'pBKGgetTransactionCost BORRADO' AS info
END

GO

/* FILE: 62 pBKGgetTransactionCost.sql    */

CREATE PROC pBKGgetTransactionCost
@FeatureId						INT=0,
@TransactionTypeId				INT=0,
@SubTransactionTypeId			INT=0,
@ValueDate						DATE='19000101',
@ClientBankIdentifier			VARCHAR(32)='',
@CurrencyId						VARCHAR(16)='',
@Amount							NUMERIC(18,2)=0,
@DebitProductBankIdentifier		VARCHAR(24)='',
@DebitProductTypeId				INT=0,
@DebitCurrencyId				VARCHAR(24)='',
@CreditProductBankIdentifier	VARCHAR(24)='',
@CreditProductTypeId			INT=0,
@CreditCurrencyId				VARCHAR(24)='',
@DestinationBankRoutingNumber	VARCHAR(24)='',
@AuthorizationCode				VARCHAR(24)='',
@DocumentNumber					VARCHAR(24)='',
@DocumentType					INT=0,
@CancelCheckReasonCode			VARCHAR(32)=''
AS
BEGIN

--#region Documentaci�n INPUT
	/*
	FeatureId						int			Identificador de la funcionalidad seg�n cat�logo Features.
	TransactionTypeId				int			Identificador de la transacci�n seg�n cat�logo TransactionTypes.
	SubTransactionTypeId			int			Identificador del sub tipo de transacci�n seg�n cat�logo TransactionSubTypes.
	ValueDate						DateTime?	Fecha valor de la transacci�n.
	ClientBankIdentifier			string		Identificador interno del Cliente en el backend.
	CurrencyId						string		Identificador de la moneda de la transacci�n seg�n cat�logo Currencies.
	Amount							decimal		Monto de la transacci�n.
	DebitProductBankIdentifier		string		Identificador interno del producto a debitar en el backend
	DebitProductTypeId				int			Tipo de producto a debitar seg�n cat�logo ProductTypes.
	DebitCurrencyId					string		Identificador de la moneda del producto a debitar seg�n cat�logo Currencies.
	CreditProductBankIdentifier		string		Identificador interno del producto a acreditar en el backend
	CreditProductTypeId				int			Tipo de producto a acredidat seg�n cat�logo ProductTypes.
	CreditCurrencyId				string		Identificador de la moneda del producto a acreditar seg�n cat�logo Currencies.
	DestinationBankRoutingNumber	string		C�digo de ruta de la instituci�n destino de la transacci�n.
	AuthorizationCode				string		C�digo de autorizaci�n para acceder a un costo diferencial en caso de que corresponda.
	UserDocumentId					DocumentId	Tipo (seg�n DocumentType) y n�mero de documento de identidad del Usuario que ejecuta la transacci�n
	DocumentNumber
	DocumentType
	CancelCheckReasonCode			string		Raz�n de cancelaci�n de cheques (solo v�lido para funcionalidad de cancelaci�n de cheques).
	*/
--#endregion Documentaci�n

--#region Documetaci�n OUTPUT
	/*
	CostAmount		decimal	Monto indicando el costo de la transacci�n.
	CostCurrencyId	string	Identificador de la moneda seg�n el cat�logo Currencies, del monto que indica el costo de la transacci�n.
	*/
--#endregion Documetaci�n OUTPUT

SELECT 
 [CostAmount]		= 1
,[CostCurrencyId]	= '484'


END

GO

/* FILE: 62 pBKGgetTransactionCost.sql    */



GO

/* FILE: 72 pBKGinsertMassiveTransaction.sql    */

-- 72 pBKGinsertMassiveTransaction

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGinsertMassiveTransaction')
BEGIN
	DROP PROC pBKGinsertMassiveTransaction
	SELECT 'pBKGinsertMassiveTransaction BORRADO' AS info
END

GO

/* FILE: 72 pBKGinsertMassiveTransaction.sql    */

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
						SET @SubTransactionTypeId = 2	--Transferencias a cuentas de terceros en la instituci�n
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
				

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operaci�n Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion
				
					COMMIT TRAN 

				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operaci�n Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion

				END CATCH				
			END

			IF(@SubTransactionTypeId=2) -- 2	Transferencias a cuentas de terceros en la instituci�n
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

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operaci�n Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion

					COMMIT TRAN

				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operaci�n Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion


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

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operaci�n Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion
				
					COMMIT TRAN 

				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN 

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operaci�n Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion
			
				END CATCH	
			END

			IF(@SubTransactionTypeId=10) -- 10	Pago de pr�stamo de terceros
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


					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 0,BackendMessage = 'Operaci�n Exitosa', BackendReference = '', BackendCode = '0001', TransactionIdentity = @IdOperacion,IdOperacion= @IdOperacion,Alta =GETDATE(),IdEstatus = 82 WHERE IdPeticion = @IdPeticion
				
					COMMIT TRAN 

					
				END TRY	
				BEGIN CATCH

					IF(@@TRANCOUNT <> 0)
						ROLLBACK TRAN 

					UPDATE dbo.tBKGbackendOperationItemResult SET IsError = 1,BackendMessage = 'Operaci�n Fallida', BackendReference = 'ERROR_MESSAGE()', BackendCode = '0099', TransactionIdentity = -1,Alta =GETDATE() WHERE IdPeticion = @IdPeticion

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
		SELECT 0 IsError,'Aplicaci�n de movimientos parcial' BackendMessage,CONCAT('Se aplicaron ',@PeticionesProcesadas, ' de ', @TotalPeticiones) BackendReference, '0001' BackendCode,@TransactionId TransactionIdentity;

	IF(@PeticionesProcesadas = 0)
		SELECT 1 IsError,'Movimientos No Aplicados' BackendMessage,CONCAT('Se aplicaron ',@PeticionesProcesadas, ' de ', @TotalPeticiones) BackendReference, '0001' BackendCode,-1 TransactionIdentity;

END
GO
GO

/* FILE: 86 pBKGgetTransactionVoucher.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetTransactionVoucher')
BEGIN
	DROP PROC pBKGgetTransactionVoucher
	SELECT 'pBKGgetTransactionVoucher BORRADO' AS info
END

GO

/* FILE: 86 pBKGgetTransactionVoucher.sql    */

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON

GO

/* FILE: 86 pBKGgetTransactionVoucher.sql    */
CREATE PROCEDURE pBKGgetTransactionVoucher
@TransactionVoucherIdentifier VARCHAR(50) = '',
@RazonSocial VARCHAR(128) = '' OUTPUT
AS 
BEGIN

	SELECT @RazonSocial = per.Nombre FROM dbo.tCTLsucursales suc  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLempresas emp  WITH(NOLOCK)  ON emp.IdEmpresa = suc.IdEmpresa
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = emp.IdPersona
	WHERE suc.EsMatriz = 1

	SELECT op.Fecha Fecha,
       CONVERT(VARCHAR, op.Alta, 108) Hora,
       boir.TransactionIdentity IdTransaccionBKG,
       op.Folio IdOperacionErprise,
       pimt.DebitProductBankIdentifier NocuentaOrigen,
       'Retiro' OperacionOrigen,
       pimt.Amount MontoOrigen,
       pimt.CreditProductBankIdentifier NoCuentaDestino,
       'Deposito' OperacionDestino,
       pimt.Amount MontoDestino
FROM dbo.tGRLoperaciones op WITH (NOLOCK)
left JOIN dbo.tBKGbackendOperationItemResult boir WITH (NOLOCK)
	ON op.IdOperacion = boir.IdOperacion
left JOIN dbo.tBKGpeticionesInsertMasiveTransaction pimt WITH (NOLOCK)
	ON boir.IdPeticion = pimt.IdPeticion
WHERE op.Folio = @TransactionVoucherIdentifier;


END 

GO

/* FILE: 86 pBKGgetTransactionVoucher.sql    */

GO

/* FILE: 99.1 pBKGgetMassiveTransactionBackEndInformation.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetMassiveTransactionBackEndInformation')
BEGIN
	DROP PROC pBKGgetMassiveTransactionBackEndInformation
	SELECT 'pBKGgetMassiveTransactionBackEndInformation BORRADO' AS info
END

GO

/* FILE: 99.1 pBKGgetMassiveTransactionBackEndInformation.sql    */

CREATE PROCEDURE [dbo].[pBKGgetMassiveTransactionBackEndInformation]
	@TransactionBackEndReference VARCHAR(20) = ''
AS
BEGIN
	SELECT imt.Amount Amount,
		   oir.BackendMessage BusinessMessage,
		   oir.BackendCode,
		   oir.BackendReference,
		   oir.Alta ExecutionDate,
		   IIF(oir.IsError = 1,0,1) ExecutedSuccesfully,
		   IIF(op.IdEstatus = 18,1,0) IsCanceled,
		   imt.ValueDate,
		   imt.ExchangeRate ExchangeRateTransaction,
		   imt.ExchangeRate ExchangeRateUSD
		   
	FROM dbo.tBKGbackendOperationItemResult oir  WITH(NOLOCK)  
	INNER JOIN dbo.tBKGpeticionesInsertMasiveTransaction imt  WITH(NOLOCK)  ON imt.IdPeticion = oir.IdPeticion
	LEFT JOIN dbo.tGRLoperaciones op  WITH(NOLOCK)  ON op.IdOperacion = oir.TransactionIdentity
	WHERE imt.TransactionId = @TransactionBackEndReference
END 
GO
GO

/* FILE: 99.2 pAYCcaptacion.sql    */



IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcaptacion')
BEGIN
	DROP PROC pAYCcaptacion
	SELECT 'pAYCcaptacion BORRADO' AS info
END

GO

/* FILE: 99.2 pAYCcaptacion.sql    */

CREATE PROC pAYCcaptacion
AS
BEGIN
	
	DECLARE @fecha AS DATE=DATEADD(DAY,-1,GETDATE());
	DECLARE @alta AS DATETIME=GETDATE();
	DECLARE @inicioDeAnio DATE= DATEFROMPARTS(YEAR(@fecha), 1, 1)

	DELETE FROM dbo.tAYCcaptacion WHERE fecha<@inicioDeAnio

	IF EXISTS(SELECT 1 FROM tAYCcaptacion c  WITH(NOLOCK) WHERE c.fecha=@fecha)
		DELETE FROM dbo.tAYCcaptacion WHERE fecha=@fecha


	INSERT INTO dbo.tAYCcaptacion
	(
		Fecha,
		IdTipoDproducto,
	    IdCuenta,
	    IdSaldo,
	    Capital,
	    InteresOrdinario,
	    InteresPendienteCapitalizar,
	    MontoBloqueado,
	    MontoDisponible,
	    Saldo,
	    SaldoBalanceCuentasOrden,
	    IdEstatus,
		Alta
	)
	SELECT @fecha,
		   c.IdTipoDProducto,
		   sdo.IdCuenta,
           sdo.IdSaldo,
           sdo.Capital,
           sdo.InteresOrdinario,
           sdo.InteresPendienteCapitalizar,
           sdo.MontoBloqueado,
           sdo.MontoDisponible,
           sdo.Saldo,
           sdo.SaldoBalanceCuentasOrden,
           sdo.IdEstatus,
		   @alta
	FROM dbo.fAYCsaldo(0) sdo 
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = sdo.IdCuenta 
	AND c.IdTipoDProducto IN (144,398)
	WHERE sdo.IdCuenta<>0
	
END

GO

/* FILE: 99.2 pAYCcaptacion.sql    */



GO

/* FILE: 99.3 vBKG_FMTticketTransaccion.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vBKG_FMTticketTransaccion')
BEGIN
	DROP VIEW vBKG_FMTticketTransaccion
	SELECT 'vBKG_FMTticketTransaccion BORRADO' AS info
END

GO

/* FILE: 99.3 vBKG_FMTticketTransaccion.sql    */

CREATE VIEW [dbo].[vBKG_FMTticketTransaccion]
AS
SELECT	Persona.Nombre,
		Saldo.Codigo,
		Saldo.Descripcion,
		Operacion	= TipoOp.Descripcion,
		Transaccion.Concepto,
		Transaccion.Referencia,
		Monto = CASE WHEN Transaccion.Naturaleza = 1 THEN 
					Transaccion.TotalCargos 
				ELSE 
					Transaccion.TotalAbonos 
				END,
		Transaccion.IdOperacion,
		Transaccion.IdTransaccion

FROM	tGRLoperaciones		Operacion	WITH (NOLOCK) INNER JOIN
		tSDOtransacciones	Transaccion	WITH (NOLOCK) ON Operacion.IdOperacion = Transaccion.IdOperacion INNER JOIN
		tSDOsaldos			Saldo		WITH (NOLOCK) ON Saldo.IdSaldo = Transaccion.IdSaldoDestino INNER JOIN
		tGRLpersonas		Persona		WITH (NOLOCK) ON Persona.IdPersona = Saldo.IdPersona INNER JOIN
		tCTLtiposOperacion	TipoOp		WITH (NOLOCK) ON TipoOp.IdTipoOperacion = Transaccion.IdTipoSubOperacion 

WHERE	--Operacion.IdTipoOperacion in (1,71) and 
NOT Saldo.IdCuentaABCD = Operacion.IdCuentaABCD AND Transaccion.IdEstatus = 1
	

GO
GO

/* FILE: 99.4 VOUCHER fFMTticketTransaccionFinancieraBKG.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fFMTticketTransaccionFinancieraBKG')
BEGIN
	DROP FUNCTION fFMTticketTransaccionFinancieraBKG
	SELECT 'fFMTticketTransaccionFinancieraBKG BORRADO' AS info
END

GO

/* FILE: 99.4 VOUCHER fFMTticketTransaccionFinancieraBKG.sql    */

CREATE FUNCTION fFMTticketTransaccionFinancieraBKG
(
	
	@IdOperacion  AS INT =0
)
RETURNS TABLE
AS
RETURN

(
SELECT SocioCodigo = Socio.Codigo,
       Cuenta = Cuenta.Codigo,
       Descripcion = Producto.Descripcion,
       Operacion = TipoOp.Descripcion,
       Socio = Persona.Nombre,
       Monto = CASE
                   WHEN TF.Naturaleza = 1 THEN
                       TF.TotalCargos
                   ELSE
                       TF.TotalAbonos
               END,
       TF.IdOperacion,
       TF.IdTipoSubOperacion,
       TF.IdEstatus,
       TF.CargosPagados,
       (TF.CapitalPagado + TF.CapitalPagadoVencido) AS CapitalPagado,
       (TF.InteresOrdinarioPagado + TF.InteresOrdinarioPagadoVencido) AS InteresOrdinarioPagado,
       (TF.InteresMoratorioPagado + TF.InteresMoratorioPagadoVencido) AS InteresMoratorioPagado,
       TF.IVAPagado,
       Cuenta.IdTipoDProducto,
       FechaSiguientePago = ISNULL(estadisticaSiguientePago.FechaSiguientePago,''),
       TF.SaldoCapital AS Saldo,
       TF.SaldoCapitalAnterior AS SaldoAnterior,
	   tf.SaldoAnterior AS SalAnteriorConInteres,
	   tf.Saldo AS SaldoConIntereses,
       TF.Fecha,
       sucsoc.Descripcion AS Sucursal,
	   Cuenta.IdCuenta,
	   TF.IdTransaccion
FROM tSDOtransaccionesFinancieras TF WITH (NOLOCK)
INNER JOIN dbo.tSDOtransaccionesFinancierasEstadisticas tfEstadisticas WITH (NOLOCK) ON tfEstadisticas.IdTransaccion = TF.IdTransaccion
LEFT JOIN dbo.tSDOestadisticasSiguientePago estadisticaSiguientePago ON estadisticaSiguientePago.IdTransaccion = tfEstadisticas.IdTransaccion
INNER JOIN tAYCcuentas Cuenta WITH (NOLOCK) ON Cuenta.IdCuenta = TF.IdCuenta
INNER JOIN tCTLtiposOperacion TipoOp WITH (NOLOCK) ON TipoOp.IdTipoOperacion = TF.IdTipoSubOperacion
	AND NOT (TipoOp.IdTipoOperacion IN ( 503, 4 ))
INNER JOIN tSCSsocios Socio WITH (NOLOCK) ON Socio.IdSocio = Cuenta.IdSocio
INNER JOIN tGRLpersonas Persona WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
INNER JOIN tAYCproductosFinancieros Producto WITH (NOLOCK) ON Producto.IdProductoFinanciero = Cuenta.IdProductoFinanciero
INNER JOIN tCTLsucursales sucsoc WITH (NOLOCK) ON sucsoc.IdSucursal = Socio.IdSucursal
WHERE TF.IdEstatus IN ( 1, 25, 31 ) and TF.IdOperacion=@IdOperacion AND @IdOperacion <> 0

)

GO

/* FILE: 99.4 VOUCHER fFMTticketTransaccionFinancieraBKG.sql    */


GO

/* FILE: 99.5 VOUCHER vFMTticketBKG.sql    */


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vFMTticketBKG')
BEGIN
	DROP VIEW vFMTticketBKG
	SELECT 'vFMTticketBKG BORRADO' AS info
END

GO

/* FILE: 99.5 VOUCHER vFMTticketBKG.sql    */

CREATE VIEW dbo.vFMTticketBKG
	as
SELECT	

		IdOperacion			= Operacion.IdOperacion, 
		IdSucursal			= Operacion.IdSucursal, 
		[Razon Social]		= PersonaEmpresa.Nombre,
		[Nombre Comercial]	= Empresa.NombreComercial , 
		[Codigo Sucursal]	= Sucursal.codigo,
		Sucursal			= sucursal.Descripcion , 
		Caja				= Ventanilla.Descripcion, 
		Codigo              = Ventanilla.Codigo,
		Operacion.Serie, 
		Operacion.Folio, 
        SerieFolio			= Operacion.Serie + CAST(Operacion.Folio AS VARCHAR) , 
		Operacion.Fecha,		
		Operacion.Concepto, 
		Operacion.Referencia,
		Operacion			= CASE WHEN Total < 0 THEN 
										'Retiro' 
										WHEN total = 0 THEN 
										'----' 
										ELSE 
										'Dep�sito' 
								END , 
		Total = ABS(Operacion.Total) , 
		Usuario = PersonaFisica.Nombre + ' ' + PersonaFisica.ApellidoPaterno + ' ' + PersonaFisica.ApellidoMaterno,
		Operacion.IdEstatus, 
		Operacion.IdUsuarioAlta,
		Operacion.IdCuentaABCD, 
		Operacion.IdTipoOperacion, 
		(sucursal.DomicilioCalle + ', No. ' +sucursal.DomicilioNumeroExterior + iif(sucursal.DomicilioNumeroInterior<>'', 'Int. ' + sucursal.DomicilioNumeroInterior, '') + 
		' C.P. ' + sucursal.DomicilioCodigoPostal + iif(sucursal.DomicilioCiudad<>'', ', ' + sucursal.DomicilioCiudad, '') + ', ' + sucursal.DomicilioEstado) AS SucursalDireccion,
		Operacion.Alta,
		Usuario.Usuario AS CodigoUsuario,
		Operacion.IdSocio AS OperacionIdSocio
FROM            dbo.tGRLoperaciones AS Operacion WITH (NOLOCK)  INNER JOIN
                dbo.tCTLtiposOperacion AS tco WITH (NOLOCK)  ON tco.IdTipoOperacion = Operacion.IdTipoOperacion LEFT JOIN
		        dbo.vCTLsucursalesGUI AS sucursal WITH (NOLOCK) ON sucursal.IdSucursal = Operacion.IdSucursal INNER JOIN
                dbo.tCTLempresas AS empresa WITH (NOLOCK) ON empresa.IdEmpresa = sucursal.IdEmpresa INNER JOIN
				tGRLpersonas as PersonaEmpresa WITH (NOLOCK) ON Empresa.IdPersona = PersonaEmpresa.IdPersona INNER JOIN
                dbo.tGRLcuentasABCD AS Ventanilla WITH (NOLOCK)  ON Ventanilla.IdCuentaABCD = Operacion.IdCuentaABCD INNER JOIN
				tCTLusuarios as Usuario WITH (NOLOCK)  ON Operacion.IdUsuarioAlta = Usuario.IdUsuario INNER JOIN
				tGRLpersonasFisicas as PersonaFisica WITH (NOLOCK)  ON Usuario.IdPersonaFisica = PersonaFisica.IdPersonaFisica

WHERE        --(Operacion.IdTipoOperacion IN(1,71)) AND 
(Operacion.IdOperacion <> 0)




GO

/* FILE: 99.5 VOUCHER vFMTticketBKG.sql    */



GO

/* FILE: 99.6 VOUCHER vFMTticketOperacionesRelacionadasDetalleBKG.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vFMTticketOperacionesRelacionadasDetalleBKG')
BEGIN
	DROP VIEW vFMTticketOperacionesRelacionadasDetalleBKG
	SELECT 'vFMTticketOperacionesRelacionadasDetalleBKG BORRADO' AS info
END

GO

/* FILE: 99.6 VOUCHER vFMTticketOperacionesRelacionadasDetalleBKG.sql    */

CREATE VIEW [dbo].vFMTticketOperacionesRelacionadasDetalleBKG
	AS
SELECT 
  Descripcion  = Detalle.DescripcionBienServicio,
  Cantidad  = Detalle.Cantidad,
  PrecioCimptos = Detalle.PrecioConImpuestos,
  Total   = Detalle.Total,
  OperacionPadre.IdOperacion,
  Operacion.RelOperaciones,
  SocioCodigo = Socio.Codigo,
  SocioNombre = Persona.Nombre    

FROM tGRLoperaciones  OperacionPadre WITH (NOLOCK) INNER JOIN
  tGRLoperaciones  Operacion         WITH (NOLOCK) ON Operacion.IdOperacionPadre = OperacionPadre.IdOperacion INNER JOIN 
  tGRLoperacionesD Detalle           WITH (NOLOCK) ON Detalle.RelOperacionD = Operacion.IdOperacion INNER JOIN
  tGRLbienesServicios BienServicio   WITH (NOLOCK) ON BienServicio.IdBienServicio = Detalle.IdBienServicio
  INNER JOIN tSCSsocios Socio        WITH (NOLOCK) ON Socio.IdSocio = Operacion.IdSocio
  INNER JOIN tGRLpersonas Persona    WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
  
WHERE --OperacionPadre.IdTipoOperacion in (1) and 
Operacion.IdTipoOperacion in (1,17) AND Detalle.IdEstatus = 1 --AND Operacion.RelOperacionesD != 0
 

GO

/* FILE: 99.6 VOUCHER vFMTticketOperacionesRelacionadasDetalleBKG.sql    */

GO

/* FILE: 99.7 VOUCHER vFMTticketTransaccionBKG.sql    */

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vFMTticketTransaccionBKG')
BEGIN
	drop view vFMTticketTransaccionBKG
	SELECT 'vFMTticketTransaccionBKG BORRADO' AS info
END

GO

/* FILE: 99.7 VOUCHER vFMTticketTransaccionBKG.sql    */

CREATE VIEW dbo.vFMTticketTransaccionBKG
AS
SELECT	Persona.Nombre,
		Saldo.Codigo,
		Saldo.Descripcion,
		Operacion	= TipoOp.Descripcion,
		Transaccion.Concepto,
		Transaccion.Referencia,
		Monto = CASE WHEN Transaccion.Naturaleza = 1 THEN 
					Transaccion.TotalCargos 
				ELSE 
					Transaccion.TotalAbonos 
				END,
		Transaccion.IdOperacion,
		Transaccion.IdTransaccion

FROM	tGRLoperaciones		Operacion	WITH (NOLOCK) INNER JOIN
		tSDOtransacciones	Transaccion	WITH (NOLOCK) ON Operacion.IdOperacion = Transaccion.IdOperacion INNER JOIN
		tSDOsaldos			Saldo		WITH (NOLOCK) ON Saldo.IdSaldo = Transaccion.IdSaldoDestino INNER JOIN
		tGRLpersonas		Persona		WITH (NOLOCK) ON Persona.IdPersona = Saldo.IdPersona INNER JOIN
		tCTLtiposOperacion	TipoOp		WITH (NOLOCK) ON TipoOp.IdTipoOperacion = Transaccion.IdTipoSubOperacion 

WHERE	--Operacion.IdTipoOperacion in (1,71) and 
NOT Saldo.IdCuentaABCD = Operacion.IdCuentaABCD AND Transaccion.IdEstatus = 1
	


GO

/* FILE: 99.7 VOUCHER vFMTticketTransaccionBKG.sql    */



GO
