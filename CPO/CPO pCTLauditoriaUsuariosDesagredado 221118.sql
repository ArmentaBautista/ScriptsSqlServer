
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLauditoriaUsuariosDesagredado')
BEGIN
	DROP PROC pCTLauditoriaUsuariosDesagredado
	SELECT 'pCTLauditoriaUsuariosDesagredado BORRADO' AS info
END
GO

CREATE PROC pCTLauditoriaUsuariosDesagredado
@FechaInicial AS DATE = '19000101',
@FechaFinal   AS DATE = '19000101',
@Usuario      AS VARCHAR(30) = '*'

AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM dbo.tCTLusuarios usuario WHERE usuario = @Usuario AND usuario.IdUsuario > 0)
BEGIN
    SELECT 'Usuario Invalido' AS Mensaje
END
    
SELECT Usuario            = usuarios.Usuario, 
      [Tipo de Operación] = TiposOperacion.Descripcion, 
	  [Operación]         = CONCAT(TiposOperacion.Codigo,'-',Operacion.Folio),
	  [Descripción]       = tf.Descripcion,	  	  
	  [Sub Tipo]          = Tipos.Descripcion, 
	  [Fecha]             = Operacion.Fecha,
	  [No. De Socio]      = Socios.Codigo,
	  [No. De Cuenta]	  = cuentas.Codigo,
	  [Concepto]          = tf.Concepto,
	  [Referencia]        = tf.Referencia,
	  [Importe]           = tf.MontoSubOperacion,
	  Sucursal            =Sucursales.Descripcion
	  ,sesiones.IP, sesiones.Host, sesiones.FechaTrabajo, CAST(Operacion.Alta AS TIME) AS Hora
FROM dbo.tGRLoperaciones                   Operacion      WITH(NOLOCK)
     JOIN dbo.tSDOtransaccionesFinancieras tf             WITH(NOLOCK) ON tf.IdOperacion                 = Operacion.IdOperacion AND tf.IdEstatus=1 AND tf.IdTipoSubOperacion IN (500, 501)
	 JOIN dbo.tAYCcuentas                  cuentas        WITH(NOLOCK) ON cuentas.IdCuenta               = tf.IdCuenta
	 JOIN dbo.tSCSsocios                   Socios         WITH(NOLOCK) ON Socios.IdSocio                 = cuentas.IdSocio
     JOIN dbo.tCTLsucursales               Sucursales     WITH(NOLOCK) ON Sucursales.IdSucursal          = Operacion.IdSucursal
     JOIN dbo.tCTLusuarios                 usuarios       WITH(NOLOCK) ON usuarios.IdUsuario             = Operacion.IdUsuarioAlta
     JOIN dbo.tCTLtiposOperacion           Tipos          WITH(NOLOCK) ON Tipos.IdTipoOperacion          = tf.IdTipoSubOperacion
     JOIN dbo.tCTLtiposOperacion           TiposOperacion WITH(NOLOCK) ON TiposOperacion.IdTipoOperacion = Operacion.IdTipoOperacion
	 JOIN dbo.tCTLsesiones				   sesiones		  WITH(NOLOCK) ON sesiones.IdSesion = Operacion.IdSesion
WHERE Operacion.IdEstatus=1 AND Operacion.IdTipoOperacion NOT IN (4) AND Operacion.Fecha
      BETWEEN @FechaInicial AND @FechaFinal
      AND  (usuarios.Usuario = @Usuario ) AND(usuarios.Usuario=@Usuario)

UNION ALL

SELECT Usuario            = usuarios.Usuario, 
      [Tipo de Operación] = TiposOperacion.Descripcion, 
	  [Operación]         = CONCAT(TiposOperacion.Codigo,'-',Operacion.Folio),
	  [Descripción]       = tf.Descripcion,	  	  
	  [Sub Tipo]          = Tipos.Descripcion, 
	  [Fecha]             = Operacion.Fecha,
	  [No. De Socio]      = '',
	  [No. De Cuenta]	  = '',
	  [Concepto]          = tf.Concepto,
	  [Referencia]        = tf.Referencia,
	  [Importe]           = tf.MontoSubOperacion,
	  Sucursal            =Sucursales.Descripcion
	  ,sesiones.IP, sesiones.Host, sesiones.FechaTrabajo,  CAST(Operacion.Alta AS TIME) AS Hora
FROM dbo.tGRLoperaciones                   Operacion      WITH(NOLOCK)
     JOIN dbo.tSDOtransacciones            tf             WITH(NOLOCK) ON tf.IdOperacion                 = Operacion.IdOperacion AND tf.IdEstatus=1 AND tf.IdTipoSubOperacion IN (500, 501)
     JOIN dbo.tCTLsucursales               Sucursales     WITH(NOLOCK) ON Sucursales.IdSucursal          = Operacion.IdSucursal
     JOIN dbo.tCTLusuarios                 usuarios       WITH(NOLOCK) ON usuarios.IdUsuario             = Operacion.IdUsuarioAlta
     JOIN dbo.tCTLtiposOperacion           Tipos          WITH(NOLOCK) ON Tipos.IdTipoOperacion          = tf.IdTipoSubOperacion
     JOIN dbo.tCTLtiposOperacion           TiposOperacion WITH(NOLOCK) ON TiposOperacion.IdTipoOperacion = Operacion.IdTipoOperacion
	 JOIN dbo.tCTLsesiones				   sesiones		  WITH(NOLOCK) ON sesiones.IdSesion = Operacion.IdSesion
WHERE Operacion.IdEstatus=1 AND Operacion.IdTipoOperacion NOT IN (4) AND Operacion.Fecha
      BETWEEN @FechaInicial AND @FechaFinal
      AND (usuarios.Usuario = @Usuario ) AND (usuarios.Usuario=@Usuario)

END
GO

