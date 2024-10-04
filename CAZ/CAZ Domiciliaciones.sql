

SELECT cc.Codigo AS Credito, cr.Codigo AS CtaRetiro, ca.Codigo AS CtaAhorro
FROM dbo.tAYCdomiciliaciones d  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas cc  WITH(NOLOCK) ON cc.IdCuenta = d.IdCuentaCredito
INNER JOIN dbo.tAYCcuentas cr  WITH(NOLOCK) ON cr.IdCuenta=d.IdCuentaRetiro
INNER JOIN dbo.tAYCcuentas ca  WITH(NOLOCK) ON ca.IdCuenta=d.IdCuentaDepositoAhorro
WHERE d.IdEstatus=1