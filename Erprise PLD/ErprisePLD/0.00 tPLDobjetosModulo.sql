
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDobjetosModulo')
BEGIN
	CREATE TABLE [dbo].[tPLDobjetosModulo]
	(
		Id 					INT NOT NULL IDENTITY,
		Nombre				VARCHAR(192),
		Alta					DATETIME DEFAULT GETDATE()
		
		CONSTRAINT PK_tPLDobjetosModulo_Id PRIMARY KEY(Id),
		)
		
		SELECT 'Tabla Creada tPLDobjetosModulo' AS info
END
ELSE 
	-- DROP TABLE tPLDobjetosModulo
	SELECT 'tPLDobjetosModulo Existe'
GO

