

-- DROP TABLE tPLDcatalogoInusualidades

IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tPLDcatalogoInusualidades')
BEGIN
	
	CREATE TABLE tPLDcatalogoInusualidades(
		IdInusualidad		INT PRIMARY KEY,
		Descripcion			VARCHAR(512) NOT NULL,
		IdEstatus			INT FOREIGN KEY REFERENCES dbo.tCTLestatus (IdEstatus) DEFAULT 1
	)

	SELECT 'tPLDcatalogoInusualidades CREADA' AS info
END
GO

-- TRUNCATE TABLE dbo.tPLDcatalogoInusualidades

INSERT INTO dbo.tPLDcatalogoInusualidades(IdInusualidad,Descripcion)
VALUES(100,  'Depósito en efectivo mayor o igual a $100,000.00')
GO

INSERT INTO dbo.tPLDcatalogoInusualidades(IdInusualidad,Descripcion)
VALUES(101, 'Depósitos en efectivo fraccionados en un mes calendario con un monto mayor o igual a $150,000.00')
GO


