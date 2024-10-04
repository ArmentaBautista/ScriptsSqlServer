IF EXISTS(SELECT name FROM sys.tables WHERE name='tHuellasDigitalesPersonas')
BEGIN
	-- drop table tHuellasDigitalesPersonas
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[tHuellasDigitalesPersonas]
(
	IdentificadorHuella 			INT NOT NULL,
	IdentificadorPersona			INT NOT NULL,
	NumeroHuella					INT NOT NULL,
	HuellaDigital					VARBINARY (max) NOT NULL,
	Alta							DATETIME default GetDate(),
	IdEstatus 						INT NOT NULL,
	IdUsuarioAlta 					INT NOT NULL,
	IdSesion 						INT NOT NULL
) ON [PRIMARY]


Fin:

