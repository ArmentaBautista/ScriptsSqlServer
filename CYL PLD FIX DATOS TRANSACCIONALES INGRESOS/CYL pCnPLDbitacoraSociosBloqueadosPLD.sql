

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDbitacoraSociosBloqueadosPLD')
BEGIN
	DROP PROC pCnPLDbitacoraSociosBloqueadosPLD
	SELECT 'pCnPLDbitacoraSociosBloqueadosPLD BORRADO' AS info
END
GO

CREATE PROC pCnPLDbitacoraSociosBloqueadosPLD
@pFechaInicial AS DATE='19000101',
@pFechaFinal AS DATE='19000101'
AS
BEGIN

IF @pFechaInicial='19000101' OR @pFechaFinal='19000101'
BEGIN
	SELECT 'o.O LAs fechas deben ser diferentes a 01/01/1900'
	RETURN -1
END

DECLARE @FechaInicial AS DATE=@pFechaInicial
DECLARE @FechaFinal AS DATE=@pFechaFinal

DECLARE @SociosBloqueados AS TABLE(
	IdSocio	INT,
	IdSesion	INT,
	Fecha	DATE,
	Hora	TIME

	INDEX IX_IdSocio (IdSocio)
)

INSERT INTO @SociosBloqueados
SELECT b.IdRegistro, b.IdSesion, b.Fecha, b.Hora 
FROM dbo.tADMbitacora b  WITH(NOLOCK) 
WHERE b.Tabla='tSCSsocios' 
	AND b.Campo='IdEstatus'
		AND b.ValorNuevo='105'



SELECT sc.IdSocio, sc.Codigo, sc.EsSocioValido, sc.FechaAlta, p.Nombre
,u.Usuario
,sb.Fecha,sb.Hora
,ss.Host
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN @SociosBloqueados sb		 
	ON sb.IdSocio=sc.IdSocio
INNER JOIN dbo.tCTLsesiones ss  WITH(NOLOCK) 
	ON	ss.IdSesion = sc.IdSesion
INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) 
	ON u.IdUsuario = ss.IdUsuario
WHERE sb.Fecha BETWEEN @FechaInicial AND @FechaFinal
ORDER BY sb.Fecha

END
GO
