

CREATE TABLE [dbo].[tTMPtECEproductos](
	[IdProducto] [INT] NOT NULL,
	[Codigo] [VARCHAR](30) NOT NULL,
	[Nombre] [VARCHAR](80) NOT NULL,
	[PermiteRetiro] [INT] NULL,
	[PermiteDeposito] [INT] NULL,
	[SaldoMinimo] [NUMERIC](23, 8) NOT NULL,
	[SaldoMaximo] [NUMERIC](23, 8) NOT NULL,
	[PrimerDeposito] [NUMERIC](18, 2) NULL,
	[CuentaHaberes] [BIT] NOT NULL,
	[CuentaGarantia] [BIT] NOT NULL,
	[Capacidades Diferentes] [INT] NULL,
	[Socio Excelente] [BIT] NULL,
	[Socios Fundadores] [BIT] NULL,
	[Menores de Edad] [BIT] NULL,
	[Socios Personas Morales] [BIT] NULL,
	[Socios Mujeres Mayores de Edad] [BIT] NULL,
	[Socios Hombres Mayores de Edad] [BIT] NULL,
	[Aspirantes a Socios] [BIT] NULL,
	[Empleados] [BIT] NULL,
	[Avales no Socios] [BIT] NULL,
	[Ex Socio] [BIT] NULL,
	[CrearConAportacionSocial] [BIT] NOT NULL,
	[EsAutoApertura] [BIT] NOT NULL,
	[EsMultiCuenta] [BIT] NOT NULL,
	[IdTipoDproducto] [INT] NOT NULL,
	[IdDivision] [INT] NULL,
	[Division] [VARCHAR](93) NULL,
	[TasaAnual] [NUMERIC](23, 8) NULL,
	[TasaMensual] [NUMERIC](23, 8) NULL,
	[DiasTipoaño] [NUMERIC](23, 8) NULL
) ON [PRIMARY]
GO


