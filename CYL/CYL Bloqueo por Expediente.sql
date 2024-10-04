
USE iERP_CYL_VLD
GO

DECLARE @Busqueda VARCHAR(32)='alann'
DECLARE @IdPersona INT=0
DECLARE @IdSocio INT=0

/*
	IdTipoD	Codigo	Descripcion
	1609	TSF		SERVICIOS FINANCIEROS
	1610	TMD		MEDIOS DE DISPOSICIÓN
*/

SELECT TOP 1 @IdPersona=p.idpersona, @IdSocio=sc.idsocio 
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdPersona = p.IdPersona
WHERE p.Nombre LIKE '%' + @Busqueda + '%'


SELECT p.Nombre,
t.IdTipoD, t.Codigo, t.Descripcion,
ld.IdListaD, ld.Codigo, ld.Descripcion,
montos.IdListaD, montos.Codigo, montos.Descripcion,
dep.IdListaD, dep.Codigo, dep.Descripcion,
se.*
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
LEFT JOIN dbo.tSCSpersonasSocioeconomicos se  WITH(NOLOCK) ON se.IdSocioeconomico = p.IdSocioeconomico
LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados s  WITH(NOLOCK) ON s.IdRel=se.IdRelServiciosFinancierosAsignados
LEFT JOIN dbo.tCTLtiposD t  WITH(NOLOCK) ON t.IdTipoD = s.IdTipoD
LEFT JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = s.IdListaD
LEFT JOIN dbo.tCATlistasD montos  WITH(NOLOCK) ON montos.IdListaD = se.IdListaDmontoDepositos
LEFT JOIN dbo.tCATlistasD dep  WITH(NOLOCK) ON dep.IdListaD = se.IdListaDnumeroDepositos
WHERE p.IdPersona=@IdPersona


SELECT edo.Codigo, edo.Descripcion 
FROM dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestados edo  WITH(NOLOCK) ON edo.IdEstado = pf.IdEstadoNacimiento
WHERE pf.IdPersona=@IdPersona


SELECT c.Codigo, c.Descripcion 
FROM dbo.tGRLnacionalidadesPersona np  WITH(NOLOCK) 
INNER JOIN dbo.tCTLnacionalidades c  WITH(NOLOCK) ON c.IdNacionalidad = np.IdNacionalidad 
WHERE np.IdPersona=@IdPersona


SELECT *
FROM dbo.tCTLlaborales lb  WITH(NOLOCK) 
WHERE lb.IdPersona=@IdPersona
