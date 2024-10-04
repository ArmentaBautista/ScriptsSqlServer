



IF EXISTS(SELECT name FROM sys.tables WHERE name='tAYCcarteraOperacionDiariaEnTransito')
BEGIN
	-- DROP TABLE CREATE TABLE [dbo].[tAYCcarteraOperacionDiariaEnTransito]
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].tAYCcarteraOperacionDiariaEnTransito
(
IdCuenta [int] NOT NULL
) ON [PRIMARY]



SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:







