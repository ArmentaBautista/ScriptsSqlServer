

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tBKGcatalogoMovementTypes')
BEGIN
	CREATE TABLE [dbo].[tBKGcatalogoMovementTypes]
	(
		Id				INT NOT NULL PRIMARY KEY,	
		Descripcion		VARCHAR(24) NOT NULL
	) 
	
	SELECT 'Tabla Creada tBKGcatalogoMovementTypes' AS info
	
END
ELSE 
	-- DROP TABLE tBKGcatalogoMovementTypes
	SELECT 'tBKGcatalogoMovementTypes Existe'
GO

IF NOT EXISTS(SELECT 1 FROM tBKGcatalogoMovementTypes WHERE id IN (0,1,2,3,4))
BEGIN	

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(0,'Undefined');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(1,'Credit/Debit');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(2,'Credit');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(3,'Debit');

	INSERT INTO tBKGcatalogoMovementTypes(id,Descripcion) VALUES(4,'Balance');

END
GO

SELECT * FROM dbo.tBKGcatalogoMovementTypes

GO




