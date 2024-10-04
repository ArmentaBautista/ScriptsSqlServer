--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
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
	InteresOrdinario	NUMERIC(6,4),
	InteresMoratorio	NUMERIC(6,4),
	SaldoCapital		NUMERIC(10,2),
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
SELECT @idPeriodo, @periodo, sdo.IdCuenta,sdo.CapitalPagado,sdo.InteresOrdinarioPagado,sdo.InteresMoratorioPagado,sdo.IVAInteresOrdinarioPagado,sdo.IVAInteresMoratorioPagado
FROM dbo.tSDOsaldos sdo  WITH(NOLOCK) 
INNER JOIN @tEDOCTAcreditos c ON c.IdCuenta = sdo.IdCuenta 

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

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--  Movimientos

DECLARE @tEDOCTAtiposMovimiento AS TABLE
(
    IdTipoMovimiento VARCHAR(100)
    ,TipoMovimiento VARCHAR(200)
    ,IdTipoDproducto INT
    ,Orden INT
);

INSERT INTO
    @tEDOCTAtiposMovimiento (IdTipoMovimiento, TipoMovimiento, IdTipoDproducto, Orden)
SELECT
    tiposMovimiento.IdTipoMovimiento
    ,tiposMovimiento.TipoMovimiento
    ,tiposMovimiento.IdTipoConcepto
    ,tiposMovimiento.Orden
FROM
    (
        VALUES
            /*Generados Credito*/
            ('CAPITALGENERADOCREDITO', 'Crédito', 143, 1)
            ,('IOCARGOCREDITO', 'Interés Ordinario', 143, 2)
            ,('IMCARGOCREDITO', 'Interés Moratorio', 143, 3)
            ,('CARGOSCARGOCREDITO', 'Cargos', 143, 4)
            ,('IVAIOCARGOCREDITO', 'IVA Int. Ordinario', 143, 5)
            ,('IVAIMCARGOCREDITO', 'IVA Int. Moratorio', 143, 6)
            ,('IVACARGOSCARGOCREDITO', 'IVA Cargos', 143, 7)
            /*Pagados credito*/
            ,('CAPITALPAGADOCREDITO', 'Abono a Capital', 143, 8)
            ,('IOABONOCREDITO', 'Pago de Interés Ordinario', 143, 9)
            ,('IMABONOCREDITO', 'Pago de Interés Moratorio', 143, 10)
            ,('CARGOSABONOCREDITO', 'Pago Cargos', 143, 11)
            ,('IVAIOABONOCREDITO', 'Pago IVA Int. Ordinario', 143, 12)
            ,('IVAIMABONOCREDITO', 'Pago IVA Int. Moratorio', 143, 13)
            ,('IVACARGOSABONOCREDITO', 'Pago IVA Cargos', 143, 14)
            /*Condonados credito*/
            ,('CAPITALCONDONADOCREDITO', 'Condonación', 143, 15)
            ,('IOCONDONADOCREDITO', 'Interés Ordinario condonado', 143, 16)
            ,('IMCONDONADOCREDITO', 'Interés Moratorio condonado', 143, 17)
            ,('IVAIOCONDONADOCREDITO', 'IVA Condonado Int. Ord.', 143, 18)
            ,('IVAIMCONDONADOCREDITO', 'IVA Condonado Int. Mor.', 143, 19)
            /*Castigado credito*/
            ,('CAPITALCASTIGADOCREDITO', 'Capital Castigado', 143, 15)
            ,('IOCASTIGADOCREDITO', 'Interés Ordinario Castigado', 143, 20)
            ,('IMCASTIGADOCREDITO', 'Interés Moratorio Castigado', 143, 21)
            ,('IVAIOABONOCREDITO', 'IVA Castigado', 143, 22)
    ) AS tiposMovimiento (IdTipoMovimiento, TipoMovimiento, IdTipoConcepto, Orden);



DECLARE @tEDOCTAmovimientos AS TABLE
(
    IdCuenta INT
    ,IdTransaccion INT
    ,IdPeriodo INT
    ,Fecha DATE
    ,Folio VARCHAR(100)
    ,Concepto VARCHAR(1024)
    ,Cargo NUMERIC(10, 2)
    ,Abono NUMERIC(10, 2)
    ,Saldo NUMERIC(10, 2)
    ,Orden INT
);

INSERT INTO
    @tEDOCTAmovimientos (IdCuenta, IdTransaccion, IdPeriodo, Fecha, Folio, Concepto, Cargo, Abono, Saldo, Orden)
