
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tEDOCTAcaptacionCapital')
BEGIN
	CREATE TABLE [dbo].[tEDOCTAcaptacionCapital]
	(
		IdCuenta 					INT NOT NULL,
		NoCuenta					VARCHAR(30) NOT NULL,
		IdSocio						INT NOT NULL,
		IdTipoDproducto				INT NOT NULL,
		TipoDProducto				VARCHAR(250) NOT NULL,
		IdProductoFinanciero		INT NOT NULL,
		ProductoFinanciero			VARCHAR(80) NOT NULL,
		InteresOrdinarioAnual		NUMERIC(23,8) NOT NULL,
		GAT							NUMERIC(23,8) NOT NULL DEFAULT 0,
		GATreal						NUMERIC(18,8) NOT NULL DEFAULT 0,
		IdApertura					INT NULL,
		AperturaFolio				INT NULL,		
		IdEstatus 					INT NOT NULL,
		IdPeriodo					INT NOT NULL,
		Periodo						VARCHAR(12) NOT NULL,
		DiasPeriodo					INT
		
		CONSTRAINT PK_tEDOCTAcaptacionCapital_IdCuenta_IdPeriodo	PRIMARY KEY	(IdCuenta,IdPeriodo)
		)
		
		SELECT 'Tabla Creada tEDOCTAcaptacionCapital' AS info
END
ELSE 
	-- DROP TABLE tEDOCTAcaptacionCapital
	SELECT 'tEDOCTAcaptacionCapital Existe'
GO





