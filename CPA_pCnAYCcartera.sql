
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCcartera')
	DROP PROC pCnAYCcartera
GO

CREATE PROC pCnAYCcartera
	 @FechaCartera DATE ,
     @CodigoSucursal VARCHAR(12) ='',
     @NoCuenta VARCHAR(12)=''
AS 
	SET NOCOUNT ON;
    SET XACT_ABORT ON;

	IF @FechaCartera IS NULL OR @FechaCartera='19000101'
		RETURN


	DECLARE @comando VARCHAR(MAX)=''
	DECLARE @comando2 VARCHAR(MAX)=''
		
	SET @comando ='SELECT c.CodigoSucursal,
           c.Sucursal,
           c.NoSocio,
           c.Socio,
           c.CodigoProducto,
           c.Producto,
           c.NoCuenta,
           c.TipoAmortizacion,
           c.NoPagos,
           c.PeriodicidadPago,
           c.DiasPeriodo,
           c.DiasAño,
           c.TasaInteresAnual,
           c.TasaInteresMensual,
           c.TasaMoratorioAnual,
           c.TasaMoratorioMensual,
           c.TasaIVA,
           c.FechaActivacion,
           c.[Monto Solicitado],
           c.MontoOtorgado,
           c.MontoEntregado,
           c.FechaVencimiento,
           c.Finalidad,
           c.FinalidadDescripcion,
           c.TipoCredito,
           c.Division,
           c.DiasMoralCapital,
           c.DiasMoraInteres,
           c.ParcialidadesAtrasadas,
           c.Capital,
           c.CapitalVigente,
           c.CapitalVencido,
           c.CapitalAtrasado,
           c.CapitalActual,
           c.IO,
           c.[IVA IO],
           c.[IO Atrasado],
           c.[IVA IO Atrasado],
           c.[IO Total Atrasado],
           c.[IO Vigente],
           c.[IO Vencido],
           c.[IO CuentasOrden],
           c.[IM Total],
           c.[IVA IM],
           c.[IM Vigente],
           c.[IM Vencido],
           c.[IM CuentasOrden],
           c.Cargos,
           c.[IVA Cargos],
           c.[Cargos Total],
           c.SaldoAtrasado,
           c.SaldoAlDia,
           c.SaldoActual,
           c.EstatusCartera,
           c.ProximoVencimiento,
           c.FechaUltimoPagoCapital,
           c.FechaUltimoPagoInteres,
           c.RestructuraRenovacion,
           c.PagosSostenidos,
           c.Estimacion,
           c.EstimacionAdicional,
           c.EstimacionCNBV,
           c.EstimacionRiesgosOperativos,
           c.[Rango Morosidad],
           c.[Asentamiento/Colonia],
           c.[Localidad/Ciudad],
           c.Municipio,
           c.Telefonos,
           c.Aval1,
           c.Aval2,
           c.Aval3
	FROM ';

	SET @comando = CONCAT(@comando,'dbo.fAYCcartera(''',@FechaCartera,''') c');
	
	IF @CodigoSucursal IN( '*','',' ') AND  @NoCuenta IN( '*','',' ')
		SET @comando2=@comando

	IF @CodigoSucursal NOT IN( '*','',' ')
	BEGIN
		SET @comando2 = CONCAT(@comando,' WHERE c.CodigoSucursal=''',@CodigoSucursal,'''')
	END


	IF @NoCuenta NOT IN( '*','',' ')
	BEGIN
		SET @comando2 = CONCAT(@comando,' WHERE c.NoCuenta=''',@NoCuenta,'''')
	END

	PRINT	@comando2
	EXEC(@comando2)

GO