
/* INFO (⊙_☉) JCA.07/12/2023.12:09 p. m. 
Nota: Script integral para la generación de saldos diarios de captación
		Entre otras cosas se puede usar para calcular el saldo promedio
		Historicos de Saldos de Captación
		Estados de cuanta de Ahorro de BKG
		Estadistivos de FNG, etc
		El proceso consiste en :
		1. una tabla para los datos diarios
		2. un sp que inserta los datos en la tabla
		3. un job que ejecuta diariamente el sp
*/



/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= 
Tabla 
=^..^=  */
IF DB_NAME()<>'MSDB'
BEGIN 
	IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCcaptacion')
	BEGIN
		-- DROP TABLE tAYCcaptacion
	
		CREATE TABLE [dbo].[tAYCcaptacion](
			[Fecha]								DATE,
			IdTipoDproducto						INT,
			[IdCuenta]							[int] NOT NULL,
			[IdSaldo]							[INT] NOT NULL,
			[Capital]							[NUMERIC](25, 8) NULL,
			[InteresOrdinario]					[NUMERIC](25, 8) NULL,
			[InteresPendienteCapitalizar]		[NUMERIC](23, 8) NOT NULL,
			[MontoBloqueado]					[NUMERIC](23, 8) NOT NULL,
			[MontoDisponible]					[NUMERIC](38, 8) NULL,
			[Saldo]								[NUMERIC](38, 8) NULL,
			[SaldoBalanceCuentasOrden]			[NUMERIC](38, 8) NULL,
			[IdEstatus]							[INT] NOT NULL,
			[Alta]								DATETIME
		)
		SELECT 'OBJETO tAYCcaptacion Creado' AS info
	END
	SELECT 'OBJETO tAYCcaptacion Existente' AS info

	IF NOT EXISTS(SELECT 1
					FROM sys.indexes i 
					WHERE i.name='IX_tAYCcaptacion_Fecha' 
						AND i.object_id=OBJECT_ID('tAYCcaptacion'))
	BEGIN
		CREATE NONCLUSTERED INDEX IX_tAYCcaptacion_Fecha
		ON [dbo].[tAYCcaptacion] (Fecha DESC)

		SELECT 'Indice creado IX_tAYCcaptacion_Fecha' AS info
	END
END
GO
 
 /* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= 
  SP
 =^..^=  */
IF DB_NAME()<>'MSDB'
BEGIN 
		DECLARE @sql AS NVARCHAR(max)='	
			IF EXISTS(SELECT name FROM sys.objects o WHERE o.name=''pAYCcaptacion'')
			BEGIN
				DROP PROC pAYCcaptacion
				SELECT ''pAYCcaptacion BORRADO'' AS info
			END
		'

		EXEC sys.sp_executesql @sql
 
		SET @sql ='
					CREATE PROC pAYCcaptacion
					AS
					BEGIN
	
						DECLARE @fecha AS DATE=DATEADD(DAY,-1,GETDATE());
						DECLARE @alta AS DATETIME=GETDATE();
	
						IF EXISTS(SELECT 1 FROM tAYCcaptacion c  WITH(NOLOCK) WHERE c.fecha=@fecha)
							DELETE FROM dbo.tAYCcaptacion WHERE fecha=@fecha


						INSERT INTO dbo.tAYCcaptacion
						(
							Fecha,
							IdTipoDproducto,
							IdCuenta,
							IdSaldo,
							Capital,
							InteresOrdinario,
							InteresPendienteCapitalizar,
							MontoBloqueado,
							MontoDisponible,
							Saldo,
							SaldoBalanceCuentasOrden,
							IdEstatus,
							Alta
						)
						SELECT @fecha,
							   c.IdTipoDProducto,
							   sdo.IdCuenta,
							   sdo.IdSaldo,
							   sdo.Capital,
							   sdo.InteresOrdinario,
							   sdo.InteresPendienteCapitalizar,
							   sdo.MontoBloqueado,
							   sdo.MontoDisponible,
							   sdo.Saldo,
							   sdo.SaldoBalanceCuentasOrden,
							   sdo.IdEstatus,
							   @alta
						FROM dbo.fAYCsaldo(0) sdo 
						INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = sdo.IdCuenta 
						AND c.IdTipoDProducto IN (144,398,716,1570,2196,2621)
						WHERE sdo.IdCuenta<>0
	
					END'
		EXEC sys.sp_executesql @sql
END
GO



/* @^•ﻌ•^@ @^•ﻌ^@   JCA.07/12/2023.12:38 p. m. Nota: JOB   */
USE [msdb]
GO

IF EXISTS(SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'jCaptacion')
	GOTO FIN

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
	EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'jCaptacion', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Ejecuta la inserción de los saldos diarios de las cuentas de Captación.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'su', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

/****** Object:  Step [GenerarCaptacionDiaria]    Script Date: 23/02/2023 11:58:17 p. m. ******/
DECLARE @bd AS VARCHAR(24);
SELECT TOP 1 @bd=b.name  FROM sys.databases b WHERE b.name LIKE 'iERP____'

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'InsertarSaldosCaptacionDiaria', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
exec pAYCcaptacion
', 
		@database_name=@bd, 
		@flags=0

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

DECLARE @uid AS UNIQUEIDENTIFIER
SET @uid = NEWID();

EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'GenerarCaptacionDiaria', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20230223, 
		@active_end_date=99991231, 
		@active_start_time=1, 
		@active_end_time=235959, 
		@schedule_uid=@uid --N'd5a72477-47f7-48a9-a78b-e4f40f9a23a0'

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

COMMIT TRANSACTION

GOTO EndSave

QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION

SELECT 'JOB YA EXISTE'

EndSave:
SELECT 'JOB CREADO'
FIN:

GO