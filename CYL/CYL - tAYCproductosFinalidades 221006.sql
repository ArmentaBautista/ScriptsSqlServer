
IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCproductosFinalidades')
BEGIN
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYCproductosFinalidades]
(
	[IdProducto] [int] NOT NULL,
	[IdFinalidad] [int] NOT NULL,
	[IdDivision] [INT] NOT NULL,
	[IdEstatus] [int] NOT NULL
) ON [PRIMARY]


ALTER TABLE [dbo].[tAYCproductosFinalidades] 
ADD CONSTRAINT [FK_tAYCproductosFinalidades_IdEstatus] 
FOREIGN KEY ([IdEstatus]) REFERENCES [dbo].[tCTLestatus] ([IdEstatus])


ALTER TABLE [dbo].[tAYCproductosFinalidades] 
ADD CONSTRAINT [FK_tAYCproductosFinalidades_IdFinalidad] 
FOREIGN KEY ([IdFinalidad]) REFERENCES [dbo].[tAYCfinalidades] ([IdFinalidad])


ALTER TABLE [dbo].[tAYCproductosFinalidades] 
ADD CONSTRAINT [FK_tAYCproductosFinalidades_IdProducto] 
FOREIGN KEY ([IdProducto]) REFERENCES [dbo].[tAYCproductosFinancieros] ([IdProductoFinanciero])


ALTER TABLE [dbo].[tAYCproductosFinalidades] 
ADD CONSTRAINT [FK_tAYCproductosFinalidades_IdDivision] 
FOREIGN KEY ([IdDivision]) REFERENCES [dbo].[tCNTdivisiones]([IdDivision])


SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: