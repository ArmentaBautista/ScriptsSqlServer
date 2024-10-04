
-- ProductStatus

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoProductStatus')
BEGIN
	CREATE TABLE dbo.tBKGcatalogoProductStatus
	(
	ProductStatusId INT NOT NULL PRIMARY KEY,
	Description VARCHAR (128) NOT NULL,
	Descripcion VARCHAR (128) NOT NULL,
	IdEstatus INT NOT NULL
	) 

	ALTER TABLE dbo.tBKGcatalogoProductStatus ADD CONSTRAINT FK_tBKGcatalogoProductStatus_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
	
	SELECT 'Tabla Creada tBKGcatalogoProductStatus' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoProductStatus
	SELECT 'tBKGcatalogoProductStatus Existe'
GO



-- Registros iniciales
IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoProductStatus t  WITH(NOLOCK) WHERE t.ProductStatusId IN (0,1,2,3))
BEGIN	
		INSERT INTO tBKGcatalogoProductStatus (ProductStatusId, Description, Descripcion, IdEstatus)
		VALUES
		( 0, 'Undefined', 'Indefinido', 0 ), 
		( 1, 'Active', 'Activo', 1 ), 
		( 2, 'Deleted', 'Eliminado', 7 ), 
		( 3, 'Inactive', 'Inactivo', 3 )	
END
GO	

SELECT * FROM dbo.tBKGcatalogoProductStatus
GO	


