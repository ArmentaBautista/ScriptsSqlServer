USE [Importacion]
GO
/****** Object:  Table [dbo].[migra_persona]    Script Date: 05/04/2022 07:40:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[migra_persona](
	[IdentificadorPersona] [varchar](50) NULL,
	[Tipo] [varchar](50) NULL,
	[Nombre] [varchar](200) NULL,
	[Nombre2] [varchar](200) NULL,
	[ApellidoPaterno] [varchar](200) NULL,
	[ApellidoMaterno] [varchar](200) NULL,
	[FechaNacimiento] [varchar](12) NULL,
	[Genero] [char](1) NULL,
	[CURP] [varchar](50) NULL,
	[RFC] [varchar](50) NULL,
	[RFCValidado] [char](1) NULL,
	[EstadoNacimiento] [varchar](50) NULL,
	[TipoIdentificacion] [varchar](50) NULL,
	[NoIdentificacion] [varchar](50) NULL,
	[NivelEstudios] [varchar](50) NULL,
	[Profesion] [varchar](50) NULL,
	[Ocupacion] [varchar](200) NULL,
	[EsExtranjero] [varchar](1) NULL,
	[IdFiscal] [varchar](50) NULL,
	[CalidadMigratoria] [varchar](50) NULL,
	[ActividadEmpresarial] [varchar](50) NULL,
	[EstadoCivil] [varchar](50) NULL,
	[TipoRelacionado] [varchar](50) NULL
) ON [PRIMARY]
GO
