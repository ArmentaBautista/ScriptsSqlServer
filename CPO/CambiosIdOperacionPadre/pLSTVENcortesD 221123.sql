

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pLSTVENcortesD')
BEGIN
	DROP PROC pLSTVENcortesD
	SELECT 'OBJETO BORRADO' AS info
END
GO

CREATE PROC pLSTVENcortesD
 @IdCorteD  int,
 @IdCorte  INT ,
 @IdCierre  INT ,
 @IdUsuario  INT ,
 @IdDivisa  INT
AS

DECLARE @tSDOtransacciones AS TABLE(
		IdSaldoDestino INT INDEX Cluster_I1 (IdSaldoDestino),
		IdCorte INT INDEX Cluster_I2 (IdSaldoDestino),
		IdDivisa INT,
		TotalCargos NUMERIC(18,2),
		TotalAbonos NUMERIC(18,2),
		CambioNeto NUMERIC(18,2)
)

INSERT INTO @tSDOtransacciones (IdSaldoDestino,IdCorte,IdDivisa,TotalCargos,TotalAbonos,CambioNeto)
SELECT t.IdSaldoDestino, t.IdCorte, t.IdDivisa, t.TotalCargos,t.TotalAbonos, t.CambioNeto
FROM [tSDOtransacciones] t WITH (nolock) 
WHERE idestatus=1 --and t.IdTipoDDominioDestino=851
AND t.IdCorte=@IdCorte 
--INNER JOIN tGRLoperaciones o WITH (NOLOCK) ON o.IdOperacion = t.IdOperacion

DECLARE @IdSaldoDestino AS INT
DECLARE @divisa AS INT

SELECT TOP 1 @IdSaldoDestino=tr.IdSaldoDestino, @IdDivisa=tr.IdDivisa FROM @tSDOtransacciones tr

SELECT tVENcortesD.IdCorteD, 
tVENcortes.IdCorte, tVENcortes.IdCierre AS CorteIdCierre, tVENcortes.IdUsuarioCajero AS CorteIdUsuarioCajero, tVENcortes.IdRelSaldoRealMontoDenominacion AS CorteIdRelSaldoRealMontoDenominacion,
tCTLdivisas.IdDivisa,tctlDivisas.Codigo AS DivisaCodigo,tctlDivisas.descripcion AS DivisaDescripcion,tctldivisas.EsLocal AS DivisaEsLocal, 
tVENcortesD.SaldoInicial,
CASE WHEN tt.IdCorte IS NULL  THEN tVENcortesD.entradas ELSE tt.totalcargos END  AS Entradas,
CASE WHEN tt.IdCorte IS NULL  THEN tVENcortesD.Salidas ELSE tt.TotalAbonos END AS Salidas,
 tVENcortesD.SaldoFinal, 
tVENcortesD.SaldoReal,
tVENcortesD.FaltanteSobrante, 
tVENcortesD.FaltanteSobranteLocal,
tVENcortesD.IdEstatus,
--, vCTLestatusActualGUI.IdEstatus, vCTLestatusActualGUI.IdUsuarioAlta, vCTLestatusActualGUI.UsuarioAlta, vCTLestatusActualGUI.Alta, vCTLestatusActualGUI.IdUsuarioCambio, vCTLestatusActualGUI.UsuarioCambio, vCTLestatusActualGUI.UltimoCambio, vCTLestatusActualGUI.IdTipoDDominio, vCTLestatusActualGUI.TipoDominioCodigo, vCTLestatusActualGUI.TipoDominioDescripcion, vCTLestatusActualGUI.EstatusCodigo, vCTLestatusActualGUI.EstatusDescripcion, vCTLestatusActualGUI.EstatusColor, vCTLestatusActualGUI.IdObservacionE, vCTLestatusActualGUI.IdObservacionEDominio, vCTLestatusActualGUI.TieneObservaciones, vCTLestatusActualGUI.IdSesion,
@IdSaldoDestino, @IdDivisa AS SaldoIdDivisa, tt.TotalCargos, tt.TotalAbonos,tt.CambioNeto
FROM  tVENcortesD WITH (NOLOCK) 
INNER JOIN tVENcortes  WITH (NOLOCK) ON tVENcortesD.IdCorte = tVENcortes.IdCorte 
INNER JOIN tCTLdivisas WITH(NOLOCK) ON tvencortesD.IdDivisa=tctldivisas.IdDivisa 
INNER  JOIN tSDOsaldos saldos WITH(NOLOCK)ON saldos.IdCuentaABCD=tVENcortes.IdCuentaABCDCaja AND saldos.IdDivisa=tctldivisas.IdDivisa
LEFT JOIN 
			(
				SELECT  t.IdCorte
				, SUM(t.TotalCargos) AS TotalCargos
				, SUM(t.TotalAbonos)  AS TotalAbonos
				, SUM(t.CambioNeto) AS CambioNeto
				FROM @tSDOtransacciones t 
				Group by  t.IdCorte
			) tt ON tt.IdCorte=tVENcortes.IdCorte    
WHERE dbo.tVENcortes.IdCorte =@IdCorte 
AND NOT tVENcortesD.IdCorteD=0
			







GO


