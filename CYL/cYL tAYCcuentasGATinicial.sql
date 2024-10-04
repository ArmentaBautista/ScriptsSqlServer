
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAYCcuentasGATinicial')
BEGIN
	CREATE TABLE [dbo].[tAYCcuentasGATinicial]
	(
		IdCuenta			INT NOT NULL, 
		GATinicial			NUMERIC(23,8) NOT NULL,
		Alta				DATETIME NOT NULL DEFAULT GETDATE()
	) ON [PRIMARY]

	SELECT 'Tabla Creada tAYCcuentasGATinicial' AS info
	
	ALTER TABLE dbo.tAYCcuentasGATinicial 
	ADD CONSTRAINT FK_tAYCcuentasGATinicial_IdCuenta 
	FOREIGN KEY (IdCuenta) REFERENCES dbo.tAYCcuentas (IdCuenta)
	
END
ELSE 
	-- DROP TABLE tAYCcuentasGATinicial
	SELECT 'tAYCcuentasGATinicial Existe'
GO

