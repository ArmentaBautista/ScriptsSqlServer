SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

create PROC pPLDdeteccionInusualidadesTMP
@pFechaTrabajo DATE='19000101',
@pIdPersona	INT=0,
@pDebug bit=0
AS
BEGIN

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- VARIABLES
DECLARE @FechaTrabajo AS DATE=@pFechaTrabajo
DECLARE @IdPersona	AS INT=@pIdPersona
DECLARE @IdSocio AS INT

IF (@FechaTrabajo='19000101')
	SET @FechaTrabajo=GETDATE()

DECLARE @Fecha12MesesAtras AS DATE = DATEADD(MONTH,-12,@FechaTrabajo)
DECLARE @FechaInicial AS DATE=(SELECT p.Inicio FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 AND  @Fecha12MesesAtras BETWEEN p.Inicio AND p.Fin)
DECLARE @FechaFinal AS DATE=(SELECT p.Fin FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 AND @FechaTrabajo BETWEEN p.Inicio AND p.Fin)
DECLARE @FechaFinMes AS DATE=EOMONTH(@FechaTrabajo)

SELECT @FechaTrabajo AS FechaTrabajo, @Fecha12MesesAtras AS Fecha12,@FechaInicial AS FechaIni, @FechaFinal AS FechaFin

IF @IdPersona<>0
	SET @IdSocio = (SELECT TOP 1 sc.IdSocio FROM dbo.tSCSsocios sc  WITH(NOLOCK) WHERE sc.IdPersona=@IdPersona)

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= 
VARIABLES DE TABLA PARA CARGA DE DATOS
=^..^= */

/* INFO (?_?) 
Se crea la tabla de socios y cuentas, pero, esta se llena  de 2 formas. 1) Cuando el IdSocio<>0 se llena al inicio. 2) Caso contrario, cuando ya se tienen las financieras
*/
DECLARE @ServiciosCanales TABLE(
	IdRel			INT,
	IdTipoD			INT,
	IdListaD		INT,
	Descripcion		VARCHAR(80)
)

	INSERT @ServiciosCanales (IdRel,IdTipoD,IdListaD, Descripcion)
	SELECT s.IdRel,s.IdTipoD,s.IdListaD,ld.Descripcion
	FROM dbo.tSCSserviciosFinancierosMediosAsignados s  WITH(NOLOCK) 
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) 
		on ld.IdListaD = s.IdListaD
	INNER JOIN dbo.tSCSpersonasSocioeconomicos se  WITH(NOLOCK) 
		ON se.IdRelServiciosFinancierosAsignados=s.IdRel
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
		ON p.IdSocioeconomico = se.IdSocioeconomico
			AND ((@IdPersona = 0) OR (p.IdPersona = @IdPersona)) 
	WHERE s.IdEstatus=1

SELECT * FROM @ServiciosCanales

DECLARE @socios TABLE(
	IdSocio					INT,
	NoSocio					VARCHAR(24),
	Nombre					VARCHAR(128),
	ActividadEmpresarial	BIT,
	PersonaMoral			BIT,
	MontoLimiteRetiros		NUMERIC(12,2),
	MontoLimiteDepositos	NUMERIC(12,2),
	NumeroLimiteRetiros		NUMERIC(12,2),
	NumeroLimiteDepositos	NUMERIC(12,2),
	NumeroSucursalesDia		INT,
	UsaAhorro				BIT,
	UsaInversion			BIT,
	UsaCredito				BIT,
	UsaEfectivo				BIT,
	UsaTransferencia		BIT,
	UsaCheque				BIT,
	IngresosOrdinarios		NUMERIC(12,2)
)

SELECT 
sc.IdSocio,sc.Codigo, p.Nombre, sc.ExentaIVA, p.EsPersonaMoral
,[MontoLimiteRetiros] = montoR.Valor
,[MontoLimiteDepositos] = montoD.Valor
,[NumeroLimiteRetiros] = numR.Valor	
,[NumeroLimiteDepositos] = numD.Valor
, ie.IngresoOrdinario
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
LEFT JOIN dbo.tSCSanalisisCrediticio ac  WITH(NOLOCK) 
	ON ac.IdPersona = sc.IdPersona
