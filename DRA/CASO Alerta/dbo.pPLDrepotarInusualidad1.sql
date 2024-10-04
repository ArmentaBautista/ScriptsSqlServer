SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO




create or alter  PROC  dbo.pPLDrepotarInusualidadTMP
	@fecha AS DATE='19000101',
	@pIdSocio as int=0
as
SET NOCOUNT ON
SET XACT_ABORT ON	


BEGIN
	
----Obtiene el monto promedio de 12 meses atras de cada socio

DECLARE @IdPeriodo AS INT=(SELECT	fcip.IdPeriodo FROM	dbo.fCTLObtenerIdPeriodo(@fecha,0) fcip);
DECLARE @IdPeriodoEmpieza AS INT=0;


PRINT @IdPeriodo;
WITH tabla AS (
SELECT TOP 12 *FROM tCTLperiodos tc
WHERE tc.IdPeriodo<=@idperiodo AND tc.EsAjuste !=1
ORDER BY tc.IdPeriodo DESC
)SELECT TOP 1 @IdPeriodoEmpieza=IdPeriodo FROM tabla
 ORDER BY IdPeriodo;
 	
	PRINT @IdPeriodoEmpieza; 

-------- EN BASE AL PERIODO QUE SE INICIA(12 MESES ATRAS) SE PROMEDIA EL MONTO DE LOS DEPOSITOS
---///Se valida que la suma de depositos en el mes sea mayor o igual a 5000 y que el monto de los depositos promedios sea mayor a 5000 y ademas se valida el parametro de aumento 

DECLARE @MontoPromedioDepositosMesesAtras AS NUMERIC(23,8)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-16)
DECLARE @MontoPromedioRetirosMesesAtras AS NUMERIC(23,8)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-18)


SELECT o.IdOperacion, o.Folio,
o.IdSocio, o.IdPeriodo,t.IdTipoSubOperacion--,SUM(t.MontoSubOperacion)AS monto,COUNT(*) AS NumeroMov,td.IdMetodoPago
 FROM  dbo.tSDOtransaccionesD td (NOLOCK)
 JOIN tGRLoperaciones o (NOLOCK)ON o.IdOperacion=td.IdOperacion
 JOIN  dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=td.RelTransaccion
 JOIN tCTLtiposOperacion ope (NOLOCK)ON ope.IdTipoOperacion=o.IdTipoOperacion
WHERE  NOT o.IdTipoOperacion IN (4,22,0)AND t.IdTipoSubOperacion IN (500,501) AND t.IdEstatus!=18 AND td.IdMetodoPago=-2 AND td.EsCambio=0 
--and IdSocio!=0---AND tsf.IdOperacion!=0 AND ope.IdTipoOperacion=1
and o.IdSocio=@pIdSocio
--GROUP BY o.IdSocio, o.IdPeriodo ,t.IdTipoSubOperacion,td.IdMetodoPago--,o.IdTipoOperacion,ope.Descripcion



