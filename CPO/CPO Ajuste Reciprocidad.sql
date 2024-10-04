
USE IERP_OBL
GO

SELECT c.Reciprocidad, c.MontoReciprocidad, c.MontoSolicitado
-- UPDATE c SET c.Reciprocidad=.1, c.MontoReciprocidad=800
FROM dbo.tAYCaperturas a  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdApertura = a.IdApertura
WHERE a.Folio='164944'

