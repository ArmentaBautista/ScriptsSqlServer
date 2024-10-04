
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pLSTcorteD')
BEGIN
	DROP PROC pLSTcorteD
	SELECT 'pLSTcorteD BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROC pLSTcorteD
	@TipoOperacion AS varchar(10) = '',
	@IdCorteD AS int = 0,
	@IdCorte AS INT =0,
	@IdCierre AS INT =0,
	@IdUsuario AS INT =0,
	@IdDivisa AS INT=0
	AS
	BEGIN
		SET NOCOUNT ON
		SET XACT_ABORT ON

		IF(@TipoOperacion='LST')
		BEGIN
			IF @IdCorte<>0 AND @IdCierre<>0 AND @IdUsuario <>0
			BEGIN
				SELECT IdCorteD, IdCorte, CorteIdCierre, CorteIdUsuarioCajero, CorteIdRelSaldoRealMontoDenominacion, 
				 IdDivisa, DivisaCodigo, DivisaDescripcion, DivisaEsLocal, SaldoInicial, Entradas, Salidas,
				 (SaldoInicial+Entradas-Salidas)as SaldoFinal, SaldoReal, FaltanteSobrante,FaltanteSobranteLocal,  IdEstatus
	            FROM vVENcortesDGUI 
				WHERE IdCorte =@IdCorte AND CorteIdCierre=@IdCierre AND CorteIdUsuarioCajero=@IdUsuario AND NOT IdCorteD=0
			END
		END
		
		IF @TipoOperacion='CRTES' AND @IdCorte<>0
		BEGIN
			IF ( @IdCierre<>0 AND @IdUsuario<>0)
			BEGIN
				--SELECT vvd.IdCorteD, vvd.IdCorte, vvd.CorteIdCierre,vvd.CorteIdUsuarioCajero,vvd.CorteIdRelSaldoRealMontoDenominacion, vvd.IdDivisa, vvd.DivisaCodigo,vvd.DivisaDescripcion, vvd.DivisaEsLocal ,vvd.SaldoInicial,
			 --      vvd.Entradas, vvd.Salidas,
			 --      (vvd.SaldoInicial+vvd.Entradas-vvd.Salidas) AS SaldoFinal, vvd.SaldoReal,vvd.FaltanteSobrante,vvd.FaltanteSobranteLocal, vvd.IdEstatus
				--  ,vvd.IdSaldoDestino,
			 --      vvd.SaldoIdDivisa, vvd.TotalCargos, vvd.TotalAbonos,
			 --      vvd.CambioNeto
				--  FROM vVENcortesD vvd
				--  WHERE IdCorte =@IdCorte AND CorteIdCierre=@IdCierre AND CorteIdUsuarioCajero=@IdUsuario AND NOT IdCorteD=0
			
					EXEC dbo.pLSTcortesD @IdCorteD = 0,      
										 @IdCorte = @IdCorte,       
										 @IdCierre = @IdCierre,       
										 @IdUsuario = @IdUsuario,      
										 @IdDivisa = 1 


			END
			ELSE
			BEGIN
				  SELECT vvd.IdCorteD, vvd.IdCorte, vvd.CorteIdCierre,vvd.CorteIdUsuarioCajero,vvd.CorteIdRelSaldoRealMontoDenominacion, vvd.IdDivisa, vvd.DivisaCodigo,vvd.DivisaDescripcion, vvd.DivisaEsLocal ,vvd.SaldoInicial,
			       vvd.Entradas, vvd.Salidas,
			       (vvd.SaldoInicial+vvd.Entradas-vvd.Salidas) AS SaldoFinal, vvd.SaldoReal,vvd.FaltanteSobrante,vvd.FaltanteSobranteLocal, vvd.IdEstatus,
			       0 as IdSaldoDestino,
			       0 as SaldoIdDivisa,0 AS  TotalCargos,0 AS  TotalAbonos,
			       0 as CambioNeto FROM vVENcortesDGUI vvd
				  WHERE vvd.IdCorte=@IdCorte AND NOT idcorteD=0
					--SELECT vvd.IdCorteD, vvd.IdCorte, vvd.CorteIdCierre,vvd.CorteIdUsuarioCajero,vvd.CorteIdRelSaldoRealMontoDenominacion,vvd.CorteIdEstatusActual, vvd.IdDivisa, vvd.DivisaCodigo,vvd.DivisaDescripcion, vvd.DivisaEsLocal ,vvd.SaldoInicial,
			  --     vvd.Entradas, vvd.Salidas,
			  --     (vvd.SaldoInicial+vvd.Entradas-vvd.Salidas) AS SaldoFinal, vvd.SaldoReal,vvd.FaltanteSobrante,vvd.FaltanteSobranteLocal, vvd.IdEstatusActual, vvd.IdEstatus,vvd.IdUsuarioAlta, vvd.UsuarioAlta, vvd.Alta,vvd.IdUsuarioCambio, vvd.UsuarioCambio, vvd.UltimoCambio,vvd.IdTipoDDominio, vvd.TipoDominioCodigo,
			  --     vvd.TipoDominioDescripcion, vvd.Estatuscodigo,vvd.EstatusDescripcion, vvd.EstatusColor, vvd.IdObservacionE,vvd.IdObservacionEDominio, vvd.TieneObservaciones, vvd.IdSesion,vvd.IdSaldoDestino,
			  --     vvd.SaldoIdDivisa, vvd.TotalCargos, vvd.TotalAbonos,
			  --     vvd.CambioNeto
				 -- FROM vVENcortesD vvd
				 -- WHERE IdCorte =@IdCorte  AND NOT IdCorteD=0
			
				END
			
		END
		
		IF @TipoOperacion='SDOSFC' AND @IdCorte<>0 AND @IdCierre<>0 AND @IdUsuario<>0 AND @IdDivisa<>0
		BEGIN
			SELECT vvd.IdCorteD, vvd.IdCorte, vvd.CorteIdCierre,vvd.CorteIdUsuarioCajero,vvd.CorteIdRelSaldoRealMontoDenominacion, vvd.IdDivisa, vvd.DivisaCodigo,vvd.DivisaDescripcion, vvd.DivisaEsLocal ,vvd.SaldoInicial,
					vvd.Entradas, vvd.Salidas
					, (vvd.SaldoInicial+vvd.Entradas-vvd.Salidas) AS SaldoFinal
					, vvd.SaldoReal,vvd.FaltanteSobrante,vvd.FaltanteSobranteLocal, 
					vvd.IdSaldoDestino,
					vvd.SaldoIdDivisa, vvd.TotalCargos, vvd.TotalAbonos,
					vvd.CambioNeto,vvd.IdEstatus
					FROM vVENcortesD vvd
					WHERE IdCorte =@IdCorte AND CorteIdCierre=@IdCierre AND CorteIdUsuarioCajero=@IdUsuario AND NOT IdCorteD=0 AND vvd.IdDivisa=@IdDivisa
					ORDER BY vvd.IdCorte DESC	
			
		END
		
		
		
		END 





GO

