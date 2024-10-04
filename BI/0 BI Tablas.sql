
USE iERP_BI
GO

-- TABLA DE ENCABEZADO DE INSTRUCCIONES
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tBIinstruccionesE')
BEGIN
	-- DROP TABLE tBIinstruccionesE
	GOTO tBIinstruccionesE_creada
END


CREATE TABLE tBIinstruccionesE(
	IdInstruccionE INT PRIMARY KEY IDENTITY,
	IdEmpresa INT NOT NULL,
	RFC	VARCHAR(14) NULL,
	Descripcion VARCHAR(256) NULL,
	Periodicidad INT DEFAULT 1, -- 1 Mensual, 2 Semanal, 3 Diaria
	IdEstatus INT DEFAULT 1,
	Alta DATE DEFAULT CURRENT_TIMESTAMP
)


-- Existe o fue creada la tabla de encabezados
tBIinstruccionesE_creada:


-- TABLA DE DETALLE DE INSTRUCCIONES
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tBIinstruccionesD')
BEGIN
	-- DROP TABLE tBIinstruccionesD
	GOTO tBIinstruccionesD_creada
END


CREATE TABLE tBIinstruccionesD(
	IdInstruccionD INT PRIMARY KEY IDENTITY,
	IdInstruccionE INT FOREIGN KEY REFERENCES  tBIinstruccionesE(IdInstruccionE),
	Descripcion VARCHAR(256) NULL,
	BDprincipal VARCHAR(32) NULL,
	BDejecucion VARCHAR(32) NULL,
	Instruccion VARCHAR(max) NULL,
	TablaDestino VARCHAR(256) NULL,
	Periodo VARCHAR(6) NULL,
	IdEstatus INT DEFAULT 1
)


-- Existe o fue creada la tabla de detalles
tBIinstruccionesD_creada:

/*
--
-- STORED PROCEDURES
--
*/

-- OBTIENE LAS INSTRUCCIONES DE CADA CLIENTE BASANDOSE EN SU RFC, SOLO OBTIENE LAS ACTIVAS, TANTO CLIENTES COMO INSTRUCCIONES DETALLADAS
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pBIobtenerInstruccionesCliente')
BEGIN
	DROP PROC pBIobtenerInstruccionesCliente
END
GO

CREATE PROC pBIobtenerInstruccionesCliente
@RFC VARCHAR(14)
AS
	SELECT E.IdInstruccionE, E.RFC,E.Periodicidad, D.IdInstruccionD, D.Descripcion, D.BDprincipal, D.BDejecucion, D.Instruccion, D.TablaDestino
	FROM dbo.tBIinstruccionesE E  WITH(nolock) 
	INNER JOIN  dbo.tBIinstruccionesD D  WITH(nolock) ON D.IdInstruccionE = E.IdInstruccionE
	WHERE e.IdEstatus=1 AND d.IdEstatus=1 AND E.RFC=@rfc










