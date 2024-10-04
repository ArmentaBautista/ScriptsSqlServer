
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDPTresultadosActualizacionesPerfilTransaccional')
BEGIN
	DROP PROC dbo.pCnPLDPTresultadosActualizacionesPerfilTransaccional
	SELECT 'pCnPLDPTresultadosActualizacionesPerfilTransaccional BORRADO' AS info
END
GO

CREATE PROC dbo.pCnPLDPTresultadosActualizacionesPerfilTransaccional
@pIdActualizacion AS INT
AS
BEGIN
	DECLARE @IdActualizacion AS INT=@pIdActualizacion
	EXEC dbo.pPLDPTactualizacionesPerfilTransaccional @pTipoOperacion = 'RESULTADOS',  -- varchar(25)
	                                                  @pIdActualizacion = @IdActualizacion, -- int
	                                                  @pNoSocio = '',        -- varchar(20)
	                                                  @pPersona = ''         -- varchar(20)
END
GO
