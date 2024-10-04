
SELECT 
suc.Descripcion AS Sucursal
-- , s.IdBienServicio, s.Codigo, s.Descripcion
-- ,c.IdContrato
, c.Folio, c.Fecha
-- , c.DomiciliarCargos
, c.AplicaVigencia, c.InicioVigencia, c.FinVigencia
--, c.IdSocio, c.IdCuenta
, sc.Codigo AS NoSocio
, per.Nombre
, cta.Codigo AS Nocuenta_ATMTDD,  FORMAT(cta.SaldoCapital,'C','es-MX') AS SaldoCapital
--, tap.IdTipoD, tap.Descripcion
--, tper.IdTipoD, tper.Descripcion
--, e.IdEstatus, e.Descripcion
FROM dbo.tCOMcontratosServicios c  WITH(NOLOCK) 
INNER JOIN dbo.tGRLbienesServicios s  WITH(NOLOCK) ON s.IdBienServicio = c.IdServicio
AND s.IdBienServicio=187
INNER JOIN dbo.tAYCcargosComisionesAsignados cca  WITH(NOLOCK) on cca.IdRel=c.IdRelCargosComisionesAsignados
INNER JOIN dbo.tCTLtiposD tap  WITH(NOLOCK) ON tap.IdTipoD = cca.IdTipoDAplicacion
INNER JOIN dbo.tCTLtiposD tper  WITH(NOLOCK) ON tper.IdTipoD = cca.IdTipoDPeriodicidad
INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = c.IdEstatus
LEFT JOIN  dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
LEFT JOIN  dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = sc.IdSucursal
LEFT JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
LEFT JOIN dbo.tAYCcuentas cta  WITH(NOLOCK) ON cta.IdSocio = sc.IdSocio AND cta.IdProductoFinanciero=45
WHERE c.IdEstatus=1
ORDER BY suc.Descripcion, c.Fecha ASC




-- Fix IdTipoDAplicacion = 499, IdTipoDPeriodicidad=301
/*
DISABLE TRIGGER trValidarCancelacionContrato ON dbo.tCOMcontratosServicios

ENABLE TRIGGER trValidarCancelacionContrato ON dbo.tCOMcontratosServicios

SELECT 
s.IdBienServicio, s.Codigo, s.Descripcion,
c.IdContrato, c.Folio, c.Fecha, c.DomiciliarCargos, c.AplicaVigencia, c.IdSocio, c.IdCuenta
, tap.IdTipoD, tap.Descripcion
, tper.IdTipoD, tper.Descripcion
, e.IdEstatus, e.Descripcion
--, cca.*
-- BEGIN TRAN UPDATE c SET DomiciliarCargos=1, AplicaVigencia=1
-- BEGIN TRAN UPDATE cca SET IdTipoDAplicacion = 499, IdTipoDPeriodicidad=301
FROM dbo.tCOMcontratosServicios c  WITH(NOLOCK) 
INNER JOIN dbo.tGRLbienesServicios s  WITH(NOLOCK) ON s.IdBienServicio = c.IdServicio
AND s.IdBienServicio=187
INNER JOIN dbo.tAYCcargosComisionesAsignados cca  WITH(NOLOCK) on cca.IdRel=c.IdRelCargosComisionesAsignados
INNER JOIN dbo.tCTLtiposD tap  WITH(NOLOCK) ON tap.IdTipoD = cca.IdTipoDAplicacion
INNER JOIN dbo.tCTLtiposD tper  WITH(NOLOCK) ON tper.IdTipoD = cca.IdTipoDPeriodicidad
INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) ON e.IdEstatus = c.IdEstatus
WHERE c.IdEstatus=1
*/
-- commit

-- rollback


