

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDauditoriaIndicadores')
BEGIN
	DROP PROC pCnPLDauditoriaIndicadores
	SELECT 'pCnPLDauditoriaIndicadores BORRADO' AS info
END
GO

CREATE PROC pCnPLDauditoriaIndicadores
@pFechaInicial AS DATE='19000101',
@pFechaFinal AS DATE='19000101'
AS
BEGIN
	
		TRUNCATE TABLE dbo.tPLDdesagregadoOperacionesProductosFinancierosMetodoPago

		INSERT INTO tPLDdesagregadoOperacionesProductosFinancierosMetodoPago
		EXEC dbo.pAYCdesagregadoOperacionesProductosFinancierosMetodoPago2 @FechaInicial = @pFechaInicial, -- date
																		   @FechaFinal = @pFechaFinal,   -- date
																		   @NoSocio = '*'                 -- varchar(20)

		DECLARE @diff AS INT=DATEDIFF(MONTH,@pFechaInicial,@pFechaFinal)
		IF @diff>12
		BEGIN
			SELECT 'Su consulta excede los 3 Meses permitidos (' + CAST(@diff AS VARCHAR) + '). Acote sus fechas por favor'
			RETURN
		END

		SET NOCOUNT ON

		DECLARE @ops AS TABLE(
						Id	INT,
						Fecha	DATE,
						Alta	DATETIME,
						CodigoSucursal	VARCHAR(12),
						Sucursal	VARCHAR(80),
						TipoOperacion	VARCHAR(30),
						Folio	INT,
						TipoMovimiento	VARCHAR(30),
						MetodoPago	VARCHAR(30),
						PagadoCapital	NUMERIC(13,2),
						PagadoIO	NUMERIC(13,2),
						PagadoIM	NUMERIC(13,2),
						PagadoIVA	NUMERIC(13,2),
						SaldoCapitalAnterior	NUMERIC(13,2),
						Total	NUMERIC(13,2),
						MontoSubOperacion	NUMERIC(13,2),
						SaldoCapital	NUMERIC(13,2),
						NoSocio	VARCHAR(24),
						Nombre	VARCHAR(128),
						RFC	VARCHAR(32),
						NoCuenta	VARCHAR(24),
						Producto	VARCHAR(80),
						TipoProducto	VARCHAR(250),
						Usuario	VARCHAR(40),
						NivelRiesgo	VARCHAR(250)
				)

		DECLARE @FechaInicial AS DATE=@pFechaInicial
		DECLARE @FechaFinal AS DATE=@pFechaFinal

		INSERT INTO @ops
		SELECT *
		FROM tPLDdesagregadoOperacionesProductosFinancierosMetodoPago o  WITH(NOLOCK) 


		/* a) i. Número de Socios que operaron */
		SELECT 
		COUNT(DISTINCT o.NoSocio) AS [a) i. Número de Socios que operaron]
		--SUM(DISTINCT IIF(o.NivelRiesgo='ALTO',1,0)) AS TotalSocios
		FROM @ops o 


		/* a) ii. Número de Socios de Alto Riesgo */
		SELECT 
		COUNT(DISTINCT calfin.IdSocio) AS [a) ii. Número de Socios de Alto Riesgo]
		FROM dbo.tPLDmatrizEvaluacionesRiesgoCalificacionesFinales calfin  WITH(NOLOCK) 
		INNER JOIN dbo.tPLDmatrizEvaluacionesRiesgo eval  WITH(NOLOCK) 
			ON eval.IdEvaluacionRiesgo = calfin.IdEvaluacionRiesgo
				AND eval.Fecha BETWEEN @FechaInicial AND @FechaFinal
		WHERE calfin.NivelDeRiesgoDescripcion='ALTO'

		/* a) iii. Número de PEPs identificados durante el año */
		SELECT COUNT(DISTINCT ppe.IdPersona) AS [a) iii. Número de PEPs identificados durante el año]
		FROM dbo.tPLDppe ppe  WITH(NOLOCK) 
		WHERE ppe.IdEstatus=1
			AND CAST(alta AS DATE) BETWEEN @FechaInicial AND @FechaFinal

		/* a) iv. Número de Socios Extrajeros */
		SELECT 
		  COUNT(sc.IdSocio) AS [iv. Número de Socios Extrajeros]
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		LEFT JOIN (
					SELECT nac.IdPersona, STRING_AGG(n.Descripcion,',') AS Nacionalidades
					FROM dbo.tGRLnacionalidadesPersona nac  WITH(NOLOCK) 
					INNER JOIN dbo.tCTLnacionalidades n  WITH(NOLOCK) 
						ON n.IdNacionalidad = nac.IdNacionalidad
					GROUP BY nac.IdPersona
					) n ON n.IdPersona = p.IdPersona
		WHERE sc.EsSocioValido=1
			AND p.EsExtranjero=1
				AND EXISTS (SELECT 
							1
							FROM @ops o 
							WHERE sc.Codigo=o.NoSocio)

		/* b) Total de Sucursales que Operaron en el Periodo */
		SELECT 
		COUNT(DISTINCT o.Sucursal) AS [b) Total de Sucursales que Operaron en el Period]
		FROM @ops o

		/* c) iii Número de Alertas generadas por cada producto*/
		SELECT 
		  pf.Codigo
		, pf.Descripcion AS Producto
		, COUNT(1) AS [c) iii Número de Alertas generadas por cada producto]
		FROM dbo.tPLDoperaciones opld  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
			ON c.IdCuenta = opld.IdCuenta
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
			ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		WHERE CAST(opld.Alta AS DATE) BETWEEN @FechaInicial AND @FechaFinal
		AND opld.IdCuenta<>0
		GROUP BY pf.Codigo, pf.Descripcion



		/* d) i. Número Total de operaciones realizadas*/
		SELECT COUNT(1) AS [d) i. Número Total de operaciones realizadas]
		FROM @ops o

		

		/* d) iii. Listado de transacciones realizadas*/
		PRINT 'd) iii. Listado de transacciones realizadas superiores a $150,000'
		SELECT o.Fecha,
			   o.Sucursal,
			   o.TipoOperacion,
			   o.Folio,
			   o.TipoMovimiento,
			   o.MetodoPago,
			   o.MontoSubOperacion,
			   o.NoSocio,
			   o.Nombre,
			   o.NoCuenta,
			   o.Producto,
			   o.TipoProducto
		FROM @ops o
		WHERE o.MontoSubOperacion>150000

END
GO