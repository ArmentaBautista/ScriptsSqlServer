

USE iERP_BI
GO

-- VALIDACIÓN DE EXISTENCIA
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='tCTLperiodidadesEjecucion')
BEGIN
	-- DROP TABLE tCTLperiodidadesEjecucion
	SELECT 'TABLA tCTLperiodidadesEjecucion YA EXISTE'
	GOTO TABLA_YA_EXISTE
END


CREATE TABLE dbo.tCTLperiodidadesEjecucion(
	IdPeriodicidad INT PRIMARY KEY  NOT NULL,
	Codigo CHAR(10) NOT NULL,
	Descripcion VARCHAR(30) NOT NULL,
	IdEstatus INT DEFAULT 1 NOT NULL,
	Alta DATE DEFAULT CURRENT_TIMESTAMP NOT NULL
)

SELECT 'TABLA tCTLperiodidadesEjecucion CREADA'

-- Existe o fue creada la tabla de encabezados
TABLA_YA_EXISTE:

--- INSERTS

BEGIN TRY  
     INSERT INTO dbo.tCTLperiodidadesEjecucion (IdPeriodicidad,Codigo,Descripcion,IdEstatus,Alta)
     VALUES
     (   1,        -- IdPeriodicidad - int
         'CUSTOM',       -- Codigo - char(6)
         'PERSONALIZADO',       -- Descripcion - varchar(30)
         1,        -- IdEstatus - int
         GETDATE() -- Alta - date
         )
END TRY  
BEGIN CATCH  
     SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_STATE() AS ErrorState, ERROR_SEVERITY() AS ErrorSeverity, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

BEGIN TRY  
     INSERT INTO dbo.tCTLperiodidadesEjecucion (IdPeriodicidad,Codigo,Descripcion,IdEstatus,Alta)
     VALUES
     (   2,        -- IdPeriodicidad - int
         'DAILY',       -- Codigo - char(6)
         'TODOS LOS DÍAS L-D',       -- Descripcion - varchar(30)
         1,        -- IdEstatus - int
         GETDATE() -- Alta - date
         )
END TRY  
BEGIN CATCH  
     SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_STATE() AS ErrorState, ERROR_SEVERITY() AS ErrorSeverity, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

BEGIN TRY  
     INSERT INTO dbo.tCTLperiodidadesEjecucion (IdPeriodicidad,Codigo,Descripcion,IdEstatus,Alta)
     VALUES
     (   3,        -- IdPeriodicidad - int
         'MONTHLY',       -- Codigo - char(6)
         'UN DÍA DE CADA MES',       -- Descripcion - varchar(30)
         1,        -- IdEstatus - int
         GETDATE() -- Alta - date
         )
END TRY  
BEGIN CATCH  
     SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_STATE() AS ErrorState, ERROR_SEVERITY() AS ErrorSeverity, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

-- VALORES INSERTADOS

SELECT * FROM dbo.tCTLperiodidadesEjecucion
