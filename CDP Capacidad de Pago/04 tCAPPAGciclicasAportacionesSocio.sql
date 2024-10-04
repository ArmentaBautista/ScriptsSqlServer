
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCAPPAGciclicasAportacionesSocio')
BEGIN
	CREATE TABLE [dbo].[tCAPPAGciclicasAportacionesSocio]
	(
		IdAportacionSocio 		INT NOT NULL IDENTITY,
		IdCapacidadPago			INT NOT NULL, 
		Concepto				VARCHAR(32),
		Monto					NUMERIC(11,2),

		CONSTRAINT PK_tCAPPAGciclicasAportacionesSocio_IdAportacionSocio PRIMARY KEY(IdAportacionSocio),
		CONSTRAINT FK_tCAPPAGciclicasAportacionesSocio_IdCapacidadPago FOREIGN KEY (IdCapacidadPago) REFERENCES tCAPPAGgenerales(IdCapacidadPago)
		)
		
		SELECT 'Tabla Creada tCAPPAGciclicasAportacionesSocio' AS info
END
ELSE 
	-- DROP TABLE tCAPPAGciclicasAportacionesSocio
	SELECT 'tCAPPAGciclicasAportacionesSocio Existe'
GO

