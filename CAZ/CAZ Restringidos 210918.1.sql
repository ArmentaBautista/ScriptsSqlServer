



/*
Cambiar a varchar pues era de tipo entero y para la tablas con llaves compuestas no permitia grabar más de un número
*/

ALTER TABLE dbo.tAYCsociosRestringidos
	ADD Fecha DATE DEFAULT CURRENT_TIMESTAMP
GO
