
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcreditosEntregados')
BEGIN
	DROP PROC pAYCcreditosEntregados
	SELECT 'pAYCcreditosEntregados BORRADO' AS info
END
GO

CREATE PROC pAYCcreditosEntregados
@FechaInicial AS DATE,
@FechaFinal AS DATE,
@Sucursal AS VARCHAR(10),
@Cuenta AS VARCHAR(80)
AS
BEGIN

DECLARE @traspasos AS TABLE(
	IdOperacion		INT,
	Folio			BIGINT,
	Fecha			DATE,
	Codigo			VARCHAR(30),
	TotalGenerado	NUMERIC(18,2),
	UsuarioTraspaso VARCHAR(250),
	INDEX IX_Traspasos_IdOperacion NONCLUSTERED(IdOperacion)
);

-- Insertar en tabla los traspasos
INSERT @traspasos
(IdOperacion,Folio,Fecha,Codigo,TotalGenerado,UsuarioTraspaso)
SELECT 
			  	    IdOperacion     = tFinancieraTraspaso.IdOperacion,
			     	Folio           = op.Folio, 
		    		Fecha           = tFinancieraTraspaso.Fecha, 
		    		Codigo          = cuentaTraspaso.Codigo,
		    		TotalGenerado   = tFinancieraTraspaso.TotalGenerado,
		    		UsuarioTraspaso = CONCAT(personatraspaso.Nombre, ' ', personatraspaso.ApellidoPaterno, ' ', personatraspaso.ApellidoMaterno)
		    		 
		    FROM dbo.tSDOtransaccionesFinancieras tFinancieraTraspaso With(Nolock)
            LEFT JOIN dbo.tGRLoperaciones      op              WITH(Nolock) ON tFinancieraTraspaso.IdOperacion = op.IdOperacion 
		    																								     AND op.IdTipoOperacion = 22
																												 AND op.Fecha BETWEEN @FechaInicial AND @FechaFinal
            LEFT JOIN dbo.tAYCcuentas          cuentaTraspaso  With(Nolock) ON cuentaTraspaso.IdCuenta         = tFinancieraTraspaso.IdCuenta
																				AND cuentaTraspaso.IdTipoDProducto = 144 
		    INNER JOIN dbo.tCTLusuarios        usuariotraspaso With(Nolock) ON usuariotraspaso.IdUsuario       = tFinancieraTraspaso.IdUsuarioCambio
		    INNER JOIN dbo.tGRLpersonasFisicas personatraspaso With(Nolock) ON personatraspaso.IdPersonaFisica = usuariotraspaso.IdPersonaFisica
		    WHERE tFinancieraTraspaso.IdTipoSubOperacion = 500
			AND  tFinancieraTraspaso.Fecha BETWEEN @FechaInicial AND @FechaFinal

-- Consulta


SELECT 
		NumeroSocio             = socio.Codigo,
		NombreSocio             = persona.Nombre,
		NumeroSucursal          = sucursalcuenta.Codigo,
		NombreSucursal          = sucursalcuenta.Descripcion,
		ImporteCredito          = cuenta.MontoEntregado,
		NumeroCredito           = cuenta.Codigo,
		FechaEntrega            = cuenta.FechaEntrega,
		UsuarioInstrumento      = CONCAT(usentpersona.Nombre, ' ', usentpersona.ApellidoPaterno, ' ',usentpersona.ApellidoMaterno),
		UsuarioActivo           = CONCAT(perusactivo.Nombre, ' ', perusactivo.ApellidoPaterno, ' ', perusactivo.ApellidoMaterno),
		NumeroCheque            = cheque.Folio,
		FechaEmisionCheque      = cheque.Fecha,
		ImporteCheque           = cheque.Monto,
		UsuarioEmitioCheque     = CONCAT(uschequepersona.Nombre, ' ', uschequepersona.ApellidoPaterno, ' ', uschequepersona.ApellidoMaterno),
		FolioFichaRetiro        = operacion.Folio,
		FechaEmisionFichaRetiro = transaccion.Fecha,
		ImporteFicha            = transaccion.CapitalGenerado,
		UsuarioEmitioTicket     = CONCAT(usuticketpersona.Nombre,' ',usuticketpersona.ApellidoPaterno, ' ', usuticketpersona.ApellidoMaterno),
        FolioDeposito           = trasp.Folio,
		FechadeDeposito         = trasp.Fecha,
		ImporteDeposito         = trasp.TotalGenerado,
		CuentadeDeposito        = trasp.Codigo,
		UsuarioTraspaso         = trasp.UsuarioTraspaso

