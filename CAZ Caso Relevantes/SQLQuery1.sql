
SELECT Domicilio, * FROM dbo.tPLDoperacionesRelavantes
WHERE RFC IN ('CTE160926MF6')

SELECT Domicilio, * FROM dbo.tPLDoperacionesRelavantes WHERE IdPeriodo=396

EXEC dbo.pPLDeliminarAcentosCaracteresEspecialesEnReportes @TipoOperacion = 'REL-XLS', -- varchar(20)
                                                           @IdPeriodo = 396       -- int


DELETE FROM dbo.tPLDoperacionesRelavantes WHERE IdPeriodo=396 AND Id<>18704
