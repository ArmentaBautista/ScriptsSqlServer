
-- Select * from tBKGcatalogoThirdPartyProductTypes

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoThirdPartyProductTypes')
BEGIN
	CREATE TABLE tBKGcatalogoThirdPartyProductTypes
	(
		ProductTypeId		INT				PRIMARY KEY,
		ProductTypeName		VARCHAR(64)		NOT NULL,
		Descripcion			VARCHAR(128)	NOT NULL
	) 

	SELECT 'Tabla Creada tBKGcatalogoThirdPartyProductTypes' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoThirdPartyProductTypes
	SELECT 'tBKGcatalogoThirdPartyProductTypes Existe'
GO

IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoThirdPartyProductTypes t  WITH(NOLOCK) 
			WHERE t.ProductTypeId IN (1,2,3,4,5))
BEGIN	
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   1,  'Local', 'Dentro de la institución')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   2,  'Country', 'Fuera de la institución y dentro del país')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   3,  'Foreign', 'Fuera de la institución y fuera del país')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   4,  'LBTR', 'Para operaciones a través del Banco Central (LBTR, SINPE)')
		
		INSERT INTO dbo.tBKGcatalogoThirdPartyProductTypes (ProductTypeId,ProductTypeName,Descripcion)
		VALUES (   5,  'Wallet (de uso interno)', 'Para Billetera Electrónica')
		
END
GO

SELECT * FROM dbo.tBKGcatalogoThirdPartyProductTypes
GO

