USE iERP_KFT
GO	

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE 
@periodo VARCHAR(18)='2023-08',
@idPeriodo INT,
@fechaInicioPeriodo DATE,
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
	Periodo				VARCHAR(12),
	CAT                 NUMERIC(23, 8)
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
	IdDomicilio	INT,
	IdPeriodo	INT,
	IdRel		INT,
	CP			VARCHAR(10),
	Calle		VARCHAR(256),
	Colonia		VARCHAR(64),
	Localidad	VARCHAR(64),
	Municipio	VARCHAR(64),
	Estado		VARCHAR(32),
	Periodo		VARCHAR(16),
	NumeroExterior VARCHAR(24),
	NumeroInterior VARCHAR(24)
)



/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE CUENTAS ACTIVAS, CONDONADAS Y CASTIGADAS
INSERT @tEDOCTAcreditos (IdCuenta,IdSocio,IdProducto,NoCuenta,Producto,Finalidad,MontoOtorgado,FechaEntrega,TipoPlazo,NoPlazos,TipoPrestamo,FechaVencimiento,ProximoAbono,InteresOrdinario,InteresMoratorio,SaldoCapital,IdEstatus,IdPeriodo,Periodo, CAT)
SELECT c.IdCuenta,c.IdSocio, c.IdProductoFinanciero AS IdProducto, c.Codigo AS NoCuenta, c.Descripcion AS Producto, fin.Descripcion AS Finalidad, c.Monto AS MontoOtorgado
,c.FechaActivacion AS FechaEntrega, tplazo.Descripcion AS TipoPlazo, c.NumeroParcialidades AS NoPlazos, tprod.Descripcion AS TipoPrestado, c.Vencimiento
,IIF(c.PrimerVencimientoPendienteCapital<c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) AS ProximoAbono
,c.InteresOrdinarioAnual, c.InteresMoratorioAnual,c.SaldoCapital, c.IdEstatus, @idPeriodo AS IdPeriodo, @periodo AS Periodo, c.CAT
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCfinalidades fin  WITH(NOLOCK) ON fin.IdFinalidad = c.IdFinalidad
INNER JOIN @tCTLtiposD tplazo ON tplazo.IdTipoD=c.IdTipoDPlazo
INNER JOIN @tCTLtiposD tprod  ON tprod.IdTipoD = c.IdTipoDAICclasificacion
INNER JOIN (
			SELECT cs.IdCuenta
			FROM iERP_KFT_REG.dbo.tBURcuentasSaldo cs  WITH(NOLOCK) 
			INNER JOIN iERP_KFT_REG.dbo.tBURfechas f  WITH(NOLOCK) 
				ON f.IdFecha = cs.IdFecha
					AND f.Fecha BETWEEN @fechaInicioPeriodo AND @fechaFinPeriodo
						AND cs.IdEstatus<>7
) bur ON bur.IdCuenta = c.IdCuenta
WHERE c.IdTipoDProducto=143 

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE CUENTAS CERRADAS EN EL PERIODO
INSERT @tEDOCTAcreditos (IdCuenta,IdSocio,IdProducto,NoCuenta,Producto,Finalidad,MontoOtorgado,FechaEntrega,TipoPlazo,NoPlazos,TipoPrestamo,FechaVencimiento,ProximoAbono,InteresOrdinario,InteresMoratorio,SaldoCapital,IdEstatus,IdPeriodo,Periodo)
SELECT c.IdCuenta,c.IdSocio, c.IdProductoFinanciero AS IdProducto, c.Codigo AS NoCuenta, c.Descripcion AS Producto, fin.Descripcion AS Finalidad, c.Monto AS MontoOtorgado
,c.FechaActivacion AS FechaEntrega, tplazo.Descripcion AS TipoPlazo, c.NumeroParcialidades AS NoPlazos, tprod.Descripcion AS TipoPrestado, c.Vencimiento
,IIF(c.PrimerVencimientoPendienteCapital<c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteCapital,c.PrimerVencimientoPendienteInteres) AS ProximoAbono
,c.InteresOrdinarioAnual, c.InteresMoratorioAnual,c.SaldoCapital, c.IdEstatus, @idPeriodo AS IdPeriodo, @periodo AS Periodo
--,stat.FechaBaja
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCfinalidades fin  WITH(NOLOCK) 
	ON fin.IdFinalidad = c.IdFinalidad
