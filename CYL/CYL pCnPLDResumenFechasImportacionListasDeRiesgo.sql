

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDResumenFechasImportacionListasDeRiesgo')
BEGIN
	DROP PROC pCnPLDResumenFechasImportacionListasDeRiesgo
	SELECT 'pCnPLDResumenFechasImportacionListasDeRiesgo BORRADO' AS info
END
GO

CREATE PROC pCnPLDResumenFechasImportacionListasDeRiesgo
AS
BEGIN

		select 
		DATEPART(YEAR, lb.Alta) AS Año,
		DATEPART(MONTH, lb.Alta) AS Mes, 
		DATEPART(DAY, lb.Alta) AS Dia,
		t.Descripcion AS Tipo1, 
		tl.Descripcion AS Tipo2, 
		COUNT(1) AS Num 
		FROM tPLDlistasBloqueadas lb with(nolock)
		INNER JOIN dbo.tCTLtiposD t  WITH(NOLOCK) 
			ON t.IdTipoD = lb.IdTipoDlistaBloqueada 
		INNER JOIN dbo.tCTLtiposD tl  WITH(NOLOCK) 
			ON tl.IdTipoD = lb.IdTipoDListaPLD 
		GROUP BY DATEPART(YEAR, lb.Alta), DATEPART(MONTH, lb.Alta), DATEPART(DAY, lb.Alta), t.Descripcion, tl.Descripcion 
		ORDER BY Año DESC, Mes DESC, Dia DESC

END
GO

