
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDPTactualizacionesPerfilTransaccional')
BEGIN
	DROP PROC dbo.pCnPLDPTactualizacionesPerfilTransaccional
	SELECT 'pCnPLDPTactualizacionesPerfilTransaccional BORRADO' AS info
END
GO

CREATE PROC dbo.pCnPLDPTactualizacionesPerfilTransaccional
AS
BEGIN
	
	EXEC dbo.pPLDPTactualizacionesPerfilTransaccional @pTipoOperacion = 'EVALUACIONES',  -- varchar(25)
	                                                  @pIdActualizacion = 0, -- int
	                                                  @pNoSocio = '',        -- varchar(20)
	                                                  @pPersona = ''         -- varchar(20)
	

END
GO