

SELECT c.IdCuenta, c.Codigo, c.Descripcion, a.TasaIva, c.TasaIva, ce.EsActividadPrimaria
-- begin tran UPDATE c SET c.TasaIva=0, c.IdImpuesto=3
-- begin tran UPDATE a SET a.TasaIva=0, a.IdImpuestoIva=3
-- begin tran UPDATE ce SET ce.EsActividadPrimaria=0
FROM dbo.tAYCaperturas a  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdApertura = a.IdApertura
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdApertura = a.IdApertura
WHERE a.Folio IN (2596)



SELECT *
-- begin tran UPDATE po SET po.IVAinteresOrdinarioEstimado=0, po.TotalSinAhorro=po.Capital+po.InteresOrdinarioEstimado,  po.Total=po.Capital+po.InteresOrdinarioEstimado
FROM dbo.tAYCparcialidadesOriginales po  WITH(NOLOCK) 
WHERE po.IdCuenta=1838933
ORDER BY po.NumeroParcialidad

COMMIT

ROLLBACK



