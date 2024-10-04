IF EXISTS(SELECT name FROM sys.tables WHERE name='TercerosPLD')
BEGIN
	SELECT 'Tabla existente' AS info
	GOTO Fin
END

CREATE TABLE [dbo].[TercerosPLD]
(
[Id] [int] NOT NULL IDENTITY(0, 1),
[IdentificadorSocio] [int] NOT NULL,
[IdentificadorPersonaSocio] [int] NOT NULL,
[IdentificadorPersonaTercero] [int] NOT NULL,
[EsPropietarioReal] [bit] NOT NULL DEFAULT ((0)),
[EsProveedorRecursos] [bit] NOT NULL DEFAULT ((0)),
) 

SELECT 'Tabla Creada' AS info

-- Goto tag
Fin:

GO
