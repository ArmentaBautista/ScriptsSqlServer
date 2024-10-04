

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='fAYCcreditosParcialidadesPorVencer')
BEGIN
	DROP FUNCTION fAYCcreditosParcialidadesPorVencer
END
GO

CREATE FUNCTION [fAYCcreditosParcialidadesPorVencer] 
(
	@FechaFin	 AS DATE 
)

-- Modificar la tabla tCTLperiodos para evitar el CAST
RETURNS TABLE
AS

RETURN
(
SELECT	
		NoSocio					= socios.SocioCodigo,
		Nombre					= CuentaBAS.SocioPersonaNombre,
		Cuenta					= CuentaBAS.Codigo,
		Producto				= CuentaBAS.ProductosFinancieroDescripcion,
		Finalidad				= CuentaBAS.FinalidadDescripcion,
		División				= CuentaBAS.DivisionDescripcion,
		Tipo					= CuentaBAS.SubtipoDescripcion,
		[Tipo Amortización]		= CuentaBAS.TipoParcilidadDescripcion,
		Plazo					= CuentaBAS.PlazoDescripcion,
		Sucursal				= CuentaBAS.SucursalDescripcion,
		Asentamiento			= Socios.Asentamiento,
		[Ciudad/Localidad]		= Socios.Ciudad,
		[Municipio/Delegación]	= Socios.Municipio,
		Estado					= Socios.Estado,
		Pais					= Socios.Pais,
		[Fecha Entrega]			= Estadistica.FechaEntregada,
		Vence					= CASE 
									WHEN Cuenta.PrimerVencimientoPendienteCapital <= Cuenta.PrimerVencimientoPendienteInteres THEN 
										Cuenta.PrimerVencimientoPendienteCapital
									ELSE
										Cuenta.PrimerVencimientoPendienteInteres
								  END,
		[Último Movimiento]		= Cuenta.FechaUltimaTransaccion,
		[Monto Crédito]			= Cuenta.MontoEntregado,
		Capital					= Calculo.Capital,
		[Interés Ordinario]		= Calculo.InteresOrdinario,
		[Interés Moratorio]		= Calculo.InteresMoratorio,
		Cargos					= Calculo.Cargos,
		Impuestos				= Calculo.Impuestos,
		Total					= Calculo.Total,
		[Estado Actual]			= CASE
									WHEN Cuenta.PrimerVencimientoPendienteCapital <= CURRENT_TIMESTAMP OR 
										 Cuenta.PrimerVencimientoPendienteInteres <= CURRENT_TIMESTAMP THEN
											'CON ATRASO'
									ELSE
											'AL DIA'
								  END,
		[Gestor Asignado]		= Gestor.Nombre,
		[Fecha Próximo Pago]	= ISNULL((SELECT TOP 1 Vencimiento FROM tAYCparcialidades WITH(NOLOCK) WHERE EstaPagada = 0 AND Vencimiento> @FechaFin AND IdCuenta=Cuenta.IdCuenta ORDER BY Vencimiento), NULL)
 
FROM	tAYCcuentas										Cuenta		WITH(NOLOCK)	JOIN 
		vAYCcuentasBAS									CuentaBAS	WITH(NOLOCK)	ON CuentaBAS.IdCuenta = Cuenta.IdCuenta		JOIN
		vSCSsociosBAS									Socios		WITH(NOLOCK)	ON Socios.IdSocio = Cuenta.IdSocio			JOIN
		fAYCcalcularSaldoDeudoras(0,CURRENT_TIMESTAMP,16,0)	Calculo						ON Calculo.IdCuenta = Cuenta.IdCuenta		JOIN
		tAYCcuentasEstadisticas							Estadistica WITH(NOLOCK)	ON Estadistica.IdCuenta = Cuenta.IdCuenta	JOIN
		vGYCgestoresBAS									Gestor		WITH(NOLOCK)	ON Gestor.IdGestor = Estadistica.IdGestor
		--LEFT JOIN  fAYCcalculaProximoVencimientoCredito(@FechaFin, 0) t on t.IdCuenta=Cuenta.IdCuenta

WHERE	Cuenta.IdTipoDproducto = 143			AND
		CuentaBAS.IdEstatus = 1					AND
		not Estadistica.FechaEntregada = '19000101'	AND
		(	
			Cuenta.PrimerVencimientoPendienteCapital <= @FechaFin OR 
			cuenta.PrimerVencimientoPendienteInteres <= @FechaFin
		)			
)	



GO

