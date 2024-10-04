

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tAuditoriaPedidos')
BEGIN

		CREATE TABLE tAuditoriaPedidos 
		(
			Id			INT IDENTITY(1,1) PRIMARY KEY,
			Fecha		DATETIME,
			Detalles	VARCHAR(MAX)
		)

		SELECT 'Tabla Creada tAuditoriaPedidos' AS info
END
ELSE 
	-- DROP TABLE tAuditoriaPedidos
	SELECT 'tAuditoriaPedidos Existe'
GO
