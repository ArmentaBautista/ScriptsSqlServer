

-- LoanFeeStatus


IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoLoanFeeStatus')
BEGIN
	CREATE TABLE tBKGcatalogoLoanFeeStatus
	(
		Id						INT PRIMARY KEY,
		Description				VARCHAR(128) NOT NULL,
		Descripcion				VARCHAR(128) NOT NULL,
		IdEstatus				INT NOT NULL FOREIGN KEY REFERENCES dbo.tCTLestatus(IdEstatus)
	) 

	SELECT 'Tabla Creada tBKGcatalogoLoanFeeStatus' AS info
END
ELSE 
	-- DROP TABLE tBKGcatalogoLoanFeeStatus
	SELECT 'tBKGcatalogoLoanFeeStatus Existe'
GO

-- Registros iniciales
IF NOT EXISTS(SELECT 1 FROM dbo.tBKGcatalogoLoanFeeStatus t  WITH(NOLOCK) 
			WHERE t.id IN (0,1,2,3))
BEGIN	

	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (0,'Undefined', 'Indefinido',0)
	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (1,'Active', 'Activo',1)
	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (2,'Expired', 'Vencido',29)
	INSERT INTO dbo.tBKGcatalogoLoanFeeStatus (Id,Description,Descripcion,IdEstatus) VALUES (3,'Paid', 'Pagado',7)
END
GO


SELECT * FROM dbo.tBKGcatalogoLoanFeeStatus
GO

