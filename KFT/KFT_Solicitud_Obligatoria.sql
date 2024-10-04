
SELECT p.Descripcion AS Producto, r.Descripcion AS Requisito, td.Descripcion AS Modalidad --,  td.IdTipoD, td.IdTipoE,pr.*
-- UPDATE pr SET pr.Socio=884
FROM dbo.tAYCproductosFinancierosRequisitos pr  WITH(NOLOCK)
INNER JOIN dbo.tAYCproductosFinancieros p  WITH(NOLOCK) ON p.IdProductoFinanciero = pr.RelRequisitos
														AND p.IdTipoDDominioCatalogo=143
INNER JOIN dbo.tDIGrequisitos r  WITH(NOLOCK) ON r.IdRequisito = pr.IdRequisitoE
													AND pr.IdRequisitoE=43
INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) ON td.IdTipoD = pr.Socio -- AND pr.Socio!=884