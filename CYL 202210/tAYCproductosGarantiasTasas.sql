
IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCproductosGarantiasTasas')
BEGIN
	-- DROP TABLE [dbo].[tAYCproductosGarantiasTasas]
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tAYCproductosGarantiasTasas]
(
	IdProductosGarantiasTasas	INT NOT NULL PRIMARY KEY IDENTITY,
	IdProducto					INT	Not NULL,
	PorcentajeGarantia			NUMERIC(5,4)	Not Null,	
	InteresOrdinarioAnual		NUMERIC(23,8)	Not Null,	
	InteresMoratorioAnual		NUMERIC(23,8)	Not Null,
	Alta						DATETIME NOT NULL DEFAULT GetDate(),
	IdEstatus 					INT NOT NULL,
	IdUsuarioAlta 				INT NOT NULL,
	IdSesion 					INT NOT NULL
) ON [PRIMARY]


ALTER TABLE tAYCproductosGarantiasTasas 
ADD CONSTRAINT FK_tAYCproductosfinancieros_Idproducto 
FOREIGN KEY (IdProducto) REFERENCES dbo.tAYCproductosFinancieros (IdProductoFinanciero)

ALTER TABLE tAYCproductosGarantiasTasas 
ADD CONSTRAINT FK_tCTLestatus_IdEstatus 
FOREIGN KEY (IdEstatus) REFERENCES dbo.tCTLestatus (IdEstatus)

ALTER TABLE tAYCproductosGarantiasTasas 
ADD CONSTRAINT FK_tCTLusuarios_IdUsuario 
FOREIGN KEY (IdUsuarioAlta) REFERENCES dbo.tCTLusuarios(IdUsuario)

ALTER TABLE tAYCproductosGarantiasTasas 
ADD CONSTRAINT FK_tCTLsesiones_IdSesion 
FOREIGN KEY (IdSesion) REFERENCES dbo.tCTLsesiones(IdSesion)

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:


