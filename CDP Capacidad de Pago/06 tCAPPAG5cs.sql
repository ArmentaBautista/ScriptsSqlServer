
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tCAPPAG5cs')
BEGIN
	CREATE TABLE [dbo].[tCAPPAG5cs]
	(
		Id5Cs 					INT NOT NULL IDENTITY,
		IdCapacidadPago			INT NOT NULL, 
		Caracter				VARCHAR(MAX) NOT NULL,
		CapacidadPagoGestion	VARCHAR(MAX) NOT NULL,
		Capital					VARCHAR(MAX) NOT NULL,
		Colateral				VARCHAR(MAX) NOT NULL,
		Condiciones				VARCHAR(MAX) NOT NULL,
		Aplicacion				VARCHAR(MAX) NOT NULL,

		CONSTRAINT PK_tCAPPAG5cs_Id5Cs PRIMARY KEY(Id5Cs),
		CONSTRAINT FK_tCAPPAG5cs_IdCapacidadPago FOREIGN KEY (IdCapacidadPago) REFERENCES dbo.tCAPPAGgenerales (IdCapacidadPago)
		)
		
		SELECT 'Tabla Creada tCAPPAG5cs' AS info
END
ELSE 
	-- DROP TABLE tCAPPAG5cs
	SELECT 'tCAPPAG5cs Existe'
GO


