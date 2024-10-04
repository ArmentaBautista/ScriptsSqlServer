
SELECT * FROM dbo.tCTLconsultas c WHERE c.IdConsulta=522
SELECT * FROM dbo.tCTLrecursos r  WHERE r.IdRecurso=1118

/* @^..^@   JCA.30/01/2024.11:35 p. m. Nota: Fix de descripción de Consulta   */
UPDATE c 
SET c.Descripcion='Operaciones de Socios de Alto Riesgo y PEP',
c.TituloVentana='Operaciones de Socios de Alto Riesgo y PEP'
FROM dbo.tCTLconsultas c WHERE c.IdConsulta=522
GO
/*--*/


/* @^..^@   JCA.30/01/2024.11:35 p. m. Nota: Fix de descripción del Recurso   */
UPDATE r
SET r.Descripcion='Operaciones de Socios de Alto Riesgo y PEP',
r.DescripcionLarga='Operaciones de Socios de Alto Riesgo y PEP'
FROM dbo.tCTLrecursos r  WHERE r.IdRecurso=1118
GO
/*--*/

