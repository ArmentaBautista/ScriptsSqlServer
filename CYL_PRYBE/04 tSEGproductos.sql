

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tSEGproductos')
BEGIN
	CREATE TABLE [dbo].[tSEGproductos]
	(
		IdProducto		 		INT NOT NULL PRIMARY KEY IDENTITY,
		IdProductoFinanciero	INT NOT NULL ,
		Producto				VARCHAR(250),
		Dias					SMALLINT,
		LimiteInferior			NUMERIC(15,2),
		LimiteSuperior			NUMERIC(15,2),
		IdEstatus 				INT NOT NULL DEFAULT 1
	)
	SELECT 'Tabla Creada tSEGproductos' AS info
	
	ALTER TABLE dbo.tSEGproductos 
	ADD CONSTRAINT FK_tSEGproductos_IdProductoFinanciero
	FOREIGN KEY (IdProductoFinanciero) REFERENCES dbo.tAYCproductosFinancieros (IdProductoFinanciero)

END
ELSE 
	-- DROP TABLE tSEGproductos
	SELECT 'tSEGproductos Existe'
GO



