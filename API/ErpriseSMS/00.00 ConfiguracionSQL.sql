

sp_configure 'show advanced options', 1 
GO 
RECONFIGURE; 
GO 
sp_configure 'Ole Automation Procedures', 1 
GO 
RECONFIGURE; 
GO 
sp_configure 'show advanced options', 1 
GO 
RECONFIGURE;

/* JCA.16/4/2024.17:39 
Nota: SCRIPT para activar el consumo de web api desde SP's, preferentemente debe ejecutarse en una actualización de versión
*/
BEGIN

	DECLARE @tConfig AS TABLE([name] VARCHAR(50),[minimum] INT,[maximun] INT, config_value INT, run_value INT)

	INSERT @tConfig
	EXEC sp_configure 'Ole Automation Procedures'

	IF EXISTS(SELECT 1 FROM @tConfig c WHERE c.run_value=0)
	BEGIN
		EXEC sp_configure 'Ole Automation Procedures', 1;
		RECONFIGURE

		SELECT 'Parámetro cambiado' AS Info
		EXEC sp_configure 'Ole Automation Procedures'
	END
	ELSE
	BEGIN
		SELECT 'El Parámetro ya estaba configurado' AS Info
	END

END
GO
