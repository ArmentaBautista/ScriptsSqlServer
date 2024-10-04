
USE iERP_CYL
GO

SELECT cc.IdCalificacionClasificacion,cc.CalificacionSocio,
cc.Clasificacion,cc.IdPeticionConsultaPersonaBuro,
cc.Idpersona, cc.IdSocio,cc.Alta,
eb.Alta AS AltaEB,
eb.NumeroControlConsulta,
dbo.fCTLstrToDate(resBur.FechaSolicitudReporteMasReciente) AS FechaBuro,
DATEDIFF(DAY,CAST(eb.Alta AS DATE),dbo.fCTLstrToDate(resBur.FechaSolicitudReporteMasReciente)) AS DIFF
FROM dbo.tBURcalificacionClasificacion cc  WITH(NOLOCK) 
LEFT JOIN dbo.tBURrespuestaConsultaEncabezado eb
	ON eb.IdPeticionConsultaPersonaBuro = cc.IdPeticionConsultaPersonaBuro
LEFT JOIN dbo.tBURrespuestaConsultaResumenReporte resBur With(Nolock) 
	ON resBur.IdPeticionConsultaPersonaBuro = eb.IdPeticionConsultaPersonaBuro 
WHERE eb.IdPeticionConsultaPersonaBuro<>0 
ORDER BY eb.Alta DESC


-- commit