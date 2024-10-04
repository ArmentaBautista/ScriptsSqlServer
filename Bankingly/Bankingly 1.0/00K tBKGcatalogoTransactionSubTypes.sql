
-- TransactionSubTypes


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoTransactionSubTypes')
BEGIN
	CREATE TABLE tBKGcatalogoTransactionSubTypes
	(
		SubTransactionTypeId	INT PRIMARY KEY,
		Descripcion				VARCHAR(128) NOT NULL,
		Description				VARCHAR(128) NOT NULL
	) 

	SELECT 'Tabla Creada tBKGcatalogoTransactionSubTypes' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoTransactionSubTypes
	SELECT 'tBKGcatalogoTransactionSubTypes Existe'
GO

-- Registros iniciales
IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoTransactionSubTypes t  WITH(NOLOCK) 
			WHERE t.SubTransactionTypeId IN (0,1,2,3,4,6,7,8,9,10,12,15,16,17,18,19,30,31,32,33,38,43,53,54))
BEGIN	

	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (0,'Indefinido', 'Undefined' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (1,'Transferencias cuentas propias', 'Transfer between my accounts' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (2,'Transferencias a cuentas de terceros en la institución', 'Transfer to other accounts' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (3,'Transferencias a otras instituciones', 'Transfer to other institution' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (4,'Transferencias internacionales', 'Wire transfer' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (6,'Transferencias masivas dentro de la institución', 'Bulk transfer' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (7,'Pago de servicios', 'Bill payment' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (8,'Pago de tarjetas de crédito', 'Credict card payment' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (9,'Pago de préstamo', 'Loan Payment' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (10,'Pago de préstamo de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (12,'Pago de tarjeta de crédito de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (15,'Transferencias masivas a cuentas de otras instituciones', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (16,'Transferencias directas LBTR o SINPE: Enviar Fondos', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (17,'Transferencias directas LBTR o SINPE: Recibir Fondos', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (18,'Pago de préstamos propios con cuentas de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (19,'Pago de préstamos de terceros con cuentas de terceros', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (30,'Adelanto en efectivo a cuentas propias', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (31,'Adelanto en efectivo a cuentas dentro de la institución', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (32,'Adelanto en efectivo a cuentas LBTR o SINPE', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (33,'Transferencias masivas a cuentas LBTR o SINPE', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (38,'Transferencias con Billetera Electrónica', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (43,'Pago de servicios con Tarjeta de crédito', 'Bill payment with Credit Card' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (53,'Administración de tarjetas', '' )
	INSERT INTO dbo.tBKGcatalogoTransactionSubTypes (SubTransactionTypeId,Descripcion,Description) VALUES (54,'Administración de cheques', '' )

END
go


SELECT * FROM dbo.tBKGcatalogoTransactionSubTypes
go
