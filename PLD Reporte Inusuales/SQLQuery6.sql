

USE iERP_CYL_REG
GO


SELECT * FROM iERP_CYL.dbo.tctlperiodos p  WITH(NOLOCK) WHERE p.codigo='2024-04'


SELECT  * 
FROM dbo.tPLDoperacionesInusuales i  WITH(NOLOCK) 
WHERE i.IdPeriodo=315
AND id=360


--UPDATE i 
--SET i.NumeroCuenta='0120091102', i.Monto=691384.07000000, i.TipoOperacion='01' FROM dbo.tPLDoperacionesInusuales i WHERE i.Folio='000006'