FROM dbo.tAYCcuentas cuenta With(Nolock)
INNER JOIN dbo.tSCSsocios                   socio           WITH(Nolock) ON socio.IdSocio                = cuenta.IdSocio
INNER JOIN dbo.tGRLpersonas                 persona         With(Nolock) ON persona.IdPersona            = socio.IdPersona
INNER JOIN dbo.tCTLsucursales               sucursalcuenta  With(Nolock) ON sucursalcuenta.IdSucursal    = cuenta.IdSucursal
INNER JOIN dbo.tCTLusuarios                 usuarioEntrego  With(Nolock) ON usuarioEntrego.IdUsuario     = cuenta.IdUsuarioEntrego
INNER JOIN dbo.tGRLpersonasFisicas          usentpersona    WITH(Nolock) ON usentpersona.IdPersonaFisica = usuarioEntrego.IdPersonaFisica
INNER JOIN dbo.tAYCcuentasEstadisticas      cuenestadistica With(Nolock) ON cuenestadistica.IdCuenta     = cuenta.IdCuenta
INNER JOIN dbo.tCTLusuarios                 usactivo        WITH(Nolock) ON usactivo.IdUsuario           = cuenestadistica.IdUsuarioActivo
INNER JOIN dbo.tGRLpersonasFisicas          perusactivo     With(Nolock) ON perusactivo.IdPersonaFisica  = usactivo.IdPersonaFisica
INNER JOIN dbo.tSDOtransaccionesFinancieras transaccion     With(Nolock) ON transaccion.IdCuenta         = cuenta.IdCuenta 
																										   AND cuenta.IdTipoDProducto = 143
																										   AND transaccion.IdTipoSubOperacion = 501
																										   AND transaccion.Fecha BETWEEN @FechaInicial AND @FechaFinal
INNER JOIN dbo.tCTLsucursales               sucursal        With(Nolock) ON sucursal.IdSucursal          = transaccion.IdSucursal
																											AND (sucursal.Codigo = @Sucursal OR @Sucursal = '*')
LEFT JOIN dbo.tGRLoperaciones               operacion       With(Nolock) ON operacion.IdOperacion        = transaccion.IdOperacion
													  												       AND operacion.IdTipoOperacion IN (1, 10)
																										   AND operacion.Fecha BETWEEN @FechaInicial AND @FechaFinal
LEFT JOIN @traspasos trasp ON trasp.IdOperacion = transaccion.IdOperacion -- tabla temporal
LEFT JOIN dbo.tFNZcheques                   cheque           With(Nolock) ON cheque.IdCheque                  = operacion.IdCheque
LEFT JOIN dbo.tCTLusuarios                  usuariocheque    With(Nolock) ON usuariocheque.IdUsuario          = cheque.IdUsuarioAsignado
LEFT JOIN dbo.tGRLpersonasFisicas           uschequepersona  With(Nolock) ON uschequepersona.IdPersonaFisica  = usuariocheque.IdPersonaFisica
INNER JOIN dbo.tCTLusuarios                 usuarioticket    With(Nolock) ON usuarioticket.IdUsuario          = transaccion.IdUsuarioCambio
INNER JOIN dbo.tGRLpersonasFisicas          usuticketpersona With(Nolock) ON usuticketpersona.IdPersonaFisica = usuarioticket.IdPersonaFisica

WHERE  (cuenta.Codigo =  @Cuenta OR @Cuenta = '*')

	  
	--1288674

END
GO