LEFT JOIN dbo.tSCSanalisisIngresosEgresos ie  WITH(NOLOCK) 
	ON ie.IdAnalisisCrediticio = ac.IdAnalisisCrediticio
LEFT JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) 
	ON se.IdSocioeconomico = p.IdSocioeconomico
LEFT JOIN dbo.tCTLestatusActual ea WITH (NOLOCK) 
	ON ea.IdEstatusActual = se.IdEstatusActual AND ea.IdEstatus = 1
LEFT JOIN dbo.tCATlistasD montoD WITH (NOLOCK) 
	ON montoD.IdListaD = se.IdListaDmontoDepositos
LEFT JOIN dbo.tCATlistasD montoR WITH (NOLOCK) 
	ON montoR.IdListaD = se.IdListaDmontoRetiros
LEFT JOIN dbo.tCATlistasD numD WITH (NOLOCK) 
	ON numD.IdListaD = se.IdListaDnumeroDepositos
LEFT JOIN dbo.tCATlistasD numR WITH (NOLOCK) 
	ON numR.IdListaD = se.IdListaDnumeroRetiros
WHERE sc.idsocio<>0 AND ((@IdSocio = 0) OR (sc.IdSocio = @IdSocio))


DECLARE @ctas TABLE(
	IdCuenta				INT,
	IdSocio					INT,
	IdSucursal				INT,
	IdProductoFinanciero	INT,
	IdTipoDproducto			INT
)

/* INFO (?_?) 
	Si el socio es CERO se llenará la tabla de cuentas, una vez se tengan las transacciones del periodo
*/
IF @IdSocio<>0
BEGIN	
	INSERT INTO @ctas 
	SELECT c.IdCuenta, c.IdSocio, c.IdSucursal, c.IdProductoFinanciero, c.IdProductoFinanciero 
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.IdSocio=@IdSocio
END

DECLARE @tf AS TABLE(
	IdTransaccion		INT,
	IdOperacion			INT,
	IdCuenta			INT,
	Fecha				DATE,
	IdTipoSubOPeracion	INT,
	MontoSubOperacion	NUMERIC(18,2)
)

IF EXISTS(SELECT 1 FROM @ctas)
BEGIN
	INSERT @tf
	SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta,tf.Fecha,tf.IdTipoSubOperacion,tf.MontoSubOperacion
	FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
	INNER JOIN @ctas c ON c.IdCuenta = tf.IdCuenta
	WHERE tf.IdCuenta<>0 
		AND tf.IdTipoSubOPeracion IN (500,501) 
		AND tf.IdEstatus=1 
		AND tf.Fecha BETWEEN @FechaInicial AND @FechaFinal
END
ELSE
BEGIN
    INSERT @tf
	SELECT tf.IdTransaccion, tf.IdOperacion, tf.IdCuenta,tf.Fecha,tf.IdTipoSubOperacion,tf.MontoSubOperacion
	FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
	WHERE tf.IdCuenta<>0 
	AND tf.IdTipoSubOPeracion IN (500,501) 
	AND tf.IdEstatus=1 
	AND tf.Fecha BETWEEN @FechaInicial AND @FechaFinal

	INSERT INTO @ctas
	SELECT c.IdCuenta, c.IdSocio, c.IdSucursal, c.IdProductoFinanciero, c.IdProductoFinanciero 
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN @tf ON [@tf].IdCuenta = c.IdCuenta
END


DECLARE @ops AS TABLE(
	IdOperacion			INT,
	Folio				INT,
	IdTipoOperacion		INT,
	Fecha				DATE,
	Total				NUMERIC(18,2)
)

INSERT INTO @ops
SELECT op.IdOperacion, op.Folio, op.IdTipoOperacion, op.Fecha, op.Total 
FROM dbo.tGRLoperaciones op  WITH(NOLOCK) 
INNER JOIN @tf tf ON tf.IdOperacion = op.IdOperacion

DECLARE @td AS TABLE(
	IdTransaccionD		INT,
	IdOperacion			INT,
	IdMetodoPago		INT,
	IdTipoSubOPeracion	INT,
	Monto	NUMERIC(18,2)
)

