
USE iERP_BI
GO

/*

DECLARE @IdEmpresa AS INT=2
DECLARE @RfcCliente AS VARCHAR(15)
SET @RfcCliente=(SELECT rfc FROM dbo.tBSIempresas e  WITH(nolock) WHERE e.IdEmpresa=@IdEmpresa)

PRINT @RfcCliente

-- Encabezado
INSERT INTO dbo.tBIinstruccionesE (IdEmpresa,RFC,Descripcion,Periodicidad,IdEstatus)
VALUES (@IdEmpresa, @RfcCliente,'Estadisticos Cierre de Mes', 1,    1)

DECLARE @IdInstruccionE AS INT
SELECT @IdInstruccionE=e.IdInstruccionE FROM dbo.tBIinstruccionesE e  WITH(nolock) WHERE e.IdEmpresa=@IdEmpresa AND e.RFC=@RfcCliente

-- Detalle

INSERT INTO dbo.tBIinstruccionesD (IdInstruccionE,Descripcion,BDprincipal,BDejecucion,Instruccion,TablaDestino)
VALUES
(   @IdInstruccionE,  -- IdInstruccionE - int
	'Catálogo Mínimo FNG', -- Descripción
    'iERP_FNG', -- BDprincipal - varchar(32)
    'iERP_FNG_REG', -- BDejecucion - varchar(32)
    'DECLARE @periodo AS VARCHAR(6)=CONCAT(DATEPART(YYYY,GETDATE()),DATEPART(MM,GETDATE()-30))

	SELECT catmin.id,
		   catmin.IdPeriodo,
		   catmin.IdCatalogoSITI,
		   2 AS IdEmpresa,
		   catmin.Concepto,
		   catmin.Descripcion,
		   catmin.Orden,
		   catmin.Nivel,
		   catmin.Fila,
		   catmin.OrdenR01
	FROM dbo.tSITcatalogoMinimo catmin 
	JOIN dbo.tSITperiodos per ON per.IdPeriodo = catmin.IdPeriodo
	WHERE per.Periodo = @periodo', -- Instruccion - varchar(max)
	'tSITcatalogoMinimo' -- TablaDestino - varchar(256)
    )




INSERT INTO  dbo.tBIinstruccionesD (IdInstruccionE,Descripcion,BDprincipal,BDejecucion,Instruccion,TablaDestino)
VALUES
(   @IdInstruccionE,  -- IdInstruccionE - int
	'Catálogo Mínimo Saldos FNG', -- Descripción
    'iERP_FNG', -- BDprincipal - varchar(32)
    'iERP_FNG_REG', -- BDejecucion - varchar(32)
    'DECLARE @periodo AS VARCHAR(6)=CONCAT(DATEPART(YYYY,GETDATE()),DATEPART(MM,GETDATE()-30))

	SELECT IdPeriodo,
       IdCatalogoSITI,
       Periodo,
          2 AS IdEmpresa,
       Importe,
       Saldo,
       IdSucursal
	FROM dbo.tSITcatalogoMinimoSaldosFinancieros
	WHERE Periodo = @periodo', -- Instruccion - varchar(max)
	'tSITcatalogoMinimoSaldos' -- TablaDestino - varchar(256)
    )





INSERT INTO  dbo.tBIinstruccionesD (IdInstruccionE,Descripcion,BDprincipal,BDejecucion,Instruccion,TablaDestino)
VALUES
(   @IdInstruccionE,  -- IdInstruccionE - int
	'Sucursales FNG', -- Descripcion
    'iERP_FNG', -- BDprincipal - varchar(32)
    'iERP_FNG', -- BDejecucion - varchar(32)
    'DECLARE @periodo AS VARCHAR(6)=CONCAT(DATEPART(YYYY,GETDATE()),DATEPART(MM,GETDATE()-30))

			SELECT 2 AS IdEmpresa,
             idSucursal,
              @periodo AS Periodo,
             s.Codigo,
             s.Descripcion
			FROM dbo.tCTLsucursales s JOIN dbo.tCTLestatusActual e ON e.IdEstatusActual = s.IdEstatusActual
			WHERE e.IdEstatus = 1', -- Instruccion - varchar(max)
	'tBSIsucursales' -- TablaDestino - varchar(256)
    )

*/

SELECT E.IdInstruccionE, E.RFC,E.Periodicidad, E.IdEmpresa, D.IdInstruccionD, D.Descripcion, D.BDprincipal, D.BDejecucion, D.Instruccion, D.TablaDestino
FROM dbo.tBIinstruccionesE E  WITH(nolock) 
INNER JOIN  dbo.tBIinstruccionesD D  WITH(nolock) ON D.IdInstruccionE = E.IdInstruccionE
WHERE e.IdEstatus=1 AND d.IdEstatus=1 AND E.RFC='APF000121RU7'



SELECT *
FROM dbo.tBSIempresas e
WHERE e.IdEmpresa=2










