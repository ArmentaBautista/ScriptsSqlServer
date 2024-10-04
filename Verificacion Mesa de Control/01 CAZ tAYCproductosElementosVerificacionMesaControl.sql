
IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCproductosElementosVerificacionMesaControl')
BEGIN
	-- DROP TABLE tAYCproductosElementosVerificacionMesaControl
	SELECT 'Tabla existente tAYCproductosElementosVerificacionMesaControl' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYCproductosElementosVerificacionMesaControl]
(
	IdproductosElemento 	INT NOT NULL PRIMARY KEY IDENTITY,
	IdProducto				INT NOT NULL,
	IdElementoVerificacion	INT NOT NULL,
	Alta					DATETIME NOT NULL default GetDate(),
	IdEstatus 				INT NOT NULL,
	IdUsuarioAlta 			INT NOT NULL,
	IdSesion 				INT NOT NULL
) ON [PRIMARY]


ALTER TABLE dbo.tAYCproductosElementosVerificacionMesaControl
ADD CONSTRAINT FK_tAYCproductosElementosVerificacionMesaControl_IdProducto 
FOREIGN KEY (IdProducto) REFERENCES dbo.tAYCproductosFinancieros (IdProductoFinanciero)

ALTER TABLE dbo.tAYCproductosElementosVerificacionMesaControl
ADD CONSTRAINT FK_tAYCproductosElementosVerificacionMesaControl_IdElementoVerificacion 
FOREIGN KEY (IdElementoVerificacion) REFERENCES dbo.tAYCelementosVerificacionMesaControl (IdElemento)

ALTER TABLE dbo.tAYCproductosElementosVerificacionMesaControl 
ADD CONSTRAINT FK_tAYCproductosElementosVerificacionMesaControl_IdEstatus 
FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)

ALTER TABLE dbo.tAYCproductosElementosVerificacionMesaControl 
ADD CONSTRAINT FK_tAYCproductosElementosVerificacionMesaControl_IdUsuarioAlta 
FOREIGN KEY (IdUsuarioAlta) REFERENCES dbo.tCTLusuarios (IdUsuario)

ALTER TABLE dbo.tAYCproductosElementosVerificacionMesaControl 
ADD CONSTRAINT FK_tAYCproductosElementosVerificacionMesaControl_IdSesion 
FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: