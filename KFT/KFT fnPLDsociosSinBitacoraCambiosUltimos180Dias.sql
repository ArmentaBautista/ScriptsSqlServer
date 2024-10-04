
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnPLDsociosSinBitacoraCambiosUltimos180Dias')
BEGIN
	DROP FUNCTION fnPLDsociosSinBitacoraCambiosUltimos180Dias
	SELECT 'fnPLDsociosSinBitacoraCambiosUltimos180Dias BORRADO' AS info
END
GO

CREATE FUNCTION fnPLDsociosSinBitacoraCambiosUltimos180Dias()
RETURNS @sociosNOActualizados TABLE(
				idSocio INT PRIMARY KEY,
				Sucursal VARCHAR(50) NULL,
				NoSocio VARCHAR(20) NULL,
				Nombre VARCHAR(70) NULL
)
AS
BEGIN

	DECLARE @sociosActualizados TABLE
				(
					idSocio INT PRIMARY KEY
				)

	INSERT INTO @sociosActualizados (idSocio)
	SELECT b.IdRegistro
	FROM dbo.tADMbitacora b  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = b.IdRegistro
												AND sc.EsSocioValido=1
												and sc.IdEstatus=1
												AND DATEDIFF(DAY,sc.AltaSocio,GETDATE())>365
	WHERE b.Tabla IN ('tSCSsocios')
	AND b.Usuario='erpUSER'
	AND DATEDIFF(DAY,b.Fecha,GETDATE())<=180
	GROUP BY b.IdRegistro

	INSERT INTO @sociosActualizados (idSocio)
	SELECT sc.IdSocio
	FROM dbo.tADMbitacora b  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdPersona = b.IdRegistro
												AND sc.EsSocioValido=1
												and sc.IdEstatus=1
												AND DATEDIFF(DAY,sc.AltaSocio,GETDATE())>365
	WHERE b.Tabla IN ('tGRLpersonas','tGRLpersonasFisicas','tGRLpersonasMorales')
	AND b.Usuario='erpUSER'
	AND DATEDIFF(DAY,b.Fecha,GETDATE())<=180
	AND NOT EXISTS (SELECT idSocio FROM @sociosActualizados s WHERE s.IdSocio=sc.IdSocio)
	GROUP BY sc.IdSocio

	
	/*
	-- actualizados
	SELECT suc.Descripcion AS Sucursal, scAlerta.Codigo AS Nosocio, per.Nombre  
	FROM dbo.tSCSsocios scAlerta  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = scAlerta.IdPersona
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = scAlerta.IdSucursal
	INNER JOIN @sociosActualizados s ON s.idSocio=scAlerta.IdSocio
	WHERE scAlerta.IdEstatus=1 AND scAlerta.EsSocioValido=1
	ORDER BY suc.Descripcion, per.Nombre
	*/

	-- Para alerta
	INSERT INTO @sociosNOActualizados(IdSocio,Sucursal,NoSocio,Nombre)
	SELECT scAlerta.IdSocio --, suc.IdSucursal, per.IdPersona
	,suc.Descripcion AS Sucursal, scAlerta.Codigo AS Nosocio, per.Nombre  
	FROM dbo.tSCSsocios scAlerta  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = scAlerta.IdPersona
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = scAlerta.IdSucursal
	WHERE scAlerta.IdEstatus=1 AND scAlerta.EsSocioValido=1
	AND NOT EXISTS (SELECT s.idSocio FROM @sociosActualizados s WHERE s.idSocio=scAlerta.IdSocio)
	ORDER BY suc.Descripcion, per.Nombre
	
	RETURN
END