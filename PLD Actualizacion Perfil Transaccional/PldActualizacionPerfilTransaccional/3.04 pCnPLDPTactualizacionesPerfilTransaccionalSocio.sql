
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDPTactualizacionesPerfilTransaccionalSocio')
BEGIN
	DROP PROC dbo.pCnPLDPTactualizacionesPerfilTransaccionalSocio
	SELECT 'pCnPLDPTactualizacionesPerfilTransaccionalSocio BORRADO' AS info
END
GO

CREATE PROC dbo.pCnPLDPTactualizacionesPerfilTransaccionalSocio
@pNoSocio AS VARCHAR(20)=''
AS
BEGIN
	DECLARE @NoSocio AS VARCHAR(20)=@pNoSocio	
	EXEC dbo.pPLDPTactualizacionesPerfilTransaccional @pTipoOperacion = 'SOCIO',  -- varchar(25)
	                                                  @pIdActualizacion = 0, -- int
	                                                  @pNoSocio = @NoSocio,        -- varchar(20)
	                                                  @pPersona = ''         -- varchar(20)
END
GO