INSERT INTO @td
SELECT td.IdTransaccionD, o.IdOperacion, td.IdMetodoPago, td.IdTipoSubOperacion, td.Monto
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
INNER JOIN @ops o ON o.IdOperacion = td.IdOperacion
WHERE td.EsCambio=0

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= 
 DETECCIÓN DE INUSUALIDADES

 IdTipoD	Codigo	Descripcion	DescripcionLarga	IdTipoE
	993		01		Diario		Diario				106
	997		05		Mensual		Mensual				106
=^..^=  */

/* INFO (?_?) 
	Insertamos las inusualidades de fin de mes 997
*/
IF @FechaFinMes=@FechaTrabajo
BEGIN
	

	RETURN 1
END





RETURN 1

----Obtiene el monto promedio de 12 meses atras de cada socio
DECLARE @fecha AS DATE
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

DECLARE @PromedioMontoNumeroOperaciones AS TABLE (IdSocio INT,IdTipoSubOperacion INT,MontoPromedio NUMERIC(23,8),NumeroPromedio NUMERIC(23,8),IdMetodoPago int)
INSERT INTO @PromedioMontoNumeroOperaciones
SELECT  IdSocio,IdTipoSubOperacion ,( SUM(monto)/COUNT(*))  AS MontoPromedio,
  (CAST(SUM(NumeroMov) AS DECIMAL)/(COUNT(*))) AS numeroPromedio ,Depositos.IdMetodoPago FROM(
SELECT o.IdSocio, o.IdPeriodo,t.IdTipoSubOperacion,SUM(t.MontoSubOperacion)AS monto,COUNT(*) AS NumeroMov,td.IdMetodoPago
 FROM  dbo.tSDOtransaccionesD td (NOLOCK)
 JOIN tGRLoperaciones o (NOLOCK)ON o.IdOperacion=td.IdOperacion
 JOIN  dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=td.RelTransaccion
 JOIN tCTLtiposOperacion ope (NOLOCK)ON ope.IdTipoOperacion=o.IdTipoOperacion
WHERE  NOT o.IdTipoOperacion IN (4,22,0)AND t.IdTipoSubOperacion IN (500,501) AND t.IdEstatus!=18 AND td.IdMetodoPago=-2 AND td.EsCambio=0 AND IdSocio!=0---AND tsf.IdOperacion!=0 AND ope.IdTipoOperacion=1
GROUP BY o.IdSocio, o.IdPeriodo ,t.IdTipoSubOperacion,td.IdMetodoPago--,o.IdTipoOperacion,ope.Descripcion
)
as Depositos 
WHERE IdPeriodo>=@IdPeriodoEmpieza AND NOT Depositos.IdPeriodo=@IdPeriodo
GROUP BY IdSocio,IdTipoSubOperacion,Depositos.IdMetodoPago
HAVING (Depositos.IdTipoSubOperacion=500 AND  ( SUM(monto)/COUNT(*)) >=@MontoPromedioDepositosMesesAtras) OR (Depositos.IdTipoSubOperacion=501 AND ( SUM(monto)/COUNT(*)) >=@MontoPromedioRetirosMesesAtras)

