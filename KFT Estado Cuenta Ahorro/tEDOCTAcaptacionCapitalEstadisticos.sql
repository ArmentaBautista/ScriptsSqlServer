IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tEDOCTAcaptacionCapitalEstadisticos')
BEGIN
	CREATE TABLE [dbo].[tEDOCTAcaptacionCapitalEstadisticos]
	(
		IdCuenta 						INT NOT NULL,
		IdPeriodo						INT NOT NULL,
		IdSucursal						INT NOT NULL,
		FechaAperturaReinversion		DATE NOT NULL,
		MontoTransaccionesDepositos		NUMERIC(23,8),
		MontoTransaccionesRetiros		NUMERIC(23,8),
		NumeroTransaccionesDepositos	INT,
		NumeroTransaccionesRetiros		INT,
		InteresesDevengados				NUMERIC(23,8),
		InteresesPagados				NUMERIC(23,8),
		Comisiones						NUMERIC(23,8),
		Retenciones						NUMERIC(23,8),
		Vencimiento						DATE,
		UltimoMovimiento				DATE,
		FechaUltimoDeposito				DATE,
		FechaUltimoRetiro				DATE,
		SaldoPromedio					NUMERIC(23,8),
		SaldoInicial					NUMERIC(23,8),
		SaldoInicialCapital				NUMERIC(23,8),       
		SaldoInteresInicial				NUMERIC(23,8),
		SaldoCapital					NUMERIC(23,8),
		SaldoInteres					NUMERIC(23,8),
		SaldoFinal						NUMERIC(23,8)
		
		CONSTRAINT PK_tEDOCTAcaptacionCapitalEstadisticos_IdCuenta_IdPeriodo PRIMARY KEY(IdCuenta,IdPeriodo)
		
		)
		
		SELECT 'Tabla Creada tEDOCTAcaptacionCapitalEstadisticos' AS info
END
ELSE 
	-- DROP TABLE tEDOCTAcaptacionCapitalEstadisticos
	SELECT 'tEDOCTAcaptacionCapitalEstadisticos Existe'
GO

