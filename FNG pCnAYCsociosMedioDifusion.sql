


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCsociosMedioDifusion')
BEGIN
	DROP PROC pCnAYCsociosMedioDifusion
	SELECT 'pCnAYCsociosMedioDifusion BORRADO' AS info
END
GO

CREATE PROC pCnAYCsociosMedioDifusion
@fechaInicio DATE='19000101',
@fechaFin DATE='19000101',
@sucursal VARCHAR(16) = '*'
AS 
BEGIN

IF @sucursal=NULL OR @sucursal=''	
BEGIN	
	SELECT 'Debe elegir una sucursal o * para Todas'
	RETURN -1
END
IF @fechaInicio='19000101'	
BEGIN	
	SELECT 'Debe elegir una fecha válida'
	RETURN -1
END
IF @fechaFin='19000101'	
BEGIN	
	SELECT 'Debe elegir una fecha válida'
	RETURN -1
END

	DECLARE @fechaTrabajo AS DATE=GETDATE();

	SELECT soc.FechaAlta, suc.Codigo AS SucursalCodigo, suc.Descripcion AS Sucursal,
	soc.Codigo AS NoSocio, p.Nombre, pf.CURP,
	CASE 
	WHEN NOT (pf.IdPersonaFisica IS NULL)
	THEN IIF(DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo)>=18,'Socio Mayor','Menor Ahorrador') 
	ELSE
		'Persona Moral'
	END AS Rol,
	ualta.Usuario AS UsuarioRegistro,
	ld.Descripcion AS MedioDifusión	
	FROM dbo.tSCSsocios soc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = soc.IdPersona
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = soc.IdSucursal 
	LEFT JOIN tSCSpersonasSocioeconomicos eco  WITH(NOLOCK) ON eco.IdSocioeconomico=p.IdSocioeconomico	
	LEFT JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = eco.IdListaDmedioDifusionEntidad
	LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
	LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
	LEFT JOIN dbo.tCTLusuarios ualta  WITH(NOLOCK) ON ualta.idusuario= soc.IdUsuarioAlta
	WHERE soc.IdEstatus=1 
	AND (suc.Codigo=@Sucursal OR @Sucursal='*')
	AND soc.FechaAlta BETWEEN @fechaInicio AND @fechaFin
	ORDER BY soc.FechaAlta,suc.IdSucursal, soc.IdSocio


END