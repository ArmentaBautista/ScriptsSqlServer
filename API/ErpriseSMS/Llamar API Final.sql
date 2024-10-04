


declare @Numero as varchar(10)='7731106131'
	declare @Mensaje as varchar(200)='SMS from SQL SERVER'

    --DECLARE @url VARCHAR(1000) = 'https://random-data-api.com/api/v2/users'
	DECLARE @url VARCHAR(1000) = concat('http://10.10.10.3:8081/ErpriseSMS/',@Numero,'/',@Mensaje);
    DECLARE @ResponseText as table(Json_Table nvarchar(max))
	Declare @Object as Int;
   
   Exec sp_OACreate 'MSXML2.ServerXMLHTTP.6.0', @Object OUT;
   /*
	Exec sp_OAMethod @Object, 'open', NULL, 'get',
					 'https://random-data-api.com/api/v2/users/', --Your Web Service Url (invoked)
					 'false'
*/
	Exec sp_OAMethod @Object, 'open', NULL, 'get', @url,'false'

	Exec sp_OAMethod @Object, 'send'

	--Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

	--SELECT * from @ResponseText;

	INSERT into @ResponseText (Json_Table) exec sp_OAGetProperty @Object, 'responseText'

	Exec sp_OADestroy @Object

    -- Hacer lo que necesites con la respuesta de la Web API
    SELECT * from @ResponseText;