INNER JOIN @tCTLtiposD tplazo 
	ON tplazo.IdTipoD=c.IdTipoDPlazo
INNER JOIN @tCTLtiposD tprod  
	ON tprod.IdTipoD = c.IdTipoDAICclasificacion
INNER JOIN dbo.tAYCcuentasEstadisticas stat  WITH(NOLOCK) 
	ON stat.IdCuenta = c.IdCuenta
INNER JOIN (
			SELECT cs.IdCuenta
			FROM iERP_KFT_REG.dbo.tBURcuentasSaldo cs  WITH(NOLOCK) 
			INNER JOIN iERP_KFT_REG.dbo.tBURfechas f  WITH(NOLOCK) 
				ON f.IdFecha = cs.IdFecha
					AND f.Fecha BETWEEN @fechaInicioPeriodo AND @fechaFinPeriodo
			WHERE cs.IdEstatus=7
) bur ON bur.IdCuenta = c.IdCuenta


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE DATOS DE SOCIO
INSERT @tEDOCTAdatosSocio(IdSocio,IdPersona,NoSocio,Nombre,IdRelDomicilios,IdPeriodo,Periodo)
SELECT sc.IdSocio, per.IdPersona,sc.Codigo AS NoSocio,per.Nombre,per.IdRelDomicilios,@idPeriodo,@periodo
FROM tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
INNER JOIN dbo.tHSTsocios hsc  WITH(NOLOCK) 
	ON hsc.IdSocio = sc.IdSocio
		AND hsc.IdPeriodo=@idPeriodo


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- INSERT DE DOMICILIOS
INSERT @tEDOCTAdomicilios(IdDomicilio,IdPeriodo,IdRel,CP,Calle,Colonia,Localidad,Municipio,Estado,Periodo, NumeroExterior, NumeroInterior)
SELECT IdDomicilio,@idPeriodo,IdRel,dom.CodigoPostal,Calle,dom.Asentamiento,dom.Ciudad,Municipio,Estado,@periodo, dom.NumeroExterior, dom.NumeroInterior
FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
INNER JOIN @tEDOCTAdatosSocio sc  ON sc.IdRelDomicilios=dom.IdRel
WHERE dom.IdRel<>0 AND dom.IdTipoD = 11

/* INFO (⊙_☉) JCA.14/09/2023.11:58 p. m. 
Nota: Inserción a tablas Físicas de la base de Estados de Cuenta
*/

/* ฅ^•ﻌ•^ฅ   JCA.14/09/2023.11:58 p. m. Nota: Borrado de datos del periodo   */
DELETE FROM iERP_KFT_EC.dbo.tEDOCTAcreditos WHERE IdPeriodo=@idPeriodo
DELETE FROM iERP_KFT_EC.dbo.tEDOCTAdatosSocio WHERE IdPeriodo=@idPeriodo
DELETE FROM iERP_KFT_EC.dbo.tEDOCTAdomicilios WHERE IdPeriodo=@idPeriodo

/*  (◕ᴥ◕)    JCA.15/09/2023.12:01 a. m. Nota: Volcado  */
INSERT INTO iERP_KFT_EC.dbo.tEDOCTAcreditos
SELECT * FROM @tEDOCTAcreditos

INSERT INTO iERP_KFT_EC.dbo.tEDOCTAdatosSocio
SELECT * FROM @tEDOCTAdatosSocio

INSERT INTO iERP_KFT_EC.dbo.tEDOCTAdomicilios
SELECT * FROM @tEDOCTAdomicilios

SELECT COUNT(1) FROM iERP_KFT_EC.dbo.tEDOCTAcreditos WHERE IdPeriodo=@idPeriodo
SELECT COUNT(1) FROM iERP_KFT_EC.dbo.tEDOCTAdatosSocio WHERE IdPeriodo=@idPeriodo
SELECT COUNT(1) FROM iERP_KFT_EC.dbo.tEDOCTAdomicilios WHERE IdPeriodo=@idPeriodo


GOTO HELL
HELL:


