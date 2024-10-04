
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGtipoMovimientoMovementTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGtipoMovimientoMovementTypes]
	(
		IdMovementType 			INT,
		IdTipoMovimiento		INT
	) 

	ALTER TABLE dbo.tBKGtipoMovimientoMovementTypes ADD FOREIGN KEY (IdMovementType) REFERENCES dbo.tBKGcatalogoMovementTypes(Id);

	SELECT 'Tabla Creada tBKGtipoMovimientoMovementTypes' AS info
	
END
ELSE 
	-- DROP TABLE tBKGtipoMovimientoMovementTypes
	SELECT 'tBKGtipoMovimientoMovementTypes Existe'
GO

