

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnGYCrecuperacionEfectiva')
BEGIN
	DROP PROC pCnGYCrecuperacionEfectiva
	SELECT 'pCnGYCrecuperacionEfectiva BORRADO' AS info
END
GO

CREATE PROC pCnGYCrecuperacionEfectiva	
	@Gestor VARCHAR(20) = '*' ,
    @Sucursal VARCHAR(20) = '*' ,
    @FechaInicial DATE = '19000101' ,
    @FechaFinal DATE = '19000101'
AS 
BEGIN
	declare @comandoSelect VARCHAR(max) ='',
			@comandoUniones VARCHAR(MAX)='',
			@comandofiltros VARCHAR(MAX)='',
			@variablesTabla VARCHAR(max)='';

	SET @variablesTabla	= '
			DECLARE @bandas TABLE(
				PlazoInicial INT,
				PlazoFinal INT,
				Descripcion	VARCHAR(32)
			)

			INSERT INTO @bandas (PlazoInicial,PlazoFinal,Descripcion)
			SELECT 0 AS PlazoInicial , 0 AS PlazoFinal , Descripción = ''0 Días'' 
			UNION 
			SELECT 1 AS PlazoInicial , 3 AS PlazoFinal , Descripción = ''1 a 3 Días'' 
			UNION
			SELECT 4 AS PlazoInicial , 30 AS PlazoFinal , Descripción = ''4 a 30 Días'' 
			UNION
			SELECT 31 AS PlazoInicial , 60 AS PlazoFinal , Descripción = ''31 a 60 Días'' 
			UNION
			SELECT 61 AS PlazoInicial , 90 AS PlazoFinal , Descripción = ''61 a 90 Días'' 
			UNION
			SELECT 91 AS PlazoInicial , 180 AS PlazoFinal ,Descripción = ''91 a 180 Días'' 
			UNION
			SELECT 181 AS PlazoInicial , 360 AS PlazoFinal , Descripción = ''181 a 360 Días'' 
			UNION
			SELECT 361 AS PlazoInicial , 999999 AS PlazoFinal ,Descripción = ''Mayor a 360 Días''

			DECLARE @FinancierasSaldosPagados TABLE(
			Idoperacion					INT,
			IdGestor					int,
			IdCuenta					INT,
			IdTipoOperacion				INT,
			Folio						VARCHAR(24),
			IdTipoSubOperacion			INT,
			DIasMora					INT,
			Concepto					VARCHAR(128),
			Fecha						DATE,
			MontoSubOperacion			NUMERIC(18,2),
			CapitalPagado				NUMERIC(18,2),
			InteresOrdinarioPagado		NUMERIC(18,2),
			IVAInteresOrdinarioPagado	NUMERIC(18,2),
			InteresMoratorioPagado		NUMERIC(18,2),
			IVAInteresMoratorioPagado	NUMERIC(18,2),
			CargosPagados				NUMERIC(18,2),
			IVACargosPagado				NUMERIC(18,2),
			IVAPagado					NUMERIC(18,2),
			TotalPagado					NUMERIC(18,2),
			SubTotalPagado				NUMERIC(18,2),
			Total						NUMERIC(18,2),
			[Estatus al Pago]			VARCHAR(30)
			)

			INSERT INTO @FinancierasSaldosPagados
			(
				Idoperacion,
				IdGestor,
				IdCuenta,
				IdTipoOperacion,
				Folio,
				IdTipoSubOperacion,
				DIasMora,
				Concepto,
				Fecha,
				MontoSubOperacion,
				CapitalPagado,
				InteresOrdinarioPagado,
				IVAInteresOrdinarioPagado,
				InteresMoratorioPagado,
				IVAInteresMoratorioPagado,
				CargosPagados,
				IVACargosPagado,
				IVAPagado,
				TotalPagado,
				SubTotalPagado,
				Total,
				[Estatus al Pago]
			)
			SELECT 
			 Idoperacion					= op.IdOperacion
			,tf.IdGestor
			,IdCuenta					= MAX(tf.IdCuenta)
			,tOper.IdTipoOperacion
			,Folio						= CONCAT(tOper.Codigo,''-'',op.Serie,op.Folio)
			,IdTipoSubOperacion			= MAX(tf.IdTipoSubOperacion)
			,DIasMora					= MAX( tf.DiasMora)
			,Concepto					= MAX(IIF(tf.EsPrincipal = 1, tf.Concepto,tfPrincipal.Concepto))
			,Fecha						= op.Fecha
			,MontoSubOperacion			= SUM(tf.MontoSubOperacion)
			,CapitalPagado				=SUM(tf.CapitalPagado+tf.CapitalPagadoVencido)
			,InteresOrdinarioPagado		=SUM(tf.InteresOrdinarioPagado + tf.InteresOrdinarioPagadoVencido)
			,IVAInteresOrdinarioPagado	=SUM(tf.IVAInteresOrdinarioPagado)
			,InteresMoratorioPagado		=SUM(tf.InteresMoratorioPagado + tf.InteresMoratorioPagadoVencido)
			,IVAInteresMoratorioPagado	=SUM(tf.IVAInteresMoratorioPagado)
			,CargosPagados				=SUM(tf.CargosPagados)
			,IVACargosPagado			=SUM(tf.IVACargosPagado)
			,IVAPagado					=SUM(tf.IVAPagado)
			,TotalPagado				=SUM(tf.TotalPagado)
			,SubTotalPagado				=SUM(tf.SubTotalPagado)
			,Total						= op.Total
			,[Estatus al Pago]			= MAX(IIF( tf.EsPrincipal = 1, estatusDominio.Descripcion,estatusDominioPrincipal.Descripcion))
			 FROM tSDOtransaccionesFinancieras tf WITH(nolock) 
			 INNER JOIN dbo.tAYCcuentas c WITH(NOLOCK) ON c.IdCuenta = tf.IdCuenta AND c.IdTipoDProducto = 143
			 INNER JOIN dbo.tGRLoperaciones op WITH(NOLOCK) ON op.IdOperacion = tf.IdOperacion AND tf.IdOperacion!=0
			 INNER JOIN dbo.tCTLtiposOperacion tOper WITH(NOLOCK) ON tOper.IdTipoOperacion = op.IdTipoOperacion
			 INNER JOIN dbo.tCTLestatus estatusDominio WITH(NOLOCK) ON tf.IdEstatusDominio = estatusDominio.IdEstatus
			 LEFT JOIN dbo.tSDOtransaccionesFinancieras tfPrincipal ON tfPrincipal.IdCuenta = c.IdCuenta AND tfPrincipal.IdOperacion = op.IdOperacion AND tfPrincipal.EsPrincipal = 1 AND tfPrincipal.IdEstatus = 1
			 LEFT JOIN dbo.tCTLestatus estatusDominioPrincipal ON tfPrincipal.IdEstatusDominio = estatusDominioPrincipal.IdEstatus
			 WHERE op.IdOperacion>0 AND tf.IdEstatus = 1
			 GROUP BY op.IdOperacion,tf.IdGestor,op.Fecha,tOper.IdTipoOperacion,op.Folio,c.IdCuenta,op.Total,tOper.Codigo,op.Serie

