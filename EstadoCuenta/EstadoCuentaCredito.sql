
DECLARE 
@periodo VARCHAR(18)='2022-11',
@idPeriodo INT,
@fechaInicioPeriodo date,
@fechaFinPeriodo DATE

SELECT @idPeriodo=per.IdPeriodo, @fechaInicioPeriodo=per.Inicio, @fechaFinPeriodo=per.Fin FROM dbo.tCTLperiodos per  WITH(NOLOCK) WHERE per.Codigo=@periodo


DECLARE @tCTLtiposD AS TABLE(
IdTipoD			INT,
IdTipoDpadre	INT,
IdTipoE			INT,
Codigo			VARCHAR(24),
Descripcion		VARCHAR(250),
Valor			INT,
RangoInicio		INT,
RangoFin		INT
)

INSERT INTO @tCTLtiposD (IdTipoD,IdTipoDpadre,IdTipoE,Codigo,Descripcion,Valor,RangoInicio,RangoFin)
SELECT IdTipoD,IdTipoDpadre,IdTipoE,Codigo,Descripcion,Valor,RangoInicio,RangoFin FROM dbo.tCTLtiposD td  WITH(NOLOCK)

DECLARE @tEDOCTAcreditos AS TABLE(
	IdCuenta			INT PRIMARY KEY,
	IdSocio				INT,
	IdProducto			INT,
	NoCuenta			VARCHAR(30),
	Producto			VARCHAR(80),
	Finalidad			VARCHAR(250),
	MontoOtorgado		NUMERIC(10,2),
	FechaEntrega		DATE,
	TipoPlazo			VARCHAR(250),
	NoPlazos			INT,
	TipoPrestamo		VARCHAR(250),
	FechaVencimiento	DATE,
	ProximoAbono		DATE,
	InteresOrdinario	NUMERIC(5,3),
	InteresMoratorio	NUMERIC(5,3),
	SaldoCapital		NUMERIC(5,3),
	IdEstatus			INT,
	IdPeriodo			INT,
	Periodo				VARCHAR(12)
)

DECLARE @tEDOCTAdatosSocio AS TABLE(
	IdSocio			INT PRIMARY KEY,
	IdPersona		INT,
	NoSocio			VARCHAR(24),
	Nombre			VARCHAR(128),
	IdRelDomicilios INT,
	IdPeriodo		INT,
	Periodo			VARCHAR(16)
)

DECLARE @tEDOCTAdomicilios AS TABLE(
	IdRel		INT,
	CP			VARCHAR(10),
	Calle		VARCHAR(256),
	Colonia		VARCHAR(64),
	Localidad	VARCHAR(64),
	Municipio	VARCHAR(64),
	Estado		VARCHAR(32),
	IdPeriodo	INT,
	Periodo		VARCHAR(16)
)

DECLARE @tEDOCTAsaldos AS TABLE(
	IdPeriodo						INT,
	Periodo							VARCHAR(16),
	IdCuenta						INT PRIMARY KEY,
	CapitalPagado					NUMERIC(10,2),
	InteresOrdinarioPagado			NUMERIC(10,2),
	InteresMoratorioPagado			NUMERIC(10,2),
	IVAInteresOrdinarioPagado		NUMERIC(10,2),
	IVAInteresMoratorioPagado		NUMERIC(10,2)
)

DECLARE @tEDOCTAsegurosPagados AS TABLE(
	IdPeriodo					INT,
	Periodo						VARCHAR(16),
	IdCuenta					INT,
	SegurosPagados				NUMERIC(10,2),
	IVAsegurosPagados			NUMERIC(10,2),
	CargosPagados				NUMERIC(10,2),
	IVAcargosPagados			NUMERIC(10,2)
)

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE CUENTAS ACTIVAS, CONDONADAS Y CASTIGADAS
INSERT @tEDOCTAcreditos (IdCuenta,IdSocio,IdProducto,NoCuenta,Producto,Finalidad,MontoOtorgado,FechaEntrega,TipoPlazo,NoPlazos,TipoPrestamo,FechaVencimiento,ProximoAbono,InteresOrdinario,InteresMoratorio,SaldoCapital,IdEstatus,IdPeriodo,Periodo)
SELECT c.IdCuenta,c.IdSocio, c.IdProductoFinanciero AS IdProducto, c.Codigo AS NoCuenta, c.Descripcion AS Producto, fin.Descripcion AS Finalidad, c.Monto AS MontoOtorgado
,c.FechaActivacion AS FechaEntrega, tplazo.Descripcion AS TipoPlazo, c.NumeroParcialidades AS NoPlazos, tprod.Descripcion AS TipoPrestado, c.Vencimiento
,IIF(c.PrimerVencimientoPendienteCapital<c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) AS ProximoAbono
,c.InteresOrdinarioAnual, c.InteresMoratorioAnual,c.SaldoCapital, c.IdEstatus, @idPeriodo AS IdPeriodo, @periodo AS Periodo
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCfinalidades fin  WITH(NOLOCK) ON fin.IdFinalidad = c.IdFinalidad
INNER JOIN @tCTLtiposD tplazo ON tplazo.IdTipoD=c.IdTipoDPlazo
INNER JOIN @tCTLtiposD tprod  ON tprod.IdTipoD = c.IdTipoDAICclasificacion
WHERE c.IdTipoDProducto=143 and c.IdEstatus IN (1,53,73)

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE CUENTAS CERRADAS EN EL PERIODO
INSERT @tEDOCTAcreditos (IdCuenta,IdSocio,IdProducto,NoCuenta,Producto,Finalidad,MontoOtorgado,FechaEntrega,TipoPlazo,NoPlazos,TipoPrestamo,FechaVencimiento,ProximoAbono,InteresOrdinario,InteresMoratorio,SaldoCapital,IdEstatus,IdPeriodo,Periodo)
SELECT c.IdCuenta,c.IdSocio, c.IdProductoFinanciero AS IdProducto, c.Codigo AS NoCuenta, c.Descripcion AS Producto, fin.Descripcion AS Finalidad, c.Monto AS MontoOtorgado
,c.FechaActivacion AS FechaEntrega, tplazo.Descripcion AS TipoPlazo, c.NumeroParcialidades AS NoPlazos, tprod.Descripcion AS TipoPrestado, c.Vencimiento
,IIF(c.PrimerVencimientoPendienteCapital<c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) AS ProximoAbono
,c.InteresOrdinarioAnual, c.InteresMoratorioAnual,c.SaldoCapital, c.IdEstatus, @idPeriodo AS IdPeriodo, @periodo AS Periodo
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCfinalidades fin  WITH(NOLOCK) ON fin.IdFinalidad = c.IdFinalidad
INNER JOIN @tCTLtiposD tplazo ON tplazo.IdTipoD=c.IdTipoDPlazo
INNER JOIN @tCTLtiposD tprod  ON tprod.IdTipoD = c.IdTipoDAICclasificacion
INNER JOIN dbo.tAYCcuentasEstadisticas stat  WITH(NOLOCK) ON stat.IdCuenta = c.IdCuenta
			AND stat.FechaBaja BETWEEN @fechaInicioPeriodo AND @fechaFinPeriodo
