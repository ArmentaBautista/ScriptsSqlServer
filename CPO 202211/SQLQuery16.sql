



DECLARE @IdSocio AS INT = 12931
DECLARE @IdPersona AS INT = 2
DECLARE @Fecha AS DATE = '20221129'


SELECT *
FROM  dbo.fAYCcalcularSaldoDeudoras2 (0, @IdSocio, @Fecha, 2)


SELECT * FROM tAYCcarteraOperacionDiaria	



EXEC dbo.pAYCcarteraOperacionDiaria	





