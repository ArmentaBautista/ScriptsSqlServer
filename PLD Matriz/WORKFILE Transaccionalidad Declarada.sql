
DECLARE @fechaTrabajo AS DATE = '20220131' -- CURRENT_TIMESTAMP;
DECLARE @fechaInicioMes AS DATE = DATEADD(dd,-(DAY(@fechaTrabajo)-1),@fechaTrabajo)
DECLARE @IdPeriodo AS INT
SELECT @IdPeriodo=IdPeriodo FROM dbo.tCTLperiodos p WHERE p.EsAjuste=0 AND  @fechaTrabajo BETWEEN p.Inicio AND p.Fin
PRINT @IdPeriodo

DECLARE @idSocio AS INT = 16888;
DECLARE @idPersona AS INT = 0 
SET @idPersona = (SELECT sc.idpersona FROM tscssocios sc  WITH(NOLOCK) WHERE sc.idsocio=@idSocio)

DECLARE @sociosGeneral AS TABLE(
	IdSocio				INT,
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
	BloqueadoPldSistema BIT,
	IdSocioeconomico	INT
)

DECLARE @socios AS TABLE(
	IdSocio				INT,
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
	EsMenor				BIT DEFAULT 0,
	EsMayor				BIT DEFAULT 0,
	EsMoral				BIT DEFAULT 0,
	TipoSocio			SMALLINT CHECK (TipoSocio IN (1,2,3,4)),
	BloqueadoPldSistema bit,
	IdSocioeconomico	INT
)

DECLARE @calificaciones AS TABLE(
	IdPersona INT NOT NULL,
	IdSocio INT NOT NULL,
	IdFactor INT NOT NULL,
	Factor VARCHAR(64) NOT NULL,
	Elemento VARCHAR(128) NOT NULL,
	Valor VARCHAR(10) NOT NULL,
	ValorDescripcion VARCHAR(256) NULL,
	Puntos INT DEFAULT 0
)

/* LLENADO DE SOCIOS */
INSERT INTO @sociosGeneral
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
	BloqueadoPldSistema,
	IdSocioeconomico
)
SELECT sc.IdSocio,	p.IdPersona, IIF(pf.IdPersonaFisica IS NOT NULL,pf.FechaNacimiento,pm.FechaConstitucion) AS Fecha,
IIF(pf.IdPersonaFisica IS NOT NULL, DATEDIFF(YEAR,pf.FechaNacimiento,@fechaTrabajo),IIF(pm.IdPersonaMoral IS NOT NULL,DATEDIFF(YEAR,pm.FechaConstitucion,@fechaTrabajo),0)) AS Edad,
pf.IdPersonaFisica,	sc.ExentaIVA,	pm.IdPersonaMoral,	sc.EsSocioValido,	pf.Sexo,	pf.IdEstadoNacimiento,	p.IdRelDomicilios,	sc.IdSucursal,	pf.IdListaDOcupacion, sc.BloqueadoSistema, p.IdSocioeconomico
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
LEFT JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
LEFT JOIN dbo.tGRLpersonasMorales pm  WITH(NOLOCK) ON pm.IdPersona = p.IdPersona
WHERE sc.IdEstatus=1 AND ((@idSocio=0) OR (sc.IdSocio= @idSocio))

INSERT INTO @socios
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
    EsMenor,
    EsMayor,
    EsMoral,
	TipoSocio,
	BloqueadoPldSistema,
	IdSocioeconomico
)
SELECT  sg.IdSocio,sg.IdPersona,sg.Fecha,sg.Edad,sg.IdPersonaFisica,sg.ExentaIVA,sg.IdPersonaMoral,sg.EsSocioValido,sg.Genero,sg.IdEstadoNacimiento,sg.IdRelDomicilios,sg.IdSucursal,sg.IdListaDOcupacion
,IIF(sg.Edad<18,1,0), IIF(sg.Edad>17,1,0),IIF(sg.IdPersonaMoral IS NULL,0,1),
CASE
	WHEN sg.Edad<18 THEN 1
	WHEN sg.Edad>17 THEN 2
	WHEN sg.IdPersonaMoral IS NULL THEN 3
	WHEN NOT sg.IdPersonaFisica IS NULL AND sg.ExentaIVA=1 THEN 4
END,
sg.BloqueadoPldSistema, sg.IdSocioeconomico
FROM @sociosGeneral sg

DECLARE @transaccionalidadDeclarada TABLE(
		IdPersona				INT PRIMARY KEY,
		MontoDepIdTipoE			INT,
		MontoDepIdListaD		INT,
		MontoDepDescripcion		VARCHAR(64),
		MontoDepValor			NUMERIC(18,2),
		MontoRetIdTipoE			INT,
		MontoRetIdListaD		INT,
		MontoRetDescripcion		VARCHAR(64),
		MontoRetValor			NUMERIC(18,2),
		NumDepIdTipoE			INT,
		NumDepIdListaD			INT,
		NumDepDescripcion		VARCHAR(64),
		NumDepValor				NUMERIC(18,2),
		NumRetIdTipoE			INT,
		NumRetIdListaD			INT,
		NumRetDescripcion		VARCHAR(64),
		NumRetValor				NUMERIC(18,2)
)


