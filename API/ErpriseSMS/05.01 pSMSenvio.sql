
if exists(select name from sys.objects o where o.name='pSMSenvio')
begin
	drop proc pSMSenvio
	select 'pSMSenvio BORRADO' as info
end
go

create  procedure dbo.pSMSenvio
@pTelefono AS VARCHAR(10)='',
@pMensaje AS NVARCHAR(160)='',
@pRespuesta AS NVARCHAR(MAX) OUTPUT
AS
BEGIN
	/* JCA.17/4/2024.00:26 
	Nota: SP para el consumo de una web api para el envío de mensajes de texto
	Requiere que se hayan configurado las variables de sql para el uso de objetos XML com
	*/
	
	IF @pTelefono='' OR @pMensaje=''
	BEGIN
		SELECT CONCAT('ERROR, Deben proporcionarse ambos parámetros. Teléfono:',@pTelefono,'. Mensaje:',@pMensaje)
		RETURN -1
	END

	DECLARE @Telefono AS VARCHAR(10)=@pTelefono --'2451022064'
	DECLARE @Mensaje AS VARCHAR(160)=@pMensaje --'SMS from SQL SERVER'

	
	/********  JCA.16/4/2024.19:46 Info: Obtener URL de la API  ********/
	DECLARE @vUrlApiSms VARCHAR(512);
	EXEC dbo.pObtenerValorConfiguracion @IdConfiguracion = 1645,  @IdSucursal = 0, @Valor = @vUrlApiSms OUTPUT 

	/*!! TODO !! JCA:16/4/2024.19:53 QUITAR LA SIGUIENTE LÍNEA YA QUE USA EL SERVICIO DE DR ARROYO y descomentar la 31 */
	--DECLARE @url VARCHAR(1000) = CONCAT('http://74.208.85.113:367/ErpriseSMS/',@Telefono,'/',@Mensaje);
	DECLARE @url VARCHAR(1000) = CONCAT(@vUrlApiSms,@Telefono,'/',@Mensaje);

    DECLARE @ResponseText as table(Json_Table nvarchar(max))
	Declare @Object as Int;
   
    Exec sp_OACreate 'MSXML2.ServerXMLHTTP.6.0', @Object OUT;  
	Exec sp_OAMethod @Object, 'open', NULL, 'get', @url,'false'
	Exec sp_OAMethod @Object, 'send'

	INSERT into @ResponseText (Json_Table) 
	exec sp_OAGetProperty @Object, 'responseText'

	Exec sp_OADestroy @Object

    set @pRespuesta=(select top 1 Json_Table from @ResponseText)
	
	return 0
END;
GO





