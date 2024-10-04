
/* JCA.17/4/2024.02:55 
Nota: Recupera el detalle de un trámite de Confirmación de Saldos por su Folio
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnAYCconfirmacionSaldosD')
BEGIN
	DROP FUNCTION fnAYCconfirmacionSaldosD
	SELECT 'fnAYCconfirmacionSaldosD BORRADO' AS info
END
GO

CREATE FUNCTION fnAYCconfirmacionSaldosD(@pIdConfirmacionSaldosE AS INT)
RETURNS TABLE
RETURN(
	SELECT 
		cs.IdConfirmacionSaldosD,
		cs.IdConfirmacionSaldos,
		[Tipo]			= td.Descripcion,
		[Producto]		= pf.Descripcion,
		[NoCuenta]		= c.Codigo,
		cs.Capital,
		cs.InteresOrdinarioAlDia,
		cs.InteresMoratorio,
		cs.Saldo,
		cs.EstaConforme
		FROM tAYCconfirmacionSaldosD cs  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
			ON c.IdCuenta = cs.IdCuenta
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
			ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) 
			ON td.IdTipoD = c.IdTipoDProducto
		WHERE cs.IdConfirmacionSaldos=@pIdConfirmacionSaldosE
)
GO