WHERE c.IdTipoDProducto=143 and c.IdEstatus = 7

INSERT @tEDOCTAdatosSocio(IdSocio,IdPersona,NoSocio,Nombre,IdRelDomicilios,IdPeriodo,Periodo)
SELECT sc.IdSocio, per.IdPersona,sc.Codigo AS NoSocio,per.Nombre,per.IdRelDomicilios,@idPeriodo,@periodo
FROM tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
INNER JOIN (
			SELECT idsocio FROM @tEDOCTAcreditos c GROUP BY c.IdSocio
)c ON c.IdSocio = sc.IdSocio

INSERT @tEDOCTAdomicilios(IdRel,CP,Calle,Colonia,Localidad,Municipio,Estado,IdPeriodo,Periodo)
SELECT IdRel,dom.CodigoPostal,Calle,dom.Asentamiento,dom.Ciudad,Municipio,Estado,@idPeriodo,@periodo
FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
INNER JOIN @tEDOCTAdatosSocio sc  ON sc.IdRelDomicilios=dom.IdRel
WHERE dom.IdTipoD = 11


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--  MONTOS PAGADOS
INSERT INTO @tEDOCTAsaldos(IdPeriodo,Periodo,IdCuenta,CapitalPagado,InteresOrdinarioPagado,InteresMoratorioPagado,IVAInteresOrdinarioPagado,IVAInteresMoratorioPagado)
SELECT @idPeriodo,@periodo, sdo.IdCuenta,sdo.CapitalPagado,sdo.InteresOrdinarioPagado,sdo.InteresMoratorioPagado,sdo.IVAInteresOrdinarioPagado,sdo.IVAInteresMoratorioPagado
FROM dbo.tSDOsaldos sdo  WITH(NOLOCK) 
INNER JOIN @tEDOCTAcreditos c ON c.IdCuenta = sdo.IdCuenta --AND c.NoCuenta='40400418766'

INSERT @tEDOCTAsegurosPagados(IdPeriodo,Periodo,IdCuenta,SegurosPagados,IVAsegurosPagados,CargosPagados,IVAcargosPagados)
SELECT  @idPeriodo, @periodo,
		c.IdCuenta,
		SegurosPagados    = ISNULL(SUM(IIF(ISNULL(tf.NumeroCargo, 0) <> 0, ISNULL(tf.CargosPagados,0),0)),0), 
        IVAsegurosPagados = ISNULL(SUM(IIF(ISNULL(tf.NumeroCargo, 0) <> 0, ISNULL(tf.IVACargosPagado,0),0)),0),
        CargosPagados     = ISNULL(SUM(IIF(ISNULL(tf.NumeroCargo, 0) = 0, ISNULL(tf.CargosPagados,0),0)),0), 
        IVAcargosPagados  = ISNULL(SUM(IIF(ISNULL(tf.NumeroCargo, 0) = 0, ISNULL(tf.IVACargosPagado,0),0)),0)
FROM dbo.tSDOtransaccionesFinancieras tf WITH(NOLOCK)
INNER JOIN dbo.tAYCcuentas c ON c.IdCuenta = tf.IdCuenta --AND c.NoCuenta='40400418766'
WHERE tf.IdEstatus=1 AND tf.IdOperacion <> 0
      AND ISNULL(tf.IdBienServicio, 0) <> 0
      AND ISNULL(tf.NumeroCargo, 0) <> 0
      AND tf.Fecha < @fechaFinPeriodo
GROUP BY c.IdCuenta






