SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO



ALTER  PROC  [dbo].[pPLDrepotarInusualidad]
	@fecha AS DATE='19000101'
as
SET NOCOUNT ON
SET XACT_ABORT ON	


BEGIN

/* ฅ^•ﻌ•^ฅ   JCA.04/10/2023.12:35 a. m. Nota: VARIABLES PARA USO O NO DE ALERTAS   */
DECLARE @alertaSucursales BIT = 0
DECLARE @alertaServicioCredito BIT = 0
DECLARE @alertaServicioAhorro BIT = 0
DECLARE @alertaServicioInversion BIT = 0
DECLARE @alertaSucursalesMismoDia BIT = 0

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
 
	

DECLARE @IdPeriodo AS INT=(SELECT	fcip.IdPeriodo FROM	dbo.fCTLObtenerIdPeriodo(DATEADD(MONTH,-1, @fecha),0) fcip);
DECLARE @IdPeriodoEmpieza AS INT=0;

PRINT @fecha
PRINT @IdPeriodo;
WITH tabla AS (
SELECT TOP 6 *FROM tCTLperiodos tc
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
	------------------------------------------------------------------------------------------
	
	-------- EN BASE AL PERIODO QUE SE INICIA(6 MESES ATRAS) SE PROMEDIA EL MONTO DE LOS DEPOSITOS
	
	DECLARE @PromedioMontoNumeroOperaciones AS TABLE (IdSocio INT,IdTipoSubOperacion INT,MontoPromedio NUMERIC(23,8),NumeroPromedio NUMERIC(23,8),IdMetodoPago int)
	
	INSERT INTO @PromedioMontoNumeroOperaciones
	SELECT IdSocio,
       IdTipoSubOperacion,
       AVG(monto - MontoCambio) AS MontoPromedio,
       AVG(CAST(NumeroMov AS DECIMAL)) AS numeroPromedio,
       Depositos.IdMetodoPago
		FROM
		(
			SELECT o.IdSocio,
				   o.IdPeriodo,
				   t.IdTipoSubOperacion,
				   SUM(td.Monto) AS monto,
				   SUM(ISNULL(tdd.Monto, 0)) AS MontoCambio,
				   COUNT(1) AS NumeroMov,
				   td.IdMetodoPago
			FROM dbo.tSDOtransaccionesD td (NOLOCK)
				JOIN tGRLoperaciones o (NOLOCK)
					ON o.IdOperacion = td.IdOperacion
				JOIN dbo.tSDOtransacciones t (NOLOCK)
					ON t.IdOperacion = o.IdOperacion
					   AND t.IdTransaccion = td.RelTransaccion
				JOIN tCTLtiposOperacion ope (NOLOCK)
					ON ope.IdTipoOperacion = o.IdTipoOperacion
				JOIN dbo.tSCSsocios soc (NOLOCK)
					ON soc.IdSocio = o.IdSocio
				LEFT JOIN tSDOtransaccionesD tdd (NOLOCK)
					ON tdd.IdOperacion = o.IdOperacion
					   AND tdd.EsCambio = 1
			WHERE td.IdMetodoPago IN ( -2, 10 )
				  AND o.IdSocio != 0
				  AND t.IdTipoSubOperacion IN ( 500, 501 )
				  AND t.IdEstatus != 18
				  AND NOT o.IdTipoOperacion IN ( 4, 22, 0, 507, 41 )
				  AND td.EsCambio = 0
				  AND o.IdPeriodo BETWEEN @IdPeriodoEmpieza AND @IdPeriodo --AND o.IdSocio=10
			GROUP BY o.IdSocio,
					 o.IdPeriodo,
					 t.IdTipoSubOperacion,
					 td.IdMetodoPago
			UNION ALL
			SELECT soc.IdSocio,
				   o.IdPeriodo,
				   t.IdTipoSubOperacion,
				   SUM(td.Monto) AS monto,
				   SUM(ISNULL(tdd.Monto, 0)) AS montoCambio,
				   COUNT(1) AS NumeroMov,
				   td.IdMetodoPago
			FROM dbo.tSDOtransaccionesD td (NOLOCK)
				JOIN tGRLoperaciones o (NOLOCK)
					ON o.IdOperacion = td.IdOperacion
				JOIN dbo.tSDOtransacciones t (NOLOCK)
					ON t.IdOperacion = o.IdOperacion
					   AND t.IdTransaccion = td.RelTransaccion
				JOIN tCTLtiposOperacion ope (NOLOCK)
					ON ope.IdTipoOperacion = o.IdTipoOperacion
				JOIN dbo.tSCSsocios soc (NOLOCK)
					ON soc.IdPersona = o.IdPersonaMovimiento
				LEFT JOIN tSDOtransaccionesD tdd (NOLOCK)
					ON tdd.IdOperacion = o.IdOperacion
					   AND tdd.EsCambio = 1
			WHERE o.IdSocio = 0
				  AND o.IdPersona = 0
				  AND o.IdPersonaMovimiento != 0
				  AND td.IdMetodoPago IN ( -2, 10 )
				  AND t.IdTipoSubOperacion IN ( 500, 501 )
				  AND t.IdEstatus != 18
				  AND NOT o.IdTipoOperacion IN ( 4, 22, 0, 507, 41 )
				  AND td.EsCambio = 0
				  AND o.IdPeriodo BETWEEN @IdPeriodoEmpieza AND @IdPeriodo --AND o.IdSocio=10
			GROUP BY soc.IdSocio,
					 o.IdPeriodo,
					 t.IdTipoSubOperacion,
					 td.IdMetodoPago
		) AS Depositos
		GROUP BY IdSocio,
				 IdTipoSubOperacion,
				 Depositos.IdMetodoPago;
	
	
	--SELECT *FROM @PromedioMontoNumeroOperaciones
	--ORDER BY IdSocio
	

	
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
		 ) AS tabla
		 GROUP BY IdSocio,IdTipoSubOperacion,IdPersona

		 ---------------------------------------------------------------------------------------------------------------------
	----------------------------- SE OBTIENE LA SUMA DE LOS DEPOSITOS ,RETIROS Y NUMEROO DE OPERACIONES DEL MES para las primeras 4 inusualidades------------------------
	---------------------------------------------------------------------------------------------------------------------
		DECLARE @NumeroOperacionesMesTodosMetodosPagos AS TABLE (IdSocio int,IdTipoSubOperacion  int,MontoMes  numeric(23,8),NumeroOperacionesMes  INT,IdPersona INT)

		INSERT INTO  @NumeroOperacionesMesTodosMetodosPagos
		SELECT tabla.IdSocio,tabla.IdTipoSubOperacion,(SUM(tabla.Monto-tabla.MontoCambio)) AS MontoMes,COUNT(*) AS NumeroOperacionesMes ,IdPersona
		FROM (
		SELECT o.IdSocio,d.IdTipoSubOperacion,d.Monto,ISNULL(td.Monto,0) AS MontoCambio,o.IdPersona
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio 
		left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		WHERE  o.fecha BETWEEN   @fechaInicio AND   @Fecha AND o.idsocio!=0
		 AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18  
		 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		UNION all
		SELECT soc.idsocio,d.IdTipoSubOperacion, d.Monto,isnull(td.Monto,0) AS MontoCambio,soc.IdPersona
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdPersona=o.IdPersonaMovimiento
		left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		WHERE o.IdSocio=0 AND o.IdPersona=0  AND o.IdPersonaMovimiento!=0
		and o.fecha BETWEEN   @fechaInicio AND   @fecha 
		 AND d.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18   
		 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		 ) AS tabla
		 GROUP BY IdSocio,IdTipoSubOperacion,IdPersona
		
		

		--SELECT o.idsocio,d.IdTipoSubOperacion, (SUM(d.Monto-isnull(td.Monto,0))) AS MontoMes,COUNT(*) AS NumeroOperacionesMes ,soc.IdPersona
		--FROM tSDOtransaccionesD d(NOLOCK)
		--JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		--JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
		--JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=o.IdSocio
		--left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		--WHERE d.IdMetodoPago IN (-2,-10)  and o.fecha BETWEEN   @fechaInicio AND   @Fecha AND o.idsocio!=0
		-- AND t.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 
		-- AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		-- GROUP BY o.IdSocio,d.IdTipoSubOperacion,SOC.IdPersona
		

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
		 
		 ) AS tabla

		 ------------------------------------------------------------------------------------------------------------------------
	-------------------------------------OBTENER LAS TRANSACCIONES DE LA FECHA QUE SE VA A EVALUAR para las primeras 4 inusualidades--------------------------
	------------------------------------------------------------------------------------------------------------------------
	DECLARE @TransaacionesDTodosMetodos AS TABLE (IdPersona INT,MontoSubOperacion NUMERIC(23,8),IdUsuarioAlta INT,Alta DATETIME,IdUsuarioCambio INT,UltimoCambio DATETIME,IdSesion INT,IdOperacion INT, IdtransaccionD INT,IdSocio INT,IdCuenta INT,IdEstattus INT,EsPersonaMoral BIT,IdTipoSubOperacion INT,fecha  DATE,IdDivisa int,IdSucursal INT,IdMetodoPago INT)
	
	INSERT INTO @TransaacionesDTodosMetodos


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
		WHERE  o.fecha = @fecha AND o.idsocio!=0
		AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
		AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
	  UNION ALL
		SELECT soc.IdPersona,(d.Monto-ISNULL(td.Monto,0)) AS Monto,o.IdUsuarioAlta,o.Alta,o.IdUsuarioCambio,o.UltimoCambio,o.IdSesion,d.IdOperacion,d.IdTransaccionD,soc.IdSocio,0 AS IdCuenta,o.IdEstatus,per.EsPersonaMoral,d.IdTipoSubOperacion,o.Fecha,o.IdDivisa,o.IdSucursal,d.IdMetodoPago
		FROM tSDOtransaccionesD d(NOLOCK)
		JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
		JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdPersona=o.IdPersonaMovimiento
		JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
		WHERE o.IdSocio=0 AND o.IdPersona=0  AND o.IdPersonaMovimiento!=0
		AND  o.fecha =@fecha 
		AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
		AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
		 
		 ) AS tabla

	--SELECT soc.IdPersona AS IdPersona,(d.Monto-ISNULL(td.Monto,0)),t.IdUsuarioAlta,t.Alta,t.IdUsuarioCambio,t.UltimoCambio,t.IdSesion,d.IdOperacion,d.IdTransaccionD,o.IdSocio,t.IdCuenta,o.IdEstatus,p.EsPersonaMoral,d.IdTipoSubOperacion,o.Fecha,t.IdDivisa,o.IdSucursal,d.IdMetodoPago
	-- FROM tSDOtransaccionesD d(NOLOCK)
	--JOIN tGRLoperaciones o (NOLOCK)ON d.IdOperacion=o.IdOperacion
	--JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=o.IdOperacion AND t.IdTransaccion=d.RelTransaccion
	--JOIN dbo.tSCSsocios soc(NOLOCK)ON soc.IdSocio=o.IdSocio
	--JOIN dbo.tGRLpersonas p (NOLOCK)ON p.IdPersona=soc.IdPersona
	--left join tSDOtransaccionesD td (nolock)on td.IdOperacion=o.IdOperacion and td.EsCambio=1
	--WHERE d.IdMetodoPago IN (-2,-10)  AND o.fecha = @fecha AND o.idsocio!=0
	--  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
	--  AND NOT o.IdTipoOperacion IN (4,22,0,507,41) AND d.EsCambio=0
	  
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
	) AS tabla
    ---------------------------------------------------------------------------------------------------------------------
	---------------------------------------------FIN DE MES--------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	IF (@Fecha=@fechaFin)
	BEGIN
		-------------------------------------------Operaciones realizadas en Sucursal No Declarada--------------------------------------------------------------------------
		---------------------------------------------Fin de Mes ------------------------------------------------------------------------------------------------------------

		--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		--                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		--                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Texto,IdMetodoPago,descripcion)

		--SELECT  IdPersona,1593,46,0,1,-1,@fecha,-1,@fecha,1598,0,IdOperacion,0,'Operaciones realizadas en Sucursal No Declarada',
		--0,idsocio,0,35,CONCAT('Sucursal ',Descripcion),IdMetodoPago,'X'
		--FROM (
		--SELECT t.IdSucursal, t.IdPersona,t.IdOperacion,suc.Descripcion,
		--t.idsocio ,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona ORDER BY t.IdOperacion DESC,ope.fecha DESC) AS numero
		--FROM @TransaacionesDmes t 
		--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
		--JOIN dbo.tCTLsucursales suc With (nolock) ON suc.IdSucursal = t.IdSucursal
		--WHERE NOT EXISTS (SELECT s.Id FROM dbo.tSCSsocioSucursales s With (nolock) WHERE s.IdSocio=t.IdSocio AND s.IdSucursal=t.IdSucursal AND s.IdSocio!=0)
		--AND	  NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones o (NOLOCK) WHERE o.IdInusualidad=35 AND o.IdPersona=t.IdPersona AND o.IdSocio=t.IdSocio AND CAST(o.Alta AS date)=@fecha AND o.Texto=CONCAT('Sucursal ',suc.Descripcion))
		--GROUP BY t.IdSocio,t.IdSucursal,t.IdPersona,suc.Descripcion,t.IdMetodoPago,t.IdOperacion,ope.Fecha)
		--AS tabla
		--WHERE tabla.numero=1
			

		--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		--	                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
		--	                 ----1593 ---presunta inusual   46--Estatus Generado
		--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
		--,IdtransaccionD,CONCAT('Suma de depositos del mes:',MontoMes,',Limite superior declarado',RangoFin)
		--,MontoMes,IdSocio,0,27,IdMetodoPago,'X'
		--FROM (

		--SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
		--,t.IdtransaccionD,md.RangoFin
		--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
		--,se.IdListaDmontoDepositos ,t.MontoSubOperacion
		--FROM @TransaacionesDmes t
		--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
		--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
		--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
		--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
		--JOIN dbo.tCATlistasD md With (nolock) ON md.IdListaD=se.IdListaDmontoDepositos 
		--) AS tabla 
		--WHERE tabla.IdTipoSubOperacion=500 AND  tabla.IdListaDmontoDepositos=0 AND tabla.numero=1
		--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=27 AND Alta=@fecha)



		--------------------------COMPARACION DE LA SUMA NUMERO OPERACIONES DE DEPOSITOS MES CALENDARIO----------------------
		--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------
		-----------------------------------------SIN DATO----------------------------------------------------------------------------
		
	
	
		--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		--	                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
		--	                 ----1593 ---presunta inusual   46--Estatus Generado
		--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
		--,IdtransaccionD,CONCAT('Numero de depositos del mes:',(NumeroOperacionesMes ),',Limite superior declarado',RangoFin)
		--,IdSocio,0,28,IdMetodoPago,'X',tabla.MontoMes
		--FROM (
		--   SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
		--,t.IdtransaccionD,x.NumeroOperacionesMes,nd.RangoFin,t.IdTipoSubOperacion
		--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
		--,se.IdListaDnumeroDepositos ,t.MontoSubOperacion
		--FROM @TransaacionesDmes t
		--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
		--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
		--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
		--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
		--JOIN dbo.tCATlistasD nd With (nolock) ON nd.IdListaD=se.IdListaDnumeroDepositos 
		
		--) AS tabla 

		--WHERE tabla.IdTipoSubOperacion=500 AND IdListaDnumeroDepositos=0 AND tabla.numero=1
		--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=28 AND Alta=tabla.Fecha)


		--------------------------COMPARACION DE LA SUMA MONTOS DE RETIROS MES CALENDARIO----------------------------------
		--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------
		---------------------------------------SIN DATO------------------------------------------------------------------------------
		
		--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		--	                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
		--	                 ----1593 ---presunta inusual   46--Estatus Generado
		--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
		--,IdtransaccionD,CONCAT('Monto de retiros del mes:',MontoMes,',Limite superior declarado',RangoFin)
		--,MontoMes,IdSocio,0,29,IdMetodoPago,'X'
		--FROM (

		--SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
		--,t.IdtransaccionD,mr.RangoFin
		--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
		--,se.IdListaDmontoRetiros,t.MontoSubOperacion
		--FROM @TransaacionesDmes t
		--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
		--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
		--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
		--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
		--JOIN dbo.tCATlistasD mr With (nolock) ON mr.IdListaD=se.IdListaDmontoRetiros 
		--) AS tabla 
		--WHERE tabla.IdTipoSubOperacion=501 and  IdListaDmontoRetiros=0 AND tabla.numero=1
		--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=29 AND Alta=tabla.Fecha)

		--------------------------COMPARACION DE LA SUMA NUMERO OPERACIONES DE RETIROS MES CALENDARIO------------------------
		--------------------------CONTRA EL LIMITE SUPERIOR DECLARADO--------------------------------------------------------
		---------------------------------SIN DATO----------------------------------------------------------------------------
		

		--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		--	                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
		--	                 ----1593 ---presunta inusual   46--Estatus Generado
		--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
		--,IdtransaccionD,CONCAT('Numero de retiros del mes:',(NumeroOperacionesMes ),',Limite superior declarado',RangoFin)
		--,IdSocio,0,30,IdMetodoPago,'X',tabla.MontoMes
		--FROM (
		--  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
		--,t.IdtransaccionD,x.NumeroOperacionesMes,nr.RangoFin,t.IdTipoSubOperacion
		--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
		--,se.IdListaDnumeroRetiros,t.MontoSubOperacion
		--FROM @TransaacionesDmes t
		--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
		--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
		--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
		--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
		--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
		--JOIN dbo.tCATlistasD nr With (nolock) ON nr.IdListaD=se.IdListaDnumeroRetiros 
		
		--) AS tabla 

		--WHERE tabla.IdTipoSubOperacion=501 AND  IdListaDnumeroRetiros=0 AND tabla.numero=1
		--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=30 AND Alta=tabla.Fecha)

		----------------------------REVISAR ALERTAMIENTOS POR SERVICIOS------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------
		------------------------sin dato--------------------------------------------
		
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
		AND o.idsocio!=0 --AND (SELECT  dbo.[fDIVmontoCalculado](o.IdDivisa,-4,o.Fecha,d.monto))>=@montoOperacionFraccionada --AND t.IdCuenta!=0
		AND d.IdTipoSubOperacion IN (500,501)  AND o.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(o.IdOperacion)=0 
		AND NOT o.IdTipoOperacion IN (4,22,0) AND d.EsCambio=0
		GROUP BY o.IdSocio,soc.idpersona
		having count(o.idoperacion)>1
		
		) AS tabla 
		
		WHERE (SELECT  dbo.[fDIVmontoCalculado](1,-4,@fecha,tabla.MontoCuenta))>@MontoRelevante
		AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.IdSocio  AND opl.IdInusualidad=16 AND Alta=@fecha)

		---------Monto Acumulado de depósitos que al Cierre de Mes sea superior a 300 mil pesos para personas Físicas-------------------
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Descripcion)		
		SELECT  p.IdPersona, 1593,46,SUM(td.Monto)-SUM(ISNULL(tr.Monto,0))  AS MontoAcumulado,1,-1,@fecha,-1,GETDATE(),1598,0,0,0,'Monto Acumulado de depósitos que al Cierre de Mes sea superior a 300 mil pesos para personas Físicas.',
		SUM(td.Monto)-SUM(ISNULL(tr.Monto,0)),sc.IdSocio,0,43,'x'
		FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
		INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
		INNER JOIN (
						SELECT f.IdOperacion, c.IdSocio
						FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK)
						INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta 
						INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = f.IdOperacion AND o.Fecha BETWEEN @fechaInicio AND @fechaFin
						GROUP BY f.IdOperacion, c.IdSocio 
					) AS f ON f.IdOperacion = td.IdOperacion
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = f.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona AND p.EsPersonaMoral=0 AND sc.ExentaIVA=0
		LEFT JOIN  dbo.tSDOtransaccionesD tr  WITH(NOLOCK) ON tr.IdOperacion = f.IdOperacion AND tr.EsCambio=1
		WHERE td.EsCambio=0 AND td.IdTipoSubOperacion=500
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdSocio=sc.IdSocio AND IdInusualidad=43 AND CAST(alta AS DATE)=@fecha)
		GROUP BY  sc.IdSocio,p.IdPersona--,td.IdTransaccionD
		HAVING SUM(td.Monto)-SUM(ISNULL(tr.Monto,0)) >= 300000


		------Monto Acumulado de depósitos que al Cierre de Mes sea superior a 500 mil pesos para personas Físicas con actividad empresarial
			INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Descripcion)		
		SELECT  p.IdPersona, 1593,46,SUM(td.Monto)-SUM(ISNULL(tr.Monto,0))  AS MontoAcumulado,1,-1,@fecha,-1,GETDATE(),1598,0,0,0,'Monto Acumulado de depósitos que al Cierre de Mes sea superior a 500 mil pesos para personas Físicas con actividad empresarial.',
		SUM(td.Monto)-SUM(ISNULL(tr.Monto,0)),sc.IdSocio,0,44,'x'
		FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
		INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
		INNER JOIN (
						SELECT f.IdOperacion, c.IdSocio
						FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK)
						INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta 
						INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = f.IdOperacion AND o.Fecha BETWEEN @fechaInicio AND @fechaFin
						GROUP BY f.IdOperacion, c.IdSocio 
					) AS f ON f.IdOperacion = td.IdOperacion
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = f.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona AND p.EsPersonaMoral=0 AND sc.ExentaIVA=1
		LEFT JOIN  dbo.tSDOtransaccionesD tr  WITH(NOLOCK) ON tr.IdOperacion = f.IdOperacion AND tr.EsCambio=1
		WHERE td.EsCambio=0 AND td.IdTipoSubOperacion=500
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdSocio=sc.IdSocio AND IdInusualidad=44 AND CAST(alta AS DATE)=@fecha)
		GROUP BY  sc.IdSocio,p.IdPersona--,td.IdTransaccionD
		HAVING SUM(td.Monto)-SUM(ISNULL(tr.Monto,0)) >= 500000

		------------------Monto Acumulado de depósitos que al Cierre de Mes sea superior a 500 mil pesos para personas Morales
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
                    ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
                     MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Descripcion)		
		SELECT  p.IdPersona, 1593,46,SUM(td.Monto)-SUM(ISNULL(tr.Monto,0))  AS MontoAcumulado,1,-1,@fecha,-1,GETDATE(),1598,0,0,0,'Monto Acumulado de depósitos que al Cierre de Mes sea superior a 500 mil pesos para personas Morales.',
		SUM(td.Monto)-SUM(ISNULL(tr.Monto,0)),sc.IdSocio,0,45,'x'
		FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
		INNER JOIN dbo.tCATmetodosPago mp  WITH(NOLOCK) ON mp.IdMetodoPago = td.IdMetodoPago AND mp.IdMetodoPago IN (-10,-2) 
		INNER JOIN (
						SELECT f.IdOperacion, c.IdSocio
						FROM dbo.tSDOtransaccionesFinancieras f  WITH(NOLOCK)
						INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = f.IdCuenta 
						INNER JOIN dbo.tGRLoperaciones o  WITH(NOLOCK) ON o.IdOperacion = f.IdOperacion AND o.Fecha BETWEEN @fechaInicio AND @fechaFin
						GROUP BY f.IdOperacion, c.IdSocio 
					) AS f ON f.IdOperacion = td.IdOperacion
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = f.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona AND p.EsPersonaMoral=1
		LEFT JOIN  dbo.tSDOtransaccionesD tr  WITH(NOLOCK) ON tr.IdOperacion = f.IdOperacion AND tr.EsCambio=1
		WHERE td.EsCambio=0 AND td.IdTipoSubOperacion=500
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones (NOLOCK) WHERE IdSocio=sc.IdSocio AND IdInusualidad=45 AND CAST(alta AS DATE)=@fecha)
		GROUP BY  sc.IdSocio,p.IdPersona--,td.IdTransaccionD
		HAVING SUM(td.Monto)-SUM(ISNULL(tr.Monto,0)) >= 500000
		
		
		------------Suma de Depósitos al Cierre de Mes es 3 veces superior a los Ingresos Ordinarios declarados por el Socio	Mensual
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
		WHERE tabla.IdTipoSubOperacion=500 AND iif (Ingreso=0, 0,( MontoMes/tabla.Ingreso))>3 AND tabla.numero=1 AND tabla.Ingreso>30000
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=34 AND Alta=tabla.Fecha)
		
	END

	/*  (◕ᴥ◕)    JCA.04/10/2023.12:39 a. m. Nota: Se agrega validación para ejecutar o no dependiendo de como este configurado  */
	IF(@alertaSucursales=1)
	BEGIN
		-----------------------------------------------------Operaciones realizadas en Sucursal No Declarada--------------------------------------------------------------
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
							,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
							 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,Texto,IdMetodoPago,descripcion)

			SELECT  IdPersona,1593,46,0,1,-1,@fecha,-1,@fecha,1598,0,IdOperacion,0,'Operaciones realizadas en Sucursal No Declarada',
			0,idsocio,0,35,CONCAT('Sucursal ',Descripcion),IdMetodoPago,'X'
			FROM (
			SELECT t.IdSucursal, t.IdPersona,t.IdOperacion,suc.Descripcion,
			t.idsocio ,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona ORDER BY t.IdOperacion DESC,ope.fecha DESC) AS numero
			FROM @TransaacionesD t 
			JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
			JOIN dbo.tCTLsucursales suc With (nolock) ON suc.IdSucursal = t.IdSucursal
			WHERE NOT EXISTS (SELECT s.Id FROM dbo.tSCSsocioSucursales s With (nolock) WHERE s.IdSocio=t.IdSocio AND s.IdSucursal=t.IdSucursal AND s.IdSocio!=0)
			AND	  NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones o (NOLOCK) WHERE o.IdInusualidad=35 AND o.IdPersona=t.IdPersona AND o.IdSocio=t.IdSocio AND CAST(o.Alta AS date)=@fecha AND o.Texto=CONCAT('Sucursal ',suc.Descripcion))
			GROUP BY t.IdSocio,t.IdSucursal,t.IdPersona,suc.Descripcion,t.IdMetodoPago,t.IdOperacion,ope.Fecha)
			AS tabla
			WHERE tabla.numero=1

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
	FROM @TransaacionesDTodosMetodos t
	JOIN @NumeroOperacionesMesTodosMetodosPagos x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
	JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	JOIN dbo.tCATlistasD md With (nolock) ON md.IdListaD=se.IdListaDmontoDepositos 
	) AS tabla 
	WHERE tabla.IdTipoSubOperacion=500 --AND tabla.MontoMes>tabla.RangoFin 
	AND IdListaDmontoDepositos !=0 AND tabla.numero=1
	AND ((tabla.RangoFin*3)<tabla.MontoMes or tabla.MontoMes>100000)
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=24 AND Alta=tabla.Fecha)


	
	--------------------------COMPARACION DE LA SUMA MONTOS DE DEPOSITOS MES CALENDARIO VS 300% RESPECTO A LO OPERADO 6 MESES ATRAS----------------------------------
	-------------------------DIARIO----------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------CON DATO-------------------------------------------------------------------------------------------------------------------
	
	

	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Suma de depositos del mes:',MontoMes,',Operado 6 meses atras',tabla.MontoPromedio)
	--,MontoMes,IdSocio,IdCuenta,40,IdMetodoPago,'X'
	--FROM (

	--SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
	--,t.IdtransaccionD,md.RangoFin
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDmontoDepositos ,t.MontoSubOperacion,ISNULL(np.MontoPromedio,0) AS MontoPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio = x.IdSocio AND np.IdTipoSubOperacion=500
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD md With (nolock) ON md.IdListaD=se.IdListaDmontoDepositos 
	--WHERE ISNULL(np.MontoPromedio,0)>=50000
	--) AS tabla 
	--WHERE tabla.IdTipoSubOperacion=500 AND tabla.MontoMes>(tabla.MontoPromedio*3)  AND tabla.numero=1 AND tabla.MontoPromedio!=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=40 AND Alta=tabla.Fecha)


	------los que no tienen informacion de 6 meses atras se compara contra lo declarado 
	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Suma de depositos del mes:',MontoMes,',Limite superior declarado',RangoFin)
	--,MontoMes,IdSocio,IdCuenta,24,IdMetodoPago,'X'
	--FROM (

	--SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
	--,t.IdtransaccionD,md.RangoFin
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDmontoDepositos ,t.MontoSubOperacion,ISNULL(np.MontoPromedio,0) AS MontoPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio = x.IdSocio AND np.IdTipoSubOperacion=500
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD md With (nolock) ON md.IdListaD=se.IdListaDmontoDepositos 
	--WHERE ISNULL(x.MontoMes,0)>=50000
	--) AS tabla 
	--WHERE tabla.IdTipoSubOperacion=500 AND tabla.MontoMes>tabla.RangoFin AND IdListaDmontoDepositos !=0 AND tabla.numero=1 AND tabla.MontoPromedio=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=24 AND Alta=tabla.Fecha)


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
	FROM @TransaacionesDTodosMetodos t
	JOIN @NumeroOperacionesMesTodosMetodosPagos x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
	JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	JOIN dbo.tCATlistasD nd With (nolock) ON nd.IdListaD=se.IdListaDnumeroDepositos 
	
	) AS tabla 

	WHERE tabla.IdTipoSubOperacion=500 AND (tabla.NumeroOperacionesMes) >tabla.RangoFin AND IdListaDnumeroDepositos!=0 AND tabla.numero=1
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=22 AND Alta=tabla.Fecha)

	
	--------------------------COMPARACION DE LA SUMA NUMERO DE DEPOSITOS EN UN MES CALENDARIO VS 300% RESPECTO A LO OPERADO 6 MESES ATRAS----------------------
	-----------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------DIARIO----------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------CON DATO----------------------------------------------------------------------------------------------------------
	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Numero de depositos del mes:',(NumeroOperacionesMes ),',Operado 6 meses atras',tabla.NumeroPromedio)
	--,IdSocio,IdCuenta,39,IdMetodoPago,'X',tabla.MontoMes
	--FROM (
	--  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
	--,t.IdtransaccionD,x.NumeroOperacionesMes,t.IdTipoSubOperacion
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDnumeroDepositos ,t.MontoSubOperacion,ISNULL(np.NumeroPromedio,0) AS NumeroPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio = x.IdSocio AND np.IdTipoSubOperacion=500
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
		
	--) AS tabla 

	--WHERE tabla.IdTipoSubOperacion=500 AND tabla.NumeroOperacionesMes >(tabla.NumeroPromedio*3) AND tabla.numero=1 AND tabla.NumeroPromedio!=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=39 AND Alta=tabla.Fecha)


	------las que no tienen historial se comparan contra lo declarado 
	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Numero de depositos del mes:',(NumeroOperacionesMes ),',Limite superior declarado',RangoFin)
	--,IdSocio,IdCuenta,22,IdMetodoPago,'X',tabla.MontoMes
	--FROM (
	--  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
	--,t.IdtransaccionD,x.NumeroOperacionesMes,t.IdTipoSubOperacion
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDnumeroDepositos ,t.MontoSubOperacion,ISNULL(np.NumeroPromedio,0) AS NumeroPromedio,nd.RangoFin
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=500
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio = x.IdSocio AND np.IdTipoSubOperacion=500
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD nd With (nolock) ON nd.IdListaD=se.IdListaDnumeroDepositos 
	
	--) AS tabla 
	--WHERE tabla.IdTipoSubOperacion=500 AND (tabla.NumeroOperacionesMes) >tabla.RangoFin AND IdListaDnumeroDepositos!=0 AND tabla.numero=1 AND tabla.NumeroPromedio=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=22 AND Alta=tabla.Fecha)
	
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
	FROM @TransaacionesDTodosMetodos t
	JOIN @NumeroOperacionesMesTodosMetodosPagos x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	JOIN dbo.tCATlistasD mr With (nolock) ON mr.IdListaD=se.IdListaDmontoRetiros 
	) AS tabla 
	WHERE tabla.IdTipoSubOperacion=501 --AND tabla.MontoMes>tabla.RangoFin 
	AND IdListaDmontoRetiros!=0 AND tabla.numero=1
	AND  ((tabla.RangoFin*3)<tabla.MontoMes or tabla.MontoMes>100000)
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=23 AND Alta=tabla.Fecha)


	--------------------------COMPARACION DE LA SUMA DE LOS MONTOS DE RETIROS EN MES CALENDARIO VS 300% RESPECTO A LO OPERADO 6 MESES ATRAS---------------------
	-----------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------DIARIO----------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------CON DATO----------------------------------------------------------------------------------------------------------
	
	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Monto de retiros del mes:',MontoMes,',Operado 6 meses atras',tabla.MontoPromedio)
	--,MontoMes,IdSocio,IdCuenta,41,IdMetodoPago,'X'
	--FROM (

	--SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
	--,t.IdtransaccionD,mr.RangoFin
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDmontoRetiros,t.MontoSubOperacion,iSNULL(np.MontoPromedio,0) AS MontoPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio=t.IdSocio AND np.IdTipoSubOperacion=501
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD mr With (nolock) ON mr.IdListaD=se.IdListaDmontoRetiros 
	--WHERE iSNULL(x.MontoMes,0)>=50000
	--) AS tabla 
	--WHERE tabla.IdTipoSubOperacion=501 AND tabla.MontoMes>(tabla.MontoPromedio*3)  AND tabla.numero=1 AND tabla.MontoPromedio!=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=41 AND Alta=tabla.Fecha)

	------los que no tienen historail de 6 mese atras se compara contra lo declarado 

	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Monto de retiros del mes:',MontoMes,',Limite superior declarado',RangoFin)
	--,MontoMes,IdSocio,IdCuenta,23,IdMetodoPago,'X'
	--FROM (

	--SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion,t.IdTipoSubOperacion
	--,t.IdtransaccionD,mr.RangoFin
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDmontoRetiros,t.MontoSubOperacion,iSNULL(np.MontoPromedio,0) AS MontoPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio=t.IdSocio AND np.IdTipoSubOperacion=501
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD mr With (nolock) ON mr.IdListaD=se.IdListaDmontoRetiros 
	--WHERE iSNULL(np.MontoPromedio,0)>=50000
	--) AS tabla 
	--WHERE tabla.IdTipoSubOperacion=501 AND tabla.MontoMes>tabla.RangoFin AND IdListaDmontoRetiros!=0 AND tabla.numero=1 AND tabla.MontoPromedio!=0 AND tabla.MontoPromedio=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=23 AND Alta=tabla.Fecha)


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
	FROM @TransaacionesDTodosMetodos t
	JOIN @NumeroOperacionesMesTodosMetodosPagos x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	JOIN dbo.tCATlistasD nr With (nolock) ON nr.IdListaD=se.IdListaDnumeroRetiros 
	
	) AS tabla 

	WHERE tabla.IdTipoSubOperacion=501 AND (tabla.NumeroOperacionesMes) >tabla.RangoFin AND IdListaDnumeroRetiros!=0 AND tabla.numero=1
	AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=25 AND Alta=tabla.Fecha)


	
	--------------------------COMPARACION DE LA SUMA NUMERO  DE RETIROS MES CALENDARIO VS 300% RESPECTO A LO OPERADO 6 MESES ATRAS ------------------------
	-------------------------DIARIO--------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------CON DATO----------------------------------------------------------------------------------------------------

	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Numero de retiros del mes:',(NumeroOperacionesMes ),',Operado 6 meses atras',tabla.NumeroPromedio)
	--,IdSocio,IdCuenta,42,IdMetodoPago,'X',tabla.MontoMes
	--FROM (
	--  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
	--,t.IdtransaccionD,x.NumeroOperacionesMes,nr.RangoFin,t.IdTipoSubOperacion
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDnumeroRetiros,t.MontoSubOperacion, ISNULL(np.NumeroPromedio,0) AS NumeroPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio = t.IdSocio AND np.IdTipoSubOperacion=501
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD nr With (nolock) ON nr.IdListaD=se.IdListaDnumeroRetiros 
	
	--) AS tabla 

	--WHERE tabla.IdTipoSubOperacion=501 AND tabla.NumeroOperacionesMes >(tabla.NumeroPromedio*3) AND tabla.numero=1 AND tabla.NumeroPromedio!=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=42 AND Alta=tabla.Fecha)


	-----Cuando no tiene historial de 6 meses  atras se compara contra lo declarado 
	--INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	--	                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	--	                 IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion,MontoReferencia)
	--	                 ----1593 ---presunta inusual   46--Estatus Generado
	--SELECT IdPersona,1593,46,MontoSubOperacion,1,-1,tabla.fecha,-1,GETDATE(),1598,IdSesion,IdOperacion
	--,IdtransaccionD,CONCAT('Numero de retiros del mes:',(NumeroOperacionesMes ),',Limite superior declarado',RangoFin)
	--,IdSocio,IdCuenta,25,IdMetodoPago,'X',tabla.MontoMes
	--FROM (
	--  SELECT per.IdPersona,x.MontoMes,ope.Fecha,ope.IdSesion,ope.IdOperacion
	--,t.IdtransaccionD,x.NumeroOperacionesMes,nr.RangoFin,t.IdTipoSubOperacion
	--,soc.IdSocio,t.IdCuenta,t.IdMetodoPago,ROW_NUMBER()OVER(PARTITION BY t.IdSocio,t.IdPersona,t.IdTipoSubOperacion ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	--,se.IdListaDnumeroRetiros,t.MontoSubOperacion, ISNULL(np.NumeroPromedio,0) AS NumeroPromedio
	--FROM @TransaacionesD t
	--JOIN @NumeroOperacionesMes x  ON x.IdSocio=t.IdSocio AND x.IdTipoSubOperacion=501
	--LEFT JOIN @PromedioMontoNumeroOperaciones np ON np.IdSocio = t.IdSocio AND np.IdTipoSubOperacion=501
	--JOIN dbo.tGRLoperaciones ope With (nolock) ON ope.IdOperacion = t.IdOperacion
	--JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = t.IdSocio
	--JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
	--JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = per.IdSocioeconomico
	--JOIN dbo.tCATlistasD nr With (nolock) ON nr.IdListaD=se.IdListaDnumeroRetiros 
	
	--) AS tabla 
	--WHERE tabla.IdTipoSubOperacion=501 AND (tabla.NumeroOperacionesMes) >tabla.RangoFin AND IdListaDnumeroRetiros!=0 AND tabla.numero=1 AND tabla.NumeroPromedio=0
	--AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones WHERE IdTransaccionD=tabla.IdtransaccionD AND IdInusualidad=25 AND Alta=tabla.Fecha)


	---------------------------------------------------------------------------------------------------------------------
	----------------------------REVISAR ALERTAMIENTOS POR SERVICIOS------------------------------------------------------
	----------------------------DIARIO-----------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
	--credito
	/*  (◕ᴥ◕)    JCA.04/10/2023.12:39 a. m. Nota: Se agrega validación para ejecutar o no dependiendo de como este configurado  */
	IF(@alertaServicioCredito=1)
	BEGIN	
			INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
								,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
								 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

			SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'ALERTAMIENTOS POR SERVICIOS, CREDITO NO DECLARADO'
			,0,IdSocio,IdCuenta,26,0,'X'	 
			FROM ( SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
			 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
			 FROM dbo.tGRLoperaciones ope With (nolock)
			 JOIN dbo.tSDOtransaccionesD t With (nolock) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
			JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) ON tf.IdOperacion = ope.IdOperacion
			JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta=tf.IdCuenta AND c.IdTipoDProducto=143
			JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio=c.IdSocio
			JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona=s.IdPersona
			JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = p.IdSocioeconomico
			LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados AND ser.IdListaD=-38 and ser.IdTipoD=1609 AND ser.IdEstatus=1
			WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago IN (-2,-10) AND c.idcuenta!=0
			AND ser.IdListaD IS NULL   AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
			AND NOT ope.IdTipoOperacion IN (4,22,0,507,41) --AND se.IdRelServiciosFinancierosAsignados!=0
			)AS tabla
			WHERE tabla.numero=1
	END


	---ahorro
	/*  (◕ᴥ◕)    JCA.04/10/2023.12:39 a. m. Nota: Se agrega validación para ejecutar o no dependiendo de como este configurado  */
	IF(@alertaServicioAhorro=1)
	BEGIN	
			INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
								,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
								 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
			SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'ALERTAMIENTOS POR SERVICIOS AHORRO NO DECLARADO'
			,0,IdSocio,IdCuenta,26,0,'X'	 
			 FROM (
			 SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
			 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
			 FROM dbo.tGRLoperaciones ope With (nolock) 
			 JOIN dbo.tSDOtransaccionesD t With (nolock) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
			JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) ON tf.IdOperacion = ope.IdOperacion
			JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta=tf.IdCuenta AND c.IdTipoDProducto=144
			JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio=c.IdSocio
			JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona=s.IdPersona
			JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = p.IdSocioeconomico
			LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados AND ser.IdListaD=-37 and ser.IdTipoD=1609 AND ser.IdEstatus=1
			WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago IN (-2,-10) AND c.idcuenta!=0
			AND ser.IdListaD IS NULL  AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
			AND NOT ope.IdTipoOperacion IN (4,22,0,507,41)-- AND se.IdRelServiciosFinancierosAsignados!=0
			)AS tabla
			WHERE tabla.numero=1
	END

	
	---INVERSION
	/*  (◕ᴥ◕)    JCA.04/10/2023.12:39 a. m. Nota: Se agrega validación para ejecutar o no dependiendo de como este configurado  */
	IF(@alertaServicioInversion=1)
	BEGIN	
			INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
								,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
								 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
			SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'ALERTAMIENTOS POR SERVICIOS ,INVERSION NO DECLARADO'
			,0,IdSocio,IdCuenta,26,0,'X'	 
			 FROM (
			 SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
			 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
			 FROM dbo.tGRLoperaciones ope With (nolock) 
			JOIN dbo.tSDOtransaccionesD t With (nolock) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
			JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) ON tf.IdOperacion = ope.IdOperacion
			JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta=tf.IdCuenta AND c.IdTipoDProducto=398
			JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio=c.IdSocio
			JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona=s.IdPersona
			JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = p.IdSocioeconomico
			LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados AND ser.IdListaD=-36 and ser.IdTipoD=1609 AND ser.IdEstatus=1
			WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago IN (-2,-10) AND c.idcuenta!=0
			AND ser.IdListaD IS NULL  AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
			AND NOT ope.IdTipoOperacion IN (4,22,0,507,41) --AND se.IdRelServiciosFinancierosAsignados!=0
			) AS tabla 
			WHERE tabla.numero=1
	END


	----SERVICIOS
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)
	SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'ALERTAMIENTOS POR SERVICIOS ,SERVICIO NO DECLARADO',0,IdSocio,0,26,0,'X'
	FROM
	(
		SELECT s.IdPersona,
			   ope.Fecha,
			   ope.IdSesion,
			   ope.IdOperacion,
			   s.IdSocio,
			   ROW_NUMBER() OVER (PARTITION BY s.IdSocio,
											   p.IdPersona
								  ORDER BY t.IdOperacion DESC,
										   ope.Fecha DESC
								 ) AS numero
		FROM dbo.tGRLoperaciones ope WITH (NOLOCK)
			JOIN dbo.tGRLoperacionesD od WITH (NOLOCK)
				ON od.RelOperacionD = ope.IdOperacion
			JOIN dbo.tSDOtransaccionesD t WITH (NOLOCK)
				ON t.IdOperacion = ope.IdOperacion
				   AND t.EsCambio = 0
			JOIN dbo.tSCSsocios s WITH (NOLOCK)
				ON s.IdSocio = ope.IdSocio
			JOIN dbo.tGRLpersonas p WITH (NOLOCK)
				ON p.IdPersona = s.IdPersona
			JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK)
				ON se.IdSocioeconomico = p.IdSocioeconomico
			LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser WITH (NOLOCK)
				ON ser.IdRel = se.IdRelServiciosFinancierosAsignados
				   AND ser.IdListaD = -39
				   AND ser.IdTipoD = 1609
				   AND ser.IdEstatus = 1
		WHERE ope.Fecha = @fecha
			  AND t.IdMetodoPago IN ( -2, -10 )
			  AND od.IdBienServicio != 0
			  AND s.IdSocio != 0
			  AND ser.IdListaD IS NULL
			  AND ope.IdEstatus != 18
			  AND dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion) = 0
			  AND NOT ope.IdTipoOperacion IN ( 4, 22, 0, 507, 41 ) --AND se.IdRelServiciosFinancierosAsignados!=0
	) AS tabla
	WHERE tabla.numero = 1;


	
	------------------------------------------------------------------------------------------------
	---------------------------Número máximo de sucursales para transaccionar en un solo día mayor al declarado
	/*  (◕ᴥ◕)    JCA.04/10/2023.12:39 a. m. Nota: Se agrega validación para ejecutar o no dependiendo de como este configurado  */
	IF(@alertaSucursalesMismoDia=1)
	BEGIN
		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
					,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
					 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,descripcion)
		SELECT IdPersona ,1593,46,0,1,-1,@fecha,-1,@fecha,1598,0,0,0,CONCAT('Número máximo de sucursales para transaccionar en un solo día mayor al declarado.Númer Suc:',COUNT(t.IdSocio),'declaradas:',t.NumeroMaximoSucursales)
		,0,idsocio,0,36,t.IdMetodoPago,'X' FROM (
		SELECT  t.IdPersona,t.idsocio,t.IdSucursal,t.fecha,se.NumeroMaximoSucursales,t.IdMetodoPago
		 FROM @TransaacionesD t
		 LEFT JOIN dbo.tGRLpersonas pf (NOLOCK)ON pf.IdPersona=t.IdPersona
		LEFT JOIN dbo.tSCSpersonasSocioeconomicos se (NOLOCK)ON se.IdSocioeconomico=pf.IdSocioeconomico
		 WHERE IdTipoSubOperacion=500 
		AND NOT EXISTS(SELECT IdTransaccionD FROM dbo.tPLDoperaciones oper (NOLOCK) WHERE oper.IdPersona=t.IdPersona AND oper.IdSocio=t.IdSocio AND oper.IdInusualidad=36 AND CAST(oper.Alta AS DATE)=@fecha)
		GROUP BY t.IdPersona,IdSocio,IdSucursal,fecha,se.NumeroMaximoSucursales,t.IdMetodoPago
		) AS t
		GROUP BY t.IdPersona, t.IdSocio,t.fecha,t.NumeroMaximoSucursales,t.IdMetodoPago
		HAVING( t.NumeroMaximoSucursales<COUNT(*))
	END

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
	
	---------------------------------------------------------------------------------------------------------------------
	----------------------------REVISAR ALERTAMIENTOS POR CANAL DE DISTRIBUCION------------------------------------------------------
	----------------------------DIARIO-----------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------

	
	--transferencia
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

	SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'Canal de Distribución utilizado no Declarado, transferencia no declarado'
	,0,IdSocio,IdCuenta,38,0,'X'	 
	FROM ( SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
	 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	 FROM dbo.tGRLoperaciones ope With (nolock)
	 JOIN dbo.tSDOtransaccionesD t With (nolock) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
	JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) ON tf.IdOperacion = ope.IdOperacion
	JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta=tf.IdCuenta 
	JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio=c.IdSocio
	JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona=s.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = p.IdSocioeconomico
	LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados  
	AND ser.IdTipoD=1610 AND ser.IdListaD=-1398 AND ser.IdEstatus=1 
	WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago =-3 AND c.IdCuenta!=0  AND t.Monto>50000
	AND ser.IdListaD IS NULL   AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
	AND NOT ope.IdTipoOperacion IN (4,22,0,507,41) --AND se.IdRelServiciosFinancierosAsignados!=0
	)AS tabla
	WHERE tabla.numero=1
	AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl WITH (NOLOCK)  WHERE opl.IdSocio=tabla.IdSocio AND opl.IdCuenta=tabla.IdCuenta AND opl.IdInusualidad=38 AND Alta=tabla.Fecha)

	--cheques
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

	SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'Canal de Distribución utilizado no Declarado, cheques no declarado'
	,0,IdSocio,IdCuenta,38,0,'X'	 
	FROM ( SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
	 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion DESC,ope.Fecha DESC) AS numero
	 FROM dbo.tGRLoperaciones ope WITH (NOLOCK)
	 JOIN dbo.tSDOtransaccionesD t WITH (NOLOCK) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
	JOIN dbo.tSDOtransaccionesFinancieras tf WITH (NOLOCK) ON tf.IdOperacion = ope.IdOperacion
	JOIN dbo.tAYCcuentas c WITH (NOLOCK) ON c.IdCuenta=tf.IdCuenta 
	JOIN dbo.tSCSsocios s WITH (NOLOCK) ON s.IdSocio=c.IdSocio
	JOIN dbo.tGRLpersonas p WITH (NOLOCK) ON p.IdPersona=s.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) ON se.IdSocioeconomico = p.IdSocioeconomico
	LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser WITH (NOLOCK) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados  
	AND ser.IdTipoD=1610 AND ser.IdListaD=-1399 AND ser.IdEstatus=1
	WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago =-1 AND c.IdCuenta!=0 AND t.Monto>50000
	AND ser.IdListaD IS NULL   AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
	AND NOT ope.IdTipoOperacion IN (4,22,0,507,41) --AND se.IdRelServiciosFinancierosAsignados!=0
	)AS tabla
	WHERE tabla.numero=1
	AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.IdSocio AND opl.IdCuenta=tabla.IdCuenta AND opl.IdInusualidad=38 AND alta=tabla.Fecha)

	--efectivo
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

	SELECT IdPersona,1593,46
	,Monto
	,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,IdTransaccionD,'Canal de Distribución utilizado no Declarado, efectivo no declarado'  -- 180,000.00
	,total,IdSocio,IdCuenta,38,IdMetodoPago,'X'	 
	--,tabla.Nombre,tabla.MontoSubOperacion,monto,total
	FROM ( 
		SELECT  
		s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
		ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
		,p.Nombre,tf.MontoSubOperacion,ope.Total,t.Monto,t.IdTransaccionD,t.IdMetodoPago
		FROM dbo.tGRLoperaciones ope With (nolock)
		JOIN dbo.tSDOtransaccionesD t With (nolock) 
			ON t.IdOperacion = ope.IdOperacion 
				AND t.EsCambio=0 
		JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) 
			ON tf.IdOperacion = ope.IdOperacion
		JOIN dbo.tAYCcuentas c With (nolock) 
			ON c.IdCuenta=tf.IdCuenta 
		JOIN dbo.tSCSsocios s With (nolock) 
			ON s.IdSocio=c.IdSocio
		JOIN dbo.tGRLpersonas p With (nolock) 
			ON p.IdPersona=s.IdPersona
		JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) 
			ON se.IdSocioeconomico = p.IdSocioeconomico
		LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) 
			ON ser.IdRel=se.IdRelServiciosFinancierosAsignados  
				AND ser.IdTipoD=1610 
					AND ser.IdListaD=-1400 
						AND ser.IdEstatus=1
		WHERE ope.Fecha=@fecha 
			AND t.IdMetodoPago =-2 
				AND c.IdCuenta!=0 
					AND t.Monto>50000
						AND ser.IdListaD IS NULL   
							AND ope.IdEstatus!=18 
								AND dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
									AND NOT ope.IdTipoOperacion IN (4,22,0,507,41)-- AND se.IdRelServiciosFinancierosAsignados!=0
	)AS tabla
	WHERE tabla.numero=1
		AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  
						WHERE opl.IdSocio=tabla.IdSocio 
							AND opl.IdCuenta=tabla.IdCuenta 
								AND opl.IdInusualidad=38 
									AND Alta=tabla.Fecha)

	--voucher
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

	SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'Canal de Distribución utilizado no Declarado, voucher no declarado'
	,0,IdSocio,IdCuenta,38,0,'X'	 
	FROM ( SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
	 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	 FROM dbo.tGRLoperaciones ope With (nolock)
	 JOIN dbo.tSDOtransaccionesD t With (nolock) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
	JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) ON tf.IdOperacion = ope.IdOperacion
	JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta=tf.IdCuenta 
	JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio=c.IdSocio
	JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona=s.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = p.IdSocioeconomico
	LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados  
	AND ser.IdTipoD=1610 AND ser.IdListaD=-1401 AND ser.IdEstatus=1
	WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago =-9 AND c.IdCuenta!=0 AND t.Monto>50000
	AND ser.IdListaD IS NULL   AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
	AND NOT ope.IdTipoOperacion IN (4,22,0,507,41) --AND se.IdRelServiciosFinancierosAsignados!=0
	)AS tabla
	WHERE tabla.numero=1
	AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.IdSocio AND opl.IdCuenta=tabla.IdCuenta AND opl.IdInusualidad=38 AND Alta=tabla.Fecha)


	--voucher efectivo
	INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago,Descripcion)

	SELECT IdPersona,1593,46,0,1,-1,Fecha,-1,GETDATE(),1598,IdSesion,IdOperacion,0,'Canal de Distribución utilizado no Declarado, voucher efectivo no declarado'
	,0,IdSocio,IdCuenta,38,0,'X'	 
	FROM ( SELECT  s.IdPersona,ope.Fecha,ope.IdSesion,ope.IdOperacion,s.IdSocio,c.IdCuenta,
	 ROW_NUMBER()OVER(PARTITION BY s.IdSocio,p.IdPersona ORDER BY t.IdOperacion desc,ope.Fecha desc) AS numero
	 FROM dbo.tGRLoperaciones ope With (nolock)
	 JOIN dbo.tSDOtransaccionesD t With (nolock) ON t.IdOperacion = ope.IdOperacion AND t.EsCambio=0 
	JOIN dbo.tSDOtransaccionesFinancieras tf With (nolock) ON tf.IdOperacion = ope.IdOperacion
	JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta=tf.IdCuenta 
	JOIN dbo.tSCSsocios s With (nolock) ON s.IdSocio=c.IdSocio
	JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona=s.IdPersona
	JOIN dbo.tSCSpersonasSocioeconomicos se With (nolock) ON se.IdSocioeconomico = p.IdSocioeconomico
	LEFT JOIN dbo.tSCSserviciosFinancierosMediosAsignados ser With (nolock) ON ser.IdRel=se.IdRelServiciosFinancierosAsignados  
	AND ser.IdTipoD=1610 AND ser.IdListaD=-1402 AND ser.IdEstatus=1
	WHERE   ope.Fecha=@Fecha AND t.IdMetodoPago =-10 AND c.IdCuenta!=0 AND t.Monto>50000
	AND ser.IdListaD IS NULL   AND ope.IdEstatus!=18 AND  dbo.fnPLDesOperacionDotacionCustodia(ope.IdOperacion)=0 
	AND NOT ope.IdTipoOperacion IN (4,22,0,507,41)-- AND se.IdRelServiciosFinancierosAsignados!=0
	)AS tabla
	WHERE tabla.numero=1
	AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tabla.IdSocio AND opl.IdCuenta=tabla.IdCuenta AND opl.IdInusualidad=38 AND Alta=tabla.Fecha)

	  -------Inusualidad por Relevancia
	  IF ((SELECT Valor FROM dbo.tPLDconfiguracion WHERE IdParametro=-34)='True')
	   BEGIN
		 DECLARE @MontoRelevancia NUMERIC(23,8)=0
		 SET @MontoRelevancia=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-33)

	       INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
	     	,UltimoCambio,IdTipoDDominio,IdObservacionE,IdObservacionEDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
	     	MontoReferencia,IdSocio, IdCuenta,GeneradaDesdeSistema,Texto,IdInusualidad,IdMetodoPago,Descripcion)
			----1593 --- presunta inusual   46--GNEREDO
			SELECT o.IdPersona,1593 ,46 ,t.Monto,1,o.IdUsuarioAlta,o.Fecha,o.IdUsuarioCambio,
			o.Fecha,1598,0,0,o.IdSesion,td.IdOperacionOrigen,td.IdTransaccionD,'INUSUALIDAD POR MONTO RELEVANTE',@MontoRelevancia,o.IdSocio,0,1,'INUSUALIDAD POR MONTO RELEVANTE',17,td.IdMetodoPago,'X'
			FROM dbo.tPLDoperaciones td WITH(NOLOCK)
			INNER JOIN tGRLoperaciones AS o  WITH (NOLOCK) ON o.IdOperacion = td.IdOperacionOrigen
			inner JOIN tSDOtransaccionesD AS t  WITH (NOLOCK) ON t.IdTransaccionD=td.IdTransaccionD AND t.EsCambio=0
			WHERE o.Fecha=@fecha AND td.IdTipoDoperacionPLD=1594
			AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=o.IdSocio AND opl.IdInusualidad=17 AND Alta=o.Fecha)
	   END

	   ------Operación presunta preocupante por inusualidad de empleado
			IF ((SELECT valor FROM dbo.tPLDconfiguracion WHERE IdParametro=-35)='True')
			BEGIN
			---1597 presunta preocupante
				INSERT INTO dbo.tPLDoperaciones(IdPersona, IdTipoDoperacionPLD, IdEstatusAtencion, Monto, IdEstatus, IdUsuarioAlta, Alta, IdUsuarioCambio, UltimoCambio, IdTipoDDominio, texto, IdOperacionOrigen, IdTransaccionD, TipoIndicador, MontoReferencia, IdSocio, IdCuenta, IdListaDOperacion, Descripcion, IdPersonaUsuarioServicios, IdListaDorigenRecursos, GeneradaDesdeSistema, IdInusualidad)
				select pf.IdPersona,1597,46,Monto,1,-1,@fecha,-1,@fecha,1598,'OPERACIÓN PRESUNTA PREOCUPANTE POR INUSUALIDAD DE EMPLEADO',IdOperacionOrigen,IdTransaccionD,'OPERACIÓN PRESUNTA PREOCUPANTE POR INUSUALIDAD DE EMPLEADO',MontoReferencia,IdSocio,IdCuenta,IdListaDOperacion,'X',IdPersonaUsuarioServicios,IdListaDorigenRecursos,1,18
				FROM dbo.tPLDoperaciones ope
				JOIN dbo.tGRLpersonasFisicas pf With (nolock) ON pf.IdPersona = ope.IdPersona
				WHERE CAST(ope.Alta AS DATE )=@fecha AND pf.EsEmpleado=1 AND ope.IdTipoDoperacionPLD=1593
				AND ope.IdPersona!=0
				AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=ope.IdSocio AND opl.IdCuenta=ope.IdCuenta AND opl.IdInusualidad=18 AND Alta=@fecha)
		    END


			-------------------*******************************Cuando el monto por liquidar sea mayor al 50% del monto original o el No. De plazos sea igual a la mitad del total de plazos de apertura****
	DECLARE @MontoCreditos AS DECIMAL(23,8)=0
	SET @MontoCreditos=(SELECT valor FROM tPLDconfiguracion tp (nolock)WHERE tp.IdParametro=-7)

	IF (@MontoCreditos!=0)
	BEGIN

		INSERT INTO tPLDoperaciones(IdPersona,IdTipoDoperacionPLD,IdEstatusAtencion,Monto,IdEstatus,IdUsuarioAlta,Alta,IdUsuarioCambio
		                ,UltimoCambio,IdTipoDDominio,IdSesion,IdOperacionOrigen,IdTransaccionD,TipoIndicador,
		                 MontoReferencia,IdSocio, IdCuenta,IdInusualidad,IdMetodoPago)
		                 ----1593 ---presunta inusual   46--Estatus Generado
		SELECT tg.IdPersona,1593,46,tf.MontoSubOperacion,1,-1,tf.Fecha,-1,tf.Fecha,1598,0,t.IdOperacion,t.IdTransaccionD,
		'Cuando el monto por liquidar sea mayor al 50% del monto original o el No. De plazos sea igual a la mitad del total de plazos de apertura.',c.Monto,tg.IdSocio,tf.IdCuenta,10
		,t.IdMetodoPago
		 FROM tSDOtransaccionesD t (NOLOCK)
		JOIN tGRLoperaciones tg (NOLOCK)ON tg.IdOperacion=t.IdOperacion
		JOIN tSDOtransaccionesFinancieras tf(NOLOCK)ON tf.IdOperacion=t.IdOperacion
		JOIN tayccuentas c (NOLOCK)ON c.IdCuenta=tf.IdCuenta AND c.IdTipoDParcialidad!=719----PAGO ÚNICO DE CAPITAL MÁS INTERÉS AL FINAL
		WHERE  dbo.fnPLDesOperacionDotacionCustodia(tg.IdOperacion)=0 AND tg.IdEstatus=1  AND 
		 t.IdTipoSubOperacion=500 AND t.IdMetodoPago=-2  AND tg.Fecha=@fecha AND t.EsCambio=0
		AND NOT EXISTS(SELECT 1 FROM dbo.tPLDoperaciones opl With (nolock)  WHERE opl.IdSocio=tg.IdSocio AND opl.IdCuenta=c.IdCuenta AND opl.IdInusualidad=10 AND Alta=tf.Fecha)
		AND c.IdTipoDProducto=143 AND c.Monto>@MontoCreditos AND (tf.MontoSubOperacion >c.monto/2) AND c.IdEstatus=7
		GROUP BY tg.IdSocio,tf.IdCuenta,tf.Fecha,t.IdOperacion,t.IdTransaccionD,tf.MontoSubOperacion,c.Monto,t.IdMetodoPago,tg.IdPersona



	
	END

END 














GO

