IF EXISTS(SELECT name FROM sys.types o WHERE o.name='tpPLDsociosDatosGenerales')
BEGIN
	DROP TYPE tpPLDsociosDatosGenerales
	SELECT 'tpPLDsociosDatosGenerales BORRADO' AS info
END
GO

CREATE TYPE [dbo].tpPLDsociosDatosGenerales AS TABLE(
	[IdSocio] [INT] NOT NULL,
	[IdPersona] [int] NULL,
	[Fecha] [date] NULL,
	[Edad] [int] NULL,
	[IdPersonaFisica] [int] NULL,
	[ExentaIVA] [bit] NULL,
	[IdPersonaMoral] [int] NULL,
	[EsSocioValido] [bit] NULL,
	[Genero] [char](1) NULL,
	[IdEstadoNacimiento] [int] NULL,
	[IdRelDomicilios] [int] NULL,
	[IdSucursal] [int] NULL,
	[IdListaDOcupacion] [int] NULL,
	[IdSocioeconomico] [int] NULL,
	[NoSocio] [varchar](24) NULL DEFAULT (''),
	[Nombre] [varchar](250) NULL DEFAULT (''),
	[IdPaisNacimiento] [int] NULL,
	[EsExtranjero] [bit] NULL,
	
	INDEX [IX_IdPersona] NONCLUSTERED ([IdPersona] ASC),
	PRIMARY KEY CLUSTERED ([IdSocio] ASC) WITH (IGNORE_DUP_KEY = OFF)
)
GO


