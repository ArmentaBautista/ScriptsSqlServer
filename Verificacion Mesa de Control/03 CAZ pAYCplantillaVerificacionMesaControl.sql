
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCplantillaVerificacionMesaControl')
BEGIN
	DROP PROC pAYCplantillaVerificacionMesaControl
	SELECT 'pAYCplantillaVerificacionMesaControl BORRADO' AS info
END
GO

CREATE PROC pAYCplantillaVerificacionMesaControl
@tipoOperacion VARCHAR(24)='',
@noCuenta VARCHAR(24)='',
@IdUsuarioAlta INT=0,
@IdSesion INT = 0
AS
BEGIN

	IF @tipoOperacion='PLANTILLA'
	BEGIN
		/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
		-- Variables
		DECLARE @puntosVerificacion AS TABLE
		(
			IdVerificacionMesaControl 	INT NOT NULL DEFAULT 0,
			IdCuenta					INT NOT NULL DEFAULT 0,
			IdElemento					INT NOT NULL DEFAULT 0,
			Cubierto					BIT	NOT NULL DEFAULT 0,
			NoCubierto					BIT NOT NULL DEFAULT 0,
			Alta						DATETIME NOT NULL DEFAULT GETDATE(),
			IdEstatus 					INT NOT NULL DEFAULT 0,
			IdUsuarioAlta 				INT NOT NULL DEFAULT 0,
			IdSesion 					INT NOT NULL DEFAULT 0
		)

		DECLARE @idCuenta INT
		DECLARE @idProducto INT
		DECLARE @noRegistros INT
		DECLARE @alta DATETIME = CURRENT_TIMESTAMP

		/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
	
		SELECT @idCuenta = IdCuenta, @idProducto=IdProductoFinanciero FROM dbo.tAYCcuentas  WITH(NOLOCK) WHERE Codigo=@noCuenta
		
		IF (@idCuenta IS NULL OR @idCuenta=0)
			THROW 50005, N'La cuenta proporcionada no existe', 1;
		
		IF NOT EXISTS(SELECT 1 FROM tAYCproductosElementosVerificacionMesaControl p  WITH(NOLOCK) WHERE p.IdProducto=@idProducto)
			THROW 50005, N'El producto financiero de la cuenta proporcionada no tiene elementos de verificación asignados', 1;
			
		-- Revisar si existen registros de plantilla en la base con estatus 1 para la cuenta solicitada
		INSERT INTO @puntosVerificacion	(IdVerificacionMesaControl,IdCuenta,IdElemento,Cubierto,NoCubierto,Alta,IdEstatus,IdUsuarioAlta,IdSesion)
		SELECT IdVerificacionMesaControl,IdCuenta,IdElemento,Cubierto,NoCubierto,Alta,IdEstatus,IdUsuarioAlta,IdSesion 
		FROM tAYCverificacionMesaControl vmc  WITH(NOLOCK) WHERE IdEstatus=1 and IdCuenta=@idCuenta

		SET @noRegistros = (SELECT COUNT(1) FROM @puntosVerificacion)
		if @noRegistros=0
		BEGIN
		-- Sino existen, crearlos y devolverlos
			INSERT INTO dbo.tAYCverificacionMesaControl (IdCuenta,IdElemento,Cubierto,NoCubierto,Alta,IdEstatus,IdUsuarioAlta,IdSesion)
			SELECT @idCuenta, pe.IdElementoVerificacion,0,0,@alta,1,@IdUsuarioAlta,@IdSesion 
			FROM dbo.tAYCproductosElementosVerificacionMesaControl pe  WITH(NOLOCK) WHERE pe.IdEstatus=1 AND pe.IdProducto=@idProducto 

			SELECT IdVerificacionMesaControl,IdCuenta,IdElemento,Cubierto,NoCubierto,Alta,IdEstatus,IdUsuarioAlta,IdSesion 
			FROM tAYCverificacionMesaControl vmc  WITH(NOLOCK) WHERE IdEstatus=1 and IdCuenta=@idCuenta

			RETURN 1
		END
		ELSE
        BEGIN
		-- Si existen de devolverlos
			SELECT IdVerificacionMesaControl,IdCuenta,IdElemento,Cubierto,NoCubierto,Alta,IdEstatus,IdUsuarioAlta,IdSesion 
			FROM tAYCverificacionMesaControl vmc  WITH(NOLOCK) WHERE IdEstatus=1 and IdCuenta=@idCuenta

			RETURN 1
        END

	END
	 
	IF @tipoOperacion='OBTENER'
	BEGIN

		SELECT IdVerificacionMesaControl,IdCuenta,IdElemento,Cubierto,NoCubierto,Alta,IdEstatus,IdUsuarioAlta,IdSesion 
		FROM tAYCverificacionMesaControl vmc  WITH(NOLOCK) WHERE IdEstatus=1 and IdCuenta=@idCuenta

		RETURN 1
    END

END
GO