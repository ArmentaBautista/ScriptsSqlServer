
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDdeteccionAlertamientos')
BEGIN
	DROP PROC pPLDdeteccionAlertamientos
	SELECT 'pPLDdeteccionAlertamientos BORRADO' AS info
END
GO

CREATE PROC pPLDdeteccionAlertamientos
@pFechaTrabajo AS DATE='20240430',
@pFiltrarEfectivo AS INT=0,
@pDebug AS BIT=1
AS
BEGIN

/********  JCA.27/4/2024.01:47 Info: Parámetros del SP  ********/
DECLARE @FechaTrabajo AS DATE=@pFechaTrabajo
DECLARE @FiltrarEfectivo AS INT=@pFiltrarEfectivo
DECLARE @Debug AS BIT=@pDebug

/********  JCA.27/4/2024.01:48 Info: Parámetros de las Inusualidades  ********/
/*!! TODO !! JCA:27/4/2024.01:54 Obtener los valores de la tabla de Configuraciones  */
DECLARE @NumeroMesesOperacionesEvaluacion AS INT=6

DECLARE @PorcentajeSumaDepositosMesCalendario AS NUMERIC(3,2)=3.0
DECLARE @MontoUmbralSumaDepositosMesCalendario AS NUMERIC(15,2)=100000
DECLARE @PorcentajeSumaRetirosMesCalendario AS NUMERIC(3,2)=3.0
DECLARE @MontoUmbralSumaRetirosMesCalendario AS NUMERIC(15,2)=100000
/********  JCA.27/4/2024.02:06 Info: El siguiente parámetro corresponde al monto configurado para la Relevancia  ********/
DECLARE @MontoDlsUmbralFraccionesCierreMes AS NUMERIC(15,2)=7500 
DECLARE @MontoUmbralFraccionesCierreMesPF AS NUMERIC(15,2)=300000
DECLARE @MontoUmbralFraccionesCierreMesPM AS NUMERIC(15,2)=500000

DECLARE @MontoIngresosParaInusualidad AS NUMERIC(15,2)=15000
DECLARE @PorcentajeSumaDepositosCierreMesVsIngresos AS NUMERIC(3,2)=3.0

DECLARE @MontoOtorgadoCreditosLiquidados AS NUMERIC(15,2)=50000
DECLARE @PorcentajeSobreMontoCreditosLiquidados AS NUMERIC(3,2)=3.0
DECLARE @PorcentajeSobrePlazoCreditosLiquidados AS NUMERIC(3,2)=3.0
DECLARE @DiasDespuesDesembolsoCreditosLiquidados AS INT=15

/********  JCA.27/4/2024.02:34 Info: Fechas de filtrado de movimientos  ********/
DECLARE @InicioMesActual AS DATE
DECLARE @FinMesActual AS DATE
DECLARE @IdPeriodoActual AS INT
DECLARE @InicioMesesEvaluacion AS DATE = DATEADD(MONTH,-@NumeroMesesOperacionesEvaluacion,@FechaTrabajo)
SELECT @IdPeriodoActual = p.IdPeriodo, @InicioMesActual=p.Inicio, @FinMesActual=p.Fin FROM dbo.tCTLperiodos p  WITH(NOLOCK) WHERE p.EsAjuste=0 AND @FechaTrabajo BETWEEN p.Inicio AND p.Fin

IF @Debug=1 SELECT 'Periodo Consultado' AS Info, @IdPeriodoActual AS IdPeriodoActual, @InicioMesesEvaluacion AS Inicio6Meses, @InicioMesActual AS InicioMesActual, @FinMesActual AS FinMesActual 

/********  JCA.28/4/2024.22:15 Info: Estatus Actual TransaccioensD  ********/
DECLARE @EA AS TABLE
(
    [IdEstatusActual] INT,
    [IdEstatus] INT,
    [IdTipoDDominio] INT
);

