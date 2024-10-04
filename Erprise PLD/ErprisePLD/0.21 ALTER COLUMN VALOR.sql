

/* INFO (?_?) JCA.11/01/2024.06:12 p. m. 
Nota: Modificación del tamaño del campo Valor, anteriormente estaba en 10, 
pero empezó a generar un error de desbordamiento cuando se insertaban cantidades muy grandes.
*/

ALTER TABLE dbo.tPLDmatrizEvaluacionesRiesgoCalificaciones
	ALTER COLUMN Valor VARCHAR(21)
GO


