
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnPLDPTactualizacionesPerfilTransaccionalPersona')
BEGIN
	DROP PROC dbo.pCnPLDPTactualizacionesPerfilTransaccionalPersona
	SELECT 'pCnPLDPTactualizacionesPerfilTransaccionalPersona BORRADO' AS info
END
GO

CREATE PROC dbo.pCnPLDPTactualizacionesPerfilTransaccionalPersona
@pPersona AS VARCHAR(20)=''
AS
BEGIN
	DECLARE @Persona AS VARCHAR(20)=@pPersona
	EXEC dbo.pPLDPTactualizacionesPerfilTransaccional @pTipoOperacion = 'PERSONA',  -- varchar(25)
	                                                  @pIdActualizacion = 0, -- int
	                                                  @pNoSocio = '',        -- varchar(20)
	                                                  @pPersona = @Persona         -- varchar(20)
END
GO

