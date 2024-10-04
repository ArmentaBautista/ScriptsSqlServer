

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tSEGcaptacion')
BEGIN
	CREATE TABLE [dbo].[tSEGcaptacion]
	(
		IdSocio 			INT NOT NULL ,
		IdProducto			INT NOT NULL ,
		Producto			VARCHAR(250) NOT NULL DEFAULT '',
		Saldo				NUMERIC(15,2)
	) 

	SELECT 'Tabla Creada tSEGcaptacion' AS info
	
	ALTER TABLE dbo.tSEGcaptacion 
	ADD CONSTRAINT FK_tSEGcaptacion_IdSocio
	FOREIGN KEY (IdSocio) REFERENCES dbo.tSCSsocios (IdSocio)

	ALTER TABLE dbo.tSEGcaptacion 
	ADD CONSTRAINT FK_tSEGcaptacion_IdProducto
	FOREIGN KEY (IdProducto) REFERENCES dbo.tSEGproductos (IdProducto)

END
ELSE 
	-- DROP TABLE tSEGcaptacion
	SELECT 'tSEGcaptacion Existe'
GO