INSERT INTO @EA(IdEstatusActual,IdEstatus,IdTipoDDominio)
SELECT ea.IdEstatusActual, ea.IdEstatus, ea.IdTipoDDominio 
FROM dbo.tCTLestatusActual ea  WITH(NOLOCK) 
WHERE ea.IdEstatus=1 AND ea.IdTipoDDominio=1409

/********  JCA.27/4/2024.03:15 Info: Carga de las Financieras de los últimos 6 meses  ********/
DECLARE @FinancierasEvaluacion TABLE(
		IdTransaccion INT NOT NULL,
		IdOperacion INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Fecha DATE NOT NULL,
		MontoSubOperacion NUMERIC(11,2) NULL DEFAULT 0,
		IdCuenta INT NOT NULL,
		Naturaleza SMALLINT,
		TotalCargos NUMERIC(11,2),
		TotalAbonos NUMERIC(11,2),
		SaldoCapital NUMERIC(11,2),
		SaldoCapitalAnterior NUMERIC(11,2)
	)

INSERT @FinancierasEvaluacion
SELECT 
tf.IdTransaccion,
tf.IdOperacion,
tf.IdTipoSubOperacion,
tf.Fecha,
tf.MontoSubOperacion,
tf.IdCuenta,
tf.Naturaleza,
tf.TotalCargos,
tf.TotalAbonos,
tf.SaldoCapital,
tf.SaldoCapitalAnterior
FROM dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK)
INNER JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) 
	ON op.IdOperacion = tf.IdOperacion
		AND op.IdTipoOperacion IN (1,2,10,22,41)
WHERE tf.IdOperacion<>0
	AND tf.IdEstatus=1
		AND tf.IdTipoSubOperacion IN (500,501)
			AND tf.Fecha BETWEEN @InicioMesesEvaluacion AND @FinMesActual

	IF @Debug=1 
		SELECT 'Financieras Evaluacion' as Info, * 
		FROM @FinancierasEvaluacion fe
		
/********  JCA.27/4/2024.04:04 Info: Carga de TD de los últimos 6 meses  ********/	
DECLARE @TdEvaluacion TABLE(
		IdTransaccionD INT NOT NULL,
		IdOperacion INT NOT NULL,
		IdMetodoPago INT NOT NULL,
		IdTipoSubOperacion INT NOT NULL,
		Monto NUMERIC(11,2) NOT NULL DEFAULT 0
	)

INSERT @TdEvaluacion (IdTransaccionD,IdOperacion,IdMetodoPago,IdTipoSubOperacion,Monto)
SELECT td.IdTransaccionD, td.IdOperacion, td.IdMetodoPago, td.IdTipoSubOperacion, td.Monto 
FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK)
INNER JOIN @EA ea 
	ON ea.IdEstatusActual = td.IdEstatusActual
INNER JOIN (
			SELECT tf.IdOperacion 
			FROM @FinancierasEvaluacion tf
			GROUP BY tf.IdOperacion
			) f ON f.IdOperacion = td.IdOperacion
WHERE td.EsCambio=0

	IF @Debug=1 
		SELECT 'Td Evaluacion' as Info, * FROM @TdEvaluacion

/********  JCA.28/4/2024.23:09 Info: Cuentas en las que se ha transaccionado  ********/
DECLARE @cuentas TABLE(
	IdCuenta INT NOT NULL PRIMARY KEY,
	IdSocio INT NOT NULL,
	IdApertura	INT NULL,
	IdProducto INT NOT NULL,
	IdTipoDproducto INT NOT NULL,
	Producto VARCHAR(128) NOT NULL,
	NoCuenta VARCHAR(32) NOT NULL,
	Monto	NUMERIC(13,2),
	Vencimiento	DATE,
	FechaEntregada DATE,
	FechaBaja DATE DEFAULT '19000101',
	TienePagoAnticipados BIT DEFAULT 0,
	IdEstatus INT,

	INDEX IxIdSocio(IdSocio)	
)

