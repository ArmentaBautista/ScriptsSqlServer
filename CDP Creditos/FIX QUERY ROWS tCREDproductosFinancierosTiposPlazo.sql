
/********  JCA.20/8/2024.02:27 Info: Papi con este script fue que hiciste el fix para los tipos de plazo  ********/

SELECT 
pf.Descripcion,
pf.IdProductoFinanciero,d.IdTipoD
FROM dbo.tCREDproductosFinancierosTiposPlazo t  WITH(NOLOCK) 
INNER JOIN [iERP_CDP].dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = t.IdProductoFinanciero
INNER JOIN dbo.tCTLtiposD d  WITH(NOLOCK) 
	ON d.IdTipoD = t.IdTipoDplazo
WHERE d.IdTipoD IN (297,298,299,300,301,302,302,1854,2153,2154,2155,2156,2157,2158,2838)
ORDER BY pf.IdProductoFinanciero


	

SELECT 
--pf.Descripcion,d.IdTipoE,
'(',
pf.IdProductoFinanciero,',',
d.IdTipoD,',',
1,',',
1,',',
1,'),'
FROM [iERP_CDP].dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
INNER JOIN iERP_CDP.dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = pf.IdEstatusActual
		AND ea.IdEstatus=1
CROSS JOIN dbo.tCTLtiposD d  WITH(NOLOCK) 	
WHERE d.IdTipoD IN (293,294,295,296,297,298,299,300,301,302,302,1854,2153,2154,2155,2156,2157,2158,302)
	AND pf.IdTipoDDominioCatalogo=143
ORDER BY pf.IdProductoFinanciero ASC,d.IdTipoD ASC


SELECT * FROM dbo.tAYCproductosFinancieros ORDER BY IdProductoFinanciero desc

