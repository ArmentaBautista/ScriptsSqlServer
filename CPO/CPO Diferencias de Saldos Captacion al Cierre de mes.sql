

DECLARE @cap TABLE(
cuenta VARCHAR(32),
producto VARCHAR(128),
saldoCapitalAnterior NUMERIC(18,2),
saldoCapitalNuevo NUMERIC(18,2),
idcuenta	INT,
idsocio	int
)

INSERT INTO @cap
(
    cuenta,
	producto,
    saldoCapitalAnterior
)
SELECT cap.Cuenta, cap.Producto, cap.SaldoCapital
FROM iERP_OBL_RPT..tAYCcaptacionDiaria  cap WITH(NOLOCK) 
WHERE cap.Fecha='20230731'
AND NOT (cap.Cuenta IS NULL)


UPDATE @cap SET saldoCapitalNuevo=c.SaldoCapital ,idcuenta= c.idcuenta, idsocio=c.IdSocio
		--SELECT c.SaldoCapital , c.IdCuenta
		FROM tayccuentas c  WITH(NOLOCK) 
		INNER JOIN @cap cap ON cap.cuenta=c.Codigo
		WHERE c.IdCuenta<>0

SELECT sc.Codigo, c.idcuenta, c.cuenta,c.producto, c.saldoCapitalAnterior, c.saldoCapitalNuevo, (c.saldoCapitalNuevo-c.saldoCapitalAnterior) AS DIFF 
FROM @cap c
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.idsocio
WHERE (saldoCapitalNuevo-saldoCapitalAnterior)>1000
ORDER BY DIFF DESC


