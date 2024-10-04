




-- exec dbo.plstMensajesDeCobranzaPreventiva
SELECT ''

DECLARE @IdCuenta	INT=0
DECLARE @Telefono	VARCHAR(10)='7731057625'
DECLARE @Mensaje	VARCHAR(MAX)='PAGUE YA!'
DECLARE @resp AS NVARCHAR(MAX)

EXEC dbo.pSMSenvio @Telefono,@Mensaje,@resp OUTPUT

SELECT @resp

--insert into dbo.tSMScobranzaEnviados (Telefono,Respuesta, IdCuenta, Mensaje) 
--values (@Telefono,@resp,@IdCuenta,@Mensaje)



--  truncate table dbo.tSMScobranzaEnviados

/*
EXEC dbo.pSMScobranzaDRA @pDebug = 1              -- bit
                       , @pReemplazarTelefono = 1 -- bit
                       , @pTelefonoReemplazo = N'2451022064'   -- nvarchar(10)
                       , @pLimiteDeResultados = 11    -- int



SELECT * FROM dbo.tSMScobranzaEnviados  WITH(NOLOCK) WHERE Fecha='20240301'
*/



