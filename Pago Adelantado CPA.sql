

SELECT c.PermitePagoAdelantado, c.IdTipoDPagoAnticipado, c.Descripcion
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.IdTipoDProducto=143 AND c.IdEstatus=1

