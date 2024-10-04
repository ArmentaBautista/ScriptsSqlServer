

DECLARE @baseDatos AS NVARCHAR(50)='iERP_CAZ_REG';
DECLARE @nombreRespaldo AS NVARCHAR(50);
DECLARE @scriptRespaldo AS NVARCHAR(max)

SET @nombreRespaldo=CONCAT('E:\BD_Backup\',@baseDatos,'_',FORMAT(GETDATE(),'yyyyMMdd.hhmm'),'.bak')

SET @scriptRespaldo=CONCAT('BACKUP DATABASE ', @baseDatos,' TO DISK =','''', @nombreRespaldo , '''')
--PRINT @scriptRespaldo

EXEC sys.sp_executesql @scriptRespaldo
