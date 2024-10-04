
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='plstMensajesDeCobranzaPreventiva')
BEGIN
	DROP PROC plstMensajesDeCobranzaPreventiva
	SELECT 'plstMensajesDeCobranzaPreventiva BORRADO' AS info
END
GO

CREATE PROC plstMensajesDeCobranzaPreventiva
AS
		DECLARE @fecha AS DATE=GETDATE();
		DECLARE @fechacartera AS DATE=GETDATE();

		SELECT
			ISNULL(tel.Telefono,'') AS Telefono,
			@fecha AS Fecha,
			s.Codigo AS Nosocio,
			per.Nombre,
			c.Codigo AS Cuenta,
			c.Codigo,c.Descripcion AS Producto,
			par.Vencimiento,
			TotalAtrasado = fasc.CapitalAtrasado + fasc.InteresOrdinarioTotalAtrasado + fasc.InteresMoratorioTotal + fasc.Cargos + fasc.CargosImpuestos, 
			DiasMora=dbo.fAYCmoraMaxima(@fecha,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) ,
			es.Descripcion AS Estatus,
			Mensaje3=IIF(c.IdEstatusCartera=28,CONCAT('Caja Dr Arroyo le informa que el',' ',  CONVERT(varchar, PAR.Vencimiento,103),' vencio su cuenta',' ', c.Codigo ,' ','por',' ','$',  fasc.CapitalAtrasado + fasc.InteresOrdinarioTotalAtrasado + fasc.InteresMoratorioTotal + fasc.Cargos + fasc.CargosImpuestos,' ','Conserve su buen historial. Si realizo el pago favor de ignorar'),'Caja Dr Arroyo le informa que vencio su cuenta. Por lo que le sugerimos se comunique al 4888880057 o pase a nuestras oficinas horario 9:00 a 17:00 hrs'),
			Mensaje =CONCAT('Caja Dr Arroyo le informa que el',' ',  CONVERT(varchar, PAR.Vencimiento,103),' vencio su cuenta',' ', c.Codigo ,' ','por',' ','$',  fasc.CapitalAtrasado + fasc.InteresOrdinarioTotalAtrasado + fasc.InteresMoratorioTotal + fasc.Cargos + fasc.CargosImpuestos,' ','Conserve su buen historial. Si realizo el pago favor de ignorar')
		FROM dbo.tSCSsocios s
		JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = s.IdSocio
		JOIN dbo.tCTLestatus es ON es.IdEstatus = c.IdEstatusCartera
		JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = s.IdPersona
		LEFT JOIN dbo.vTelefonosConsultaSat tel WITH(NOLOCK) ON tel.IdSocio= s.IdSocio AND tel.Orden=1
		JOIN dbo.tAYCparcialidades par  WITH(NOLOCK) ON par.IdCuenta = c.IdCuenta
													 AND  par.Vencimiento=IIF(c.PrimerVencimientoPendienteInteres<c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres,c.PrimerVencimientoPendienteCapital)
		JOIN dbo.fAYCcalcularCarteraOperacion(@fechacartera, 2, 0, 0, 'DEVPAG') fasc ON fasc.IdCuenta = c.IdCuenta 
		WHERE c.IdTipoDProducto=143
		AND c.IdEstatus=1 --AND c.IdCuenta=111925
		AND dbo.fAYCmoraMaxima(@fecha,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) BETWEEN 1 AND 89
GO

