

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tSEGproductosRangoSaldo')
BEGIN
	CREATE TABLE [dbo].[tSEGproductosRangoSaldo]
	(
		IdProductoFinanciero	INT NOT NULL,
		LimiteInferior			NUMERIC(15,2),
		LimiteSuperior			NUMERIC(15,2),
		IdEstatus 				INT NOT NULL DEFAULT 1
	) ON [PRIMARY]
	SELECT 'Tabla Creada tSEGproductosRangoSaldo' AS info
	
END
ELSE 
	-- DROP TABLE tSEGproductosRangoSaldo
	SELECT 'tSEGproductosRangoSaldo Existe'
GO

