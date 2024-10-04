

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCTLenviarMail')
BEGIN
	DROP PROC pCTLenviarMail
	SELECT 'pCTLenviarMail BORRADO' AS info
END
GO

CREATE PROC pCTLenviarMail
	@perfil AS VARCHAR(50)='MailServDev',
	@destinatario AS VARCHAR(MAX)='desarrollo@intelix.mx',
	@Cc AS VARCHAR(MAX)='',
	@Cco AS VARCHAR(MAX)='',
	@asunto AS VARCHAR(500)='',
	@cuerpo AS NVARCHAR(max)=''
AS
BEGIN
	EXEC msdb.dbo.sp_send_dbmail @profile_name=@perfil,
                    @recipients=@destinatario,
                    @subject=@asunto,
					@body_format = 'HTML',
                    @body=@cuerpo,
					@copy_recipients = @Cc,
					@blind_copy_recipients = @Cco
END
GO