--SELECT *FROM @PromedioMontoNumeroOperaciones
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
	WHERE d.IdMetodoPago=-2  and o.fecha BETWEEN   @FechaInicio AND   @fecha AND o.idsocio!=0
	 AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
	 GROUP BY o.IdSocio,d.IdTipoSubOperacion,ld.RangoFin,lr.RangoFin,d.IdMetodoPago
	HAVING ((d.IdTipoSubOperacion=500 AND (SUM(t.MontoSubOperacion))>=@SumaDepositosMes) AND ( d.IdTipoSubOperacion=500 AND COUNT(*)>=(IIF(@NumeroDepositosMes>ld.RangoFin,@NumeroDepositosMes,ld.RangoFin)) ))
	    OR ((d.IdTipoSubOperacion=501 AND (SUM(t.MontoSubOperacion))>=@SumaRetirosMes)  AND (d.IdTipoSubOperacion=501 AND COUNT(*)>= (IIF(@NumeroRetirosMes>lr.RangoFin,@NumeroRetirosMes,lr.RangoFin)) ))
	 	


	--SELECT *FROM @MontoNumeroOperacionesMes
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
	WHERE d.IdMetodoPago=-2  AND o.fecha = @fecha AND o.idsocio!=0
	  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
	  	
			 
	 ----Validar las inusualidades con las variables de tipo tabla creadas anteriormente

	 ----------------RESPECTO AL MONTO DE LAS OPERACIONES -------------------------Solo el ultimo dia de mes 
	 DECLARE @PorcentajeIncremento AS NUMERIC(23,8)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=-6)

	 IF (@fecha= @fechaFin)
	 BEGIN
	  ----inserta en la tabla de tPLDtransaccionesDanalizadas
	 INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
	 SELECT t.IdtransaccionD,IIF(om.IdTipoSubOperacion=500,1,2)
			   FROM @TransaacionesD t
	  JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  WHERE iif(om.MontoMes=0,0,((om.MontoMes-p.MontoPromedio)/p.MontoPromedio))>@PorcentajeIncremento
	  AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=IIF(om.IdTipoSubOperacion=500,1,2))

	 ------- -inserta en la tabla de tPLDoperaciones
	   INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado
		SELECT t.IdPersona,1593,46,om.MontoMes,1,-1,t.Alta,-1,t.UltimoCambio,1598,t.IdSesion,t.IdOperacion,t.IdtransaccionD,CONCAT('Porcentaje de incremento considerable en ',IIF(om.IdTipoSubOperacion=500,'Depositos','Retiros'),' .Suma de monto en el mes: ',om.MontoMes,'depositos promedio 12 meses',p.MontoPromedio),
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
	 INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
	 SELECT t.IdtransaccionD,IIF(om.IdTipoSubOperacion=500,3,4)
			    FROM @TransaacionesD t
	  JOIN @MontoNumeroOperacionesMes om ON om.idsocio=t.IdSocio AND om.IdTipoSubOperacion=t.IdTipoSubOperacion
	  JOIN @PromedioMontoNumeroOperaciones p ON p.idsocio=t.IdSocio AND p.IdTipoSubOperacion = t.IdTipoSubOperacion
	  WHERE iif(om.NumeroOperacionesMes=0,0,((om.NumeroOperacionesMes-p.NumeroPromedio)/p.NumeroPromedio))>1
	  AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=IIF(om.IdTipoSubOperacion=500,3,4))


	  INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
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
		INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
		SELECT 0,6
			  FROM @TransaacionesD t
		where  IdTipoSubOperacion=500 AND fecha BETWEEN @fechaInicioDias AND @fecha 
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=6)
		GROUP BY IdSocio,IdDivisa
		HAVING (SELECT  dbo.[fDIVmontoCalculado](IdDivisa,2,@fecha,sum(MontoSubOperacion)))>=10000
		
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,idInusualidad,IdMetodoPago)
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
		
		
	--	-------------------------------ALERTA POR DEPOSITO SUPERIOR A 300 MIL PESOS PARA PERSONAS FISICAS ACUMULADOS EN UN MES CALENDARIO---------------------- solo el ultimo dia del mes

	IF  (@fecha=@fechaFin)
	BEGIN
	-------inserta en la tabla de tPLDtransaccionesDanalizadas
		INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
		SELECT t.IdtransaccionD,7 FROM @TransaacionesD t
			JOIN @MontoNumeroOperacionesMes op ON op.idsocio=t.IdSocio
			WHERE t.EsPersonaMoral=0  AND op.IdTipoSubOperacion =500 AND t.IdSocio!=0 AND op.MontoMes>300000
			AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=7)

		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     --1593 ---presunta inusual   46--Estatus Generado
		SELECT t.IdPersona,1593,46,t.IdPersona,1,-1,t.Alta,-1,t.UltimoCambio,1598,t.IdSesion,t.IdOperacion,t.IdtransaccionD,'Alerta por depósito Superior a 300 mil pesos para personas Físicas acumulados en un mes calendario.',
				op.MontoMes,t.IdSocio,t.IdCuenta,7,t.IdMetodoPago
				FROM @TransaacionesD t
		JOIN @MontoNumeroOperacionesMes op ON op.idsocio=t.IdSocio
		WHERE t.EsPersonaMoral=0  AND op.IdTipoSubOperacion =500 AND t.IdSocio!=0 AND op.MontoMes>300000
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)


		SELECT 'Alerta por depositos superiores a 300 mil'AS Operacion, *FROM @TransaacionesD t
		JOIN @MontoNumeroOperacionesMes op ON op.idsocio=t.IdSocio
		WHERE t.EsPersonaMoral=0  AND op.IdTipoSubOperacion =500 AND t.IdSocio!=0 AND op.MontoMes>300000
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)

    END

		
	--	---**************************Operaciones que no están de acuerdo con la capacidad económica del cliente, y que éstas no concuerden con la capacidad económica del cliente (ingresos menos el depósito [mes calendario], es igual o superior a 500%).****--solo el ultimo dia del mes
	IF (@fecha=@fechaFin)
	BEGIN
		-----inserta en la tabla de tPLDtransaccionesDanalizadas
	INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
	SELECT t.IdtransaccionD,8
			FROM  @TransaacionesD t
		JOIN @MontoNumeroOperacionesMes op ON op.IdSocio=t.IdSocio
		WHERE (t.IngresosOrdinarios+t.IngresosExtraordinarios)>0  AND ((op.MontoMes-(t.IngresosOrdinarios+t.IngresosExtraordinarios))*100)/(t.IngresosOrdinarios+t.IngresosExtraordinarios)>=500
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=8)


		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado
		SELECT t.IdPersona,1593,46,op.MontoMes,1,-1,t.Alta,-1,t.UltimoCambio,1598,t.IdSesion,t.IdOperacion,t.IdtransaccionD,CONCAT('Ingresos menos depositos es igual o menor a 500% , suma de depositos al mes ',op.MontoMes, ' ingresos Ordinarios ',t.IngresosOrdinarios ,' ingresos extraordinarios ', t.IngresosExtraordinarios),
		((op.MontoMes-(t.IngresosOrdinarios+t.IngresosExtraordinarios))*100)/(t.IngresosOrdinarios+t.IngresosExtraordinarios),t.IdSocio,tf.IdCuenta,8
		,t.IdMetodoPago
			FROM @TransaacionesD t 
		JOIN @MontoNumeroOperacionesMes op ON op.IdSocio=t.IdSocio
		JOIN dbo.tGRLoperaciones o (NOLOCK)ON o.IdOperacion=t.IdOperacion
	    JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=t.IdOperacion
		WHERE t.IdTipoSubOperacion=500 and (t.IngresosOrdinarios+t.IngresosExtraordinarios)>0  AND ((op.MontoMes-(t.IngresosOrdinarios+t.IngresosExtraordinarios))*100)/(t.IngresosOrdinarios+t.IngresosExtraordinarios)>=500
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)

			SELECT 'Ingresos menos depósito [mes calendario] ,es igual o superior a 500%' AS Operacion,t.IngresosOrdinarios,t.IngresosExtraordinarios,op.MontoMes, t.IdPersona ,t.MontoSubOperacion ,t.IdUsuarioAlta ,t.Alta , t.IdUsuarioCambio ,t.UltimoCambio ,t.IdSesion ,t.IdOperacion ,t.IdtransaccionD ,t.IdSocio ,t.IdCuenta ,
                                                                                                    t.IdEstattus ,t.EsPersonaMoral  ,t.fecha   ,op.IdTipoSubOperacion ,op.MontoMes ,
                                                                                                    op.NumeroOperacionesMes
																									 FROM @TransaacionesD t 
		JOIN @MontoNumeroOperacionesMes op ON op.IdSocio=t.IdSocio
		WHERE (t.IngresosOrdinarios+t.IngresosExtraordinarios)>0  AND ((op.MontoMes-(t.IngresosOrdinarios+t.IngresosExtraordinarios))*100)/(t.IngresosOrdinarios+t.IngresosExtraordinarios)>=500
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD)


    END

	

	
	------********************Realización de varios depósitos el mismo día en diferentes sucursales de la misma entidad financiera, en forma inusual, respecto al comportamiento habitual del cliente. Más de una sucursal*********************--------------------------------------
	--inserta en la tabla de tPLDtransaccionesDanalizadas

	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado

	SELECT IdPersona ,1593,46,0,1,-1,@fecha,-1,@fecha,1598,0,0,0,'Realización de varios depósitos el mismo día en diferentes sucursales de la misma entidad financiera, en forma inusual, respecto al comportamiento habitual del cliente. Más de una sucursal.',
	0,idsocio,0,9,t.IdMetodoPago FROM (
	SELECT  t.IdPersona,t.idsocio,t.IdSucursal,t.fecha,se.NumeroMaximoSucursales,t.IdMetodoPago
	 FROM @TransaacionesD t
	 LEFT JOIN dbo.tGRLpersonas pf (NOLOCK)ON pf.IdPersona=t.IdPersona
	LEFT JOIN dbo.tSCSpersonasSocioeconomicos se (NOLOCK)ON se.IdSocioeconomico=pf.IdSocioeconomico
	 WHERE IdTipoSubOperacion=500 
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones oper (NOLOCK) WHERE oper.IdPersona=t.IdPersona AND oper.IdSocio=t.IdSocio AND oper.IdInusualidad=9 AND CAST(oper.Alta AS DATE)=@fecha)
	GROUP BY t.IdPersona,IdSocio,IdSucursal,fecha,se.NumeroMaximoSucursales,t.IdMetodoPago
	) AS t
	GROUP BY t.IdPersona, t.IdSocio,t.fecha,t.NumeroMaximoSucursales,t.IdMetodoPago
	HAVING(t.NumeroMaximoSucursales!=0 AND t.NumeroMaximoSucursales<COUNT(*))OR (t.NumeroMaximoSucursales=0 AND COUNT(*)>1)
	
	
	;WITH tabla AS (
	SELECT t.idsocio,t.IdSucursal,t.fecha,se.NumeroMaximoSucursales
	 FROM @TransaacionesD t
	 LEFT JOIN dbo.tGRLpersonas pf (NOLOCK)ON pf.IdPersona=t.IdPersona
	LEFT JOIN dbo.tSCSpersonasSocioeconomicos se (NOLOCK)ON se.IdSocioeconomico=pf.IdSocioeconomico
	 WHERE IdTipoSubOperacion=500 
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones oper (NOLOCK) WHERE oper.IdPersona=t.IdPersona AND oper.IdSocio=t.IdSocio AND oper.IdInusualidad=9 AND CAST(oper.Alta AS DATE)=@fecha)
	GROUP BY IdSocio,t.IdSucursal,fecha,se.NumeroMaximoSucursales
	)
	SELECT t.IdSocio ,
           t.fecha ,
		   t.NumeroMaximoSucursales,COUNT(*) FROM tabla t
		   GROUP BY t.IdSocio,t.fecha,t.NumeroMaximoSucursales
		   HAVING (t.NumeroMaximoSucursales!=0 AND t.NumeroMaximoSucursales<COUNT(*))OR(t.NumeroMaximoSucursales=0 AND COUNT(*)>1)
	

	-------------------*******************************Cuando el monto por liquidar sea mayor al 50% del monto original o el No. De plazos sea igual a la mitad del total de plazos de apertura****
	DECLARE @MontoCreditos AS DECIMAL(23,8)=0
	SET @MontoCreditos=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-7)

	IF (@MontoCreditos!=0)
	BEGIN

	----inserta en la tabla de tPLDtransaccionesDanalizadas
	INSERT INTO dbo.tPLDtransaccionesDanalizadas( IdTransaccionD, IdInusualidad )
	SELECT t.IdTransaccionD,10
	 FROM tSDOtransaccionesD t (NOLOCK)
	JOIN tGRLoperaciones tg (NOLOCK)ON tg.IdOperacion=t.IdOperacion
	JOIN tSDOtransaccionesFinancieras tf(NOLOCK)ON tf.IdOperacion=t.IdOperacion
	JOIN tayccuentas c (NOLOCK)ON c.IdCuenta=tf.IdCuenta
	WHERE  dbo.fnPLDesOperacionDotacionCustodia(tg.IdOperacion)=0 AND tg.IdEstatus=1  AND 
	 t.IdTipoSubOperacion=500 AND t.IdMetodoPago=-2  AND tg.Fecha=@fecha AND t.EsCambio=0
    AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDtransaccionesDanalizadas (NOLOCK) WHERE IdTransaccionD=t.IdtransaccionD AND IdInusualidad=10)
	AND c.IdTipoDProducto=143 AND c.Monto>@MontoCreditos AND (tf.MontoSubOperacion >c.monto/2) --AND c.IdEstatus=7
	GROUP BY tg.IdSocio,tf.IdCuenta,tf.Fecha,t.IdOperacion,t.IdTransaccionD

	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
                     ----1593 ---presunta inusual   46--Estatus Generado
	SELECT 0,1593,46,tf.MontoSubOperacion,1,-1,tf.Fecha,-1,tf.Fecha,1598,0,t.IdOperacion,t.IdTransaccionD,'Cuando el monto por liquidar sea mayor al 50% del monto original o el No. De plazos sea igual a la mitad del total de plazos de apertura.',c.Monto,tg.IdSocio,tf.IdCuenta,10
	,t.IdMetodoPago
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
    
	
	----------------------------------------Inusualidad por Zona geografica basada en la sucursal------------------------------------------------------------------------
PRINT 'Inusualidad por zonageografica'


	SELECT  t.IdSocio,t.IdSucursal,suc.Descripcion AS Sucursal,t.IdPersona
	FROM @TransaacionesD t 
	JOIN dbo.tCTLsucursales suc With (nolock) ON suc.IdSucursal = t.IdSucursal
	WHERE EXISTS(SELECT ss.IdSocio FROM dbo.tSCSsocioSucursales ss With (nolock) WHERE ss.IdSocio=t.IdSocio) AND 
	NOT EXISTS (SELECT *FROM dbo.tSCSsocioSucursales s With (nolock) WHERE s.IdSocio=t.IdSocio AND s.IdSucursal=t.IdSucursal AND s.IdSocio!=0)
	AND	  NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones o (NOLOCK) WHERE o.IdInusualidad=15 AND o.IdPersona=t.IdPersona AND o.IdSocio=t.IdSocio AND CAST(o.Alta AS date)=@fecha AND o.Texto=CONCAT('Sucursal ',suc.Descripcion))
	GROUP BY t.IdSocio,t.IdSucursal,t.IdPersona,suc.Descripcion

	--'Si notiene sucursal no serealiza la validacion
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Texto,IdMetodoPago)

	SELECT  t.IdPersona,1593,46,0,1,-1,@fecha,-1,@fecha,1598,0,0,0,'Inusualidad por zona Geográfica basada en la sucursal',
	0,t.idsocio,0,15,CONCAT('Sucursal ',suc.Descripcion),t.IdMetodoPago
	FROM @TransaacionesD t 
	JOIN dbo.tCTLsucursales suc With (nolock) ON suc.IdSucursal = t.IdSucursal
	WHERE  EXISTS(SELECT ss.IdSocio FROM dbo.tSCSsocioSucursales ss With (nolock) WHERE ss.IdSocio=t.IdSocio) AND 
	NOT EXISTS (SELECT s.Id FROM dbo.tSCSsocioSucursales s With (nolock) WHERE s.IdSocio=t.IdSocio AND s.IdSucursal=t.IdSucursal AND s.IdSocio!=0)
	AND	  NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones o (NOLOCK) WHERE o.IdInusualidad=15 AND o.IdPersona=t.IdPersona AND o.IdSocio=t.IdSocio AND CAST(o.Alta AS date)=@fecha AND o.Texto=CONCAT('Sucursal ',suc.Descripcion))
	GROUP BY t.IdSocio,t.IdSucursal,t.IdPersona,suc.Descripcion,t.IdMetodoPago



	-----------------------------------OPERACIONES REALIZADAS EN UNA MISMA CUENTA,POR MONTOS FRACCIONADOS
	-----------------------------------QUE POR CADA OPERACION INDIVIDUAL SEA IGUAL O MAYOR A 500 DOLARES Y
	-----------------------------------QUE EN UN MES CALENDARIO SUMEN 7500 DOLARES------------------------------------------------------------------------------------
	DECLARE @montoOperacionFraccionada AS NUMERIC(23,8)=0
	DECLARE @MontoInusualidadesAcumulacionMontosFraccionados AS NUMERIC(23,8)=0

	SET @montoOperacionFraccionada=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-31)
	SET @MontoInusualidadesAcumulacionMontosFraccionados=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-32)
	
	IF (@fecha= @fechaFin)
	 BEGIN
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
		
		 SELECT 0,1593,46,tabla.MontoCuenta,1,-1,@fecha,-1,@fecha,1598,0,0,0
		 ,CONCAT('Alerta por montos fraccionados:operaciones individuales que sean iguales o superen ',@montoOperacionFraccionada,' dolares,realizadas en un mismo mes calendario que igualen o superen los ',@MontoInusualidadesAcumulacionMontosFraccionados,' dolares.Monto Acumulado en pesos  ',tabla.MontoCuenta,', monto en dolares ',(SELECT  dbo.[fDIVmontoCalculado](1,2,@fecha,tabla.MontoCuenta))),
		(SELECT  dbo.[fDIVmontoCalculado](1,2,@fecha,tabla.MontoCuenta)),tabla.IdSocio,tabla.IdCuenta,16,tabla.IdMetodoPago
		FROM (
		SELECT o.idsocio,t.IdCuenta ,SUM(t.MontoSubOperacion) AS MontoCuenta,d.IdMetodoPago
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSDOtransaccionesFinancieras t (NOLOCK)ON t.IdOperacion=o.IdOperacion 
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio
		WHERE d.IdMetodoPago=-2  and o.fecha BETWEEN   @fechaInicio AND   @fechaFin AND o.idsocio!=0 AND (SELECT  dbo.[fDIVmontoCalculado](o.IdDivisa,2,o.Fecha,t.MontoSubOperacion))>=@montoOperacionFraccionada AND t.IdCuenta!=0
		AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
		GROUP BY o.IdSocio,t.IdCuenta,d.IdMetodoPago
		
		) AS tabla 
		
		WHERE (SELECT  dbo.[fDIVmontoCalculado](1,2,@fecha,tabla.MontoCuenta))>@MontoInusualidadesAcumulacionMontosFraccionados 
		AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.IdSocio AND opl.IdCuenta=tabla.IdCuenta AND opl.IdInusualidad=16)

		---
		SELECT tabla.IdSocio,tabla.IdCuenta,tabla.MontoCuenta
		FROM (
		SELECT o.idsocio,t.IdCuenta ,SUM(t.MontoSubOperacion) AS MontoCuenta
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSDOtransaccionesFinancieras t (NOLOCK)ON t.IdOperacion=o.IdOperacion 
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio
		WHERE d.IdMetodoPago=-2  and o.fecha BETWEEN   @fechaInicio AND   @fechaFin AND o.idsocio!=0 AND (SELECT  dbo.[fDIVmontoCalculado](o.IdDivisa,2,o.Fecha,t.MontoSubOperacion))>=@montoOperacionFraccionada AND t.IdCuenta!=0
		AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
		GROUP BY o.IdSocio,t.IdCuenta
		
		) AS tabla 
		
		WHERE (SELECT  dbo.[fDIVmontoCalculado](1,2,@fecha,tabla.MontoCuenta))>@MontoInusualidadesAcumulacionMontosFraccionados 
		
---valida si un credito se paga antes de los 15 dias posteriores a la fecha de entrega 

        DECLARE @PagoAnticipado AS VARCHAR(50)=(SELECT valor FROM dbo.tPLDconfiguracion (NOLOCK) WHERE IdParametro=1)

		IF (@PagoAnticipado='True')
		BEGIN

		DECLARE @DiasLiquidacionAnticipada AS TINYINT=15
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad)

		SELECT sc.IdPersona,1593,46,tf.MontoSubOperacion,1,-1,GETDATE(),-1,GETDATE(),1598,0,tf.IdOperacion,0,'por liquidación anticipada de 15 días con respecto de la entrega',
		tf.MontoSubOperacion,sc.IdSocio,c.IdCuenta,1
			
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) ON ce.IdCuenta = c.IdCuenta
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		JOIN dbo.tSDOtransaccionesFinancieras tf WITH(NOLOCK)ON tf.IdCuenta = c.IdCuenta AND tf.Fecha=@fecha  AND tf.IdTipoSubOperacion=500
		WHERE c.IdTipoDProducto=143 AND ce.FechaBaja=@fecha
		AND DATEDIFF(dd,c.FechaActivacion,ce.FechaBaja) <=@DiasLiquidacionAnticipada
		AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=sc.idsocio AND opl.IdCuenta=c.idcuenta AND opl.IdInusualidad=1)
	END


	 
	 END
END 

GO

