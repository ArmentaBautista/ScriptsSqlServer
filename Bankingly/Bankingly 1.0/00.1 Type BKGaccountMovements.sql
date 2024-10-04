

IF EXISTS (SELECT 1 FROM sys.types WHERE name = 'BKGaccountMovements')
    DROP TYPE BKGaccountMovements
GO

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

