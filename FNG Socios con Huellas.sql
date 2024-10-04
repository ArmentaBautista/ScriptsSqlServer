

DECLARE @huellas AS TABLE(
	RelHuellasDigitalesPersona INT,
	NumHuellas INT
)

INSERT INTO @huellas (RelHuellasDigitalesPersona,NumHuellas)
SELECT RelHuellasDigitalesPersona, COUNT(1) AS NumHuellas
FROM dbo.tPERhuellasDigitalesPersona h  WITH(NOLOCK) 
WHERE h.IdEstatus=1
GROUP BY h.RelHuellasDigitalesPersona

DECLARE @sociosActivos AS TABLE
(
	IdPersona INT,
	IdSocio INT,
	EsSocioValido BIT,
	RelHuellasDigitalesPersona INT
)

INSERT INTO @sociosActivos (IdPersona,IdSocio,EsSocioValido,RelHuellasDigitalesPersona)
SELECT sc.IdPersona, idsocio, EsSocioValido, pf.RelHuellasDigitalesPersona 
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
WHERE sc.IdEstatus=1


DECLARE @numSociosActivos AS DECIMAL = (SELECT COUNT(1) FROM @sociosActivos WHERE EsSocioValido=1)
DECLARE @numSociosConHuella AS DECIMAL

SELECT @numSociosConHuella=COUNT(1) 
FROM @sociosActivos sc  
INNER JOIN @huellas h ON h.RelHuellasDigitalesPersona = sc.RelHuellasDigitalesPersona
					AND sc.RelHuellasDigitalesPersona!=0

select 
SociosValidos	= @numSociosActivos,
SociosConHuella	= @numSociosConHuella,  
Pocentaje		= @numSociosConHuella/@numSociosActivos




