
USE iERP_CYL
GO

/*
SELECT cc.IdCalificacionClasificacion,cc.CalificacionSocio,
cc.Clasificacion,cc.IdPeticionConsultaPersonaBuro,
cc.Idpersona, cc.IdSocio,cc.Alta,
eb.Alta AS AltaEB,
eb.NumeroControlConsulta
--dbo.fCTLstrToDate(resBur.FechaSolicitudReporteMasReciente) AS FechaBuro,
FROM dbo.tBURcalificacionClasificacion cc  WITH(NOLOCK) 
LEFT JOIN dbo.tBURrespuestaConsultaEncabezado eb
	ON eb.IdPeticionConsultaPersonaBuro = cc.IdPeticionConsultaPersonaBuro
WHERE cc.IdPeticionConsultaPersonaBuro=73861
*/

SELECT eb.NumeroControlConsulta
, dbo.fCTLstrToDate(resp.FechaSolicitudReporteMasReciente) AS FechaBuro
, per.Nombre, per.RFC, p.Direccion1
, p.ColoniaPoblacion,p.Ciudad,p.Estado,p.CP
, cb.IdConsultaBuroCredito, p.IdPeticionConsultaPersonaBuro
, eb.IdRespuestaConsultaEncabezado, resp.IdRespuestaConsultaResumenReporte
, score.*
FROM dbo.tBURpeticionConsultaPersonaBuro p 
INNER JOIN dbo.tBURConsultaBuroCreditoE cb  WITH(NOLOCK)
	ON cb.IdConsultaBuroCredito = p.IdConsultaBuroCredito
INNER JOIN dbo.tBURrespuestaConsultaEncabezado eb
	ON eb.IdPeticionConsultaPersonaBuro = p.IdPeticionConsultaPersonaBuro
INNER JOIN dbo.tBURrespuestaConsultaResumenReporte resp  WITH(NOLOCK) 
	ON resp.IdPeticionConsultaPersonaBuro = p.IdPeticionConsultaPersonaBuro
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) 
	ON per.IdPersona = p.IdPersona
LEFT JOIN dbo.tBURrespuestaConsultaScoreBuroCredito score  WITH(NOLOCK) 
	ON score.IdPeticionConsultaPersonaBuro = p.IdPeticionConsultaPersonaBuro
--WHERE eb.NumeroControlConsulta IN (2945466391,2945473273,2945460158)
WHERE dbo.fCTLstrToDate(resp.FechaSolicitudReporteMasReciente)>='20230711' 
 AND nombre='FRANCISCO CRUZ SANTIAGO'

-- 