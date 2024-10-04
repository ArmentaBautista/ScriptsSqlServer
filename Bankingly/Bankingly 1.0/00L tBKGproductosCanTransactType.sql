
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





