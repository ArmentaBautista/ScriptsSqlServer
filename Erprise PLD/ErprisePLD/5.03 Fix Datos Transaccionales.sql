


DECLARE @FechaInicial AS DATE='20230101'
DECLARE @FechaFinal AS DATE='20231231'

-- Tabla de financieras
DECLARE @tf AS TABLE(
	IdSocio				INT,
	IdCuenta			int,
	IdTipoSubOperacion	int,
	MontoSubOperacion	numeric(13,2)
)

INSERT INTO @tf
SELECT 
c.IdSocio, c.IdCuenta,tf.IdTipoSubOperacion, tf.MontoSubOperacion
FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
	ON op.IdOperacion = tf.IdOperacion
		AND op.IdTipoOperacion IN (1,10)
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdCuenta = tf.IdCuenta
WHERE tf.IdTipoSubOperacion IN (500,501)
	AND tf.Fecha BETWEEN @FechaInicial AND @FechaFinal


-- Tabla de Socios
DECLARE @socios AS TABLE(
	IdPersona			INT,
	Idsocio				INT,
	IdSocioeconomico	INT
)

INSERT INTO @socios
SELECT
p.IdPersona, sc.IdSocio, p.IdSocioeconomico
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN (
		SELECT IdSocio FROM @tf GROUP BY IdSocio
) tf ON tf.Idsocio = sc.IdSocio

-- Tabla totales operaciones
DECLARE @totales AS TABLE(
	IdSocio				INT,
	NumTotalDepositos	NUMERIC(13,2),
	NumTotalRetiros		NUMERIC(13,2),
	SumaDepositos		NUMERIC(13,2),
	SumaRetiros			NUMERIC(13,2)
)

INSERT @totales
SELECT 
tf.IdSocio,
SUM(IIF(tf.IdTipoSubOperacion=500,1,0)) AS NumTotalDepositos,
SUM(IIF(tf.IdTipoSubOperacion=501,1,0)) AS NumTotalRetiros,
SUM(IIF(tf.IdTipoSubOperacion=500,tf.MontoSubOperacion,0)) AS SumaDepositos,
SUM(IIF(tf.IdTipoSubOperacion=501,tf.MontoSubOperacion,0)) AS SumaRetiros
FROM @tf tf  
GROUP BY tf.IdSocio

SELECT
soc.IdSocioeconomico, sc.Idsocio,sc.IdPersona
,soc.NumeroDepositos,t.NumTotalDepositos
,soc.NumeroRetiros,t.NumTotalRetiros
,soc.MontoDepositos,t.SumaDepositos
,soc.MontoRetiros, t.SumaRetiros
FROM @socios sc 
INNER JOIN dbo.tSCSpersonasSocioeconomicos soc  WITH(NOLOCK) 
	ON soc.IdSocioeconomico = sc.IdSocioeconomico
		AND soc.IdSocioeconomico<>0
INNER JOIN @totales t
	ON t.IdSocio=sc.Idsocio
ORDER BY sc.Idsocio

	--4834
	