
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='vCreditoscontingenciaCOVID19')
BEGIN
	DROP VIEW vCreditoscontingenciaCOVID19
END
GO

CREATE VIEW vCreditoscontingenciaCOVID19
 as
SELECT sucursal.Descripcion AS Sucursal,
socio.Codigo AS NoSocio,
persona.Nombre,
cuentas.Codigo AS NoCuenta,
cuentas.Descripcion AS Poducto,
tiposd.Descripcion AS Tipo,
cuentas.MontoEntregado,
InicioAmortizacion= contE.Inicio,
PeriodosAsignados=contE.NumeroPeriodosGracia,
InicioPeriodosGracia=contE.Fecha,
VencimientoPeriodoGracia = contingD.Fin,
cov.Nota,
usuario.Usuario
FROM dbo.tAYCcuentasTratamientoCovid cov   WITH(NOLOCK)
 INNER JOIN dbo.tAYCcuentas cuentas  WITH(NOLOCK) ON cuentas.IdCuenta = cov.IdCuenta
 INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = cuentas.IdSocio
 INNER JOIN dbo.tGRLpersonas persona  WITH(NOLOCK) ON persona.IdPersona = socio.IdPersona
 INNER JOIN dbo.tCTLsucursales sucursal  WITH(NOLOCK) ON sucursal.IdSucursal = cuentas.IdSucursal
 INNER JOIN dbo.tCTLtiposD tiposd  WITH(NOLOCK) ON tiposd.IdTipoD=cuentas.IdTipoDProducto
 INNER JOIN dbo.tAYCmovimientosContingenciaE contE With(nolock) ON contE.IdCuenta = cuentas.IdCuenta
 INNER JOIN dbo.tAYCmovimientosContingenciaD contingD ON contingD.IdMovimientoPeriodoGracia = contE.IdMovimientoPeriodoGracia AND contingD.NumeroParcialidad = (contE.Inicio + contE.NumeroPeriodosGracia-1)
 INNER JOIN dbo.tCTLsesiones ss  WITH(nolock) ON ss.IdSesion = cov.IdSesion
 INNER JOIN dbo.tCTLusuarios usuario  WITH(nolock) ON usuario.IdUsuario = ss.IdUsuario
 WHERE cov.IdEstatus=1
GO
