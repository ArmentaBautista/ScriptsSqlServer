

/* INFO (⊙_☉) JCA.04/10/2023.02:22 a. m. 
Nota: FIX PARA DESHABILITAR LOS MÉTODOS DE PAGO QUE NO SE UTILIZAN
*/

UPDATE fp SET fp.IdEstatus=0
FROM dbo.tCTLcuentasABCDformasPago fp  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD tdom  WITH(NOLOCK) 
	ON tdom.IdTipoD = fp.IdTipoDdominio
INNER JOIN dbo.tCTLtiposD tt  WITH(NOLOCK) 
	ON tt.IdTipoD = fp.IdTipoD
INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) 
	ON mp.IdMetodoPago = fp.IdMetodoPago
WHERE mp.IdMetodoPago IN (-4,-5,-6,-7)