SELECT
    dcuentas.IdCuenta
    ,tFinanciera.IdTransaccion
    ,IdPeriodo = @idPeriodo
    ,tFinanciera.Fecha
    ,Folio = CONCAT(tipoOperacion.Codigo, '-', OperacionPadre.Folio)
    ,Concepto = tipoMovimiento.TipoMovimiento
    ,Cargo = CASE
                 ----------cargos-------------------
                 /*capital cargo*/

                 WHEN tipoMovimiento.IdTipoMovimiento = 'CAPITALGENERADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CapitalGenerado, 0))
                          + ABS(ISNULL(tFinanciera.CapitalGeneradoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.CapitalGenerado, 0) + ISNULL(tFinanciera.CapitalGeneradoVencido, 0)

                 /*interes ordinario cargo*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IOCARGOCREDITO'
                      AND ABS(ISNULL(tFinanciera.InteresOrdinarioDevengado, 0))
                          + ABS(ISNULL(tFinanciera.InteresOrdinarioDevengadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.InteresOrdinarioDevengado, 0)
                     + ISNULL(tFinanciera.InteresOrdinarioDevengadoVencido, 0)
                 /*interes Moratorio cargo*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IMCARGOCREDITO'
                      AND ABS(ISNULL(tFinanciera.InteresMoratorioDevengado, 0))
                          + ABS(ISNULL(tFinanciera.InteresMoratorioDevengadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.InteresMoratorioDevengado, 0)
                     + ISNULL(tFinanciera.InteresMoratorioDevengadoVencido, 0)
                 /*Cargos cargo*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'CARGOSCARGOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CargosGenerados, 0)) > 0 THEN
                     ISNULL(tFinanciera.CargosGenerados, 0)
                 /*IVA io cargo*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVAIMCARGOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVAInteresOrdinarioDevengado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVAInteresOrdinarioDevengado, 0)
                 /*IVA im cargo*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVAIMCARGOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVAInteresMoratorioDevengado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVAInteresMoratorioDevengado, 0)
                 /*IVA cargo cargo*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVACARGOSCARGOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVACargosGenerados, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVACargosGenerados, 0)
                 ELSE
                     0
             END
    ,Abono = CASE ----------abonos-------------------
                 /*capital Abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'CAPITALPAGADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CapitalPagado, 0)) + ABS(ISNULL(tFinanciera.CapitalPagadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.CapitalPagado, 0) + ISNULL(tFinanciera.CapitalPagadoVencido, 0)
                 /*interes ordinario Abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IOABONOCREDITO'
                      AND ABS(ISNULL(tFinanciera.InteresOrdinarioPagado, 0))
                          + ABS(ISNULL(tFinanciera.InteresOrdinarioPagadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.InteresOrdinarioPagado, 0)
                     + ISNULL(tFinanciera.InteresOrdinarioPagadoVencido, 0)
                 /*interes Moratorio Abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IMABONOCREDITO'
                      AND ABS(ISNULL(tFinanciera.InteresMoratorioPagado, 0))
                          + ABS(ISNULL(tFinanciera.InteresMoratorioPagadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.InteresMoratorioPagado, 0)
                     + ISNULL(tFinanciera.InteresMoratorioPagadoVencido, 0)
                 /*Cargos abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'CARGOSABONOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CargosPagados, 0)) > 0 THEN
                     ISNULL(tFinanciera.CargosPagados, 0)
                 /*IVA io abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVAIOABONOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVAInteresOrdinarioPagado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVAInteresOrdinarioPagado, 0)
                 /*IVA im abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVAIMABONOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVAInteresMoratorioPagado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVAInteresMoratorioPagado, 0)
                 /*IVA cargos abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVACARGOSABONOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVACargosPagado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVACargosPagado, 0)
                 /*Condonados*/
                 /*Condonacion*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'CAPITALCONDONADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CapitalCondonado, 0))
                          + ABS(ISNULL(tFinanciera.CapitalCondonadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.CapitalCondonado, 0) + ISNULL(tFinanciera.CapitalCondonadoVencido, 0)
                 /*io condonado abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IOCONDONADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.InteresMoratorioCondonado, 0))
                          + ABS(ISNULL(tFinanciera.InteresMoratorioCondonadoVencido, 0))
                          + ABS(ISNULL(
                                          IIF(
                                              tFinanciera.IdTipoSubOperacion = 6
                                              AND tFinanciera.IdEstatusDominio = 1
                                              ,tFinanciera.InteresMoratorioDeCuentasOrden
                                              ,0)
                                          ,0
                                      )
                               ) > 0 THEN
                     ISNULL(tFinanciera.InteresMoratorioCondonado, 0)
                     + ISNULL(tFinanciera.InteresMoratorioCondonadoVencido, 0)
                     + ISNULL(
                                 IIF(
                                     tFinanciera.IdTipoSubOperacion = 6
                                     AND tFinanciera.IdEstatusDominio = 1
                                     ,tFinanciera.InteresMoratorioDeCuentasOrden
                                     ,0)
                                 ,0
                             )
                 /*im condonado abono*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IOCONDONADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.InteresMoratorioCondonado, 0))
                          + ABS(ISNULL(tFinanciera.InteresMoratorioCondonadoVencido, 0))
                          + ABS(ISNULL(
                                          IIF(
                                              tFinanciera.IdTipoSubOperacion = 6
                                              AND tFinanciera.IdEstatusDominio = 1
                                              ,tFinanciera.InteresMoratorioDeCuentasOrden
                                              ,0)
                                          ,0
                                      )
                               ) > 0 THEN
                     ISNULL(tFinanciera.InteresMoratorioCondonado, 0)
                     + ISNULL(tFinanciera.InteresMoratorioCondonadoVencido, 0)
                     + ISNULL(
                                 IIF(
                                     tFinanciera.IdTipoSubOperacion = 6
                                     AND tFinanciera.IdEstatusDominio = 1
                                     ,tFinanciera.InteresMoratorioDeCuentasOrden
                                     ,0)
                                 ,0
                             )
                 /*iva io condonado*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVAIOCONDONADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVAInteresOrdinarioCondonado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVAInteresOrdinarioCondonado, 0)
                 /*iva im condonado*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IVAIMCONDONADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.IVAInteresMoratorioCondonado, 0)) > 0 THEN
                     ISNULL(tFinanciera.IVAInteresMoratorioCondonado, 0)
                 /*castigados abono*/
                 /*capital castigado*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'CAPITALCASTIGADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CapitalCastigado, 0))
                          + ABS(ISNULL(tFinanciera.CapitalCastigadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.CapitalCastigado, 0) + ISNULL(tFinanciera.CapitalCastigadoVencido, 0)
                 /*io castigado*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'CAPITALCASTIGADOCREDITO'
                      AND ABS(ISNULL(tFinanciera.CapitalCastigado, 0))
                          + ABS(ISNULL(tFinanciera.CapitalCastigadoVencido, 0)) > 0 THEN
                     ISNULL(tFinanciera.CapitalCastigado, 0) + ISNULL(tFinanciera.CapitalCastigadoVencido, 0)
                 /*im castigado*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IOCASTIGADOCREDITO'
                      AND tFinanciera.IdTipoSubOperacion = 14
                      AND ABS(ISNULL(tFinanciera.InteresOrdinarioDeCuentasOrden, 0)) > 0 THEN
                     ABS(ISNULL(tFinanciera.InteresOrdinarioDeCuentasOrden, 0))
                 /*iva castigado*/
                 WHEN tipoMovimiento.IdTipoMovimiento = 'IMCASTIGADOCREDITO'
                      AND tFinanciera.IdTipoSubOperacion = 14
                      AND ABS(ISNULL(tFinanciera.InteresMoratorioDeCuentasOrden, 0)) > 0 THEN
                     ABS(ISNULL(tFinanciera.InteresMoratorioDeCuentasOrden, 0))
                 ELSE
                     0
             END
    ,Saldo = tFinanciera.SaldoCapital
    ,Orden = tipoMovimiento.Orden
FROM
    @tEDOCTAcreditos dcuentas
    INNER JOIN dbo.tCTLperiodos periodo WITH (NOLOCK)
               ON periodo.IdPeriodo = @idPeriodo
    INNER JOIN dbo.tSDOtransaccionesFinancieras tFinanciera WITH (NOLOCK)
               ON tFinanciera.IdCuenta = dcuentas.IdCuenta
                  AND tFinanciera.Fecha
                  BETWEEN periodo.Inicio AND periodo.Fin
    INNER JOIN dbo.tGRLoperaciones operacion WITH (NOLOCK)
               ON operacion.IdOperacion = tFinanciera.IdOperacion
    INNER JOIN dbo.tGRLoperaciones OperacionPadre WITH (NOLOCK)
               ON OperacionPadre.IdOperacion = operacion.IdOperacionPadre
    INNER JOIN dbo.tCTLtiposOperacion tipoOperacion WITH (NOLOCK)
               ON tipoOperacion.IdTipoOperacion = OperacionPadre.IdTipoOperacion
    INNER JOIN @tEDOCTAtiposMovimiento tipoMovimiento
               ON (
                      ----------cargos-------------------
                      /*capital cargo*/
                      (
                          tipoMovimiento.IdTipoMovimiento = 'CAPITALGENERADOCREDITO'
                          AND ABS(ISNULL(tFinanciera.CapitalGenerado, 0))
                              + ABS(ISNULL(tFinanciera.CapitalGeneradoVencido, 0)) > 0
                      )
                      /*interes ordinario cargo*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IOCARGOCREDITO'
                              AND ABS(ISNULL(tFinanciera.InteresOrdinarioDevengado, 0))
                                  + ABS(ISNULL(tFinanciera.InteresOrdinarioDevengadoVencido, 0)) > 0
                          )
                      /*interes Moratorio cargo*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IMCARGOCREDITO'
                              AND ABS(ISNULL(tFinanciera.InteresMoratorioDevengado, 0))
                                  + ABS(ISNULL(tFinanciera.InteresMoratorioDevengadoVencido, 0)) > 0
                          )
                      /*Cargos cargo*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'CARGOSCARGOCREDITO'
                              AND ABS(ISNULL(tFinanciera.CargosGenerados, 0)) > 0
                          )
                      /*IVA io cargo*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIMCARGOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAInteresOrdinarioDevengado, 0)) > 0
                          )
                      /*IVA im cargo*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIMCARGOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAInteresMoratorioDevengado, 0)) > 0
                          )
                      /*IVA cargo cargo*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVACARGOSCARGOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVACargosGenerados, 0)) > 0
                          )

                      ----------abonos-------------------
                      /*capital Abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'CAPITALPAGADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.CapitalPagado, 0))
                                  + ABS(ISNULL(tFinanciera.CapitalPagadoVencido, 0)) > 0
                          )
                      /*interes ordinario Abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IOABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.InteresOrdinarioPagado, 0))
                                  + ABS(ISNULL(tFinanciera.InteresOrdinarioPagadoVencido, 0)) > 0
                          )
                      /*interes Moratorio Abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IMABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.InteresMoratorioPagado, 0))
                                  + ABS(ISNULL(tFinanciera.InteresMoratorioPagadoVencido, 0)) > 0
                          )
                      /*Cargos abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'CARGOSABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.CargosPagados, 0)) > 0
                          )
                      /*IVA io abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIOABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAInteresOrdinarioPagado, 0)) > 0
                          )
                      /*IVA im abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIMABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAInteresMoratorioPagado, 0)) > 0
                          )
                      /*IVA cargos abono*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVACARGOSABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVACargosPagado, 0)) > 0
                          )
                      /*
					campos condonados
					*/
                      /*Capital condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'CAPITALCONDONADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.CapitalCondonado, 0))
                                  + ABS(ISNULL(tFinanciera.CapitalCondonadoVencido, 0)) > 0
                          )
                      /*IO condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IOCONDONADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.InteresOrdinarioCondonado, 0))
                                  + ABS(ISNULL(tFinanciera.InteresOrdinarioCondonadoVencido, 0))
                                  + ABS(ISNULL(
                                                  IIF(
                                                      tFinanciera.IdTipoSubOperacion = 6
                                                      AND tFinanciera.IdEstatusDominio = 1
                                                      ,tFinanciera.InteresOrdinarioDeCuentasOrden
                                                      ,0)
                                                  ,0
                                              )
                                       ) > 0
                          )
                      /*IM condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IOCONDONADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.InteresMoratorioCondonado, 0))
                                  + ABS(ISNULL(tFinanciera.InteresMoratorioCondonadoVencido, 0))
                                  + ABS(ISNULL(
                                                  IIF(
                                                      tFinanciera.IdTipoSubOperacion = 6
                                                      AND tFinanciera.IdEstatusDominio = 1
                                                      ,tFinanciera.InteresMoratorioDeCuentasOrden
                                                      ,0)
                                                  ,0
                                              )
                                       ) > 0
                          )
                      /*IVA IO condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIOCONDONADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAInteresOrdinarioCondonado, 0)) > 0
                          )
                      /*IVA IM condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIMCONDONADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAInteresMoratorioCondonado, 0)) > 0
                          )
                      /*
						  Campos castigados
						  */
                      /*Capital castigado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'CAPITALCASTIGADOCREDITO'
                              AND ABS(ISNULL(tFinanciera.CapitalCastigado, 0))
                                  + ABS(ISNULL(tFinanciera.CapitalCastigadoVencido, 0)) > 0
                          )
                      /*IO condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IOCASTIGADOCREDITO'
                              AND tFinanciera.IdTipoSubOperacion = 14
                              AND ABS(ISNULL(tFinanciera.InteresOrdinarioDeCuentasOrden, 0)) > 0
                          )
                      /*IM condonado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IMCASTIGADOCREDITO'
                              AND tFinanciera.IdTipoSubOperacion = 14
                              AND ABS(ISNULL(tFinanciera.InteresMoratorioDeCuentasOrden, 0)) > 0
                          )
                      /*IVA castigado*/
                      OR
                          (
                              tipoMovimiento.IdTipoMovimiento = 'IVAIOABONOCREDITO'
                              AND ABS(ISNULL(tFinanciera.IVAcastigado, 0)) > 0
                          )
                  );

SELECT * FROM @tEDOCTAcreditos
SELECT * FROM @tEDOCTAdatosSocio
SELECT * FROM @tEDOCTAdomicilios
SELECT * FROM @tEDOCTAsaldos
SELECT * FROM @tEDOCTAsegurosPagados
SELECT * FROM @tEDOCTAmovimientos
