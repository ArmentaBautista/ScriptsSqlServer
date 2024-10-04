SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO



ALTER  PROC  [dbo].[pPLDrepotarInusualidad]
	@fecha AS DATE='19000101'
as
SET NOCOUNT ON
SET XACT_ABORT ON	


BEGIN
	

DECLARE @IdPeriodo AS INT=(SELECT	fcip.IdPeriodo FROM	dbo.fCTLObtenerIdPeriodo(@fecha,0) fcip);
DECLARE @IdPeriodoEmpieza AS INT=0;

PRINT @fecha
PRINT @IdPeriodo;

WITH tabla AS (
SELECT TOP 12 *FROM tCTLperiodos tc
WHERE tc.IdPeriodo<=@idperiodo AND tc.EsAjuste !=1
ORDER BY tc.IdPeriodo DESC
)SELECT TOP 1 @IdPeriodoEmpieza=IdPeriodo FROM tabla
 ORDER BY IdPeriodo;

--primer dia del mes dependiendo de la fecha
DECLARE @fechaInicio AS DATE='19000101'
 set @FechaInicio= CONVERT(DATE,DATEADD(dd,-(DAY(@fecha)-1),@fecha),112)

 ---último día del mes
 DECLARE @fechaFin AS DATE='19000101'
 SET @fechaFin= EOMONTH(@fecha,0)

	PRINT @IdPeriodoEmpieza;
	PRINT @fechaFin 


	
	---------------------------------------------------------------------------------------------------------------------
	----------------------------- SE OBTIENE LA SUMA DE LOS DEPOSITOS ,RETIROS Y NUMEROO DE OPERACIONES DEL MES------------------------
	---------------------------------------------------------------------------------------------------------------------
		DECLARE @NumeroOperacionesMes AS TABLE (IdSocio int,IdTipoSubOperacion  int,MontoMes  numeric(23,8),NumeroOperacionesMes  INT,IdPersona INT)

		INSERT INTO  @NumeroOperacionesMes
		SELECT tabla.IdSocio,tabla.IdTipoSubOperacion,(SUM(tabla.Monto-tabla.MontoCambio)) AS MontoMes,COUNT(*) AS NumeroOperacionesMes ,IdPersona
		FROM (
				SELECT o.IdSocio,d.IdTipoSubOperacion,d.Monto,ISNULL(td.Monto,0) AS MontoCambio,o.IdPersona
				FROM tSDOtransaccionesD d(NOLOCK)
				JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
				JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
				JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio 
				left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
				WHERE d.IdMetodoPago IN (-2,-10)  and o.fecha BETWEEN   @fechaInicio AND   @Fecha AND o.idsocio!=0
				 AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18  
				 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
				 AND d.Monto>50000 -- JCA 220123 Se agrega por política de FNG, las operaciones deben ser superiores a 50K
				UNION all
				SELECT soc.idsocio,d.IdTipoSubOperacion, d.Monto,isnull(td.Monto,0) AS MontoCambio,soc.IdPersona
				FROM tSDOtransaccionesD d(NOLOCK)
				JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
				JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdPersona=o.IdPersonaMovimiento
				left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
				WHERE o.IdSocio=0 AND o.IdPersona=0  AND o.IdPersonaMovimiento!=0
				AND d.IdMetodoPago IN (-2,-10)  and o.fecha BETWEEN   @fechaInicio AND   @fecha 
				 AND d.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18   
				 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
				 AND d.Monto>50000  -- JCA 220123 Se agrega por política de FNG, las operaciones deben ser superiores a 50K
		 ) AS tabla
		 GROUP BY IdSocio,IdTipoSubOperacion,IdPersona
		

		--SELECT *FROM @NumeroOperacionesMes
	------------------------------------------------------------------------------------------------------------------------
	-------------------------------------OBTENER LAS TRANSACCIONES DE LA FECHA QUE SE VA A EVALUAR--------------------------
	------------------------------------------------------------------------------------------------------------------------
	DECLARE @TransaacionesD AS TABLE (IdPersona INT,MontoSubOperacion NUMERIC(23,8),IdUsuarioAlta INT,Alta DATETIME,IdUsuarioCambio INT,UltimoCambio DATETIME,IdSesion INT,IdOperacion INT, IdtransaccionD INT,IdSocio INT,IdCuenta INT,IdEstattus INT,EsPersonaMoral BIT,IdTipoSubOperacion INT,fecha  DATE,IdDivisa int,IdSucursal INT,IdMetodoPago INT)
	
	INSERT INTO @TransaacionesD
	SELECT tabla.IdPersona, tabla.Monto, tabla.IdUsuarioAlta, tabla.Alta, tabla.IdUsuarioCambio,
	tabla.UltimoCambio, tabla.IdSesion, tabla.IdOperacion, tabla.IdTransaccionD, tabla.IdSocio,
	tabla.IdCuenta, tabla.IdEstatus, tabla.EsPersonaMoral, tabla.IdTipoSubOperacion, tabla.Fecha,
	tabla.IdDivisa, tabla.IdSucursal, tabla.IdMetodoPago
	FROM (
		SELECT soc.IdPersona AS IdPersona,(d.Monto-ISNULL(td.Monto,0)) AS Monto,t.IdUsuarioAlta,t.Alta,t.IdUsuarioCambio,t.UltimoCambio,t.IdSesion,d.IdOperacion,d.IdTransaccionD,o.IdSocio,t.IdCuenta,o.IdEstatus,p.EsPersonaMoral,d.IdTipoSubOperacion,o.Fecha,t.IdDivisa,o.IdSucursal,d.IdMetodoPago
		 FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
		JOIN dbo.tSCSsocios soc(NOLOCK)ON soc.IdSocio=o.IdSocio
		JOIN dbo.tGRLpersonas p (NOLOCK)ON p.IdPersona=soc.IdPersona
		left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		WHERE d.IdMetodoPago IN (-2,-10)  AND o.fecha = @fecha AND o.idsocio!=0
		AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
		AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		AND d.Monto>50000  -- JCA 220123 Se agrega por política de FNG, las operaciones deben ser superiores a 50K
	  UNION ALL
		SELECT soc.IdPersona,(d.Monto-ISNULL(td.Monto,0)) AS Monto,o.IdUsuarioAlta,o.Alta,o.IdUsuarioCambio,o.UltimoCambio,o.IdSesion,d.IdOperacion,d.IdTransaccionD,soc.IdSocio,0 AS IdCuenta,o.IdEstatus,per.EsPersonaMoral,d.IdTipoSubOperacion,o.Fecha,o.IdDivisa,o.IdSucursal,d.IdMetodoPago
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdPersona=o.IdPersonaMovimiento
		JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		WHERE o.IdSocio=0 AND o.IdPersona=0  AND o.IdPersonaMovimiento!=0
		AND d.IdMetodoPago IN (-2,-10)  and o.fecha =@fecha 
		AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
		AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		AND d.Monto>50000  -- JCA 220123 Se agrega por política de FNG, las operaciones deben ser superiores a 50K 
		 ) AS tabla
  
	  --SELECT *FROM @TransaacionesD

	-------------------------------------OBTENER LAS TRANSACCIONES DEl mes QUE SE VA A EVALUAR--------------------------
	------------------------------------------------------------------------------------------------------------------------
	DECLARE @TransaacionesDmes AS TABLE (IdPersona INT,MontoSubOperacion NUMERIC(23,8),IdUsuarioAlta INT,Alta DATETIME,IdUsuarioCambio INT,UltimoCambio DATETIME,IdSesion INT,IdOperacion INT, IdtransaccionD INT,IdSocio INT,IdCuenta INT,IdEstattus INT,EsPersonaMoral BIT,IdTipoSubOperacion INT,fecha  DATE,IdDivisa int,IdSucursal INT,IdMetodoPago INT)
	
	INSERT INTO @TransaacionesDmes
	SELECT  tabla.IdPersona, tabla.Monto, tabla.IdUsuarioAlta, tabla.Alta, tabla.IdUsuarioCambio,
	tabla.UltimoCambio, tabla.IdSesion, tabla.IdOperacion, tabla.IdTransaccionD, tabla.IdSocio, 
	tabla.IdCuenta, tabla.IdEstatus, tabla.EsPersonaMoral, tabla.IdTipoSubOperacion, tabla.Fecha, 
	tabla.IdDivisa, tabla.IdSucursal, tabla.IdMetodoPago
	FROM (
	SELECT soc.IdPersona AS IdPersona,(d.Monto- ISNULL(td.Monto,0)) AS Monto,t.IdUsuarioAlta,t.Alta,t.IdUsuarioCambio,t.UltimoCambio,t.IdSesion,d.IdOperacion,d.IdTransaccionD,o.IdSocio,t.IdCuenta,o.IdEstatus,p.EsPersonaMoral,d.IdTipoSubOperacion,o.Fecha,t.IdDivisa,o.IdSucursal,d.IdMetodoPago
	 FROM tSDOtransaccionesD d(NOLOCK)
	JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
	JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
	JOIN dbo.tSCSsocios soc(NOLOCK)ON soc.IdSocio=o.IdSocio
	JOIN dbo.tGRLpersonas p (NOLOCK)ON p.IdPersona=soc.IdPersona
	left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
	WHERE d.IdMetodoPago IN (-2,-10)  AND o.fecha BETWEEN @fechaInicio and @fecha AND o.idsocio!=0
	  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
	  AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
	  AND d.Monto>50000  -- JCA 220123 Se agrega por política de FNG, las operaciones deben ser superiores a 50K
	  UNION ALL
		SELECT soc.IdPersona,(d.Monto-ISNULL(td.Monto,0)) AS Monto,o.IdUsuarioAlta,o.Alta,o.IdUsuarioCambio,o.UltimoCambio,o.IdSesion,d.IdOperacion,d.IdTransaccionD,soc.IdSocio,0 AS IdCuenta,o.IdEstatus,per.EsPersonaMoral,d.IdTipoSubOperacion,o.Fecha,o.IdDivisa,o.IdSucursal,d.IdMetodoPago
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdPersona=o.IdPersonaMovimiento
		JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		WHERE o.IdSocio=0 AND o.IdPersona=0  AND o.IdPersonaMovimiento!=0
		AND d.IdMetodoPago IN (-2,-10)  and o.fecha BETWEEN @fechaInicio AND @fecha 
		AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
		AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		AND d.Monto>50000  -- JCA 220123 Se agrega por política de FNG, las operaciones deben ser superiores a 50K
	) AS tabla


    ---------------------------------------------------------------------------------------------------------------------
	---------------------------------------------FIN DE MES--------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------



	IF (@Fecha=@fechaFin)
	BEGIN
		

		 -----------Alerta por montos fraccionados:operaciones individuales que sean iguales o superen 500 dolares,realizadas en un mismo mes calendario que igualen o superen los 7500 dolares 
		DECLARE @montoOperacionFraccionada AS NUMERIC(23,8)=0
		DECLARE @MontoRelevante AS NUMERIC(23,8)=0
	
		SET @montoOperacionFraccionada=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-31)
		SET @MontoRelevante=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-33)
	
	
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio,IdInusualidad,IdMetodoPago,Descripcion)
		
		 SELECT idpersona,1593,46,1,-1,@fecha,-1,@fecha,1598,0,0,0
		 ,CONCAT('Alerta por montos fraccionados:operaciones individuales que sean igualen o superen ',@montoOperacionFraccionada,' dolares,realizadas en un mismo mes calendario que igualen o superen los ',@MontoRelevante,' dolares.Monto Acumulado en pesos  ',tabla.MontoCuenta,', monto en dolares ',(SELECT  dbo.[fDIVmontoCalculado](1,-4,@fecha,tabla.MontoCuenta))),
		tabla.MontoCuenta,tabla.IdSocio,16,0,'x'
		FROM (
				SELECT o.idsocio ,SUM(d.monto-isnull(tr.Monto,0)) AS MontoCuenta,soc.idpersona
				FROM tSDOtransaccionesD d(NOLOCK)
				JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
				LEFT JOIN  dbo.tSDOtransaccionesD tr  WITH(NOLOCK) ON tr.IdOperacion = o.IdOperacion AND tr.EsCambio=1
				JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio
				WHERE d.IdMetodoPago IN (-2,-10)  and o.fecha BETWEEN   @fechaInicio AND   @fechaFin 
				AND o.idsocio!=0 AND (SELECT  dbo.[fDIVmontoCalculado](o.IdDivisa,-4,o.Fecha,d.monto))>=@montoOperacionFraccionada --AND t.IdCuenta!=0
				AND d.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
				AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
				GROUP BY o.IdSocio,soc.idpersona
				having count(o.idoperacion)>1
		) AS tabla 
		WHERE (SELECT  dbo.[fDIVmontoCalculado](1,-4,@fecha,tabla.MontoCuenta))>@MontoRelevante
		AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.IdSocio  AND opl.IdInusualidad=16 AND Alta=@fecha)
		




		----------Suma de Depósitos al Cierre de Mes es 3 veces superior a los Ingresos Ordinarios declarados por el Socio	Mensual
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
			                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
			                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
		SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
		,IdtransaccionD,CONCAT('Suma de Depósitos al Cierre de Mes es 3 veces superior a los Ingresos Ordinarios declarados por el Socio.Monto Mensual:',MontoMes,',Ingresos declarados',tabla.Ingreso)
		,MontoMes,IdSocio,0,34,IdMetodoPago,'X'
		FROM (
				SELECT soc.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
				,t.IdtransaccionD,t.MontoSubOperacion
				,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
				,(aie.IngresoOrdinario) AS Ingreso
				FROM @TransaacionesDmes t
				JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
				JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
				JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
				JOIN dbo.tSCSanalisisCrediticio ac With (nolock) ON ac.IdPersona = soc.IdPersona
				JOIN dbo.tSCSanalisisIngresosEgresos aie With (nolock) ON aie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
		) AS tabla 
		WHERE tabla.IdTipoSubOperacion=500 AND iif (Ingreso=0, 0,( MontoMes/tabla.Ingreso))>3 AND tabla.numero=1
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=34 AND Alta=tabla.Fecha)

		--	-------------------------------ALERTA POR DEPOSITO SUPERIOR A 300 MIL PESOS PARA PERSONAS FISICAS ACUMULADOS EN UN MES CALENDARIO---------------------- solo el ultimo dia del mes
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Descripcion)
                     --1593 ---presunta inusual   46--Estatus Generado
		SELECT  tabla.IdPersona,1593,46,tabla.MontoSubOperacion,1,-1,tabla.Alta,-1,tabla.UltimoCambio,1598,tabla.IdSesion,tabla.IdOperacion,tabla.IdtransaccionD,
		'Alerta por depósito Superior a 300 mil pesos para personas fisicas acumulados en un mes calendario.',tabla.MontoMes,tabla.IdSocio,tabla.IdCuenta,7,'X' 
		FROM (
		SELECT ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,op.IdTipoSubOperacion ORDER BY t.IdOperacion DESC,t.fecha desc ) AS numero	
		,op.MontoMes, t.IdPersona,t.Alta,t.UltimoCambio,t.IdSesion,t.IdOperacion,t.IdtransaccionD,
		t.IdSocio,t.IdCuenta,t.MontoSubOperacion
		FROM @TransaacionesDmes t
		JOIN @NumeroOperacionesMes op ON op.idsocio=t.IdSocio
		WHERE t.EsPersonaMoral=0  AND op.IdTipoSubOperacion =500 AND t.IdSocio!=0 AND op.MontoMes>300000
		
		) AS tabla
		WHERE tabla.numero=1
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones v (NOLOCK) WHERE v.IdTransaccionD=tabla.IdtransaccionD AND v.IdInusualidad=7)


	
		--	-------------------------------ALERTA POR DEPOSITO SUPERIOR A 500 MIL PESOS PARA PERSONAS morales ACUMULADOS EN UN MES CALENDARIO---------------------- solo el ultimo dia del mes
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Descripcion)
                     --1593 ---presunta inusual   46--Estatus Generado
		SELECT  tabla.IdPersona,1593,46,tabla.MontoSubOperacion,1,-1,tabla.Alta,-1,tabla.UltimoCambio,1598,tabla.IdSesion,tabla.IdOperacion,tabla.IdtransaccionD,
		'Alerta por depósito Superior a 500 mil pesos para personas morales acumulados en un mes calendario.',tabla.MontoMes,tabla.IdSocio,tabla.IdCuenta,39,'X' 
		FROM (
		SELECT ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,op.IdTipoSubOperacion ORDER BY t.IdOperacion DESC,t.fecha desc ) AS numero	
		,op.MontoMes, t.IdPersona,t.Alta,t.UltimoCambio,t.IdSesion,t.IdOperacion,t.IdtransaccionD,
		t.IdSocio,t.IdCuenta,t.MontoSubOperacion
		FROM @TransaacionesDmes t
		JOIN @NumeroOperacionesMes op ON op.idsocio=t.IdSocio
		WHERE t.EsPersonaMoral=1  AND op.IdTipoSubOperacion =500 AND t.IdSocio!=0 AND op.MontoMes>500000
		
		) AS tabla
		WHERE tabla.numero=1
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones v (NOLOCK) WHERE v.IdTransaccionD=tabla.IdtransaccionD AND v.IdInusualidad=39)
		
		
	END


	---------------------------------------------------------------------------------------------------------------------
	--------------------------COMPARACION DE LA SUMA MONTOS DE DEPOSITOS MES CALENDARIO----------------------------------
	--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
	-------------------------DIARIO--------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------	
	--------------------------------------CON DATO-------------------------------------------------------------------------------

	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
		                 ----1593 ---presunta inusual   46--Estatus Generado
	SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	,IdtransaccionD,CONCAT('Suma de depositos del mes:',MontoMes,',Limite superior declarado',RangoFin)
	,MontoMes,IdSocio,IdCuenta,24,IdMetodoPago,'X'
	FROM (
		SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
		,t.IdtransaccionD,md.RangoFin
		,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
		,se.IdListaDmontoDepositos ,t.MontoSubOperacion
		FROM @TransaacionesD t
		JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
		JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
		JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
		JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
		JOIN dbo.tCATlistasD md With (nolock) ON md.IdListaD=se.IdListaDmontoDepositos 
	) AS tabla 
	WHERE tabla.IdTipoSubOperacion=500 AND tabla.MontoMes>tabla.RangoFin AND IdListaDmontoDepositos !=0 AND tabla.numero=1
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=24 AND Alta=tabla.Fecha)


	



	---------------------------------------------------------------------------------------------------------------------
	--------------------------COMPARACION DE LA SUMA NUMERO OPERACIONES DE DEPOSITOS MES CALENDARIO----------------------
	--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
	-------------------------DIARIO--------------------------------------------------------------------------------------
	-----------------------------------------CON DATO----------------------------------------------------------------------------

	

	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
		                 ----1593 ---presunta inusual   46--Estatus Generado
	SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	,IdtransaccionD,CONCAT('Numero de depositos del mes:',(NumeroOperacionesMes ),',Limite superior declarado',RangoFin)
	,IdSocio,IdCuenta,22,IdMetodoPago,'X',tabla.MontoMes
	FROM (
			  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
			,t.IdtransaccionD,x.NumeroOperacionesMes,nd.RangoFin,t.IdTipoSubOperacion
			,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
			,se.IdListaDnumeroDepositos ,t.MontoSubOperacion
			FROM @TransaacionesD t
			JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
			JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
			JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
			JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
			JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
			JOIN dbo.tCATlistasD nd With (nolock) ON nd.IdListaD=se.IdListaDnumeroDepositos 
	
	) AS tabla 
	WHERE tabla.IdTipoSubOperacion=500 AND (tabla.NumeroOperacionesMes) >tabla.RangoFin AND IdListaDnumeroDepositos!=0 AND tabla.numero=1
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=22 AND Alta=tabla.Fecha)

	
	---------------------------------------------------------------------------------------------------------------------
	--------------------------COMPARACION DE LA SUMA MONTOS DE RETIROS MES CALENDARIO----------------------------------
	--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
	-------------------------DIARIO--------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	---------------------------------------CON DATO------------------------------------------------------------------------------
	
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
		                 ----1593 ---presunta inusual   46--Estatus Generado
	SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	,IdtransaccionD,CONCAT('Monto de retiros del mes:',MontoMes,',Limite superior declarado',RangoFin)
	,MontoMes,IdSocio,IdCuenta,23,IdMetodoPago,'X'
	FROM (

	SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
	,t.IdtransaccionD,mr.RangoFin
	,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	,se.IdListaDmontoRetiros,t.MontoSubOperacion
	FROM @TransaacionesD t
	JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	JOIN dbo.tCATlistasD mr With (nolock) ON mr.IdListaD=se.IdListaDmontoRetiros 
	) AS tabla 
	WHERE tabla.IdTipoSubOperacion=501 AND tabla.MontoMes>tabla.RangoFin AND IdListaDmontoRetiros!=0 AND tabla.numero=1
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=23 AND Alta=tabla.Fecha)


	




	---------------------------------------------------------------------------------------------------------------------
	--------------------------COMPARACION DE LA SUMA NUMERO OPERACIONES DE RETIROS MES CALENDARIO------------------------
	--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
	-------------------------DIARIO--------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	-----------------------------------------CON DATO----------------------------------------------------------------------------

	

	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
		                 ----1593 ---presunta inusual   46--Estatus Generado
	SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	,IdtransaccionD,CONCAT('Numero de retiros del mes:',(NumeroOperacionesMes ),',Limite superior declarado',RangoFin)
	,IdSocio,IdCuenta,25,IdMetodoPago,'X',tabla.MontoMes
	FROM (
	  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
	,t.IdtransaccionD,x.NumeroOperacionesMes,nr.RangoFin,t.IdTipoSubOperacion
	,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	,se.IdListaDnumeroRetiros,t.MontoSubOperacion
	FROM @TransaacionesD t
	JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	JOIN dbo.tCATlistasD nr With (nolock) ON nr.IdListaD=se.IdListaDnumeroRetiros 
	
	) AS tabla 

	WHERE tabla.IdTipoSubOperacion=501 AND (tabla.NumeroOperacionesMes) >tabla.RangoFin AND IdListaDnumeroRetiros!=0 AND tabla.numero=1
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=25 AND Alta=tabla.Fecha)

	----------------------------------------------------------------------
	------------Liquidación anticipada de Crédito 15 días después con respecto a la fecha de entrega que esta sea con Cheque o Transferencia
	 DECLARE @PagoAnticipado AS VARCHAR(50)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=1)

		IF (@PagoAnticipado='True')
		BEGIN

			DECLARE @DiasLiquidacionAnticipada AS TINYINT=15
			INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
			            ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
			             IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

			SELECT tabla.IdPersona,1593,46,tabla.MontoSubOperacion,1,-1,tabla.Fecha,-1,tabla.Fecha,1598,0,tabla.IdOperacion,0,'Liquidación anticipada de Crédito 15 días después con respecto a la fecha de entrega que esta sea con Cheque o Transferencia',
			tabla.IdSocio,tabla.IdCuenta,19,tabla.IdMetodoPago,'x'
			FROM (
			SELECT ope.Folio, sc.IdPersona,tf.MontoSubOperacion,ope.Fecha,tf.IdOperacion,
			sc.IdSocio,c.IdCuenta,td.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY ope.Fecha ORDER BY ope.IdOperacion DESC) AS numero 
				
			FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
			INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
			INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
			JOIN dbo.tSDOtransaccionesFinancieras tf WITH(NOLOCK)ON tf.IdCuenta = c.IdCuenta AND tf.Fecha=@fecha  AND tf.IdTipoSubOperacion=500
																AND tf.MontoSubOperacion>50000 -- JCA 20221101 FNG Solicitud TI-1022-003 
			JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.idoperacion=tf.IdOperacion
			JOIN dbo.tSDOtransaccionesD td With (nolock) ON td.IdOperacion = ope.IdOperacion AND td.EsCambio=0 
			JOIN (SELECT oc.IdOperacion,tfc.IdCuenta,oc.Fecha,tfc.IdTipoSubOperacion
				 FROM dbo.tGRLoperaciones oc With (nolock) 
				JOIN dbo.tSDOtransaccionesFinancieras tfc With (nolock) ON tfc.IdOperacion=oc.IdOperacion
				JOIN dbo.tSDOtransaccionesD tdc With (nolock) ON tdc.IdOperacion = oc.IdOperacion 
				AND tdc.EsCambio=0 AND tdc.IdMetodoPago IN (-1,-3) AND tfc.IdTipoSubOperacion=501
				) AS x ON x.IdCuenta = c.IdCuenta
			WHERE c.IdTipoDProducto=143 AND ce.FechaBaja=@fecha
			AND DATEDIFF(dd,c.FechaActivacion,ce.FechaBaja) <=@DiasLiquidacionAnticipada)
			 AS tabla
			 WHERE tabla.numero=1
			 AND IdMetodoPago IN ( -2,-10)			
			AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.idsocio AND opl.IdCuenta=tabla.idcuenta AND opl.IdInusualidad=19 AND Alta=tabla.Fecha)



		END

		DECLARE @MontoCreditos AS DECIMAL(23,8)=0
		SET @MontoCreditos=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-7)

		IF (@MontoCreditos!=0)
		BEGIN

		
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
		                 ----1593 ---presunta inusual   46--Estatus Generado
		SELECT 0,1593,46,tf.MontoSubOperacion,1,-1,tf.Fecha,-1,tf.Fecha,1598,0,t.IdOperacion,t.IdTransaccionD,'Cuando el monto por liquidar sea mayor al 50% del monto original o el No. De plazos sea igual a la mitad del total de plazos de apertura.',c.Monto,tg.IdSocio,tf.IdCuenta,10
		,t.IdMetodoPago,'X'
		 FROM tSDOtransaccionesD t (NOLOCK)
		JOIN tGRLoperaciones tg (NOLOCK)ON tg.IdOperacion=t.IdOperacion
		JOIN tSDOtransaccionesFinancieras tf(NOLOCK)ON tf.IdOperacion=t.IdOperacion
		JOIN tayccuentas c (NOLOCK)ON c.IdCuenta=tf.IdCuenta AND c.IdTipoDParcialidad!=719----PAGO ÚNICO DE CAPITAL MÁS INTERÉS AL FINAL
		WHERE  dbo.fnPLDesOperacionDotacionCustodia(tg.IdOperacion)=0 AND tg.IdEstatus=1  AND 
		 t.IdTipoSubOperacion=500 AND t.IdMetodoPago=-2  AND tg.Fecha=@fecha AND t.EsCambio=0
		 AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)
		AND c.IdTipoDProducto=143 AND c.Monto>@MontoCreditos AND (tf.MontoSubOperacion >c.monto/2) AND c.IdEstatus=7
		GROUP BY tg.IdSocio,tf.IdCuenta,tf.Fecha,t.IdOperacion,t.IdTransaccionD,tf.MontoSubOperacion,c.Monto,t.IdMetodoPago



		SELECT 0,1593,46,0,1,-1,tf.Fecha,-1,tf.Fecha,1598,tf.MontoSubOperacion,t.IdOperacion,t.IdTransaccionD,10,c.Monto,tg.IdSocio,tf.IdCuenta,10
		 FROM tSDOtransaccionesD t (NOLOCK)
		JOIN tGRLoperaciones tg (NOLOCK)ON tg.IdOperacion=t.IdOperacion
		JOIN tSDOtransaccionesFinancieras tf(NOLOCK)ON tf.IdOperacion=t.IdOperacion
		JOIN tayccuentas c (NOLOCK)ON c.IdCuenta=tf.IdCuenta
		WHERE  dbo.fnPLDesOperacionDotacionCustodia(tg.IdOperacion)=0 AND tg.IdEstatus=1  AND 
		 t.IdTipoSubOperacion=500 AND t.IdMetodoPago=-2  AND tg.Fecha=@fecha AND t.EsCambio=0
		 AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)
		AND c.IdTipoDProducto=143 AND c.Monto>@MontoCreditos AND (tf.MontoSubOperacion >c.monto/2) AND c.IdEstatus=7
		GROUP BY tg.IdSocio,tf.IdCuenta,tf.Fecha,t.IdOperacion,t.IdTransaccionD,tf.MontoSubOperacion,c.Monto
		END
    
	
	

	--------ajuste del monto de operaciones relevantes considerando el cambio 
	  UPDATE o SET o.Monto=x.Monto
	  FROM dbo.tPLDoperaciones o
	  JOIN ( SELECT transacciones.IdOperacion,(transacciones.Monto-transaccionesCambio.Monto) AS Monto FROM (
	  SELECT ope.IdEstatus,ope.IdOperacion,td.EsCambio,td.Monto 
	  FROM dbo.tSDOtransaccionesD td With (nolock) 
	  JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = td.IdOperacion
	  WHERE ope.Fecha=@fecha
	  AND td.EsCambio=1
	  ) AS transaccionesCambio
	  JOIN (
	    SELECT ope.IdEstatus,ope.IdOperacion,td.EsCambio,td.Monto 
		FROM dbo.tSDOtransaccionesD td With (nolock) 
	  JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = td.IdOperacion
	  WHERE ope.Fecha=@fecha
	  AND td.EsCambio=0) AS transacciones ON transacciones.IdOperacion = transaccionesCambio.IdOperacion
		) AS x ON x.IdOperacion = o.IdOperacionOrigen
	  WHERE CAST(alta AS DATE)=@fecha
	  AND o.Monto!=x.Monto AND o.Monto!=0

	  -------Inusualidad por Relevancia
	  --IF ((SELECT Valor FROM dbo.tPLDconfiguracion WHERE IdParametro=-34)='True')
	  -- BEGIN
		 --DECLARE @MontoRelevancia NUMERIC(23,8)=0
		 --SET @MontoRelevancia=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-33)

	  --     INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	  --   	,UltimoCambio,IdTipoDDominio,IdObservacionE,IdObservacionEDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	  --   	MontoReferencia,IdSocio, IdCuenta,GeneradaDesdeSistema,Texto,IdInusualidad,IdMetodoPago,Descripcion)
			------1593 --- presunta inusual   46--GNEREDO
			--SELECT o.IdPersona,1593 ,46 ,t.Monto,1,o.IdUsuarioAlta,o.Fecha,o.IdUsuarioCambio,
			--o.Fecha,1598,0,0,o.IdSesion,td.IdOperacionOrigen,td.IdTransaccionD,'INUSUALIDAD POR MONTO RELEVANTE',@MontoRelevancia,o.IdSocio,0,1,'INUSUALIDAD POR MONTO RELEVANTE',17,td.IdMetodoPago,'X'
			--FROM dbo.tPLDoperaciones td WITH(NOLOCK)
			--INNER JOIN tGRLoperaciones AS o  WITH (NOLOCK) ON o.IdOperacion = td.IdOperacionOrigen
			--inner JOIN tSDOtransaccionesD AS t  WITH (NOLOCK) ON t.IdTransaccionD=td.IdTransaccionD AND t.EsCambio=0
			--WHERE o.Fecha=@fecha AND td.IdTipoDoperacionPLD=1594
	  -- END

	   ------Operación presunta preocupante por inusualidad de empleado
			--IF ((SELECT valor FROM dbo.tPLDconfiguracion WHERE IdParametro=-35)='True')
			--BEGIN
			-----1597 presunta preocupante
			--	INSERT INTO dbo.tPLDoperaciones(IdPersona, IdTipoDoperacionPLD, IdEstatusAtencion, Monto, IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio, IdTipoDDominio, texto, IdOperacionOrigen, IdTransaccionD, TipoIndicador, MontoReferencia, IdSocio, IdCuenta, IdListaDOperacion, Descripcion, IdPersonaUsuarioServicios, IdListaDorigenRecursos, GeneradaDesdeSistema, IdInusualidad)
			--	select pf.IdPersona,1597,46,Monto,1,-1,@fecha,-1,@fecha,1598,'OPERACIÓN PRESUNTA PREOCUPANTE POR INUSUALIDAD DE EMPLEADO',IdOperacionOrigen,IdTransaccionD,'OPERACIÓN PRESUNTA PREOCUPANTE POR INUSUALIDAD DE EMPLEADO',MontoReferencia,IdSocio,IdCuenta,IdListaDOperacion,'X',IdPersonaUsuarioServicios,IdListaDorigenRecursos,1,18
			--	FROM dbo.tPLDoperaciones ope
			--	JOIN dbo.tGRLpersonasFisicas pf With (nolock) ON pf.IdPersona = ope.IdPersona
			--	WHERE CAST(ope.Alta AS DATE )=@fecha AND pf.EsEmpleado=1 AND ope.IdTipoDoperacionPLD=1593
			--	AND ope.IdPersona!=0
		 --   END

END 

GO

