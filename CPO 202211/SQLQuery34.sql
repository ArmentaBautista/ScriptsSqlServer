
SELECT TOP 10 c.codigo FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
WHERE c.idestatus=1 AND c.idtipodproducto=144
ORDER BY c.IdCuenta DESC

SELECT c.IdCuenta, c.IdSaldo FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
					JOIN dbo.tSDOsaldos s With (nolock) ON s.IdSaldo=c.IdSaldo AND s.IdEstatus=1
					WHERE c.IdEstatus=1 AND  c.Codigo='10-093778'

SELECT c.IdCuenta, c.IdSaldo FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.IdEstatus=1 AND c.IdSaldo!=0 AND  c.Codigo='10-093778'