'

	SET @comandoSelect =CONCAT(@variablesTabla,'

			SELECT 
			Folio = tf.Folio , 
			Fecha = tf.Fecha , 
			[Fecha de Asignación] = asignaciones.FechaAsignacion, 
			[Última Gestión] = gestiones.UltimaGestion , 
			Concepto = tf.Concepto ,
			Monto = tf.MontoSubOperacion , 
			[Código Sucursal] = s.Codigo , 
			[Sucursal] = s.Descripcion ,
			Cuenta = c.Codigo , 
			Producto = c.Descripcion , 
			Estatus = Es.Descripcion ,
			[Motivo Castigo]=ISNULL(castigos.MotivoCastigo,''''),
            [Estatus al Pago] = CASE WHEN pagosCreditosCastigadosCondonados.IdCuenta IS NOT NULL THEN pagosCreditosCastigadosCondonados.[Estatus al Pago]
								WHEN pagosCreditosActivos.IdCuenta IS NOT NULL THEN pagosCreditosActivos.[Estatus al Pago]
								ELSE '''' END ,
            Resumen = ''$ '' + CONCAT(c.MontoEntregado, '''') + '' - '' + CONCAT(c.NumeroParcialidades, '''') + '' Plazos - '' + pl.Descripcion + '' ,Tasa '' + CONCAT(( c.InteresOrdinarioAnual * 100 ), '''') + '' % Anual'' ,
            [Código del Socio] = sc.Socio ,
			[Nombre del Socio] = sc.Nombre ,  
			[Tipo de Gestor] = g.TipoGestorDescripcion , 
			[Código Gestor] = g.Codigo ,
			Gestor = g.Nombre ,  
			[Gestiones 30 Dias] = ISNULL(gestiones30dias.NumeroActividadesRango,0) , 
			[Gestiones Totales] = gestiones.TotalGestiones , 
			[Días Mora] = tf.DIasMora ,
			[Monto del Capital] = tf.CapitalPagado , 
			[Capital Pagado Atrasado] = ( ISNULL(pagosCreditosActivos.CapitalAtrasado, 0) + ISNULL(pagosCreditosCastigadosCondonados.CapitalAtrasado,0) ) ,
            [Capital Pagado Actual] = ( ISNULL(pagosCreditosActivos.CapitalPagadoNoAtrasado,0) + ISNULL(pagosCreditosCastigadosCondonados.CapitalPagado,0) ) ,
            [Interés Ordinario] = tf.InteresOrdinarioPagado , 
			[Interés Ordinario Pagado Atrasado] = ( ISNULL(pagosCreditosActivos.InteresOrdinarioAtrasado,0) + ISNULL(pagosCreditosCastigadosCondonados.InteresOrdinarioPagado, 0) ) ,
            [Interés Ordinario Pagado Actual] = ( ISNULL(pagosCreditosActivos.InteresOrdinarioNoAtrasado, 0) ) , 
			[IVA Interés Ordinario] = tf.IVAInteresOrdinarioPagado , 
			[Interés Moratorio] = tf.InteresMoratorioPagado , 
			[IVA Interés Moratorio] = tf.IVAInteresMoratorioPagado , 
			[Cargos] = tf.CargosPagados , 
			[IVA Cargos] = tf.IVACargosPagado ,
            [Recuperación Total Atrasado] = tf.InteresMoratorioPagado + tf.InteresOrdinarioPagado + ( ISNULL(pagosCreditosActivos.CapitalAtrasado, 0) + ISNULL(pagosCreditosCastigadosCondonados.CapitalAtrasado, 0) ) + tf.CargosPagados ,
            Banda = tbl.Descripción, 
			[Total Pagado]= (ISNULL(pagosCreditosActivos.CapitalPagadoNoAtrasado,0) + ISNULL(pagosCreditosCastigadosCondonados.CapitalPagado,0) ) +
							tf.InteresOrdinarioPagado + tf.IVAInteresOrdinarioPagado + tf.InteresMoratorioPagado + tf.IVAInteresMoratorioPagado + tf.CargosPagados  + tf.IVACargosPagado',CHAR(13))

	SET @comandoUniones =CONCAT('FROM    dbo.fSDOtransaccionesFinancierasSaldosPagados(''',CONVERT(VARCHAR, @FechaInicial,112),''',''',CONVERT(VARCHAR, @FechaFinal,112),''') tf 
            INNER JOIN dbo.tAYCcuentas c WITH ( NOLOCK ) ON c.IdCuenta = tf.IdCuenta AND c.IdTipoDProducto = 143            
            INNER JOIN dbo.tCTLestatus Es WITH ( NOLOCK ) ON Es.IdEstatus = c.IdEstatus
            INNER JOIN dbo.tCTLsucursales s WITH ( NOLOCK ) ON s.IdSucursal = c.IdSucursal
            INNER JOIN dbo.vSCSsocios sc WITH ( NOLOCK ) ON sc.IdSocio = c.IdSocio
            INNER JOIN dbo.tCTLtiposD pl WITH ( NOLOCK ) ON pl.IdTipoD = c.IdTipoDPlazo            			
            INNER JOIN @bandas tbl ON tf.DIasMora BETWEEN tbl.PlazoInicial AND     tbl.PlazoFinal
			LEFT JOIN dbo.vGYCgestores g WITH ( NOLOCK ) ON g.IdGestor = tf.IdGestor AND g.IdGestor != 0
			LEFT JOIN (SELECT MAX(ac.FechaAsignacion) AS FechaAsignacion, ac.IdGestor,ac.IdCuenta
						FROM dbo.tGYCasignacionCarteraD ac WITH ( NOLOCK )
						GROUP BY ac.IdCuenta, ac.IdGestor ) asignaciones ON asignaciones.idcuenta=c.IdCuenta AND asignaciones.IdGestor = g.IdGestor
            LEFT JOIN ( SELECT  tf.Fecha ,tf.Idoperacion ,evento.IdCuenta ,evento.IdGestor,NumeroActividadesRango = COUNT(evento.IdActividad)
                        FROM    dbo.tGRLeventos evento WITH(NOLOCK)
                                INNER JOIN @FinancierasSaldosPagados tf ON tf.IdCuenta = evento.IdCuenta  AND evento.FechaRealizada BETWEEN DATEADD(DAY, -30, tf.Fecha) AND tf.Fecha AND tf.IdGestor = evento.IdGestor AND tf.IdTipoSubOperacion = 500
                        WHERE   evento.IdEstatus = 50 AND evento.IdActividad != 0 AND evento.FechaRealizada BETWEEN DATEADD(DAY, -30,''', CONVERT(VARCHAR, @FechaInicial,112),''') AND ''',CONVERT(VARCHAR, @FechaFinal,112),''' AND tf.Fecha BETWEEN ''',@FechaInicial,''' AND ''',@FechaFinal,'''		
						GROUP BY evento.IdCuenta , tf.Idoperacion , tf.Fecha , evento.IdGestor
                      ) AS gestiones30dias ON gestiones30dias.Idoperacion = tf.Idoperacion AND gestiones30dias.IdCuenta = c.IdCuenta AND gestiones30dias.Fecha = tf.Fecha AND gestiones30dias.IdGestor = tf.IdGestor
            LEFT JOIN( SELECT  [TotalGestiones] = COUNT(IdActividad) ,tf.IdCuenta ,tf.IdGestor ,UltimaGestion = MAX(FechaRealizada) ,tf.Idoperacion
                        FROM    dbo.tGRLeventos evento WITH ( NOLOCK )
                                INNER JOIN @FinancierasSaldosPagados tf ON tf.IdCuenta = evento.IdCuenta AND evento.FechaRealizada <= tf.Fecha AND tf.IdGestor = evento.IdGestor AND tf.IdTipoSubOperacion = 500
								LEFT JOIN dbo.tSDOtransacciones trans WITH(NOLOCK) ON trans.IdOperacion = tf.Idoperacion 
								inner JOIN  dbo.tCNTauxiliares auxi WITH(NOLOCK) ON auxi.IdAuxiliar = trans.IdAuxiliar 
                        WHERE   IdActividad != 0 AND evento.IdEstatus = 50 AND tf.Idoperacion != 0 AND tf.IdTipoOperacion IN(1, 10) AND tf.IdTipoSubOperacion = 500 AND tf.Idoperacion != 0 AND ((tf.Total > 0) or auxi.Codigo=''TARJETA'')
                        GROUP BY tf.IdCuenta , tf.IdGestor , tf.Idoperacion
                      ) AS gestiones ON gestiones.IdCuenta = tf.IdCuenta AND gestiones.IdGestor = tf.IdGestor AND gestiones.Idoperacion = tf.Idoperacion
			LEFT JOIN( SELECT IdListaDMotivo= lstd.IdListaD, cas.MotivoCastigo,casd.IdCuenta,cas.IdCastigo
						FROM dbo.tAYCcuentas cue WITH(NOLOCK) 
						INNER JOIN  dbo.tAYCcastigosD casd WITH(NOLOCK) ON casd.IdCuenta= cue.IdCuenta
						INNER JOIN dbo.tAYCcastigos cas WITH(NOLOCK) ON cas.IdCastigo = casd.IdCastigo
						INNER JOIN dbo.tCATlistasD lstd WITH(NOLOCK) ON lstd.IdListaD=casd.IdListaDMotivo
						WHERE casd.IdListaDMotivo IN(-23)
					  ) AS castigos ON castigos.IdCuenta = c.IdCuenta
			LEFT JOIN dbo.fSDOpagosCreditosActivos(''',CONVERT(VARCHAR, @FechaInicial,112),''',''',CONVERT(VARCHAR, @FechaFinal,112),''') pagosCreditosActivos ON c.IdCuenta = pagosCreditosActivos.IdCuenta AND tf.Idoperacion = pagosCreditosActivos.IdOperacion
            LEFT JOIN dbo.vSDOpagosCreditosCastigadosCondonados pagosCreditosCastigadosCondonados WITH ( NOLOCK ) ON pagosCreditosCastigadosCondonados.IdCuenta = c.IdCuenta AND pagosCreditosCastigadosCondonados.IdOperacion = tf.Idoperacion
			LEFT JOIN dbo.tSDOtransacciones trans WITH(NOLOCK) ON trans.IdOperacion = tf.Idoperacion AND tf.IdTipoOperacion IN(1,10)   
			LEFT JOIN  dbo.tCNTauxiliares auxi WITH(NOLOCK) ON auxi.IdAuxiliar = trans.IdAuxiliar',CHAR(13))
SET @comandofiltros =CONCAT('WHERE   ((tf.Idoperacion != 0 AND tf.IdTipoOperacion IN(1, 10) AND tf.IdTipoSubOperacion = 500 AND tf.Idoperacion != 0 AND ((tf.Total > 0) or auxi.Codigo=''TARJETA''))  
							OR (tf.Idoperacion != 0 AND tf.IdTipoOperacion IN(43) AND tf.IdTipoSubOperacion = 500 AND tf.Idoperacion != 0)) 
							AND ( g.Codigo = ''',@Gestor,''' OR ''',@Gestor,''' = ''*'' )  
							AND ( s.Codigo = ''',@Sucursal,''' OR ''',@Sucursal,''' = ''*'' )  
							AND ( tf.Fecha BETWEEN ''',CONVERT(VARCHAR, @FechaInicial,112),''' AND ''',CONVERT(VARCHAR, @FechaFinal,112),''' )');

PRINT CAST(CONCAT(@comandoSelect,@comandoUniones,@comandofiltros) AS ntext)

EXEC(@comandoSelect + @comandoUniones+@comandofiltros)

END
	




GO

