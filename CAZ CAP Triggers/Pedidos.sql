

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tVentasPedidos')
BEGIN
	CREATE TABLE [dbo].tVentasPedidos
	(
		IdPedido 				INT NOT NULL IDENTITY,
		Producto				VARCHAR(32) NOT NULL,
		Monto					NUMERIC(15,2) NOT NULL,
		Alta					DATETIME DEFAULT GETDATE()
		
		CONSTRAINT PK_tVentasPedidos_IdPedido PRIMARY KEY(IdPedido),
		)
		
		SELECT 'Tabla Creada tVentasPedidos' AS info
END
ELSE 
	-- DROP TABLE tVentasPedidos
	SELECT 'tVentasPedidos Existe'
GO




