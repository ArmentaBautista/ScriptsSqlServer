
USE intelixDEV
GO


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCproductosFinalidades')
BEGIN
	SELECT 'tAYCproductosFinalidades Ya Existe' AS info
	GOTO Salida
END


CREATE TABLE dbo.tAYCproductosFinalidades(
				IdProducto	INT NOT NULL FOREIGN KEY REFERENCES dbo.tAYCproductosFinancieros(IdProductoFinanciero),	
				IdFinalidad	int	NOT NULL FOREIGN KEY REFERENCES dbo.tAYCfinalidades(IdFinalidad),		
				IdEstatus	int	NOT NULL FOREIGN KEY REFERENCES dbo.tCTLestatus(IdEstatus)		
)

SELECT 'tAYCproductosFinalidades Creada' AS info

Salida: