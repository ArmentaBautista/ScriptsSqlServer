



DECLARE 
@Periodo VARCHAR(18)='2023-08',
@IdPeriodo INT,
@fechaInicioPeriodo DATE,
@fechaFinPeriodo DATE,
@diasPeriodo INT

SELECT @IdPeriodo=per.IdPeriodo, @fechaInicioPeriodo=per.Inicio, @fechaFinPeriodo=per.Fin FROM dbo.tCTLperiodos per  WITH(NOLOCK) WHERE per.Codigo=@Periodo
SET @diasPeriodo=DAY(EOMONTH(@fechaFinPeriodo))

INSERT INTO iERP_KFT_EC..tEDOCTAcaptacionCapital	
SELECT
c.IdCuenta,
c.Codigo,
c.IdSocio,
c.IdTipoDProducto,
tp.Descripcion,			
pf.IdProductoFinanciero,
pf.Descripcion,
c.InteresOrdinarioAnual,
ISNULL(c.GAT,0),
ISNULL(c.GATreal,0),
a.IdApertura,
a.Folio,
c.IdEstatus,
@IdPeriodo,
@Periodo,
@diasPeriodo
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
	ON tp.IdTipoD = c.IdTipoDProducto
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN tSDOhistorialAcreedoras ha  WITH(NOLOCK) 
	ON ha.IdCuenta = c.IdCuenta
		AND ha.IdPeriodo=@IdPeriodo
LEFT JOIN dbo.tAYCaperturas a  WITH(NOLOCK) 
	ON a.IdApertura = c.IdApertura
WHERE c.IdTipoDProducto IN (144,398,716,2621)




