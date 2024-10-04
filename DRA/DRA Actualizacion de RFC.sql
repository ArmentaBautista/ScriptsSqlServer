
USE iERP_DRA
GO


SELECT
 [RfcExcel]	= r.RFC
,[RFCerprise] = p.RFC
,[Diferente] = IIF(r.RFC<>p.RFC,'DIFF','')
-- BEGIN TRAN UPDATE p SET p.RFC=r.RFC
FROM dbo.tTMPrfcsPorActualizar r  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.Codigo=r.[No de Socio]
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
WHERE r.RFC<>p.RFC


SELECT sc.codigo, x.* 
FROM tTMPrfcsPorActualizarDiferentes x
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.idsocio=x.idpersona


