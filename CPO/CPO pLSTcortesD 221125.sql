
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pLSTcortesD')
BEGIN
	DROP PROC pLSTcortesD
	SELECT 'pLSTVENcortesD BORRADO' AS info
END
GO

CREATE PROC pLSTcortesD
 @IdCorteD  int,
 @IdCorte  INT ,
 @IdCierre  INT ,
 @IdUsuario  INT ,
 @IdDivisa  INT
AS

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- Datos de cortes, cortesD y saldos
DECLARE @cortes AS TABLE(
		IdCorteD	int	,
		IdCorte	int	,
		IdCierre	int	,
		IdUsuarioCajero	int	,
		IdRelSaldoRealMontoDenominacion	int	,
		IdDivisa	int	,
		Codigo	varchar(50)	,
		descripcion	varchar(50)	,
		EsLocal	bit	,
		SaldoInicial	numeric(18,2)	,
		SaldoFinal	numeric(18,2)	,
		SaldoReal	numeric(18,2)	,
		FaltanteSobrante	numeric(18,2)	,
		FaltanteSobranteLocal	numeric(18,2)	,
		IdEstatus	int	,
		IdSaldoDestino	int	,
		SaldoIdDivisa	int	,
		Entradas numeric(18,2)	,
		Salidas numeric(18,2)	
)

INSERT INTO @cortes (IdCorteD,IdCorte,IdCierre,IdUsuarioCajero,IdRelSaldoRealMontoDenominacion,IdDivisa,Codigo,descripcion,EsLocal,
SaldoInicial,SaldoFinal,SaldoReal,FaltanteSobrante,FaltanteSobranteLocal,IdEstatus,IdSaldoDestino,SaldoIdDivisa,Entradas, Salidas)
SELECT cd.IdCorteD, cor.IdCorte, cor.IdCierre, cor.IdUsuarioCajero, cor.IdRelSaldoRealMontoDenominacion, d.IdDivisa,d.Codigo,d.descripcion,d.EsLocal,
cd.SaldoInicial
, cd.SaldoFinal
, cd.SaldoReal,cd.FaltanteSobrante, cd.FaltanteSobranteLocal,cd.IdEstatus, saldos.IdSaldo AS IdSaldoDestino, saldos.IdDivisa AS SaldoIdDivisa
, cd.Entradas, cd.Salidas
FROM  tVENcortesD cd WITH (NOLOCK) 
INNER JOIN tVENcortes cor WITH (NOLOCK) ON cd.IdCorte = cor.IdCorte AND cor.IdCorte=@IdCorte
INNER JOIN tCTLdivisas d WITH(NOLOCK) ON cd.IdDivisa=d.IdDivisa AND d.IdDivisa=@IdDivisa
INNER  JOIN tSDOsaldos saldos WITH(NOLOCK)ON saldos.IdCuentaABCD=cor.IdCuentaABCDCaja AND saldos.IdDivisa=d.IdDivisa
WHERE cd.IdCorteD=@IdCorteD 

DECLARE @IdSaldoDestino AS INT
SELECT TOP 1 @IdSaldoDestino=c.IdSaldoDestino FROM @cortes c

/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- Datos de transacciones

DECLARE @tSDOtransacciones AS TABLE(
		IdSaldoDestino INT INDEX Cluster_I1 (IdSaldoDestino),
		IdCorte INT INDEX Cluster_I2 (IdSaldoDestino),
		IdDivisa INT,
		TotalCargos NUMERIC(18,2),
		TotalAbonos NUMERIC(18,2),
		CambioNeto NUMERIC(18,2)
)

INSERT INTO @tSDOtransacciones (IdCorte,TotalCargos,TotalAbonos,CambioNeto)
SELECT t.IdCorte, t.TotalCargos,t.TotalAbonos, t.CambioNeto
FROM [tSDOtransacciones] t WITH (nolock) 
WHERE idestatus=1  AND t.IdCorte=@IdCorte AND t.IdDivisa=@IdDivisa AND t.IdSaldoDestino=@IdSaldoDestino


/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- Consulta General

SELECT cor.IdCorteD, 
cor.IdCorte, cor.IdCierre AS CorteIdCierre, cor.IdUsuarioCajero AS CorteIdUsuarioCajero, cor.IdRelSaldoRealMontoDenominacion AS CorteIdRelSaldoRealMontoDenominacion,
cor.IdDivisa,cor.Codigo AS DivisaCodigo,cor.descripcion AS DivisaDescripcion,cor.EsLocal AS DivisaEsLocal, 
cor.SaldoInicial,
CASE WHEN tt.IdCorte IS NULL  THEN cor.entradas ELSE tt.totalcargos END  AS Entradas,
CASE WHEN tt.IdCorte IS NULL  THEN cor.Salidas ELSE tt.TotalAbonos END AS Salidas,
(cor.SaldoInicial  
	+ CASE WHEN tt.IdCorte IS NULL  THEN cor.entradas ELSE tt.totalcargos END
	- CASE WHEN tt.IdCorte IS NULL  THEN cor.Salidas ELSE tt.TotalAbonos END) AS SaldoFinal, 
cor.SaldoReal,
cor.FaltanteSobrante, 
cor.FaltanteSobranteLocal,
cor.IdEstatus,
cor.IdSaldoDestino, cor.IdDivisa AS SaldoIdDivisa
, tt.TotalCargos, tt.TotalAbonos,tt.CambioNeto
FROM  @cortes cor
LEFT JOIN 
			(
				SELECT  t.IdCorte
				, SUM(t.TotalCargos) AS TotalCargos
				, SUM(t.TotalAbonos)  AS TotalAbonos
				, SUM(t.CambioNeto) AS CambioNeto
				FROM @tSDOtransacciones t 
				Group by  t.IdCorte
			) tt ON tt.IdCorte=cor.IdCorte    

			







GO

