
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCAPPAGciclicasResumen')
BEGIN
	CREATE TABLE [dbo].[tCAPPAGciclicasResumen]
	(
		IdResumenCiclica 						INT NOT NULL IDENTITY,
		IdCapacidadPago							INT NOT NULL, 
		PrecioTotalVenta						NUMERIC(11,2),	
		MargenRiesgo							AS (PrecioTotalVenta*.20),
		PrecioAjustadoVenta						AS (PrecioTotalVenta - (PrecioTotalVenta*.20)),
		CostoProduccionAportacionSocio			NUMERIC(11,2),	
		PrecioAjustadoVentaMenosAportaciónSocio	AS ((PrecioTotalVenta - (PrecioTotalVenta*.20)) - CostoProduccionAportacionSocio),
		FinanciamientoRequerido					NUMERIC(11,2),	
		InteresesFinanciamiento					NUMERIC(11,2),	
		IvaIntereses							NUMERIC(11,2),	
		TotalPagarFinanciamiento				NUMERIC(11,2),	
		DisponibleActividadCiclica				AS ((PrecioTotalVenta - (PrecioTotalVenta*.20)) - TotalPagarFinanciamiento - CostoProduccionAportacionSocio),

		CONSTRAINT PK_tCAPPAGciclicasResumen_IdResumenCiclica PRIMARY KEY(IdResumenCiclica),
		CONSTRAINT FK_tCAPPAGciclicasResumen_IdCapacidadPago FOREIGN KEY (IdCapacidadPago) REFERENCES tCAPPAGgenerales(IdCapacidadPago)
		)
		
		SELECT 'Tabla Creada tCAPPAGciclicasResumen' AS info
END
ELSE 
	-- DROP TABLE tCAPPAGciclicasResumen
	SELECT 'tCAPPAGciclicasResumen Existe'
GO

