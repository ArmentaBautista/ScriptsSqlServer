
IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE NAME='tSEGproductosDias')
BEGIN
	CREATE TABLE [dbo].[tSEGproductosDias]
	(
		IdProductoFinanciero	INT NOT NULL,
		Dias					SMALLINT,
		IdEstatus 				INT NOT NULL DEFAULT 1
	) ON [PRIMARY]
	SELECT 'Tabla Creada tSEGproductosDias' AS info
	
END
ELSE 
	-- DROP TABLE tSEGproductosDias
	SELECT 'tSEGproductosDias Existe'
GO