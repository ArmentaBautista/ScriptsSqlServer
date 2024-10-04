
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pLSTvisualizarCuentasAgestionarBAK')
BEGIN
	DROP PROC pLSTvisualizarCuentasAgestionarBAK
	SELECT 'pLSTvisualizarCuentasAgestionarBAK BORRADO' AS info
END
GO

CREATE PROC pLSTvisualizarCuentasAgestionarBAK
	@TipoOperacion AS VARCHAR(20),
    @IdGestor AS INT =0,
    @IdEstratoCartera INT = 0,
    @Sucursal VARCHAR(20) = '',
    @Ruta VARCHAR(20) = '',
    @Cuenta VARCHAR(25) = '',
    @Socio VARCHAR(25) = '',
    @FechaTrabajo DATE = '19000101',
	@MoraInicio INT = 0,
	@MoraFin INT = 0,
	@ParcialidadesAtrasadas INT = 0,
	@IdGestorFiltro INT = 0,
	@CodigoPostal INT = 0,
	@IdAsentamiento INT = 0,
	@FechaPago DATE='19000101'
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @Consulta AS NVARCHAR(MAX) = '',
			@ConsultaCtsOrden AS NVARCHAR(MAX) = '',
			@UnionCastigadas NVARCHAR(MAX)='',
			@ConsultaCtasOrden NVARCHAR(MAX)='',
            @Uniones AS NVARCHAR(MAX) = '',
            @Condiciones AS NVARCHAR(MAX) = '',
			@UnionesRutas AS NVARCHAR(MAX)='',
			@UnioCuentas AS  NVARCHAR(MAX)='',
			@UnionesCuentaSimple AS NVARCHAR(MAX)='',
			@Ordenamiento AS NVARCHAR(MAX) = '';

	SET @UnionesRutas ='INNER JOIN dbo.tGYCrutasD rd WITH(NOLOCK) ON rd.IdAsentamiento = cec.IdAsentamiento
		INNER JOIN dbo.tGYCRutas r WITH(NOLOCK) ON r.IdRuta = rd.IdRuta
		INNER JOIN dbo.tCTLestatus estatusRutas WITH(NOLOCK) on estatusRutas.IdEstatus = rd.IdEstatus and estatusRutas.IdEstatus=1
		INNER JOIN dbo.tGYCgestores g WITH(NOLOCK) ON g.IdGestor = r.IdGestor';
	
	SET @Consulta = CONCAT('select
		cue.IdCuenta, cec.IdEstratoCobranza, cec.IdTipoCobranzaSITI, DescripcionEstrato=est.Descripcion
		,est.EsAutomatico, suc.IdSucursal, NombreSucursal=suc.Descripcion	
		,UltimaGestion=gestiones.UltimaGestion, UltimoGestor=gestiones.CodigoGestor
		,IdGestor = cueEstadisticas.IdGestor, TotalGestiones=gestiones.NumeroGestiones, CodigoCuenta=cue.Codigo
		,prod.IdProductoFinanciero,ProductoFinanciero=prod.Descripcion
		,DiasMora=  fMoraMaxima.MoraMaxima --CASE WHEN cue.PrimerVencimientoPendienteCapital < cue.PrimerVencimientoPendienteInteres
	                                  --THEN DATEDIFF(d,cue.PrimerVencimientoPendienteCapital,''',CONVERT(VARCHAR(50),@FechaTrabajo,112),''')
	                                  --ELSE DATEDIFF(d,cue.PrimerVencimientoPendienteInteres,''',CONVERT(VARCHAR(50),@FechaTrabajo,112),''')END
		,IdEstatusCuenta=cue.IdEstatus,IdEstatusCuentaCartera=cue.IdEstatusCartera
		,SaldoAtrazado= CASE WHEN cec.SaldoAtrazado IS NOT NULL THEN cec.SaldoAtrazado
							 WHEN cartera.CapitalAtrasado IS NOT NULL THEN 
									ISNULL(cartera.CapitalAtrasado,0)+ISNULL(cartera.InteresOrdinarioTotalAtrasado,0)
									+ ISNULL(cartera.InteresMoratorioTotal,0)
									+ ISNULL(cartera.CargosTotal,0)
							 ELSE 0 END 
		,SaldoAlDía = CASE WHEN cec.SaldoAlDía IS NOT NULL THEN cec.SaldoAlDía
						   WHEN cartera.CapitalAlDia IS NOT NULL THEN
								ISNULL(cartera.CapitalAlDia,0)
								+ CASE WHEN cue.IdEstatusCartera=28 THEN  ISNULL(cartera.InteresOrdinarioVigente,0)
									  ELSE ISNULL(cartera.InteresOrdinarioVencido,0) END
								+ ISNULL(cartera.IVAInteresOrdinario,0)
								+ CASE WHEN cue.IdEstatusCartera=28 then ISNULL(cartera.InteresMoratorioVigente,0)
										ELSE ISNULL(cartera.InteresMoratorioVencido,0) END
								+ ISNULL(cartera.IVAinteresMoratorio,0)
								+ ISNULL(cartera.CargosTotal,0)
							ELSE 0 END 
		,SaldoActual=ISNULL(cartera.CapitalExigible,0) 
					 + CASE WHEN cue.IdEstatusCartera=28 THEN  ISNULL(cartera.InteresOrdinarioVigente,0)
									  ELSE ISNULL(cartera.InteresOrdinarioVencido,0) END
					 + ISNULL(cartera.IVAInteresOrdinario,0)
					 + CASE WHEN cue.IdEstatusCartera=28 then ISNULL(cartera.InteresMoratorioVigente,0)
						 	ELSE ISNULL(cartera.InteresMoratorioVencido,0) END
					 + ISNULL(cartera.IVAinteresMoratorio,0)
					 + ISNULL(cartera.CargosTotal,0)
		,con.IdConvenio,FolioConvenio=con.Folio,Convenio=con.FechaConvenio
		,FechaPromesa=con.FechaVigencia	,IdSocio=soc.IdSocio,IdpersonaSocio=per.IdPersona
		,NoSocio=soc.Codigo,NombreSocio=per.Nombre,Direccion=per.Domicilio,Telefonos=telefonos.Telefonos 
		,cec.EsManual, cec.Alta, RutaDescripcion=',IIF(@Ruta!='', 'r.Descripcion',''''''),'		
		,cue.IdApertura, gestiones.IdEvento	
		,ResumenCuenta=''$ '' + CAST(CONVERT(MONEY, cue.MontoEntregado) AS VARCHAR(30)) + '' - ''+ CAST(cue.NumeroParcialidades AS VARCHAR(15)) + '' Plazos - ''
	        + tipoPlazos.Descripcion + '' ,Tasa ''+ CAST(CAST(cue.InteresOrdinarioAnual * 100 AS NUMERIC(23, 1)) AS VARCHAR) + '' % Anual''
		,Vencimiento=cue.Vencimiento, DescripcionEstatusCartera=estatusCartera.Descripcion
		,IdEstatusCartera=estatusCartera.IdEstatus, DescripcionEstatusCuenta=estatusCuenta.Descripcion
		,HaberesSocio=ISNULL(cec.SaldoAbin,0)+ISNULL(cec.SaldoAhorro,0)
		,avalCartera.Aval1,avalCartera.Aval2,avalCartera.Aval3,pp.ParcialidadesAtrasadas
		,EnDepartamentoJuridico = IIF(cueJur.IdRegistro IS NOT NULL,1,0), EnProcesoJudicial=IIF(cueJud.IdRegistro IS NOT NULL,1,0)
		,MoraDescripcion= tbl.Descripción');
	
	SET @Uniones = CONCAT('FROM dbo.tAYCcuentas cue WITH(NOLOCK)
		INNER JOIN dbo.tAYCcuentasEstadisticas cueEstadisticas WITH(NOLOCK) ON cueEstadisticas.IdCuenta = cue.IdCuenta AND cueEstadisticas.IdApertura = cue.IdApertura AND cue.IdEstatus IN(1,53,73,7) and cue.IdTipoDProducto = 143
		INNER JOIN dbo.tAYCproductosFinancieros prod WITH(NOLOCK) ON prod.IdProductoFinanciero = cue.IdProductoFinanciero
		INNER JOIN dbo.tCTLsucursales suc WITH(NOLOCK) ON suc.IdSucursal = cue.IdSucursal
		INNER JOIN dbo.tCTLtiposD tipoPlazos  WITH ( NOLOCK ) ON tipoPlazos.IdTipoD = cue.IdTipoDPlazo
		INNER JOIN dbo.tCTLestatus estatusCartera  WITH ( NOLOCK ) ON estatusCartera.IdEstatus = cue.IdEstatusCartera
		INNER JOIN dbo.tCTLestatus estatusCuenta  WITH ( NOLOCK ) ON estatusCuenta.IdEstatus = cue.IdEstatus
		INNER JOIN dbo.tSCSsocios soc WITH(NOLOCK) ON soc.IdSocio = cue.IdSocio
		INNER JOIN dbo.tGRLpersonas per WITH(NOLOCK) ON per.IdPersona = soc.IdPersona
		LEFT JOIN dbo.tGYCcuentasEstratosCobranza cec WITH(NOLOCK) ON cec.IdCuenta = cue.IdCuenta
		LEFT JOIN dbo.tGYCestratosCobranza est WITH(NOLOCK) ON est.IdEstratoCobranza = cec.IdEstratoCobranza
		LEFT JOIN dbo.tCTLestatus eEstrato WITH(NOLOCK) ON eEstrato.IdEstatus = est.IdEstatus AND eEstrato.IdEstatus=1
		LEFT JOIN dbo.tGYCconveniosCuentas con WITH(NOLOCK) ON con.IdCuenta = cue.IdCuenta AND con.IdEstatus = 1
		LEFT JOIN dbo.tAYCavalesCartera avalCartera WITH(NOLOCK) ON avalCartera.RelAvales = cue.IdCuenta 
		LEFT JOIN dbo.fGYCparcialidadesAtrazadas(''', CONVERT(VARCHAR(50),@FechaTrabajo,112),''') pp ON  pp.IdCuenta = cue.IdCuenta
		LEFT JOIN dbo.fAYCobtenerMoraMaxima(''', CONVERT(VARCHAR(50),@FechaTrabajo,112),''',0,1) fMoraMaxima ON fMoraMaxima.IdCuenta = cue.IdCuenta
		LEFT JOIN ( SELECT   0 AS PlazoInicial ,
                       0 AS PlazoFinal ,
                       Descripción = ''0 Días''
              UNION --Rangos: Cartera Sana, de 1 a 3, de 4 a 30, de 31 a 60, de 61 a 90, de 90 a 180, de 181 a 30, más de 360
              SELECT   1 AS PlazoInicial ,
                       3 AS PlazoFinal ,
                       Descripción = ''1 a 3 Días''
              UNION
              SELECT   4 AS PlazoInicial ,
                       30 AS PlazoFinal ,
                       Descripción = ''4 a 30 Días''
              UNION
              SELECT   31 AS PlazoInicial ,
                       60 AS PlazoFinal ,
                       Descripción = ''31 a 60 Días''
              UNION
              SELECT   61 AS PlazoInicial ,
                       90 AS PlazoFinal ,
                       Descripción = ''61 a 90 Días''
              UNION
              SELECT   91 AS PlazoInicial ,
                       180 AS PlazoFinal ,
                       Descripción = ''91 a 180 Días''
              UNION
              SELECT   181 AS PlazoInicial ,
                       360 AS PlazoFinal ,
                       Descripción = ''181 a 360 Días''
              UNION
              SELECT   361 AS PlazoInicial ,
                       999999 AS PlazoFinal ,
                       Descripción = ''Mayor a 360 Días''
            ) tbl ON fMoraMaxima.MoraMaxima BETWEEN tbl.PlazoInicial AND tbl.PlazoFinal
		LEFT JOIN dbo.vCATtelefonosAgrupados telefonos  ON per.IdRelTelefonos=telefonos.IdRel
		',IIF(@Ruta!='',@UnionesRutas,''),'
		LEFT JOIN(	
				 	SELECT c.IdCuenta,eve.IdPersona,[UltimaGestion]	= MAX(eve.FechaRealizada),[NumeroGestiones]	= COUNT(eve.IdActividad)
				 		,[Visitas] = SUM(IIF(eve.IdTipoD = 1376 OR eve.IdTipoD=1374,1,0)),IdEvento=MAX(eve.IdEvento),CodigoGestor=MAX(gest.Codigo)
				 	FROM dbo.tGRLeventos eve  WITH(NOLOCK) 
				 	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON eve.IdCuenta= c.IdCuenta 
				 	INNER JOIN dbo.vGYCgestores gest ON gest.IdGestor = eve.IdGestor
				 	INNER JOIN dbo.tCTLestatus estatusEvento WITH(NOLOCK)ON	estatusEvento.IdEstatus = eve.IdEstatus AND estatusEvento.IdEstatus=50
				 	INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON (ce.IdCuenta = c.IdCuenta AND ce.IdApertura = c.IdApertura) 
				 														    AND (eve.FechaRealizada BETWEEN DATEADD(DAY, -30, ce.FechaUltimaGestion) and ce.FechaUltimaGestion)
				 	GROUP BY c.IdCuenta,eve.IdPersona
				 ) AS gestiones ON gestiones.IdCuenta=cue.IdCuenta AND (gestiones.IdPersona = cec.IdPersona)
		LEFT JOIN dbo.tGYCcuentasJuridico cueJur WITH(NOLOCK) ON cueJur.IdCuenta = cue.IdCuenta AND cueJur.IdEstatus=1
		LEFT JOIN dbo.tGYCcuentasProcesoJudicial cueJud WITH(NOLOCK) ON cueJud.IdCuenta = cue.IdCuenta AND cueJud.IdEstatus=1
		LEFT JOIN dbo.tCTLasentamientos asent With(nolock) ON asent.IdAsentamiento = per.IdAsentamiento AND asent.IdEstatus=1
		LEFT JOIN dbo.tAYCcartera cartera WITH(NOLOCK) ON cartera.IdCuenta = cue.IdCuenta AND cartera.FechaCartera=CAST(CONVERT(VARCHAR(10),''',@FechaTrabajo,''',112) AS DATE)
		');
	
	DECLARE @Comodin AS VARCHAR(max) ='WHERE';

	IF (@IdGestor!='' AND @Ruta!='')
	BEGIN
		SET @Condiciones=CONCAT(' g.IdGestor =',@IdGestor,' ')
	END

    IF @TipoOperacion = 'ESTRATOAEC'
    BEGIN
        IF @IdEstratoCartera <> 0 BEGIN        
            --SET @Condiciones = CONCAT(@Condiciones,IIF(CHARINDEX(' AND ',@Condiciones) = 0, ' AND', ''),' cec.IdEstratoCobranza=',@IdEstratoCartera,' ');
			SET @Condiciones = CONCAT(@Condiciones, IIF(@Condiciones!='',' AND ',''), ' cec.IdEstratoCobranza=',@IdEstratoCartera,' ');
		END
            
        IF @Sucursal != '' BEGIN
            --SET @Condiciones = CONCAT(@Condiciones,' AND',' suc.Codigo=''',@Sucursal,'''',' ');
			SET @Condiciones = CONCAT(@Condiciones, IIF(@Condiciones!='',' AND ',''), ' suc.Codigo=''',@Sucursal,'''',' ');
		END            
        IF @Ruta != ''BEGIN        
            --SET @Condiciones = CONCAT(@Condiciones,' AND',' r.Codigo=''',@Ruta,'''',' ');
			SET @Condiciones = CONCAT(@Condiciones, IIF(@Condiciones!='',' AND ',''), ' r.Codigo=''',@Ruta,'''',' ');
		END            

    END;

    IF @TipoOperacion = 'CUENTAAEC'
    BEGIN
		IF @Cuenta!=''
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' cue.Codigo=''',@Cuenta,'''',' ');
    END;

    IF @TipoOperacion = 'SOCIOAEC'
    BEGIN
		IF @Socio != ''
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' soc.Codigo=''',@Socio,'''',' ');
    END;
	IF @TipoOperacion = 'RANGOMORAEC'
    BEGIN
		IF(@MoraInicio<0 AND @MoraFin=0)
		BEGIN
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' cue.Vencimiento BETWEEN DATEADD(DAY,-15,CAST(CONVERT(VARCHAR(10),''',@FechaTrabajo,''',112) AS DATE)) and CAST(CONVERT(VARCHAR(10),''',@FechaTrabajo,''',112) AS DATE) ',CHAR(13)
									,'AND fMoraMaxima.MoraMaxima=0')
        END 
		ELSE 
		BEGIN	
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' fMoraMaxima.MoraMaxima BETWEEN ',@MoraInicio,' and ',@MoraFin,' ');
		END 
    END;
	IF @TipoOperacion = 'RANGOPAGOSEC'
    BEGIN
		SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' pp.ParcialidadesAtrasadas = ',@ParcialidadesAtrasadas,' ');
    END;
	IF @TipoOperacion = 'GESTORAEC'
    BEGIN
		IF @IdGestorFiltro != 0
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' cueEstadisticas.IdGestor = ',@IdGestorFiltro,' ');
    END;
    IF @TipoOperacion = 'CODPOSAEC'
    BEGIN
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' asent.CodigoPostal = ''',@CodigoPostal,''' ');
    END;
	IF @TipoOperacion = 'ASENTAMAEC'
    BEGIN
			SET @Condiciones = CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' per.IdAsentamiento = ',@IdAsentamiento,' ');
    END;
    IF @TipoOperacion='FCHPAGAEC'
	BEGIN	
		SET @Condiciones=CONCAT(IIF(@Condiciones!='',' AND ',''),@Condiciones,' cue.Vencimiento = CAST(CONVERT(VARCHAR(10),''',@FechaTrabajo,''',112) AS DATE)');
	END 

	IF @Condiciones =''
		SET @Comodin = REPLACE(@Comodin,'WHERE','')
	
	SET @Ordenamiento ='ORDER BY cue.IdEstatus';

	PRINT @Consulta;
	PRINT @Uniones;
	PRINT @Comodin
	PRINT @Condiciones;
	PRINT @Ordenamiento;

	  SET @Consulta = CONCAT(@Consulta, CHAR(13), @Uniones,CHAR(13),@Comodin, @Condiciones,CHAR(13),@Ordenamiento)
	  --SELECT @Consulta  
    EXECUTE sys.sp_executesql @Consulta;


END
 











GO

