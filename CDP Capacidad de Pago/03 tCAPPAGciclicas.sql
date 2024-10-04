
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCAPPAGciclicas')
BEGIN
	CREATE TABLE [dbo].[tCAPPAGciclicas]
	(
		IdItemCiclica 					INT IDENTITY,
		IdCapacidadPago					INT NOT NULL, 
		Tipo							BIT NOT NULL,
		Concepto						VARCHAR(32) NOT NULL,
		Cantidad						NUMERIC(8,2),
		UnidadMedida					VARCHAR(8) NOT NULL,
		PrecioUnitario					NUMERIC(11,2),
		Total							AS (Cantidad*PrecioUnitario),
		MesFecha01						DATE DEFAULT '19000101',
		MesMonto01						NUMERIC(11,2),
		MesFecha02						DATE DEFAULT '19000101',
		MesMonto02						NUMERIC(11,2),
		MesFecha03						DATE DEFAULT '19000101',
		MesMonto03						NUMERIC(11,2),
		MesFecha04						DATE DEFAULT '19000101',
		MesMonto04						NUMERIC(11,2),
		MesFecha05						DATE DEFAULT '19000101',
		MesMonto05						NUMERIC(11,2),
		MesFecha06						DATE DEFAULT '19000101',
		MesMonto06						NUMERIC(11,2),
		MesFecha07						DATE DEFAULT '19000101',
		MesMonto07						NUMERIC(11,2),
		MesFecha08						DATE DEFAULT '19000101',
		MesMonto08						NUMERIC(11,2),
		MesFecha09						DATE DEFAULT '19000101',
		MesMonto09						NUMERIC(11,2),
		MesFecha10						DATE DEFAULT '19000101',
		MesMonto10						NUMERIC(11,2),
		MesFecha11						DATE DEFAULT '19000101',
		MesMonto11						NUMERIC(11,2),
		MesFecha12						DATE DEFAULT '19000101',
		MesMonto12						NUMERIC(11,2),
		MesFecha13						DATE DEFAULT '19000101',
		MesMonto13						NUMERIC(11,2),
		MesFecha14						DATE DEFAULT '19000101',
		MesMonto14						NUMERIC(11,2),
		MesFecha15						DATE DEFAULT '19000101',
		MesMonto15						NUMERIC(11,2),
		MesFecha16						DATE DEFAULT '19000101',
		MesMonto16						NUMERIC(11,2),
		MesFecha17						DATE DEFAULT '19000101',
		MesMonto17						NUMERIC(11,2),
		MesFecha18						DATE DEFAULT '19000101',
		MesMonto18						NUMERIC(11,2),

		CONSTRAINT PK_tCAPPAGciclicas_IdItemCiclica PRIMARY KEY(IdItemCiclica),
		CONSTRAINT FK_tCAPPAGciclicas_IdCapacidadPago FOREIGN KEY (IdCapacidadPago) REFERENCES tCAPPAGgenerales(IdCapacidadPago)
		)
		
		SELECT 'Tabla Creada tCAPPAGciclicas' AS info
END
ELSE 
	-- DROP TABLE tCAPPAGciclicas
	SELECT 'tCAPPAGciclicas Existe'
GO

