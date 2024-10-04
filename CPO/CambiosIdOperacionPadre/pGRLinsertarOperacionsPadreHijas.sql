

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGRLinsertarOperacionsPadreHijas')
BEGIN
	DROP PROC pGRLinsertarOperacionsPadreHijas
	SELECT 'pGRLinsertarOperacionsPadreHijas BORRADO' AS info
END
GO

CREATE PROC pGRLinsertarOperacionsPadreHijas
@idOperacion AS INT,
@idOperacionPadre AS INT,
@RelOperaciones AS INT,
@RelOperacionesD AS INT,
@RelTransacciones AS INT,
@RelTransaccionesFinancieras AS INT
AS
BEGIN

	INSERT dbo.tGRLoperacionesPadreHijas
	(
	    IdOperacion,
	    IdOperacionPadre,
	    RelOperaciones,
	    RelOperacionesD,
	    RelTransacciones,
	    RelTransaccionesFinancieras
	)
	VALUES
	(   @IdOperacion ,
	    @IdOperacionPadre ,
	    @RelOperaciones ,
	    @RelOperacionesD ,
	    @RelTransacciones ,
	    @RelTransaccionesFinancieras
	  )

END