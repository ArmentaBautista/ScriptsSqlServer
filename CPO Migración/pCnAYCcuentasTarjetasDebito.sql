

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCcuentasTarjetasDebito')
BEGIN
	DROP PROC pCnAYCcuentasTarjetasDebito
	SELECT 'pCnAYCcuentasTarjetasDebito BORRADO' AS info
END
GO

CREATE PROC pCnAYCcuentasTarjetasDebito
AS
BEGIN

DECLARE @tarjetas TABLE(
	NumeroTarjeta			VARCHAR(12), 
	Consecutivo				VARCHAR(4),
	FinVigencia				DATE, 
	EstatusTarjeta			VARCHAR(30), 
	NoCuenta				VARCHAR(30), 
	EstatusCuenta			VARCHAR(30),
	NoSocio					VARCHAR(30),
	Nombre					VARCHAR(128)
)
                    	
INSERT INTO @tarjetas
(
    NumeroTarjeta,
    Consecutivo,
    FinVigencia,
    EstatusTarjeta,
    NoCuenta,
    EstatusCuenta,
	NoSocio,
	Nombre
)                 
SELECT 
t.NumeroTarjeta, t.Consecutivo,t.FinVigencia, e.Descripcion AS EstatusTarjeta
, cta.Codigo AS NoCuenta, eCta.Descripcion AS EstatusCuenta
,sc.Codigo
,p.Nombre
FROM dbo.tSCStarjetas t  WITH(NOLOCK)
INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
	ON e.IdEstatus = t.IdEstatus
INNER JOIN dbo.tAYCcuentas cta  WITH(NOLOCK) 
	ON cta.IdCuenta = t.IdCuenta
INNER JOIN dbo.tCTLestatus eCta  WITH(NOLOCK) 
ON eCta.IdEstatus = cta.IdEstatus
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = cta.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona=sc.IdPersona


SELECT 
	   t.NumeroTarjeta,
       t.Consecutivo,
       t.FinVigencia,
       t.EstatusTarjeta,
       t.NoCuenta,
       t.EstatusCuenta,
	   t.NoSocio,
	   t.Nombre
FROM @tarjetas t

END

GO