DECLARE @PromedioMontoNumeroOperaciones AS TABLE (IdSocio INT,IdTipoSubOperacion INT,MontoPromedio NUMERIC(23,8),NumeroPromedio NUMERIC(23,8),IdMetodoPago int)
INSERT INTO @PromedioMontoNumeroOperaciones
SELECT  IdSocio,IdTipoSubOperacion ,( SUM(monto)/COUNT(*))  AS MontoPromedio,
  (CAST(SUM(NumeroMov) AS DECIMAL)/(COUNT(*))) AS numeroPromedio ,Depositos.IdMetodoPago FROM(
SELECT o.IdSocio, o.IdPeriodo,t.IdTipoSubOperacion,SUM(t.MontoSubOperacion)AS monto,COUNT(*) AS NumeroMov,td.IdMetodoPago
 FROM  dbo.tSDOtransaccionesD td (NOLOCK)
 JOIN tGRLoperaciones o (NOLOCK)ON o.IdOperacion=td.IdOperacion
 JOIN  dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=td.RelTransaccion
 JOIN tCTLtiposOperacion ope (NOLOCK)ON ope.IdTipoOperacion=o.IdTipoOperacion
WHERE  NOT o.IdTipoOperacion IN (4,22,0)AND t.IdTipoSubOperacion IN (500,501) AND t.IdEstatus!=18 AND td.IdMetodoPago=-2 AND td.EsCambio=0 
--and IdSocio!=0---AND tsf.IdOperacion!=0 AND ope.IdTipoOperacion=1
and o.IdSocio=@pIdSocio
GROUP BY o.IdSocio, o.IdPeriodo ,t.IdTipoSubOperacion,td.IdMetodoPago--,o.IdTipoOperacion,ope.Descripcion
)
as Depositos 
WHERE IdPeriodo>=@IdPeriodoEmpieza AND NOT Depositos.IdPeriodo=@IdPeriodo
GROUP BY IdSocio,IdTipoSubOperacion,Depositos.IdMetodoPago
HAVING (Depositos.IdTipoSubOperacion=500 AND  ( SUM(monto)/COUNT(*)) >=@MontoPromedioDepositosMesesAtras) OR (Depositos.IdTipoSubOperacion=501 AND ( SUM(monto)/COUNT(*)) >=@MontoPromedioRetirosMesesAtras)



SELECT *FROM @PromedioMontoNumeroOperaciones
--ORDER BY IdSocio
----------------------------------------------------OBTIENE LA SUMA Y NUMERO  DE LOS DEPOSITOS Y RETIROS DEL MES



