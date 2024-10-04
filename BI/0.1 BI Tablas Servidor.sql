
USE iERP_BI
GO

/*
	TABLAS PARA CREARSE EN EL SERVIDOR BI
	ALMACENAN LOS DATOS OBTENIDOS DESDE LOS CLIENTES
*/

/***************************************************/

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tSITcatalogoMinimo')
BEGIN
	-- DROP TABLE tSITcatalogoMinimo
	SELECT 'tSITcatalogoMinimo ya existe....'
	GOTO tSITcatalogoMinimo
END

CREATE TABLE [dbo].tSITcatalogoMinimo
(
[id] INT NOT NULL,
[IdPeriodo] INT NOT NULL,
[IdCatalogoSITI] INT NOT NULL,
[IdEmpresa] INT NOT NULL,
[Concepto] VARCHAR(12) NOT NULL,
[Descripcion] VARCHAR(250) NOT NULL,
[Orden] INT NOT NULL,
[Nivel] INT NOT NULL,
[Fila] INT NOT NULL,
[OrdenR01] INT NOT NULL
)

-- Existe o fue creada la tabla
tSITcatalogoMinimo_creada:

/***************************************************/

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tSITcatalogoMinimoSaldos')
BEGIN
	-- DROP TABLE tSITcatalogoMinimoSaldos
	SELECT 'tSITcatalogoMinimoSaldos ya existe...'
	GOTO tSITcatalogoMinimoSaldos
END


CREATE TABLE [dbo].[tSITcatalogoMinimoSaldos]
(
--[Id] INT IDENTITY,
[IdPeriodo] INT NOT NULL,
[IdCatalogoSITI] INT NOT NULL,
[Periodo] VARCHAR(6) NOT NULL,
[IdEmpresa] INT NOT NULL,
[Importe] NUMERIC(21, 0) NOT NULL,
[Saldo] NUMERIC(23, 8) NOT NULL,
[IdSucursal] INT NOT NULL
)

-- Existe o fue creada la tabla
tSITcatalogoMinimoSaldos_creada:

/***************************************************/

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tBSIsucursales')
BEGIN
	-- DROP TABLE tBSIsucursales
	GOTO tBSIsucursales_creada
END


CREATE TABLE [dbo].[tBSIsucursales]
(
--[Id] INT IDENTITY,
[IdEmpresa] [int] NOT NULL,
[idSucursal] [int] NOT NULL,
[Periodo] [varchar] (6) COLLATE Modern_Spanish_CI_AI NOT NULL,
[Codigo] [varchar] (12) COLLATE Modern_Spanish_CI_AI NOT NULL,
[Descripcion] [varchar] (80) COLLATE Modern_Spanish_CI_AI NOT NULL
) ON [PRIMARY]


-- Existe o fue creada la tabla
tBSIsucursales_creada:

/***************************************************/