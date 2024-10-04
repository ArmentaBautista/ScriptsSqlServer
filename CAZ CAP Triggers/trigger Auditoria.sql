

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='trAuditarPedidos')
BEGIN
	DROP TRIGGER trAuditarPedidos
	SELECT 'trAuditarPedidos BORRADO' AS info
END
GO

CREATE TRIGGER trAuditarPedidos
ON tVentasPedidos
AFTER INSERT
AS
BEGIN
	IF (SELECT INSERTED.Monto FROM INSERTED)=0
	begin	
		THROW 50005, N'ERROR MONTO', 1;
		RETURN
	END
	ELSE
    BEGIN
		
		INSERT INTO tAuditoriaPedidos 
			(
			Fecha, 
			Detalles
			)
			SELECT 
			GETDATE(), 
			'Pedido ID: ' + CAST(INSERTED.IdPedido AS NVARCHAR(10)) + ' Producto: ' + INSERTED.Producto
			FROM INSERTED
    END
    

END
GO