--primer dia del mes dependiendo de la fecha
DECLARE @fechaInicio AS DATE='19000101'
 set @FechaInicio= CONVERT(DATE,DATEADD(dd,-(DAY(@fecha)-1),@fecha),112)
 ---último día del mes
 DECLARE @fechaFin AS DATE='19000101'
 SET @fechaFin= EOMONTH(@fecha,0)

 --////Se valida que la suma de retiros en el mes sea mayor o igual a 3000 y que el monto de los retiros promedios sea mayor a 3000 y ademas se valida el parametro de aumento 

 DECLARE @SumaDepositosMes AS NUMERIC(23,8)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-15)
 DECLARE @SumaRetirosMes AS NUMERIC(23,8)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-17)

 DECLARE @NumeroDepositosMes AS int=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-19)
 DECLARE @NumeroRetirosMes AS INT=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-20)

 PRINT @NumeroDepositosMes
 PRINT @NumeroRetirosMes

 DECLARE @MontoNumeroOperacionesMes AS TABLE (IdSocio int,IdTipoSubOperacion  int,MontoMes  numeric(23,8),NumeroOperacionesMes  INT,NumeroDepositos INT,NumeroRetiros INT,IdMetodoPago INT)

 INSERT INTO  @MontoNumeroOperacionesMes	
	SELECT o.idsocio,d.IdTipoSubOperacion, (SUM(t.MontoSubOperacion)) AS MontoMes,COUNT(*) AS NumeroOperacionesMes ,ld.RangoFin,lr.RangoFin ,d.IdMetodoPago
	FROM tSDOtransaccionesD d(NOLOCK)
	JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
	JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
	JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio
	JOIN dbo.tGRLpersonas pf (NOLOCK)ON pf.IdPersona=soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos pfs (NOLOCK)ON pfs.IdSocioeconomico=pf.IdSocioeconomico
	JOIN dbo.tCATlistasD ld (NOLOCK)ON ld.IdListaD=pfs.IdListaDnumeroDepositos
	JOIN dbo.tCATlistasD lr (NOLOCK)ON lr.IdListaD=pfs.IdListaDnumeroRetiros
	WHERE d.IdMetodoPago=-2  and o.fecha BETWEEN   @FechaInicio AND   @fecha 
	--and o.idsocio!=0
	and o.IdSocio=@pIdSocio
	 AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
	 GROUP BY o.IdSocio,d.IdTipoSubOperacion,ld.RangoFin,lr.RangoFin,d.IdMetodoPago
	HAVING ((d.IdTipoSubOperacion=500 AND (SUM(t.MontoSubOperacion))>=@SumaDepositosMes) AND ( d.IdTipoSubOperacion=500 AND COUNT(*)>=(IIF(@NumeroDepositosMes>ld.RangoFin,@NumeroDepositosMes,ld.RangoFin)) ))
	    OR ((d.IdTipoSubOperacion=501 AND (SUM(t.MontoSubOperacion))>=@SumaRetirosMes)  AND (d.IdTipoSubOperacion=501 AND COUNT(*)>= (IIF(@NumeroRetirosMes>lr.RangoFin,@NumeroRetirosMes,lr.RangoFin)) ))
	 	


	SELECT *FROM @MontoNumeroOperacionesMes
	--ORDER BY IdSocio
	

	---------------------------------OBTENER TODAS LAS TRANSACCIONESD QUE SE VAN A EVALUAR DEPENDIENDO DE LA FECHA--------------------------
	DECLARE @TransaacionesD AS TABLE (IdPersona INT,MontoSubOperacion NUMERIC(23,8),IdUsuarioAlta INT,Alta DATETIME,IdUsuarioCambio INT,UltimoCambio DATETIME,IdSesion INT,IdOperacion INT, IdtransaccionD INT,IdSocio INT,IdCuenta INT,IdEstattus INT,EsPersonaMoral BIT,IdTipoSubOperacion INT,fecha  DATE,IdDivisa int,IngresosOrdinarios NUMERIC(23,8),IngresosExtraordinarios NUMERIC(23,8),IdSucursal INT,IdMetodoPago INT)
	
	INSERT INTO @TransaacionesD
	SELECT soc.IdPersona AS IdPersona,t.MontoSubOperacion,t.IdUsuarioAlta,t.Alta,t.IdUsuarioCambio,t.UltimoCambio,t.IdSesion,d.IdOperacion,d.IdTransaccionD,o.IdSocio,t.IdCuenta,o.IdEstatus,p.EsPersonaMoral,t.IdTipoSubOperacion,o.Fecha,t.IdDivisa,ISNULL(tppt.IngresosOrdinarios,0) AS IngresosOrdinarios ,ISNULL(tppt.IngresosExtraordinarios,0) AS IngresosExtraordinarios,o.IdSucursal,d.IdMetodoPago
	 FROM tSDOtransaccionesD d(NOLOCK)
	JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
	JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
	JOIN dbo.tSCSsocios soc(NOLOCK)ON soc.IdSocio=o.IdSocio
	JOIN dbo.tGRLpersonas p (NOLOCK)ON p.IdPersona=soc.IdPersona
	LEFT JOIN tPLDsocioPerfilesTransaccionales tppt(NOLOCK)ON tppt.IdSocio=soc.IdSocio AND  tppt.EsActual=1 
	WHERE d.IdMetodoPago=-2  AND o.fecha = @fecha 
	-- and o.idsocio!=0
	and o.IdSocio=@pIdSocio
	  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
	 
	 select * from @TransaacionesD
			 
	 ----Validar las inusualidades con las variables de tipo tabla creadas anteriormente

	 ----------------RESPECTO AL MONTO DE LAS OPERACIONES -------------------------Solo el ultimo dia de mes 
	 DECLARE @PorcentajeIncremento AS NUMERIC(23,8)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-6)

	 IF (@fecha= @fechaFin)
	 BEGIN
	  ----inserta en la tabla de tPLDtransaccionesDanalizadas
	 --INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
	 SELECT t.IdtransaccionD,IIF(om.IdTipoSubOperacion=500,1,2)
			   FROM @TransaacionesD t
	  JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  WHERE iif(om.MontoMes=0,0,((om.MontoMes-p.MontoPromedio)/p.MontoPromedio))>@PorcentajeIncremento
	  AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=IIF(om.IdTipoSubOperacion=500,1,2))

	 ------- -inserta en la tabla de tPLDoperaciones
	   --INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
    --                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
    --                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado
		SELECT t.IdPersona,1593,46,om.MontoMes,1,-1,t.Alta,-1,t.UltimoCambio,1598,t.IdSesion,t.IdOperacion,t.IdtransaccionD,CONCAT('Porcentaje de incremento considerable en ',IIF(om.IdTipoSubOperacion=500,'Depositos','Retiros'),' .Suma de monto en el mes: ',om.MontoMes,IIF(om.IdTipoSubOperacion=500,' depositos',' retiros'),' promedio 12 meses',p.MontoPromedio),
		IIF(om.MontoMes=0,0,((om.MontoMes-p.MontoPromedio)/p.MontoPromedio)),om.IdSocio,tf.IdCuenta,IIF(om.IdTipoSubOperacion=500,1,2)
		,t.IdMetodoPago
			   FROM @TransaacionesD t
	  JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  JOIN dbo.tGRLoperaciones o (NOLOCK)ON o.IdOperacion=t.IdOperacion
	  JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=t.IdOperacion
	  WHERE IIF(om.MontoMes=0,0,((om.MontoMes-p.MontoPromedio)/p.MontoPromedio))>@PorcentajeIncremento
	  AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=t.IdtransaccionD)

	  --SELECT iif(om.MontoMes=0,0,((om.MontoMes-p.MontoPromedio)/p.MontoPromedio)) AS PorcentajeIncremento,om.MontoMes,p.MontoPromedio,om.NumeroOperacionesMes,om.IdSocio,om.IdTipoSubOperacion, t.IdPersona ,t.MontoSubOperacion ,t.IdUsuarioAlta ,t.Alta , t.IdUsuarioCambio ,t.UltimoCambio ,t.IdSesion ,t.IdOperacion ,t.IdtransaccionD ,t.IdTipoSubOperacion,
   --            t.IdSocio , t.IdCuenta ,t.IdEstattus ,t.EsPersonaMoral,t.fecha ,om.IdSocio , om.IdTipoSubOperacion ,om.MontoMes ,om.NumeroOperacionesMes ,p.IdSocio , p.IdTipoSubOperacion ,
   --            p.MontoPromedio ,p.NumeroPromedio 
			--   FROM @TransaacionesD t
	  --JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  --JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  --JOIN dbo.tGRLoperaciones o (NOLOCK)ON o.IdOperacion=t.IdOperacion
	  --JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=t.IdOperacion
	  --WHERE iif(om.MontoMes=0,0,((om.MontoMes-p.MontoPromedio)/p.MontoPromedio))>@PorcentajeIncremento

     END
	 
	 
	 

	 ---- ----------------------RESPECTO AL NUMERO Y FRECUENCIA DE LA TABLA-------------------solo ultimo dia del mes

	 IF (@fecha=@fechaFin)
	 BEGIN
	 --INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
	 SELECT t.IdtransaccionD,IIF(om.IdTipoSubOperacion=500,3,4)
			    FROM @TransaacionesD t
	  JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  WHERE iif(om.NumeroOperacionesMes=0,0,((om.NumeroOperacionesMes-p.NumeroPromedio)/p.NumeroPromedio))>1
	  AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=IIF(om.IdTipoSubOperacion=500,3,4))


	  --INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
   --                 ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
   --                  MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado
		SELECT t.IdPersona,1593,46,om.MontoMes,1,-1,t.Alta,-1,t.UltimoCambio,1598,t.IdSesion,t.IdOperacion,t.IdtransaccionD,CONCAT('Número de',IIF(om.IdTipoSubOperacion=500,'Deposito','Retiro'),' Número mayor al 100%.Número de operaciones mensuales ',om.NumeroOperacionesMes,',número de operaciones promedio 12 meses anteriores',p.NumeroPromedio),
		IIF(om.NumeroOperacionesMes=0,0,((om.NumeroOperacionesMes-p.NumeroPromedio)/p.NumeroPromedio)),om.IdSocio,tf.IdCuenta,IIF(om.IdTipoSubOperacion=500,3,4)
		,t.IdMetodoPago
			    FROM @TransaacionesD t
	  JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	   JOIN dbo.tGRLoperaciones o (NOLOCK)ON o.IdOperacion=t.IdOperacion
	  JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=t.IdOperacion
	  WHERE IIF(om.NumeroOperacionesMes=0,0,((om.NumeroOperacionesMes-p.NumeroPromedio)/p.NumeroPromedio))>1
	 AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=t.IdtransaccionD)

	  -- SELECT iif(om.NumeroOperacionesMes=0,0,((om.NumeroOperacionesMes-p.NumeroPromedio)/p.NumeroPromedio)) AS PorcentajeIncrementoOperaciones,om.NumeroOperacionesMes,p.NumeroPromedio,p.idsocio, t.IdPersona ,t.MontoSubOperacion ,t.IdUsuarioAlta ,t.Alta , t.IdUsuarioCambio ,t.UltimoCambio ,t.IdSesion ,t.IdOperacion ,t.IdtransaccionD ,t.IdTipoSubOperacion,
   --            t.IdSocio , tf.IdCuenta ,t.IdEstattus ,t.EsPersonaMoral,t.fecha ,om.IdSocio , om.IdTipoSubOperacion ,om.MontoMes ,om.NumeroOperacionesMes ,p.IdSocio , p.IdTipoSubOperacion ,
   --            p.MontoPromedio ,p.NumeroPromedio 
			--   FROM @TransaacionesD t
	  --JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  --JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  -- JOIN dbo.tGRLoperaciones o (NOLOCK)ON o.IdOperacion=t.IdOperacion
	  --JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=t.IdOperacion
	  --WHERE iif(om.NumeroOperacionesMes=0,0,((om.NumeroOperacionesMes-p.NumeroPromedio)/p.NumeroPromedio))>1
	  --ORDER BY t.IdSocio

     END 


	

	 -- ------ALERTA POR MONTOS FRACCIONADOS:LA SUMA DE LOS DEPOSITOS EN EFECTIVO IGUALAN O REBASAN LOS 10 MIL DOLARES (5 DIAS HABILES) ----

	  DECLARE @fechaInicioDias AS date= DATEADD(DAY,-5,@fecha)
	
		-------inserta en la tabla de tPLDtransaccionesDanalizadas
		--INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
		SELECT 0,6
			  FROM @TransaacionesD t
		where  IdTipoSubOperacion=500 AND fecha BETWEEN @fechaInicioDias AND @fecha 
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=6)
		GROUP BY IdSocio,IdDivisa
		HAVING (SELECT  dbo.[fDIVmontoCalculado](IdDivisa,2,@fecha,sum(MontoSubOperacion)))>=10000
		
		--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
  --                  ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
  --                   MontoReferencia,IdSocio, IdCuenta,idInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado
		SELECT 0,1593,46,0,1,-1,@fecha,-1,@fecha,1598,0,0,0,'La suma de los depositos en efectivo es igual o mayor a los 10 mil dolares (5 dias)',
				SUM(MontoSubOperacion),IdSocio,0,6,t.IdMetodoPago
			  FROM @TransaacionesD t
		where  IdTipoSubOperacion=500 AND fecha BETWEEN @fechaInicioDias AND @fecha
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)
		GROUP BY IdSocio,IdDivisa,t.IdMetodoPago
		HAVING (SELECT  dbo.[fDIVmontoCalculado](IdDivisa,2,@fecha,sum(MontoSubOperacion)))>=10000


		--SELECT IdSocio,SUM(MontoSubOperacion) AS MontoDepositos ,IdDivisa,@fecha
		--FROM @TransaacionesD t
		--where  IdTipoSubOperacion=500 AND fecha BETWEEN @fechaInicioDias AND @fecha 
		--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)
		--GROUP BY IdSocio,IdDivisa
		--HAVING (SELECT  dbo.[fDIVmontoCalculado](IdDivisa,2,@fecha,sum(MontoSubOperacion)))>=10000
		
		
	


	 
	 
END 

GO

