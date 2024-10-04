
/*

sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;

*/

DECLARE @Object as Int;
DECLARE @ResponseText as Varchar(8000);
DECLARE @Url as Varchar(1000);

EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'get',
                 'http://ws.cdyne.com/NotifyWS/phonenotify.asmx/GetVersion',
                 --'http://www.webservicex.net/globalweather.asmx/GetWeather?CityName=Seattle&CountryName=United+States',
                 --'http://www.webservicex.net/CurrencyConvertor.asmx/ConversionRate?FromCurrency=USD&ToCurrency=EUR',
                 'false'
EXEC sp_OAMethod @Object, 'send'
EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

SELECT @ResponseText

EXEC sp_OADestroy @Object

