

USE iERP_CDP
GO

SELECT * FROM tCTLcuentasABCDformasPago cmp  WITH(NOLOCK) 

SELECT 
  cmp.IdTipoDdominio
, dom.Descripcion AS Dominio
, tipo.IdTipoD
, tipo.Descripcion as Tipo
, mp.IdMetodoPago
, mp.Descripcion AS MetodoPago
, cmp.AplicaDeposito
, cmp.AplicaRetiro
FROM tCTLcuentasABCDformasPago cmp  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD dom  WITH(NOLOCK) 
	ON dom.IdTipoD = cmp.IdTipoDdominio
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) 
	ON mp.IdMetodoPago = cmp.IdMetodoPago
LEFT JOIN dbo.tCTLtiposD tipo  WITH(NOLOCK) 
	ON tipo.IdTipoD = cmp.IdTipoD
WHERE cmp.IdEstatus=1
ORDER BY cmp.IdTipoDdominio