

/*---[IdObjeto - 189708] [orden - 81]-----
Usuario: Janethh Roque Juarez
Fecha: Feb  1 2024  7:52PM
--------------------------------------*/
IF NOT EXISTS(SELECT * FROM sys.columns c WHERE name='MontoDepositos' AND c.object_id=OBJECT_ID('tSCSpersonasSocioeconomicos'))
BEGIN
	ALTER TABLE dbo.tSCSpersonasSocioeconomicos ADD MontoDepositos NUMERIC(18,2) DEFAULT 0 
END

IF NOT EXISTS(SELECT * FROM sys.columns c WHERE name='MontoRetiros' AND c.object_id=OBJECT_ID('tSCSpersonasSocioeconomicos'))
BEGIN
	ALTER TABLE dbo.tSCSpersonasSocioeconomicos ADD MontoRetiros NUMERIC(18,2) DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns c WHERE name='NumeroDepositos' AND c.object_id=OBJECT_ID('tSCSpersonasSocioeconomicos'))
BEGIN
	ALTER TABLE dbo.tSCSpersonasSocioeconomicos ADD NumeroDepositos int DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns c WHERE name='NumeroRetiros' AND c.object_id=OBJECT_ID('tSCSpersonasSocioeconomicos'))
BEGIN
	ALTER TABLE dbo.tSCSpersonasSocioeconomicos ADD NumeroRetiros int DEFAULT 0
END 
 GO
GO



