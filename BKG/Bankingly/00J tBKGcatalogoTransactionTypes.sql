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