INSERT INTO @cuentas (IdCuenta,IdSocio,IdApertura,IdProducto,IdTipoDproducto,Producto,NoCuenta,Monto,Vencimiento, FechaEntregada,FechaBaja,TienePagoAnticipados,IdEstatus)
SELECT c.IdCuenta, c.IdSocio,c.IdApertura, pf.IdProductoFinanciero, c.IdTipoDProducto, pf.Descripcion , c.Codigo, c.Monto,c.Vencimiento,ce.FechaEntregada, ce.FechaBaja,0,c.IdEstatus
from dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
	ON pf.IdProductoFinanciero = c.IdProductoFinanciero
INNER JOIN dbo.tAYCcuentasEstadisticas ce  WITH(NOLOCK) 
	ON ce.IdCuenta = c.IdCuenta
		AND ce.IdApertura = c.IdApertura
INNER JOIN (
			SELECT tf.IdCuenta 
			FROM @FinancierasEvaluacion tf
			GROUP BY tf.IdCuenta
			) f ON f.IdCuenta = c.IdCuenta

	IF @Debug=1 
		SELECT 'Cuentas' as Info, * FROM @cuentas

/********  JCA.28/4/2024.23:35 Info: Socios que transaccionaron  ********/
DECLARE @sociosDatosGenerales AS TABLE(
	IdSocio				INT PRIMARY KEY,
	IdPersona			INT,
	Fecha				DATE,
	Edad				INT,
	IdPersonaFisica		INT,
	ExentaIVA			BIT,
	IdPersonaMoral		INT,
	EsSocioValido		BIT,
	Genero				CHAR(1),
	IdEstadoNacimiento	INT,
	IdRelDomicilios		INT,
	IdSucursal			INT,
	IdListaDOcupacion	INT,
	IdSocioeconomico	INT,
	NoSocio				VARCHAR(24) DEFAULT '',
	Nombre				VARCHAR(250) DEFAULT '',
	IdPaisNacimiento	INT,
	EsExtranjero		BIT,

	INDEX IX_IdPersona(IdPersona)	
)

INSERT INTO @sociosDatosGenerales
	(
	    IdSocio,
	    IdPersona,
	    Fecha,
	    Edad,
	    IdPersonaFisica,
	    ExentaIVA,
	    IdPersonaMoral,
	    EsSocioValido,
	    Genero,
	    IdEstadoNacimiento,
	    IdRelDomicilios,
	    IdSucursal,
	    IdListaDOcupacion,
	    IdSocioeconomico,
	    NoSocio,
	    Nombre,
	    IdPaisNacimiento,
	    EsExtranjero
	)
	SELECT 
	sc.IdSocio
	,p.IdPersona
	,IIF(pf.IdPersonaFisica IS NOT NULL,pf.FechaNacimiento,pm.FechaConstitucion) AS Fecha
	,IIF(pf.IdPersonaFisica IS NOT NULL, DATEDIFF(YEAR,pf.FechaNacimiento,@FechaTrabajo),IIF(pm.IdPersonaMoral IS NOT NULL,DATEDIFF(YEAR,pm.FechaConstitucion,@FechaTrabajo),0)) AS Edad
	,ISNULL(pf.IdPersonaFisica,0)
	,sc.ExentaIVA
	,ISNULL(pm.IdPersonaMoral,0)
	,sc.EsSocioValido
	,pf.Sexo
	,pf.IdEstadoNacimiento
	,p.IdRelDomicilios
	,sc.IdSucursal,	pf.IdListaDOcupacion, p.IdSocioeconomico
	,sc.Codigo, p.Nombre, pf.IdPaisNacimiento,p.EsExtranjero
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN (
				SELECT c.IdSocio
				FROM @cuentas c
				GROUP BY c.IdSocio
		) cta ON cta.IdSocio = sc.IdSocio
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
	LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
	
	IF @Debug=1 SELECT 'Socios Datos Generales', * FROM @sociosDatosGenerales
	IF @Debug=1 SELECT 'Socios Datos Generales DUPLICADOS', t.IdPersona, COUNT(1) FROM @sociosDatosGenerales t GROUP BY t.IdPersona HAVING COUNT(1)>1


END
GO

