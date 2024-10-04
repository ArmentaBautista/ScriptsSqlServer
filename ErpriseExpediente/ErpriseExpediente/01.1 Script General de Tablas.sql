
USE [ErpriseExpediente]
GO
/****** Object:  Table [dbo].[tAYCcuentas]    Script Date: 14/04/2023 03:46:21 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAYCcuentas](
	[IdCuenta] [int] IDENTITY(1,1) NOT NULL,
	[IdPersona] [int] NOT NULL,
	[NumeroCuenta] [varchar](30) NOT NULL,
	[IdProducto] [int] NOT NULL,
	[IdTipoD] [int] NOT NULL,
	[Descripcion] [varchar](30) NOT NULL,
	[DescripcionLarga] [varchar](512) NULL,
	[IdEstatus] [int] NOT NULL,
	[Resumen] [varchar](250) NULL,
 CONSTRAINT [PK__tAYCcuen__D41FD706E50479A6] PRIMARY KEY CLUSTERED 
(
	[IdCuenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__tAYCcuen__E039507BAAE251A4] UNIQUE NONCLUSTERED 
(
	[NumeroCuenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tAYCetapas]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAYCetapas](
	[IdEtapa] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](20) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[AplicaIngreso] [bit] NOT NULL,
	[AplicaDisponibilidad] [bit] NOT NULL,
	[AplicaInversiones] [bit] NOT NULL,
	[AplicaCredito] [bit] NOT NULL,
	[IdEstatus] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdEtapa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tAYCetapasRequisitos]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAYCetapasRequisitos](
	[IdEtapa] [int] NOT NULL,
	[IdRequisito] [int] NOT NULL,
	[IdEstatus] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tAYCproductosFinancieros]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAYCproductosFinancieros](
	[IdProductoFinanciero] [int] NOT NULL,
	[Codigo] [varchar](24) NOT NULL,
	[Descripcion] [varchar](64) NOT NULL,
	[IdTipoDproducto] [int] NOT NULL,
 CONSTRAINT [PK_tAYCproductosFinancieros] PRIMARY KEY CLUSTERED 
(
	[IdProductoFinanciero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tDIGagrupadores]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDIGagrupadores](
	[IdAgrupador] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](20) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[EsObligatorio] [bit] NOT NULL,
	[IdEstatus] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdAgrupador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tDIGagrupadoresRequisitos]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDIGagrupadoresRequisitos](
	[IdAgrupador] [int] NOT NULL,
	[IdRequisito] [int] NOT NULL,
	[IdEstatus] [int] NOT NULL,
 CONSTRAINT [UK_IdAgrupador_IdRequisito] UNIQUE NONCLUSTERED 
(
	[IdAgrupador] ASC,
	[IdRequisito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tDIGarchivos]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDIGarchivos](
	[IdArchivo] [int] IDENTITY(1,1) NOT NULL,
	[IdExpediente] [int] NOT NULL,
	[IdRequisito] [int] NOT NULL,
	[Nombre] [varchar](92) NOT NULL,
	[Llave] [varchar](100) NOT NULL,
	[Referencia] [varchar](100) NULL,
	[EsAutogenerado] [bit] NOT NULL,
	[EstaSincronizado] [bit] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Alta] [datetime] NOT NULL,
	[IdSesion] [int] NOT NULL,
	[IdEstatus] [int] NOT NULL,
 CONSTRAINT [PK__tDIGarch__26B92111C74B4289] PRIMARY KEY CLUSTERED 
(
	[IdArchivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__tDIGarch__75E3EFCF75CD3935] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__tDIGarch__8E70B2922E3E7931] UNIQUE NONCLUSTERED 
(
	[Llave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tDIGexpediente]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDIGexpediente](
	[IdExpediente] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDdominio] [int] NOT NULL,
	[IdRegistro] [int] NOT NULL,
	[IdRequisito] [int] NOT NULL,
	[EstaCubiertoNoDocumental] [bit] NOT NULL,
	[IdPersona] [int] NOT NULL,
	[IdOperacion] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Alta] [datetime] NOT NULL,
	[IdSesion] [int] NOT NULL,
	[IdEstatus] [int] NOT NULL,
 CONSTRAINT [PK_tDIGexpediente] PRIMARY KEY CLUSTERED 
(
	[IdExpediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_tDIGexpediente] UNIQUE NONCLUSTERED 
(
	[IdRequisito] ASC,
	[IdTipoDdominio] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tDIGproductosRequisitos]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDIGproductosRequisitos](
	[IdProductoFinanciero] [int] NOT NULL,
	[IdRequisito] [int] NOT NULL,
	[IdEstatus] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tDIGrequisitos]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDIGrequisitos](
	[IdRequisito] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](20) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[EsDocumental] [bit] NOT NULL,
	[AplicaIngreso] [bit] NOT NULL,
	[AplicaDisponibilidad] [bit] NOT NULL,
	[AplicaInversiones] [bit] NOT NULL,
	[AplicaCredito] [bit] NOT NULL,
	[EsObligatorio] [bit] NOT NULL,
	[PermiteMultiarchivo] [bit] NOT NULL,
	[IdEstatus] [int] NOT NULL,
 CONSTRAINT [PK__tDIGrequ__661FC7C2AF30BE10] PRIMARY KEY CLUSTERED 
(
	[IdRequisito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__tDIGrequ__06370DAC2AE49E04] UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tGRLpersonas]    Script Date: 14/04/2023 03:46:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGRLpersonas](
	[IdPersona] [int] IDENTITY(1,1) NOT NULL,
	[ClavePersona] [varchar](50) NOT NULL,
	[EsPersonalMoral] [bit] NULL,
	[IdSocio] [int] NULL,
	[NumeroSocio] [varchar](30) NULL,
	[EsSocioValido] [bit] NULL,
	[NombreRazonSocial] [varchar](200) NULL,
	[Nombre2] [varchar](200) NULL,
	[ApellidoPaterno] [varchar](200) NULL,
	[ApellidoMaterno] [varchar](200) NULL,
	[FechaNacimiento] [varchar](12) NULL,
	[Genero] [char](1) NULL,
	[RFC] [varchar](50) NULL,
	[CURP] [varchar](50) NULL,
	[IdEstatus] [int] NULL,
 CONSTRAINT [PK__tGRLpers__2EC8D2AC19C3FA13] PRIMARY KEY CLUSTERED 
(
	[IdPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__tGRLpers__E17880747606E748] UNIQUE NONCLUSTERED 
(
	[ClavePersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tAYCcuentas] ADD  CONSTRAINT [DF_tAYCcuentas_IdProducto]  DEFAULT ((0)) FOR [IdProducto]
GO
ALTER TABLE [dbo].[tAYCcuentas] ADD  CONSTRAINT [DF__tAYCcuent__IdTip__00AA174D]  DEFAULT ((143)) FOR [IdTipoD]
GO
ALTER TABLE [dbo].[tAYCcuentas] ADD  CONSTRAINT [DF__tAYCcuent__IdEst__019E3B86]  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tAYCetapas] ADD  DEFAULT ((0)) FOR [AplicaIngreso]
GO
ALTER TABLE [dbo].[tAYCetapas] ADD  DEFAULT ((0)) FOR [AplicaDisponibilidad]
GO
ALTER TABLE [dbo].[tAYCetapas] ADD  DEFAULT ((0)) FOR [AplicaInversiones]
GO
ALTER TABLE [dbo].[tAYCetapas] ADD  DEFAULT ((0)) FOR [AplicaCredito]
GO
ALTER TABLE [dbo].[tAYCetapas] ADD  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tAYCetapasRequisitos] ADD  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tAYCproductosFinancieros] ADD  CONSTRAINT [DF_tAYCproductosFinancieros_IdTipoDproducto]  DEFAULT ((144)) FOR [IdTipoDproducto]
GO
ALTER TABLE [dbo].[tDIGagrupadores] ADD  DEFAULT ((0)) FOR [EsObligatorio]
GO
ALTER TABLE [dbo].[tDIGagrupadores] ADD  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tDIGagrupadoresRequisitos] ADD  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tDIGarchivos] ADD  CONSTRAINT [DF__tDIGarchi__EsAut__1940BAED]  DEFAULT ((0)) FOR [EsAutogenerado]
GO
ALTER TABLE [dbo].[tDIGarchivos] ADD  CONSTRAINT [DF__tDIGarchi__EstaS__1A34DF26]  DEFAULT ((0)) FOR [EstaSincronizado]
GO
ALTER TABLE [dbo].[tDIGarchivos] ADD  CONSTRAINT [DF__tDIGarchi__Fecha__1B29035F]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[tDIGarchivos] ADD  CONSTRAINT [DF__tDIGarchiv__Alta__1C1D2798]  DEFAULT (getdate()) FOR [Alta]
GO
ALTER TABLE [dbo].[tDIGarchivos] ADD  CONSTRAINT [DF__tDIGarchi__IdEst__1D114BD1]  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tDIGexpediente] ADD  CONSTRAINT [DF__tDIGexped__IdPer__6A85CC04]  DEFAULT ((0)) FOR [IdPersona]
GO
ALTER TABLE [dbo].[tDIGexpediente] ADD  CONSTRAINT [DF__tDIGexped__IdOpe__6B79F03D]  DEFAULT ((0)) FOR [IdOperacion]
GO
ALTER TABLE [dbo].[tDIGexpediente] ADD  CONSTRAINT [DF__tDIGexped__Fecha__6C6E1476]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[tDIGexpediente] ADD  CONSTRAINT [DF__tDIGexpedi__Alta__6D6238AF]  DEFAULT (getdate()) FOR [Alta]
GO
ALTER TABLE [dbo].[tDIGexpediente] ADD  CONSTRAINT [DF__tDIGexped__IdEst__6E565CE8]  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tDIGproductosRequisitos] ADD  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF_tDIGrequisitos_EsDocumental]  DEFAULT ((1)) FOR [EsDocumental]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__Aplic__4924D839]  DEFAULT ((0)) FOR [AplicaIngreso]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__Aplic__4A18FC72]  DEFAULT ((0)) FOR [AplicaDisponibilidad]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__Aplic__4B0D20AB]  DEFAULT ((0)) FOR [AplicaInversiones]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__Aplic__4C0144E4]  DEFAULT ((0)) FOR [AplicaCredito]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__EsObl__4CF5691D]  DEFAULT ((0)) FOR [EsObligatorio]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__Permi__4DE98D56]  DEFAULT ((1)) FOR [PermiteMultiarchivo]
GO
ALTER TABLE [dbo].[tDIGrequisitos] ADD  CONSTRAINT [DF__tDIGrequi__IdEst__4EDDB18F]  DEFAULT ((1)) FOR [IdEstatus]
GO
ALTER TABLE [dbo].[tAYCcuentas]  WITH CHECK ADD  CONSTRAINT [FK__tAYCcuent__IdPer__7FB5F314] FOREIGN KEY([IdPersona])
REFERENCES [dbo].[tGRLpersonas] ([IdPersona])
GO
ALTER TABLE [dbo].[tAYCcuentas] CHECK CONSTRAINT [FK__tAYCcuent__IdPer__7FB5F314]
GO
ALTER TABLE [dbo].[tAYCetapasRequisitos]  WITH CHECK ADD FOREIGN KEY([IdEtapa])
REFERENCES [dbo].[tAYCetapas] ([IdEtapa])
GO
ALTER TABLE [dbo].[tAYCetapasRequisitos]  WITH CHECK ADD  CONSTRAINT [FK__tAYCetapa__IdReq__61F08603] FOREIGN KEY([IdRequisito])
REFERENCES [dbo].[tDIGrequisitos] ([IdRequisito])
GO
ALTER TABLE [dbo].[tAYCetapasRequisitos] CHECK CONSTRAINT [FK__tAYCetapa__IdReq__61F08603]
GO
ALTER TABLE [dbo].[tDIGagrupadoresRequisitos]  WITH CHECK ADD FOREIGN KEY([IdAgrupador])
REFERENCES [dbo].[tDIGagrupadores] ([IdAgrupador])
GO
ALTER TABLE [dbo].[tDIGagrupadoresRequisitos]  WITH CHECK ADD  CONSTRAINT [FK__tDIGagrup__IdReq__567ED357] FOREIGN KEY([IdRequisito])
REFERENCES [dbo].[tDIGrequisitos] ([IdRequisito])
GO
ALTER TABLE [dbo].[tDIGagrupadoresRequisitos] CHECK CONSTRAINT [FK__tDIGagrup__IdReq__567ED357]
GO
ALTER TABLE [dbo].[tDIGarchivos]  WITH CHECK ADD  CONSTRAINT [FK_tDIGarchivos_tDIGexpediente] FOREIGN KEY([IdExpediente])
REFERENCES [dbo].[tDIGexpediente] ([IdExpediente])
GO
ALTER TABLE [dbo].[tDIGarchivos] CHECK CONSTRAINT [FK_tDIGarchivos_tDIGexpediente]
GO
ALTER TABLE [dbo].[tDIGexpediente]  WITH CHECK ADD  CONSTRAINT [FK__tDIGexped__IdReq__6991A7CB] FOREIGN KEY([IdRequisito])
REFERENCES [dbo].[tDIGrequisitos] ([IdRequisito])
GO
ALTER TABLE [dbo].[tDIGexpediente] CHECK CONSTRAINT [FK__tDIGexped__IdReq__6991A7CB]
GO
ALTER TABLE [dbo].[tDIGproductosRequisitos]  WITH CHECK ADD  CONSTRAINT [FK__tDIGprodu__IdReq__64CCF2AE] FOREIGN KEY([IdRequisito])
REFERENCES [dbo].[tDIGrequisitos] ([IdRequisito])
GO
ALTER TABLE [dbo].[tDIGproductosRequisitos] CHECK CONSTRAINT [FK__tDIGprodu__IdReq__64CCF2AE]
GO
ALTER TABLE [dbo].[tDIGproductosRequisitos]  WITH CHECK ADD  CONSTRAINT [FK_tDIGproductosRequisitos_tAYCproductosFinancieros] FOREIGN KEY([IdProductoFinanciero])
REFERENCES [dbo].[tAYCproductosFinancieros] ([IdProductoFinanciero])
GO
ALTER TABLE [dbo].[tDIGproductosRequisitos] CHECK CONSTRAINT [FK_tDIGproductosRequisitos_tAYCproductosFinancieros]
GO
ALTER TABLE [dbo].[tDIGexpediente]  WITH CHECK ADD  CONSTRAINT [ck_tipodominio] CHECK  (([IdTipoDdominio]=(232) OR [IdTipoDdominio]=(208)))
GO
ALTER TABLE [dbo].[tDIGexpediente] CHECK CONSTRAINT [ck_tipodominio]
GO
