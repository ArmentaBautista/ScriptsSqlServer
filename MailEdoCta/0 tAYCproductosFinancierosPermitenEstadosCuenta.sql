


IF EXISTS(SELECT name FROM sys.tables o  WITH(nolock) WHERE name ='tAYCproductosFinancierosPermitenEstadosCuenta')
BEGIN
	SELECT 'La tabla ya existe...'
	GOTO Salir
END


CREATE TABLE dbo.tAYCproductosFinancierosPermitenEstadosCuenta
(
	IdProductoFinanciero INT NOT NULL FOREIGN KEY REFERENCES dbo.tAYCproductosFinancieros(IdProductoFinanciero),
	IdEstatus INT NOT NULL FOREIGN KEY REFERENCES dbo.tCTLestatus(IdEstatus),
	Alta DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	IdSesion INT NULL
)


SELECT 'La tabla se ha creado correctamente'

Salir:

