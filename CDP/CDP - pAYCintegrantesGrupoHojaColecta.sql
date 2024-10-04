

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCintegrantesGrupoHojaColecta')
BEGIN
	DROP PROC pAYCintegrantesGrupoHojaColecta
	SELECT 'pAYCintegrantesGrupoHojaColecta BORRADO' AS info
END
GO

CREATE PROC pAYCintegrantesGrupoHojaColecta
@pGrupo AS VARCHAR(24)
AS
BEGIN
		SELECT 
		 [Sucursal]			= suc.Descripcion
		,[Grupo]			= CONCAT(gpo.Codigo,' - ',gpo.Descripcion)
		,[NoSocio]			= sc.Codigo
		,[Nombre]			= p.Nombre
		,[CompromisoAhorro]	= sc.CompromisoAhorro
		,[Ahorro]			= ''
		,[AhorroMenor]		= ''
		,[Vista]			= ''
		,[PagoCredito]		= ''
		,[Total]			= ''
		,[Firma]			= ''
		FROM dbo.tAYCgrupos gpo  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON suc.IdSucursal = gpo.IdSucursal
		INNER JOIN dbo.tAYCintegrantesAsignados i  WITH(NOLOCK) 
			ON i.IdRel=gpo.IdRelIntegrantes
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio=i.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		WHERE gpo.IdGrupo>0
			AND gpo.Codigo=@pGrupo
		ORDER BY Sucursal,Grupo

END
GO







