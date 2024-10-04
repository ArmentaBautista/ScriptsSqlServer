


	DECLARE @NumeroEmpresa as tinyint=7;

	DECLARE @mes AS INT=DATEPART(MM,GETDATE()-30)  
	DECLARE @año AS INT=0    
	
	IF @mes=12  
	BEGIN    
		SET @año=DATEPART(YYYY,GETDATE()-365)  
	END  
	ELSE  
	BEGIN   
	SET @año=DATEPART(YYYY,GETDATE())  
	END    
	
	
	DECLARE @periodo AS VARCHAR(6)=CONCAT(@año,FORMAT(@mes,'00'))         
	--SELECT @periodo

	SELECT @NumeroEmpresa as IdEmpresa, Periodo = replace(Per.Codigo,'-',''),
	hd.IdPeriodo,
    hd.IdCuenta,
    hd.IdSocio,
    hd.IdCatalogoSITIclasificacionContable,
    hd.MontoTransaccionesDepositos,
    hd.MontoTransaccionesRetiros,
    hd.NumeroTransaccionesDepositos,
    hd.NumeroTransaccionesRetiros,
    hd.MontoDepositosEfectivo,
    hd.NumeroDepositosEfectivo,
    hd.InteresesOrdinarioDevengado,
    hd.InteresesMoratorioDevengado,
    hd.InteresesRefinanciados,
    hd.OrdinariosDevengadosFB,
    hd.MoratoriosDevengadosFB,
    hd.OrdinariosPagadosFB,
    hd.MoratoriosPagadosFB,
    hd.InteresesPagados,
    hd.Comisiones,
    hd.Condonaciones,
    hd.Bonificaciones,
    hd.SaldoInicial,
    hd.SaldoFinal,
    hd.Vencimiento,
    hd.IdEstatus,
    hd.IdCatalogoSITIsituacion,
    hd.FechaUltimoPagoCapital,
    hd.MontoUltimoPagoCapital,
    hd.FrecuenciaPagoCapital,
    hd.FechaPrimerAmortizacion,
    hd.FechaUltimoPagoInteres,
    hd.MontoUltimoPagoInteres,
    hd.FrecuenciaPagoInteres,
    hd.FechaConsultaSIC,
    hd.PorcentajeGarantiaAval,
    hd.ValorGarantia,
    hd.FechaValuacionGarantia,
    hd.GradoPrelacionGarantia,
    hd.ValorGarantiaHipotecaria,
    hd.GarantiaLiquida,
    hd.SaldoCapital,
    hd.SaldoInteresOrdinario,
    hd.SaldoInteresMoratorio,
    hd.IdEstatusCartera,
    hd.EstaEmproblemada,
    hd.ParteCubierta,
    hd.DiasMora,
    hd.EstimacionAnterior,
    hd.EstimacionAdicionalAnterior,
    hd.TipoCartera,
    hd.IdTipoDtablaEstimacion,
    hd.IdTransaccionFinanciera,
    hd.ParteCubiertaSaldo,
    hd.PorcentajeEstimacionParteCubierta,
    hd.PorcentajeEstimacionParteExpuesta,
    hd.PorcentajeRegimenTransitorio,
    hd.EstimacionParteCubierta,
    hd.EstimacionParteExpuesta,
    hd.Estimacion,
    hd.EstimacionAdicional,
    hd.EstimacionRiesgosOperativos,
    hd.EstimacionCNBV,
    hd.Referencia,
    hd.FechaCondonacion,
    hd.CalificacionDeudor,
    hd.CalificacionParteCubierta,
    hd.CalificacionParteExpuesta,
    hd.PagosVencidos,
    hd.IdTipoDEstimacionEspecial,
    hd.PorcentajeEstimacionEspecialParteCubierta,
    hd.PorcentajeEstimacionEspecialParteExpuesta,
    hd.PorcentajeEstimacionEspecialTotal,
    hd.EstimacionCNBVanterior,
    hd.EstimacionRiesgosOperativosAnterior,
    hd.GarantiaPrendaria,
    hd.IdSucursal,
    hd.Calificacion,
    hd.IdDivision,
    hd.IdTipoDAICclasificacion,
    hd.FechaVencida,
    hd.FechaPrimerIncumplimiento,
    hd.MontoParcialidad,
    hd.ParcialidadesPagadas,
    hd.IdCatalogoSITIacreditadoRelacionado,
    hd.IdCatalogoSITIclavePrevencion,
    hd.MontoBloqueado,
    hd.UltimaAmortizacionCubierta,
    hd.MontoAmortizacionCubierta,
    hd.UltimoInteresCubierto,
    hd.MontoInteresCubierto,
    hd.EsCondonada,
    hd.IdEstatusEstimacionPeriodo,
    hd.IdEstatusEstimacion,
    hd.CapitalCondonado,
    hd.OrdinarioCondonado,
    hd.MoratorioCondonado,
    hd.NoConsiderarGarantiaLiquida,
    hd.IdCatalogoSITItipoCredito,
    hd.PorcentajeEstimacionRiesgosOperativosParteCubierta,
    hd.PorcentajeEstimacionRiesgosOperativosParteExpuesta,
    hd.DiasMoraREG
	FROM tSDOhistorialDeudoras	hd  WITH(nolock) 
	JOIN tCTLperiodos			per  WITH(nolock) on per.IdPeriodo = hd.IdPeriodo
	WHERE replace(Per.Codigo,'-','') = @periodo
	
