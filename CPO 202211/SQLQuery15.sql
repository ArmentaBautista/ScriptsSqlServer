



/*

SELECT soc.IdSocio, p.IdPersona , p.Nombre, soc.Codigo, c.*
FROM dbo.tSCSsocios soc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = soc.IdPersona
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = soc.IdSocio AND c.IdTipoDProducto=143 AND c.IdEstatus=1
WHERE p.Nombre LIKE '%martha alejandra gon%'

*/



DECLARE @IdSocio AS INT = 12931
DECLARE @IdPersona AS INT = 2
DECLARE @Fecha AS DATE = GETDATE()


--SELECT 1 FROM  dbo.fAYCcalcularSaldoDeudoras2 (0, @IdSocio, @Fecha, 2)

SELECT c.IdCuenta,
											   [No.Cuenta] = c.Codigo,
											   [Producto] = pf.Descripcion,
											   [Tipo] = tipo.Descripcion,
											   ISNULL (f.DiasMora, 0) AS DiasMora,
											   ISNULL (f.ParcialidadesVencidas, 0) AS ParcialidadesVencidas,
											   ISNULL (f.CapitalAtrasado, 0) AS TotalAtrasado,
											   ISNULL (f.SaldoTotal, 0) AS SaldoTotal,
											   p.IdPersona,
											   s.IdSocio,
											   e.Descripcion AS Estatus,
											   c.IdTipoDProducto,
											   ISNULL (f.Capital, 0) AS SaldoCapital
										FROM dbo.tAYCcuentas c WITH ( NOLOCK )
										JOIN dbo.tSCSsocios s WITH ( NOLOCK ) ON s.IdSocio = c.IdSocio
																				AND s.IdSocio=@IdSocio -- JCA JRJ 20221128.1833
										JOIN dbo.tCTLestatus e WITH ( NOLOCK ) ON e.IdEstatus = c.IdEstatus 
																				AND e.IdEstatus = 1
										JOIN dbo.tCTLestatus ee WITH ( NOLOCK ) ON ee.IdEstatus = c.IdEstatusEntrega 
																					AND c.IdEstatusEntrega = 20 -- JCA JRJ 20221128.1833
										JOIN dbo.tCTLtiposD tipo WITH ( NOLOCK ) ON tipo.IdTipoD = c.IdTipoDAIC
										JOIN dbo.tAYCproductosFinancieros pf WITH ( NOLOCK ) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
										JOIN dbo.tGRLpersonas p WITH ( NOLOCK ) ON p.IdPersona = s.IdPersona
																					AND p.IdPersona = @IdPersona  -- JCA JRJ 20221128.1833
										LEFT JOIN dbo.fAYCcalcularSaldoDeudoras2 (0, @IdSocio, @Fecha, 2) f ON f.IdCuenta = c.IdCuenta
										WHERE c.IdTipoDProducto = 143;