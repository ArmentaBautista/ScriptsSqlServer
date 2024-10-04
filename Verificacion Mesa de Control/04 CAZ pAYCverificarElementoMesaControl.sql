


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCverificarElementoMesaControl')
BEGIN
	DROP PROC pAYCverificarElementoMesaControl
	SELECT 'pAYCverificarElementoMesaControl BORRADO' AS info
END
GO

CREATE PROC pAYCverificarElementoMesaControl
@idCuenta INT,
@idElemento INT,
@cubierto BIT,
@noCubierto BIT
AS
BEGIN
	
	UPDATE v SET  v.Cubierto=@cubierto, v.NoCubierto=@noCubierto
	FROM dbo.tAYCverificacionMesaControl v WHERE v.IdEstatus=1 AND v.IdCuenta=@idCuenta

	EXEC dbo.pAYCplantillaVerificacionMesaControl @tipoOperacion = 'OBTENER', -- varchar(24)
	                                              @noCuenta = @idCuenta,      -- varchar(24)
	                                              @IdUsuarioAlta = 0,  -- int
	                                              @IdSesion = 0        -- int
	
END



