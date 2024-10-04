




SELECT fp.*, TipoDom.Descripcion, mp.Descripcion 
-- UPDATE fp SET fp.IdEstatus=2
FROM dbo.tCTLcuentasABCDformasPago fp  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD TipoDom  WITH(NOLOCK) ON TipoDom.IdTipoD = fp.IdTipoDdominio
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = fp.IdMetodoPago
WHERE fp.IdTipoDdominio=851 AND id IN (112,113)


