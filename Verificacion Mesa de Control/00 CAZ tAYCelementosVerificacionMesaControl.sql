
IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCelementosVerificacionMesaControl')
BEGIN
	-- DROP TABLE tAYCelementosVerificacionMesaControl
	SELECT 'Tabla existente: tAYCelementosVerificacionMesaControl' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYCelementosVerificacionMesaControl]
(
	IdElemento 			int NOT NULL PRIMARY KEY IDENTITY,
	Codigo				VARCHAR(16) NOT NULL,
	Descripcion			VARCHAR(32) NOT NULL,
	Alta				DATETIME default GetDate(),
	IdEstatus 			INT NOT NULL,
	IdUsuarioAlta 		INT NOT NULL,
	IdSesion 			INT NOT NULL
) ON [PRIMARY]


ALTER TABLE dbo.tAYCelementosVerificacionMesaControl 
ADD CONSTRAINT FK_tAYCelementosVerificacionMesaControl_IdEstatus 
FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)

ALTER TABLE dbo.tAYCelementosVerificacionMesaControl 
ADD CONSTRAINT FK_tAYCelementosVerificacionMesaControl_IdUsuarioAlta 
FOREIGN KEY (IdUsuarioAlta) REFERENCES dbo.tCTLusuarios (IdUsuario)

ALTER TABLE dbo.tAYCelementosVerificacionMesaControl 
ADD CONSTRAINT FK_tAYCelementosVerificacionMesaControl_IdSesion 
FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones (IdSesion)

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin: