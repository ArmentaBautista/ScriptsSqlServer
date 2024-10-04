
USE ErpriseExpediente
go

/*
Tipo: Tabla
Objeto: tDIGrequisitos
Resumen: Almacena el catálogo de requisitos que conforman un expediente. 
Estos estan definidos por un Código (único) y una descripción que usualmente es el nombre.
Se puede definir para que procesos puede usarse dicho requisito mediante los Flags "Aplica"
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tDIGrequisitos')
BEGIN
	SELECT 'tDIGrequisitos Ya Existe' AS info
	-- DROP TABLE tDIGrequisitos
	GOTO Siguiente
END

CREATE TABLE dbo.tDIGrequisitos(
	IdRequisito INT PRIMARY KEY IDENTITY,
	Codigo VARCHAR(20) NOT NULL UNIQUE,
	Descripcion VARCHAR(50) NOT NULL,
	AplicaIngreso BIT DEFAULT 0 NOT NULL,
	AplicaDisponibilidad BIT DEFAULT 0 NOT NULL,
	AplicaInversiones BIT DEFAULT 0 NOT NULL,
	AplicaCredito BIT DEFAULT 0 NOT NULL,
	EsObligatorio BIT DEFAULT 0 NOT NULL,
 	PermiteMultiarchivo BIT DEFAULT 1 NOT NULL,
	IdEstatus INT DEFAULT 1  NOT NULL
)

Siguiente:
GO

/*
Tipo: Tabla
Objeto: tDIGagrupadores
Resumen: Elementos, Etiquetas, Tags, que sirven para agrupar más de un requisito y generar una estructura más completa.
Ej. Agrupador: Comprobante de Domicilio
    Requisitos: Recibo de Luz, Recibo de Teléfono, Recibo de Agua
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tDIGagrupadores')
BEGIN
	SELECT 'tDIGagrupadores Ya Existe' AS info
	-- DROP TABLE tDIGagrupadores
	GOTO Siguiente
END

CREATE TABLE dbo.tDIGagrupadores(
	IdAgrupador INT PRIMARY KEY IDENTITY,
	Codigo VARCHAR(20) UNIQUE NOT NULL,
	Descripcion VARCHAR(50) NOT NULL,
	EsObligatorio BIT DEFAULT 0 NOT NULL,
	IdEstatus INT DEFAULT 1 NOT NULL
)

Siguiente:
GO

/*
Tipo: Tabla
Objeto: tDIGagrupadoresRequisitos
Resumen: Relación entre agrupadores y requisitos que les componen
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tDIGagrupadoresRequisitos')
BEGIN
	SELECT 'tDIGagrupadoresRequisitos Ya Existe' AS info
	-- DROP TABLE tDIGagrupadoresRequisitos
	GOTO Siguiente
END

CREATE TABLE dbo.tDIGagrupadoresRequisitos(
	IdAgrupador INT FOREIGN KEY REFERENCES dbo.tDIGagrupadores(IdAgrupador) NOT NULL,
	IdRequisito INT FOREIGN KEY REFERENCES dbo.tDIGrequisitos(IdRequisito) NOT NULL,
	IdEstatus INT DEFAULT 1 NOT NULL
)

ALTER TABLE tDIGagrupadoresRequisitos ADD CONSTRAINT UK_IdAgrupador_IdRequisito UNIQUE (IdAgrupador,IdRequisito)

Siguiente:
GO

/*
Tipo: Tabla
Objeto: tAYCetapas
Resumen: Catálogo de Etapas de los procesos de Ahorro y Crédito
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCetapas')
BEGIN
	SELECT 'tAYCetapas Ya Existe' AS info
	-- DROP TABLE tAYCetapas
	GOTO Siguiente
END

CREATE TABLE dbo.tAYCetapas(
	IdEtapa INT PRIMARY KEY IDENTITY,
	Codigo VARCHAR(20) UNIQUE NOT NULL,
	Descripcion VARCHAR(50) NOT NULL,
	AplicaIngreso BIT DEFAULT 0 NOT NULL,
	AplicaDisponibilidad BIT DEFAULT 0 NOT NULL,
	AplicaInversiones BIT DEFAULT 0 NOT NULL,
	AplicaCredito BIT DEFAULT 0 NOT NULL,
	IdEstatus INT DEFAULT 1 NOT NULL
)

Siguiente:
GO

/*
Tipo: Tabla
Objeto: tAYCetapasRequisitos
Resumen: Relación de Requisitos y la Etapa donde son empleadas
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCetapasRequisitos')
BEGIN
	SELECT 'tAYCetapasRequisitos Ya Existe' AS info
	-- DROP TABLE tAYCetapasRequisitos
	GOTO Siguiente
END

CREATE TABLE dbo.tAYCetapasRequisitos(
	IdEtapa INT FOREIGN KEY REFERENCES dbo.tAYCetapas(IdEtapa) NOT NULL,
	IdRequisito INT FOREIGN KEY REFERENCES dbo.tDIGrequisitos(IdRequisito) NOT NULL,
	IdEstatus INT DEFAULT 1 NOT NULL
)

Siguiente:
GO

/*
Tipo: Tabla
Objeto: tDIGproductosRequisitos
Resumen: Relación de Requisitos y los productos financieros a los que aplican
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tDIGproductosRequisitos')
BEGIN
	SELECT 'tDIGproductosRequisitos Ya Existe' AS info
	-- DROP TABLE tDIGproductosRequisitos
	GOTO Siguiente
END

CREATE TABLE dbo.tDIGproductosRequisitos(
	IdProductoFinanciero INT NOT NULL,
	IdRequisito INT FOREIGN KEY REFERENCES dbo.tDIGrequisitos(IdRequisito) NOT NULL,
	IdEstatus INT DEFAULT 1 NOT NULL
)

Siguiente:
GO



/*
Tipo: Tabla
Objeto: tDIGexpediente
Resumen: Almacena la relación de una entidad y los archivos de los requisitos de su expediente
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tDIGexpediente')
BEGIN
	SELECT 'tDIGexpediente Ya Existe' AS info
	-- DROP TABLE tDIGexpediente
	GOTO Siguiente
END

CREATE TABLE dbo.tDIGexpediente(
	IdExpediente INT PRIMARY KEY IDENTITY,
	IdTipoDdominio INT NOT NULL CONSTRAINT ck_tipodominio CHECK (IdTipoDdominio IN (208, 232)),
	IdDominio INT NOT NULL,	
	IdRequisito INT FOREIGN KEY REFERENCES dbo.tDIGrequisitos(IdRequisito) NOT NULL,
	ReferenciaDominio VARCHAR(200) NULL,
	IdPersona INT NOT NULL DEFAULT 0,
	IdOperacion INT NOT NULL DEFAULT 0,
	Fecha DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	Alta DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	IdEstatus INT DEFAULT 1  NOT NULL
)

Siguiente:
GO

IF EXISTS(SELECT t.name FROM sys.key_constraints k 
			INNER JOIN sys.tables t ON t.object_id = k.parent_object_id
			WHERE t.name='tDIGexpediente' AND k.name='UK_tDIGexpediente')
BEGIN
	ALTER TABLE [dbo].[tDIGexpediente] DROP CONSTRAINT [UK_tDIGexpediente]
END
GO

ALTER TABLE [dbo].[tDIGexpediente] ADD CONSTRAINT UK_tDIGexpediente UNIQUE NONCLUSTERED 
(
	[IdExpediente] ASC,
	[IdTipoDdominio] ASC,
	[IdDominio] ASC
) ON [PRIMARY]
GO



/*
Tipo: Tabla
Objeto: tDIGarchivos
Resumen: Almacena información de los archivos físicos 
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tDIGarchivos')
BEGIN
	SELECT 'tDIGarchivos Ya Existe' AS info
	-- DROP TABLE tDIGarchivos
	GOTO Siguiente
END

CREATE TABLE dbo.tDIGarchivos(
	IdArchivo INT PRIMARY KEY IDENTITY,
	IdExpediente INT FOREIGN KEY REFERENCES dbo.tDIGexpediente(IdExpediente) NOT NULL,
	IdRequisito INT FOREIGN KEY REFERENCES dbo.tDIGrequisitos(IdRequisito) NOT NULL,
	Nombre VARCHAR(50) NOT NULL UNIQUE,
	Llave VARCHAR(100) NOT NULL UNIQUE,
	Referencia VARCHAR(100) NULL,
	Archivo VARBINARY(max) NOT NULL,
	EsAutogenerado BIT DEFAULT 0 NOT NULL,
	EstaSincronizado BIT DEFAULT 0 NOT NULL,
	Fecha DATE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	Alta DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	IdEstatus INT DEFAULT 1  NOT NULL
)

Siguiente:
GO





/*
Tipo: Tabla
Objeto: tGRLpersonas
Resumen: Personas  
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tGRLpersonas')
BEGIN
	SELECT 'tGRLpersonas Ya Existe' AS info
	-- DROP TABLE tGRLpersonas
	GOTO Siguiente
END

CREATE TABLE dbo.tGRLpersonas(
	[IdPersona] INT PRIMARY KEY IDENTITY,
	[IdentificadorPersona] [varchar](50) UNIQUE NOT NULL,
	[NumeroSocio] [varchar](30) NULL,
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
	[TipoRelacionado] [varchar](50) NULL,
	[IdEstatus] INT DEFAULT 1 NOT NULL
)

Siguiente:
GO


/*
Tipo: Tabla
Objeto: tAYCcuentas
Resumen: Almacena la relación de cuentas de una persona 
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCcuentas')
BEGIN
	SELECT 'tAYCcuentas Ya Existe' AS info
	-- DROP TABLE tAYCcuentas
	GOTO Siguiente
END

CREATE TABLE dbo.tAYCcuentas(
	IdCuenta INT NOT NULL PRIMARY KEY IDENTITY,
	IdPersona INT FOREIGN KEY REFERENCES dbo.tGRLpersonas (IdPersona) NOT NULL,
	NumeroCuenta VARCHAR(30) NOT NULL UNIQUE,
	IdTipoD INT NOT NULL DEFAULT 143,
	Descripcion VARCHAR(30) NOT NULL,
	DescripcionLarga VARCHAR(512) NULL,
	IdEstatus INT DEFAULT 1 NOT NULL
)

Siguiente:
GO
-- Finaliza la sección de definición de tablas


