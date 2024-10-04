
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDPersonasPPE')
BEGIN
	DROP PROC pCnPLDPersonasPPE
	SELECT 'pCnPLDPersonasPPE BORRADO' AS info
END
GO

CREATE PROC pCnPLDPersonasPPE
AS
BEGIN

/*
230404.0012.JCA Se rediseña Consulta que muestra las PPE sus socios relacionados y su estos son Válidos.
230417.2129.JCA Se agrega la fecha de ingreso como socio, a solicitud de Julio de FNG
*/

SELECT 
 SocioPPE				= IIF(perPPE.IdPersona=perSocio.IdPersona,'PPE Socio','PPE Asimialdo')
,NombrePPE				= perPPE.Nombre
,Domicilio				= perPPE.Domicilio
,Puesto					= ISNULL(puesto.Descripcion,'''')  
,Inicio					= ISNULL(ppe.FechaInicio,'19000101')  
,Fin					= ISNULL(ppe.FechaFin,'19000101')  
,NosocioRelacionado		= sc.Codigo
,SocioConAportacion		= IIF(sc.EsSocioValido = 0,'NO','SI')
,FechaAlta				= sc.FechaAlta
,EstatusSocio			= eSc.Descripcion
,NombreSocioRelacionado	= perSocio.Nombre
,Ingresos				= ISNULL((aie.IngresoOrdinario+aie.IngresoExtraordinario),0.00)
,NivelDeRiesgo			= ISNULL(d.Descripcion,'''')
FROM dbo.tPLDppe ppe  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas perPPE  WITH(NOLOCK) ON perPPE.IdPersona = ppe.IdPersona
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = ppe.RelSocio
INNER JOIN dbo.tCTLestatus eSc  WITH(NOLOCK) ON eSc.IdEstatus = sc.IdEstatus
INNER JOIN dbo.tGRLpersonas perSocio  WITH(NOLOCK) ON perSocio.IdPersona = sc.IdPersona
-- Datos PPE
LEFT JOIN dbo.tCATlistasD puesto (NOLOCK)ON puesto.IdListaD=ppe.IdListaDpuesto
-- Datos Socio
LEFT JOIN dbo.tCATlistasD d (NOLOCK)ON d.IdListaD=sc.IdListaDnivelRiesgo
LEFT JOIN dbo.tSCSanalisisCrediticio ac With (nolock) ON ac.IdPersona = perSocio.IdPersona
LEFT JOIN dbo.tSCSanalisisIngresosEgresos aie With (nolock) ON aie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
WHERE ppe.IdEstatus=1


END

GO

