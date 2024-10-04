
USE ierp_cpa

SELECT c.Reciprocidad, *
-- UPDATE c SET c.Reciprocidad=0
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.Codigo='09-000052'

