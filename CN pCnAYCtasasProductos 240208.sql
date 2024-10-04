
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCtasasProductos')
BEGIN
	DROP PROC pCnAYCtasasProductos
	SELECT 'pCnAYCtasasProductos BORRADO' AS info
END
GO

CREATE PROCEDURE [dbo].pCnAYCtasasProductos
	
AS 
		BEGIN
			SELECT 
			t.Descripcion AS TipoProducto,
			pf.Codigo AS CodigoProductoFinanciero,pf.Descripcion AS ProductoFinanciero,
			tasa.Descripcion AS Tasa,tasa.MontoInicial,tasa.MontoFinal,tasa.TasaInteresOrdinarioMensual AS [IO mensual],tasa.TasaInteresOrdinarioAnual AS [IO anual],
			tasa.TasaInteresMoratorioMensual AS [IM mensual],tasa.TasaInteresMoratorioAnual AS [IM anual],tasa.CATinformativoCondiciones
			FROM dbo.tAYCproductosFinancieros pf With (nolock) 
			JOIN tCTLproductosFinancierosTasas tasa With (nolock) ON tasa.RelTasas = pf.RelTasas
			JOIN dbo.tCTLestatusActual eatasa With (nolock) 
				ON eatasa.IdEstatusActual = tasa.IdEstatusActual
					AND eatasa.IdEstatus=1
			JOIN dbo.tCTLestatusActual eapf With (nolock) 
				ON eapf.IdEstatusActual = pf.IdEstatusActual
					AND eapf.IdEstatus=1 	
			INNER JOIN dbo.tCTLtiposD t  WITH(NOLOCK) 
				ON t.IdTipoD = pf.IdTipoDDominioCatalogo
			WHERE pf.IdTipoDDominioCatalogo IN (143,144,398)
			ORDER BY t.IdTipoD,pf.Descripcion
		END	






GO

