
USE iERP_CPA
GO


IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tAYClineasCredito')
BEGIN
	DROP TABLE tAYClineasCredito
END
GO

CREATE TABLE tAYClineasCredito
(
	Id			INT IDENTITY PRIMARY KEY,
	Concepto	VARCHAR(32) NULL,
	Referencia	VARCHAR(32) NULL,
	Monto		MONEY null,
	Vigencia	DATE NULL,
	IdEstatus	INT FOREIGN KEY REFERENCES dbo.tCTLestatus (IdEstatus),
	Alta		DATETIME DEFAULT CURRENT_TIMESTAMP,
	IdSocio		INT FOREIGN KEY REFERENCES dbo.tSCSsocios (IdSocio)
)

GO

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tAYCcuentasRevolventes')
BEGIN
	DROP TABLE tAYCcuentasRevolventes
END
GO

CREATE TABLE tAYCcuentasRevolventes
(
	IdCuenta			INT PRIMARY KEY IDENTITY,
	IdLineaCredito		INT FOREIGN KEY REFERENCES tAYClineasCredito(Id) NULL,
	NoCuenta			VARCHAR(32) NOT NULL,
	Fecha				DATE NULL,
	FechaCorte
	Monto				MONEY,
	TasaIO				NUMERIC(5,3),
	IdEstatus			INT	FOREIGN KEY REFERENCES dbo.tCTLestatus(IdEstatus) NULL
)
GO

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tSDOsaldosCuentas')
BEGIN
	DROP TABLE tSDOsaldosCuentas
END
GO

CREATE TABLE tSDOsaldosCuentas
(
	IdSaldo			INT IDENTITY PRIMARY KEY,
	IdCuenta		INT FOREIGN KEY REFERENCES tAYCcuentasRevolventes(IdCuenta),

)
GO