


USE iERP_DRA_VAL
go

DECLARE @huella AS VARBINARY(max);
DECLARE @huella2 AS VARBINARY(max);

SELECT @huella= hh.Huella 
FROM  [IxDigitalPersona].dbo.tAYCsociosHuellas hh  WITH(NOLOCK) 
WHERE hh.NoSocio='1608-10-22628' AND hh.NumeroDedo=9


SELECT @huella2=h.HuellaDigital -- sc.Codigo AS NoSocio, p.Nombre, h.NumeroHuella, h.HuellaDigital
FROM tscssocios sc  WITH(NOLOCK) 
INNER JOIN tgrlpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
INNER JOIN dbo.tPERhuellasDigitalesPersona h  WITH(NOLOCK) ON h.RelHuellasDigitalesPersona=pf.RelHuellasDigitalesPersona
WHERE p.Nombre LIKE '%ismael duran%' AND h.NumeroHuella=10

IF @huella=@huella2
	SELECT 'Iguales'
ELSE
	SELECT 'Diferentes'


