


DECLARE @nombreTabla AS VARCHAR(256)='tgrlpersonas'


DECLARE @script1 AS VARCHAR(max)='';
DECLARE @script2 AS VARCHAR(max)='';

SET @script1= 'IF EXISTS(SELECT t.name FROM sys.triggers t WHERE t.name=''trBitacora_' + @nombreTabla + ''')
				DROP TRIGGER dbo.trBitacora_' + @nombreTabla + ';
			  '

SET @script2='
		CREATE TRIGGER [dbo].[trBitacora_' + @nombreTabla + '] ON [dbo].[' + @nombreTabla + ']
		FOR UPDATE
		AS
		BEGIN
				declare @UserName varchar(128),@Host varchar (64),@IP varchar(16),@ApplicationName varchar(64),@IdSesion INT,@UpdateDate varchar(21)

				SELECT @Host = s.host_name, @IP = c.client_net_address, @ApplicationName = s.program_name
					FROM sys.dm_exec_connections c
					JOIN sys.dm_exec_sessions    s ON c.session_id = s.session_id
					WHERE c.session_id = @@SPID;
	
					SET @IdSesion = TRY_PARSE(@ApplicationName AS INT) 
					IF @IdSesion IS NULL 
						SET @IdSesion = 0

				--- Fecha y Usuario
				SELECT @UserName=system_user, @UpdateDate=convert(varchar(8),getdate(), 112) + convert(varchar(12),getdate(), 114)'

/* Update de Campos de Tabla */
DECLARE @nombreColumna VARCHAR(256)

DECLARE CUR_BITACORA_CAMBIOS CURSOR FAST_FORWARD READ_ONLY FOR 
												SELECT c.name
												FROM sys.tables t  WITH(nolock) 
												INNER JOIN sys.columns c  WITH(nolock) ON c.object_id = t.object_id
												WHERE t.name=@nombreTabla

OPEN CUR_BITACORA_CAMBIOS

FETCH NEXT FROM CUR_BITACORA_CAMBIOS INTO @nombreColumna

WHILE @@FETCH_STATUS = 0
BEGIN
    
SET @script2 = @script2 + ' 
							IF UPDATE ('+ @nombreColumna + ') AND ( CONVERT(varchar(1000), (SELECT '+ @nombreColumna + ' FROM deleted) ) <> CONVERT(varchar(1000), (SELECT '+ @nombreColumna + ' FROM inserted ) ))
							BEGIN 
							INSERT tCTLbitacoraCambios (TipoTrn, Tabla, Campo, ValorOriginal, ValorNuevo, FechaTrn, Usuario, Host, IP, ApplicationName, IdSesion) 
							SELECT ''U'',''' + @nombreTabla + ''','''+ @nombreColumna + ''',CONVERT(varchar(1000), (SELECT '+ @nombreColumna + ' FROM deleted) ), CONVERT(varchar(1000), (SELECT '+ @nombreColumna + ' FROM inserted ) ), GETDATE(), @UserName , @Host, @IP ,@ApplicationName,0
							END'
    FETCH NEXT FROM CUR_BITACORA_CAMBIOS INTO @nombreColumna
END

CLOSE CUR_BITACORA_CAMBIOS
DEALLOCATE CUR_BITACORA_CAMBIOS

SET @script2 = @script2 + '
END'

EXEC (@script1)
EXEC (@script2)

PRINT (@script1)
PRINT (@script2)