INSERT INTO	@transaccionalidadDeclarada
(
    IdPersona,
    MontoDepIdTipoE,
    MontoDepIdListaD,
    MontoDepDescripcion,
    MontoDepValor,
    MontoRetIdTipoE,
    MontoRetIdListaD,
    MontoRetDescripcion,
    MontoRetValor,
    NumDepIdTipoE,
    NumDepIdListaD,
    NumDepDescripcion,
    NumDepValor,
    NumRetIdTipoE,
    NumRetIdListaD,
    NumRetDescripcion,
    NumRetValor
)
SELECT p.IdPersona
,montoD.IdTipoE,montoD.IdListaD,montoD.Descripcion,montoD.Valor
,montoR.IdTipoE,montoR.IdListaD,montoR.Descripcion,montoR.Valor
,numD.IdTipoE,numD.IdListaD,numD.Descripcion,numD.Valor
,numR.IdTipoE,numR.IdListaD,numR.Descripcion,numR.Valor
FROM dbo.tGRLpersonas p WITH (NOLOCK)
    INNER JOIN dbo.tSCSpersonasSocioeconomicos se WITH (NOLOCK) ON se.IdSocioeconomico = p.IdSocioeconomico
    INNER JOIN dbo.tCTLestatusActual ea WITH (NOLOCK) ON ea.IdEstatusActual = se.IdEstatusActual AND ea.IdEstatus = 1
    INNER JOIN dbo.tCATlistasD montoD WITH (NOLOCK) ON montoD.IdListaD = se.IdListaDmontoDepositos
    INNER JOIN dbo.tCTLestatusActual emontoD WITH (NOLOCK) ON emontoD.IdEstatusActual = montoD.IdEstatusActual AND emontoD.IdEstatus = 1
    INNER JOIN dbo.tCATlistasD montoR WITH (NOLOCK) ON montoR.IdListaD = se.IdListaDmontoRetiros
    INNER JOIN dbo.tCTLestatusActual emontoR WITH (NOLOCK) ON emontoR.IdEstatusActual = montoR.IdEstatusActual AND emontoR.IdEstatus = 1
    INNER JOIN dbo.tCATlistasD numD WITH (NOLOCK) ON numD.IdListaD = se.IdListaDnumeroDepositos
    INNER JOIN dbo.tCTLestatusActual enumD WITH (NOLOCK) ON enumD.IdEstatusActual = numD.IdEstatusActual AND enumD.IdEstatus = 1
    INNER JOIN dbo.tCATlistasD numR WITH (NOLOCK) ON numR.IdListaD = se.IdListaDnumeroRetiros
    INNER JOIN dbo.tCTLestatusActual enumR WITH (NOLOCK) ON enumR.IdEstatusActual = numR.IdEstatusActual AND enumR.IdEstatus = 1
WHERE ((@idPersona = 0) OR (p.IdPersona = @idPersona));


SELECT * FROM @transaccionalidadDeclarada td
--WHERE ((@idPersona = 0) OR (td.IdPersona = @idPersona));

DECLARE @idFactor INT=0;
DECLARE @factor VARCHAR(128)='';

SET @idFactor=5; SET @factor='Transaccionalidad'

/* DEPOSITOS DECLARADOS DE MENORES */
SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos Declarados - Soc. Menores',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @socios sc
INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=1 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.EsMenor=1

/* RETIROS DECLARADOS DE MENORES */ 
SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros Declarados - Soc. Menores',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @socios sc
INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=2 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.EsMenor=1

/* DEPOSITOS DECLARADOS DE MAYORES */
SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos Declarados - Soc. Mayores',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @socios sc
INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=3 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.EsMayor=1

/* RETIROS DECLARADOS DE MAYORES */ 
SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros Declarados - Soc. Mayores',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @socios sc
INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=4 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.EsMayor=1

/* DEPOSITOS DECLARADOS DE MORALES */
SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Depositos Declarados - Soc. Morales',t.MontoDepValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @socios sc
INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=5 AND t.MontoDepValor BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.EsMoral=1

/* RETIROS DECLARADOS DE MORALES */ 
SELECT sc.IdPersona,sc.IdSocio,@idFactor,@factor,'Retiros Declarados - Soc. Morales',t.MontoRetValor,CONCAT(mc.IdValor1,' - ',mc.IdValor2),mc.Puntos
FROM @socios sc
INNER JOIN @transaccionalidadDeclarada t ON t.IdPersona = sc.IdPersona
INNER JOIN dbo.tPLDmatrizConfiguracionTransaccionalidad mc  WITH(NOLOCK) ON mc.tipo=6 AND t.MontoRetValor BETWEEN mc.IdValor1 AND mc.IdValor2
WHERE sc.EsMoral=1