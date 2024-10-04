
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

