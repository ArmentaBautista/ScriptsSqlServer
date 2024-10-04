


DECLARE @RETURN_MESSAGE VARCHAR(MAX);
EXEC dbo.pSMScobranzaFNG @pDebug = 1,                           -- bit
                         @RETURN_MESSAGE = @RETURN_MESSAGE OUTPUT, -- varchar(max)
                         @pReemplazarTelefono = 1,              -- bit
                         @pTelefonoReemplazo = N'2451022064',                -- nvarchar(10)
                         @pLimiteDeResultados = 10 ,                  -- int
						 @pNoMandarSMS = 0

SELECT @RETURN_MESSAGE



SELECT
    sms.Fecha,
    count(1)
FROM dbo.tSMScobranzaEnviados sms WITH (NOLOCK)
GROUP BY Fecha


SELECT
    *
FROM dbo.tSMScobranzaEnviados sms WITH (NOLOCK)
WHERE Fecha='20240925'

-- TRUNCATE TABLE dbo.tSMScobranzaEnviados


DECLARE @fecha AS DATE=getdate()
declare @m as nvarchar(160)
declare @r as nvarchar(max)=''
declare @mensajesenviados as int
select @mensajesenviados=COUNT(1) from dbo.tSMScobranzaEnviados m  WITH(NOLOCK) where m.Fecha=@fecha

SET @m=concat_ws(' ',try_cast(@mensajesenviados as varchar(5)),' mensajes de cobranza enviados el ',convert(varchar, @fecha,5))

exec dbo.pSMSenvio '2451022064',@m,@r output
GO



declare @r as nvarchar(max)=''
exec dbo.pSMSenvio '2451022064','Prueba',@r output


EXEC master..SP_DBA
