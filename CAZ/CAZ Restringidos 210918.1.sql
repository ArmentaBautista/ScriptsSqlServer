



/*
Cambiar a varchar pues era de tipo entero y para la tablas con llaves compuestas no permitia grabar m�s de un n�mero
*/

ALTER TABLE dbo.tAYCsociosRestringidos
	ADD Fecha DATE DEFAULT CURRENT_TIMESTAMP
GO
