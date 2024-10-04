
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pLSTasignarCartera')
BEGIN
	DROP PROC pLSTasignarCartera
	SELECT 'pLSTasignarCartera BORRADO' AS info
END
GO

CREATE PROC pLSTasignarCartera
    @FechaTrabajo DATE ,
    @IdRuta INT = 0 ,
    @IdSucursal INT = 0 ,
    @IdProductoFinanciero INT = 0 ,
    @DiasMoraInicial AS INT = 0 ,
    @DiasMoraFinal AS INT = 0 ,
    @MontoOtorgadoMinimo NUMERIC(23, 8) = 0 ,
    @MontoOtorgadoMaximo NUMERIC(23, 8) = 0 ,
    @SaldoMinimo NUMERIC(23, 8) = 0 ,
    @SaldoMaximo NUMERIC(23, 8) = 0 ,
	@IdSocio INT = 0,    
    @FechaInicial DATE = '19000101' ,
    @FechaFinal DATE = '19000101',
	@IdEstatus int =0,
	@IdEstratoCartera INT = 0
AS
    SET NOCOUNT ON;

    DECLARE @sqlcommand AS NVARCHAR(MAX);
    DECLARE @condicion AS VARCHAR(MAX);
	DECLARE @condicionCastigadas AS VARCHAR(MAX);
	DECLARE @Union AS VARCHAR(MAX);
	DECLARE @UnionCarteraDiaria AS VARCHAR(max)='';
	declare @CondicionEstrato AS VARCHAR(max)='';
    BEGIN	
    DECLARE @fechaAux AS DATE;
	SELECT TOP 1 @fechaAux=FechaCartera FROM dbo.tAYCcartera WHERE FechaCartera=@FechaTrabajo


	SET @Union='UNION 
		SELECT cal.IdCuenta ,car.IdAsignacionCarteraD ,car.IdGestor ,g.Codigo ,g.Nombre ,IdEstatuscarteraD = car.IdEstatus,Capital = cal.SaldoCapital ,InteresOrdinario =cal.SaldoInteresOrdinarioCuentasOrden,InteresOrdinarioIVA =cal.SaldoIVAinteresOrdinarioCuentasOrden,InteresOrdinarioTotal= cal.SaldoInteresOrdinarioCuentasOrden + cal.SaldoIVAinteresOrdinarioCuentasOrden,interesMoratorio= cal.SaldoInteresMoratorioCuentasOrden,InteresMoratorioIVA =cal.SaldoIVAinteresMoratorioCuentasOrden,InteresMoratorioTotal = cal.SaldoInteresMoratorioCuentasOrden + cal.SaldoIVAinteresMoratorioCuentasOrden,CapitalAtrasado =cal.SaldoCapital,CapitalExigible =cal.SaldoCapital,InteresOrdinarioAtrasado =cal.SaldoInteresOrdinarioCuentasOrden,InteresOrdinarioIVAAtrasado =cal.SaldoIVAinteresOrdinarioCuentasOrden,InteresOrdinarioTotalAtrasado = cal.SaldoInteresOrdinarioCuentasOrden + cal.SaldoIVAinteresOrdinarioCuentasOrden,InteresMoratorioAtrasado = cal.SaldoInteresMoratorioCuentasOrden,InteresMoratorioIVAAtrasado = cal.SaldoIVAinteresMoratorioCuentasOrden,
			InteresMoratorioTotalAtrasado =cal.SaldoInteresMoratorioCuentasOrden + cal.SaldoIVAinteresMoratorioCuentasOrden,DiasTranscurridos =0,DiasMora= ISNULL(Es.DiasMoraReestructuraRenovacion,0),Cargos =0,CargosImpuestos =0,CargosTotal = 0,Impuestos = cal.SaldoIVAinteresOrdinarioCuentasOrden + cal.SaldoIVAinteresMoratorioCuentasOrden,Total = cal.SaldoCapital + cal.SaldoInteresOrdinarioCuentasOrden + cal.SaldoIVAinteresOrdinarioCuentasOrden + cal.SaldoInteresMoratorioCuentasOrden + cal.SaldoIVAinteresMoratorioCuentasOrden,TotalAtrasado = cal.SaldoCapital + cal.SaldoInteresOrdinarioCuentasOrden + cal.SaldoIVAinteresOrdinarioCuentasOrden + cal.SaldoInteresMoratorioCuentasOrden + cal.SaldoIVAinteresMoratorioCuentasOrden,MoraMaxima = ISNULL(Es.DiasMoraReestructuraRenovacion,0),ParcialidadesVencidas = 0,SaldoTotal = cal.SaldoCapital + cal.SaldoInteresOrdinarioCuentasOrden + cal.SaldoIVAinteresOrdinarioCuentasOrden + cal.SaldoInteresMoratorioCuentasOrden + cal.SaldoIVAinteresMoratorioCuentasOrden, Cuenta = r.Cuenta,IdTipoDProducto =r.IdTipoDProducto,
			MontoEntregado =r.MontoEntregado,Saldo =r.Saldo,IdEstatusEntrega =r.IdEstatusEntrega,FechaEntrega =r.FechaEntrega,Vencimiento =r.Vencimiento,FechaActivacion =r.FechaActivacion,r.IdSocio ,SocioCodigo = r.SocioCodigo,SocioPersonaNombre = r.SocioPersonaNombre,IdPersona = r.IdPersona,r.IdProductoFinanciero ,ProductosFinancieroCodigo=r.ProductosFinancieroCodigo, ProductosFinancieroDescripcion=r.ProductosFinancieroDescripcion ,IdSucursal =r.IdSucursal,SucursalCodigo =r.SucursalCodigo,SucursalDescripcion=r.SucursalDescripcion ,IdEstatus =r.IdEstatus,EstatusCodigo = r.EstatusCodigo,r.EstatusDescripcion,r.IdEstatusCartera,EstatusCarteraCodigo =r.EstatusCarteraCodigo, r.EstatusCarteraDescripcion,IdRuta =0,RutaCodigo ='''',RutaDescripcion =IIF(r.Ruta!='''',SUBSTRING(r.Ruta, 1, LEN(r.Ruta) - 1),r.Ruta),RutaIdGestor ='''', car.FechaAsignacionAnterior,car.FechaAsignacion, car.IdGestorUltimaGestion, car.FechaUltimaGestionAnterior,car.FechaUltimaGestion,car.IdGestorAnterior
		FROM dbo.fAYCobtenerSaldoCuentasCastigadasSocio('+CONCAT('''', @fechaAux, '''')+', 2,0 , '+CONCAT(@IdSocio,'')+') AS cal 
		INNER JOIN dbo.tAYCcuentasEstadisticas Es WITH(NOLOCK) ON Es.IdCuenta = cal.IdCuenta
		JOIN vGYCrutasAsentamientosAuxiliar r WITH(NOLOCK) ON r.IdCuenta = cal.IdCuenta
		LEFT JOIN dbo.tGYCasignacionCarteraD car WITH(NOLOCK) ON car.IdCuenta = cal.IdCuenta AND car.IdEstatus=1
		LEFT JOIN dbo.vGYCgestores g WITH(NOLOCK) ON g.IdGestor = car.IdGestor'+CHAR(13)+' ';
		IF @IdRuta!=0
		BEGIN                           
			SET @Union +=  'INNER JOIN (
			SELECT c.IdCuenta
			FROM dbo.tAYCcuentas c WITH(NOLOCK)
			INNER JOIN dbo.tSCSsocios s WITH(NOLOCK) ON s.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas per WITH(NOLOCK) ON per.IdPersona = s.IdPersona
			INNER JOIN dbo.tGYCrutasD rd WITH(NOLOCK) ON rd.IdAsentamiento = per.IdAsentamiento
			INNER JOIN dbo.tGYCRutas r WITH(NOLOCK) ON r.IdRuta = rd.IdRuta and rd.IdEstatus=1
			WHERE c.IdCuenta!=0 AND c.IdSocio!=0 AND c.IdEstatus IN (1,53,73) AND r.IdRuta ='+CONCAT(@IdRuta,'')+'
			GROUP BY c.IdCuenta) AS x ON x.IdCuenta = cal.IdCuenta'+CHAR(13)+' ';
		END

		--PRINT @Union
        SET @sqlcommand = 'SELECT car.IdCuenta, a.IdAsignacionCarteraD,a.IdGestor,g.Codigo,g.Nombre, IdEstatuscarteraD = a.IdEstatus, car.Capital, car.InteresOrdinario, car.InteresOrdinarioIVA, car.InteresOrdinarioTotal, car.InteresMoratorio, car.InteresMoratorioIVA, car.InteresMoratorioTotal, car.CapitalAtrasado, car.CapitalExigible, car.InteresOrdinarioAtrasado, car.InteresOrdinarioIVAAtrasado, car.InteresOrdinarioTotalAtrasado, car.InteresMoratorioAtrasado, car.InteresMoratorioIVAAtrasado, car.InteresMoratorioTotalAtrasado, car.DiasTranscurridos, car.DiasMora, car.Cargos, car.CargosImpuestos, car.CargosTotal, car.Impuestos, car.Total, car.TotalAtrasado, car.MoraMaxima, car.ParcialidadesVencidas, car.SaldoTotal,
								  r.Cuenta, r.IdTipoDProducto, r.MontoEntregado, r.Saldo, r.IdEstatusEntrega, r.FechaEntrega, r.Vencimiento, r.FechaActivacion, r.IdSocio, r.SocioCodigo, r.SocioPersonaNombre, r.IdPersona, r.IdProductoFinanciero, r.ProductosFinancieroCodigo, r.ProductosFinancieroDescripcion, r.IdSucursal, r.SucursalCodigo, r.SucursalDescripcion, r.IdEstatus, r.EstatusCodigo,DescripcionEstatusD= r.EstatusDescripcion, r.IdEstatusCartera, r.EstatusCarteraCodigo, r.EstatusCarteraDescripcion,IdRuta=0,RutaCodigo='''', RutaDescripcion=IIF(r.Ruta!='''',SUBSTRING(r.Ruta, 1, LEN(r.Ruta) - 1),r.Ruta), RutaIdGestor='''',a.FechaAsignacionAnterior,a.FechaAsignacion,a.IdGestorUltimaGestion, a.FechaUltimaGestionAnterior,a.FechaUltimaGestion,a.IdGestorAnterior 							  								  
						   FROM vGYCrutasAsentamientosAuxiliar r WITH(NOLOCK)
						   JOIN dbo.vGyCcartera  car WITH(NOLOCK) ON car.IdCuenta = r.IdCuenta AND car.FechaCartera='+ CONCAT('''', @fechaAux, '''')+ CHAR(13) +' '+					   
						   'LEFT JOIN dbo.tGYCasignacionCarteraD a WITH(NOLOCK) ON car.IdCuenta = a.IdCuenta and a.IdEstatus=1 '+ CHAR(13) +' '+
						   'LEFT JOIN dbo.vGYCgestores g WITH(NOLOCK) ON g.IdGestor = a.IdGestor'+CHAR(13)+' ';
						   IF @IdRuta!=0
							BEGIN                           
								SET @sqlcommand +=  'INNER JOIN (
								SELECT c.IdCuenta
								FROM dbo.tAYCcuentas c WITH(NOLOCK)
								INNER JOIN dbo.tSCSsocios s WITH(NOLOCK) ON s.IdSocio = c.IdSocio
								INNER JOIN dbo.tGRLpersonas per WITH(NOLOCK) ON per.IdPersona = s.IdPersona
								INNER JOIN dbo.tGYCrutasD rd WITH(NOLOCK) ON rd.IdAsentamiento = per.IdAsentamiento
								INNER JOIN dbo.tGYCRutas r WITH(NOLOCK) ON r.IdRuta = rd.IdRuta and rd.IdEstatus=1
								WHERE c.IdCuenta!=0 AND c.IdSocio!=0 AND c.IdEstatus IN (1,53,73) AND r.IdRuta ='+CONCAT(@IdRuta,'')+'
								GROUP BY c.IdCuenta) AS x ON x.IdCuenta = car.IdCuenta'+CHAR(13)+' ';
							END

    
	IF @IdSucursal !=0 BEGIN
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND r.IdSucursal = ', @IdSucursal), CONCAT('WHERE r.IdSucursal = ', @IdSucursal )), CHAR(13))
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND r.IdSucursal = ', @IdSucursal), CONCAT('WHERE r.IdSucursal = ', @IdSucursal )), CHAR(13))
	End

	IF @IdProductoFinanciero!=0 BEGIN
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND r.IdProductoFinanciero = ', @IdProductoFinanciero),CONCAT('WHERE r.IdProductoFinanciero = ', @IdProductoFinanciero)), CHAR(13))
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND r.IdProductoFinanciero = ', @IdProductoFinanciero),CONCAT('WHERE r.IdProductoFinanciero = ', @IdProductoFinanciero)), CHAR(13))
	End
	/*IF @IdRuta!=0 begin
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND r.IdRuta = ', @IdRuta), CONCAT('WHERE r.IdRuta = ', @IdRuta)), CHAR(13))
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND r.IdRuta = ', @IdRuta), CONCAT('WHERE r.IdRuta = ', @IdRuta)), CHAR(13))
	END*/
	IF @DiasMoraInicial >= 0 AND @DiasMoraFinal > 0 begin
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND (car.DiasMora BETWEEN ', @DiasMoraInicial, ' AND ', @DiasMoraFinal, ')'), CONCAT('WHERE (car.DiasMora BETWEEN ', @DiasMoraInicial, ' AND ', @DiasMoraFinal, ')')), CHAR(13));
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND (ISNULL(Es.DiasMoraReestructuraRenovacion, 0) BETWEEN ', @DiasMoraInicial, ' AND ', @DiasMoraFinal, ')'), CONCAT('WHERE (ISNULL(Es.DiasMoraReestructuraRenovacion,0) BETWEEN ', @DiasMoraInicial, ' AND ', @DiasMoraFinal, ')')), CHAR(13));
	end

	IF @MontoOtorgadoMinimo > 0 AND @MontoOtorgadoMaximo > 0 begin
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND (r.MontoEntregado BETWEEN ', @MontoOtorgadoMinimo, ' AND ', @MontoOtorgadoMaximo, ')'), CONCAT('WHERE (r.MontoEntregado BETWEEN ', @MontoOtorgadoMinimo, ' AND ', @MontoOtorgadoMaximo, ')')), CHAR(13));
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND (r.MontoEntregado BETWEEN ', @MontoOtorgadoMinimo, ' AND ', @MontoOtorgadoMaximo, ')'), CONCAT('WHERE (r.MontoEntregado BETWEEN ', @MontoOtorgadoMinimo, ' AND ', @MontoOtorgadoMaximo, ')')), CHAR(13));
	end
	IF @SaldoMinimo > 0 AND @SaldoMaximo > 0 begin
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND (r.Saldo BETWEEN ', @SaldoMinimo,' AND ', @SaldoMaximo, ')'), CONCAT('WHERE (r.Saldo BETWEEN ', @SaldoMinimo,' AND ', @SaldoMaximo, ')')), CHAR(13));
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND (r.Saldo BETWEEN ', @SaldoMinimo,' AND ', @SaldoMaximo, ')'), CONCAT('WHERE (r.Saldo BETWEEN ', @SaldoMinimo,' AND ', @SaldoMaximo, ')')), CHAR(13));
	end
	IF @IdSocio > 0 
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND r.IdSocio = ', @IdSocio), CONCAT('WHERE r.IdSocio = ', @IdSocio)), CHAR(13));
	
	
	IF @FechaInicial > '19000101' AND @FechaFinal > '19000101' BEGIN
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND (Es.FechaCastigo BETWEEN ''', @FechaInicial, ''' AND ''', @FechaFinal, ''')'), CONCAT('WHERE (Es.FechaCastigo BETWEEN ''', @FechaInicial, ''' AND ''', @FechaFinal, ''')')), CHAR(13));
		--SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND ( p.Vencimiento BETWEEN ','''',@FechaInicial,'''', ' AND ','''', @FechaFinal,'''', 'AND p.EstaPagada = 0', ')', CHAR(13),'ORDER BY p.NumeroParcialidad'), CONCAT('AND ( p.Vencimiento BETWEEN ','''',@FechaInicial,'''', ' AND ','''', @FechaFinal,'''', 'AND p.EstaPagada = 0', ')', CHAR(13),'ORDER BY p.NumeroParcialidad' )), CHAR(13));
		--SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND ( p.Vencimiento BETWEEN ','''',@FechaInicial,'''', ' AND ','''', @FechaFinal,'''', 'AND p.EstaPagada = 0', ')', CHAR(13),'ORDER BY p.NumeroParcialidad'), CONCAT('AND ( p.Vencimiento BETWEEN ','''',@FechaInicial,'''', ' AND ','''', @FechaFinal,'''', 'AND p.EstaPagada = 0', ')', CHAR(13),'ORDER BY p.NumeroParcialidad' )), CHAR(13));
	END
	
    IF @IdEstatus!=0 begin
		SET @condicionCastigadas = CONCAT(@condicionCastigadas, IIF (@condicionCastigadas LIKE '%WHERE%', CONCAT('AND r.IdEstatus = ', @IdEstatus), CONCAT('WHERE r.IdEstatus = ', @IdEstatus)), CHAR(13));
		SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND r.IdEstatus = ', @IdEstatus), CONCAT('WHERE r.IdEstatus = ', @IdEstatus)), CHAR(13));
	end
	
	IF EXISTS(SELECT 1 FROM sys.databases WHERE name LIKE'%RPT%')
	BEGIN 
		IF @IdEstratoCartera != 0 
		BEGIN
			--DECLARE @RfcEmpresa AS VARCHAR(max);
			--SELECT @RfcEmpresa = per.RFC FROM dbo.tCTLempresas emp with(nolock)
			--INNER JOIN dbo.tGRLpersonas per with(nolock) ON per.IdPersona = emp.IdPersona
			--WHERE emp.IdEmpresa=1			 
			 SET @sqlcommand =CONCAT(@sqlcommand,'INNER JOIN dbo.tGYCcuentasEstratosCobranza cec with(nolock) ON cec.IdCuenta = car.IdCuenta',CHAR(13));
			 SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND cec.IdEstratoCobranza = ', @IdEstratoCartera), CONCAT('WHERE cec.IdEstratoCobranza  = ', @IdEstratoCartera )), CHAR(13))
			 --IF @RfcEmpresa='CPO870402RE8'
			 --BEGIN	
				--SET @UnionCarteraDiaria = CONCAT('LEFT JOIN iERP_OBL_RPT.dbo.tayccarteradiaria carteraDiaria WITH(nolock) ON car.IdCuenta=carteraDiaria.IdCuenta',CHAR(13));
				--SET @sqlcommand =CONCAT(@sqlcommand,@UnionCarteraDiaria)
				
				--SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND CarteraDiaria.IdEstratoCobranza = ', @IdEstratoCartera), CONCAT('WHERE CarteraDiaria.IdEstratoCobranza  = ', @IdEstratoCartera )), CHAR(13))
			 --END

			 --IF @RfcEmpresa='UPS040829UG3' OR @RfcEmpresa='LAN7008173R5'
			 --BEGIN	
				--SET @UnionCarteraDiaria = CONCAT('LEFT JOIN iERP_UPS_RPT.dbo.tayccarteradiaria carteraDiaria WITH(nolock) ON car.IdCuenta=carteraDiaria.IdCuenta',CHAR(13));
				--SET @sqlcommand =CONCAT(@sqlcommand,@UnionCarteraDiaria)
				--SET @condicion = CONCAT(@condicion, IIF (@condicion LIKE '%WHERE%', CONCAT('AND CarteraDiaria.IdEstratoCobranza = ', @IdEstratoCartera), CONCAT('WHERE CarteraDiaria.IdEstratoCobranza  = ', @IdEstratoCartera )), CHAR(13))
			 --END
		END         
	END    
	
	SET @sqlcommand = CONCAT(@sqlcommand, @condicion);
		
	SET @Union = CONCAT(@Union, @condicionCastigadas);  

	SET @sqlcommand = CONCAT(@sqlcommand, @Union);  

	PRINT @sqlcommand
	--SELECT  @sqlcommand

	EXECUTE sys.sp_executesql @sqlcommand 
    END;





















GO

