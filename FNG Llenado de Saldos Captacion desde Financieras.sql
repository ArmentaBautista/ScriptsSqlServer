

-- SELECT * FROM tayccaptacion


DECLARE @fecha DATE = '2023-09-01';
DECLARE @fechaActual DATETIME = GETDATE()

WHILE @fecha <= '2023-12-31'
BEGIN
			

			INSERT INTO dbo.tAYCcaptacion
			(
			    Fecha,
			    IdTipoDproducto,
			    IdCuenta,
			    IdSaldo,
			    Capital,
			    InteresOrdinario,
				InteresPendienteCapitalizar,
			    MontoBloqueado,
			    MontoDisponible,
			    Saldo,
			    IdEstatus,
			    Alta
			)
			SELECT
			 @fecha,
			 MAX(c.IdTipoDProducto),
			 i.IdCuenta,  
			 MAX(i.IdSaldoDestino),
			 [Capital] = Sum(i.CapitalGenerado - i.capitalpagado)    
			,[SaldoInteres] = Sum(i.InteresOrdinarioDevengado - i.InteresOrdinarioPagado)   
			,0
			,[MontoBloqueado] = Sum(i.MontoBloqueado  - i.MontoDesbloqueado)    
			,[MontoDisponible] = (Sum(i.InteresOrdinarioDevengado - i.InteresOrdinarioPagado)) - (Sum(i.MontoBloqueado  - i.MontoDesbloqueado))
			,[Saldo] = Sum(i.CapitalGenerado-i.CapitalPagado+i.InteresOrdinarioDevengado-i.InteresOrdinarioPagado+i.InteresAcapitalizar-i.InteresCapitalizado-i.InteresRetirado)     
			,MAX(i.IdEstatusDominio)
			,@fechaActual
			FROM dbo.vSDOtransaccionesFinancierasISNULL i    
			INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) 
				ON c.IdCuenta = i.IdCuenta
					and c.IdTipoDProducto IN (144,398,716,1570,2196,2621)
						AND c.IdCuenta>0
			WHERE i.Fecha <= @fecha       
				AND i.IdEstatus = 1      
			GROUP By i.IdCuenta
  
  SET @fecha = DATEADD(day, 1, @fecha);
END

