


DECLARE @fechaCartera AS DATE -- fecha del calculo de cartera
DECLARE @fechaTrabajo AS DATE -- Feca de emisión del reporte

SELECT 
format (cartera.CapitalAtrasado, '#,###.00', 'es-mx') AS CapitalAtrasado
,format (cartera.CapitalExigible, '#,###.00', 'es-mx') AS CapitalExigible
, format (cartera.Capital, '#,###.00', 'es-mx') AS Capital
, format (cuenta.Monto, '#,###.00', 'es-mx') AS MontoOtorgado
, format (sdo.CapitalPagado, '#,###.00', 'es-mx') AS CapitalPagado
, cartera.ProximoVencimiento
FROM dbo.tAYCcartera cartera  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas cuenta  WITH(NOLOCK) ON cuenta.IdCuenta = cartera.IdCuenta
INNER JOIN dbo.tSDOsaldos sdo  WITH(NOLOCK) ON sdo.IdCuenta = cartera.IdCuenta
INNER JOIN dbo.tAYCcartera carteraActual WITH(NOLOCK) ON carteraActual.IdCuenta=cuenta.IdCuenta
													AND carteraActual.FechaCartera=@fechaTrabajo -- Datos del día
WHERE cartera.FechaCartera=@fechaCartera -- datos proyectados




SELECT pf.Nombre, pf.ApellidoPaterno, pf.ApellidoMaterno,  aval.EsAval, cuenta.Codigo 
FROM dbo.tAYCavalesAsignados aval  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentas cuenta  WITH(NOLOCK) ON cuenta.IdCuenta = aval.RelAvales
INNER JOIN dbo.tCAZpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = aval.IdPersona
WHERE aval.EsAval=1 

