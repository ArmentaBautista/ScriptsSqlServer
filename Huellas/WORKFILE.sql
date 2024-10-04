-- TRUNCATE TABLE tAYCsociosHuellas


SELECT * FROM dbo.tAYCsociosHuellas h0  WITH(NOLOCK) 

DECLARE @Id AS INT=1
DECLARE @nosocio AS VARCHAR(20)
DECLARE @huella AS VARBINARY(max)

SELECT @nosocio=h.NoSocio, @huella=h.Huella FROM dbo.tAYCsociosHuellas h  WITH(NOLOCK) 
WHERE h.Id=@Id

SELECT * FROM dbo.tAYCsociosHuellas h2  WITH(NOLOCK) 
WHERE h2.NoSocio=@nosocio AND h2.Huella=@huella


