





exec dbo.pPLDdeteccionInusualidades



DECLARE @Fecha AS DATE=cast(DATEADD(DAY,-1,GETDATE()) AS date)
EXECUTE dbo.pPLDrepotarInusualidad @fecha = @Fecha
