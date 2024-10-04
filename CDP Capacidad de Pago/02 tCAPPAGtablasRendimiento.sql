
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCAPPAGtablasRendimiento')
BEGIN
	CREATE TABLE [dbo].[tCAPPAGtablasRendimiento]
	(
		IdRendimiento 			INT NOT NULL IDENTITY,
		Clase					VARCHAR(32)	NOT NULL,
		Cultivo					VARCHAR(32)	NOT NULL,
		Modalidad				VARCHAR(32)	NOT NULL,
		Region 					VARCHAR(56)	NOT NULL,
		Ciclo					VARCHAR(32) NOT NULL,	
		CicloVegetativoMeses	TINYINT NOT NULL,	
		CiclosPorAño			TINYINT NOT NULL,	
		RendimientoTonelada		NUMERIC(11,2) NOT NULL,	
		PrecioVentaInpc			NUMERIC(11,2) NOT NULL,	
		CostosProduccionInpp	NUMERIC(11,2) NOT NULL,	
		IngresoHa				NUMERIC(11,2) NOT NULL,	
		Utilidad				NUMERIC(11,2) NOT NULL,	
		Factor					NUMERIC(8,2) NOT NULL,	
		Vigencia				VARCHAR(48)	NOT NULL,
		Fecha					DATE,
		Alta					DATETIME,
		IdEstatus 				INT NOT NULL,
		
		CONSTRAINT PK_tCAPPAGtablasRendimiento_IdRendimiento PRIMARY KEY(IdRendimiento),
		CONSTRAINT FK_tCAPPAGtablasRendimiento_IdEstatus FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)
		)
		
		ALTER TABLE tCAPPAGtablasRendimiento ADD CONSTRAINT DF_tCAPPAGtablasRendimiento_Fecha DEFAULT GETDATE() FOR Fecha
		ALTER TABLE tCAPPAGtablasRendimiento ADD CONSTRAINT DF_tCAPPAGtablasRendimiento_Alta DEFAULT GETDATE() FOR Alta
		ALTER TABLE tCAPPAGtablasRendimiento ADD CONSTRAINT DF_tCAPPAGtablasRendimiento_IdEstatus DEFAULT 1 FOR IdEstatus

		SELECT 'Tabla Creada tCAPPAGtablasRendimiento' AS info
END
ELSE 
	-- DROP TABLE tCAPPAGtablasRendimiento
	SELECT 'tCAPPAGtablasRendimiento Existe'
GO

