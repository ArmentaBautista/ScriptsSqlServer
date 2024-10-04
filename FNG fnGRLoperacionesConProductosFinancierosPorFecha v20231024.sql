


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnGRLoperacionesConProductosFinancierosPorFecha')
BEGIN
	DROP FUNCTION fnGRLoperacionesConProductosFinancierosPorFecha
	SELECT 'fnGRLoperacionesConProductosFinancierosPorFecha BORRADO' AS info
END
GO

CREATE FUNCTION fnGRLoperacionesConProductosFinancierosPorFecha
(@pFechaInicial DATE,
@pFechaFinal DATE)
RETURNS TABLE
RETURN(
	SELECT o.IdOperacion
	FROM dbo.tGRLoperaciones o  WITH(NOLOCK)  
	WHERE o.IdTipoOperacion NOT IN (25,507,506,38,49)
		AND o.Fecha BETWEEN @pFechaInicial AND @pFechaFinal
)
GO