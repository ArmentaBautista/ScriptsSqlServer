


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnLSTprimerTelefonoCelular')
BEGIN
	DROP FUNCTION dbo.fnLSTprimerTelefonoCelular
	SELECT 'fnLSTprimerTelefonoCelular BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnLSTprimerTelefonoCelular()
RETURNS TABLE
RETURN (
	SELECT * 
	FROM (
			SELECT  
			Numero= ROW_NUMBER() OVER(PARTITION BY cel.IdRel ORDER BY  cel.IdTelefono DESC)
			, cel.IdRel
			, cel.Telefono
			FROM dbo.tCATtelefonos cel  WITH(nolock) 
			INNER JOIN dbo.tCTLestatusActual ea1  WITH(nolock) 
				ON ea1.IdEstatusActual = cel.IdEstatusActual 
					AND ea1.IdEstatus=1
			WHERE cel.IdListaD=-1339
	) AS tel
	WHERE Numero=1
)