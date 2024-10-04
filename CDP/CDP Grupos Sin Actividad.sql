
DECLARE @MesesInactividad AS INT=6
DECLARE @fechaFinal AS DATE = GETDATE()
DECLARE @fechaInicial AS DATE=DATEADD(MONTH,-@MesesInactividad,@fechaFinal)

DECLARE @SociosGp AS TABLE(
	IdSucursal			INT,
	IdGrupo				INT,
	CodigoGrupo			VARCHAR(12),
	Grupo				VARCHAR(30),
	IdDomicilioReunion	INT,
	IdPersona			INT,
	IdSocio				INT,
	NoSocio				VARCHAR(20),
	Nombre				VARCHAR(250),
	Domicilio			VARCHAR(250)	
)

INSERT INTO @SociosGp
SELECT 
gp.IdSucursal,
gp.IdGrupo, gp.Codigo, gp.Descripcion ,gp.IdDomicilioReunion
, p.IdPersona, sc.IdSocio, sc.Codigo, p.Nombre,p.Domicilio
FROM dbo.tAYCgrupos gp  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = gp.IdEstatusActual
			AND ea.IdEstatus=1
INNER JOIN dbo.tAYCintegrantesAsignados sgp  WITH(NOLOCK) 
	ON sgp.IdRel = gp.IdRelIntegrantes
		AND sgp.IdEstatus=1
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = sgp.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona

--SELECT COUNT(1) FROM @SociosGp

DECLARE @SociosCuentas AS TABLE(
	IdSocio		INT
)

INSERT @SociosCuentas
SELECT -- tf.IdTransaccion, c.IdCuenta, c.IdSocio
c.IdSocio
FROM @SociosGp sc
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
	ON c.IdSocio = sc.IdSocio
LEFT JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)  
	ON c.IdCuenta = tf.IdCuenta
	AND tf.IdEstatus=1
	AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal
	AND tf.IdTransaccion IS NULL
GROUP BY c.IdSocio

--SELECT COUNT(1) FROM @SociosCuentas

SELECT sg.NoSocio,sg.Nombre,sg.Domicilio,
sg.CodigoGrupo,sg.Grupo,
[SucursalGrupo]	= sucG.Descripcion,
[DomicilioReunion] = domG.Descripcion
FROM @SociosGp sg
INNER JOIN @SociosCuentas sc 
	ON sc.IdSocio = sg.IdSocio
LEFT JOIN dbo.tCTLsucursales sucG  WITH(NOLOCK) 
	ON sucG.IdSucursal=sg.IdSucursal
LEFT JOIN dbo.tCATdomicilios domG  WITH(NOLOCK) 
	ON domG.IdDomicilio = sg.IdDomicilioReunion
ORDER BY sg.Nombre

