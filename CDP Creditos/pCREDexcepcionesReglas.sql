

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCREDexcepcionesReglas')
BEGIN
	DROP PROC dbo.pCREDexcepcionesReglas
	SELECT 'dbo.pCREDexcepcionesReglas BORRADO' AS info
END
GO

CREATE PROC dbo.pCREDexcepcionesReglas
@pTipoOperacion				VARCHAR(24)='',
@pIdCuenta					INT=0,
@pIdSesionSolicitud			INT=0,
@pIdUsuarioSolicitud		INT=0,
@pIdSesionAutorizacion		INT=0,
@pIdUsuarioAutorizacion		INT=0,
@pCadenaBusqueda			VARCHAR(24)= '',
@pDatos						tpExcepcionRegla null READONLY,
@pIdRecurso					INT=0,
@pIdUsuario					INT=-1,
@pIdPerfil					INT=0
AS
BEGIN
	--DECLARE @data AS tpExcepcionRegla

	IF(@pTipoOperacion='F3CTA')
	BEGIN

		SELECT c.IdCuenta, c.Codigo AS NoCuenta, c.Descripcion AS Producto, c.FechaAlta,
		suc.Descripcion AS Sucursal,
		sc.Codigo AS NoSocio, p.Nombre
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) 
			ON suc.IdSucursal = c.IdSucursal
		INNER JOIN dbo.tAYCaperturas a  WITH(NOLOCK) 
			ON a.IdApertura = c.IdApertura
				AND a.IdEstatus IN (13,14)
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = c.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		WHERE c.IdTipoDProducto=143
			AND c.IdEstatus IN (3,30)
				AND c.codigo LIKE '%' + @pCadenaBusqueda + '%'
			
		RETURN 0
    END

	IF(@pTipoOperacion='OBT')
	BEGIN
	   -- revisar si ya existe y en ese caso regresar el resultado
	   IF NOT EXISTS(SELECT 1 FROM dbo.tCREDexcepcionesReglas ex  WITH(NOLOCK) WHERE ex.IdCuenta=@pIdCuenta)
	   BEGIN
			-- crear la plantilla
			INSERT INTO dbo.tCREDexcepcionesReglas
			(
			    IdCuenta,
			    IdRegla,
				Solicitado,
			    Autorizado,
			    IdSesionSolicitud,
			    IdSesionAutorizacion,
			    Fecha,
			    Alta
			)
			SELECT 
			@pIdCuenta,
			r.IdRegla,
			0,
			0,
			0,
			0,
			GETDATE(),
			GETDATE()
			FROM dbo.tCREDreglasCredito r  WITH(NOLOCK) 
			WHERE r.IdEstatus=1

       END

       /********  JCA.15/9/2024.14:53 Info: Modalidad Usuario de Crédito  ********/
		IF((@pIdRecurso=3141 OR @pIdUsuario=-1 OR @pIdPerfil=-1) AND @pIdRecurso<>3143)
		BEGIN
            SELECT
                r.IdRegla,
                r.Grupo,
                r.Clasificacion,
                r.Tipo,
                r.Regla,
                r.ConsideracionesAdicionales,
                r.FiltrarSucursales,
                r.IdPerfil1,
                r.Perfil1,
                r.IdPerfil2,
                r.Perfil2,
                r.IdPerfil3,
                r.Perfil3,
                ex.IdCuenta,
                ex.Solicitado,
                ex.IdUsuarioSolicitud,
                ex.Autorizado,
                ex.IdUsuarioAutorizacion,
                us.Usuario AS UsuarioSolicitud,
                ua.Usuario AS UsuarioAutorizacion
            FROM dbo.tCREDexcepcionesReglas ex WITH (NOLOCK)
            INNER JOIN dbo.tfCREDreglasCreditoActivas() r
                    ON r.IdRegla = ex.IdRegla
            LEFT JOIN dbo.tCTLusuarios us WITH (NOLOCK)
                    ON us.IdUsuario = ex.IdUsuarioSolicitud
            LEFT JOIN dbo.tCTLusuarios ua WITH (NOLOCK)
                    ON ua.IdUsuario = ex.IdUsuarioAutorizacion
            WHERE ex.IdCuenta = @pIdCuenta

			RETURN 0
        END

       /********  JCA.15/9/2024.14:53 Info: Modalidad Autorizador  ********/
		IF (@pIdRecurso=3143)
		BEGIN

            SELECT
                r.IdRegla,
                r.Grupo,
                r.Clasificacion,
                r.Tipo,
                r.Regla,
                r.ConsideracionesAdicionales,
                r.FiltrarSucursales,
                r.IdPerfil1,
                r.Perfil1,
                r.IdPerfil2,
                r.Perfil2,
                r.IdPerfil3,
                r.Perfil3,
                ex.IdCuenta,
                ex.Solicitado,
                ex.IdUsuarioSolicitud,
                ex.Autorizado,
                ex.IdUsuarioAutorizacion,
                us.Usuario AS UsuarioSolicitud,
                ua.Usuario AS UsuarioAutorizacion
            FROM dbo.tCREDexcepcionesReglas ex WITH (NOLOCK)
            INNER JOIN dbo.tfCREDreglasCreditoActivas() r
                ON r.IdRegla = ex.IdRegla
                    AND (@pIdPerfil IN (r.IdPerfil1,r.IdPerfil2,r.IdPerfil3))
            LEFT JOIN dbo.tCTLusuarios us WITH (NOLOCK)
                    ON us.IdUsuario = ex.IdUsuarioSolicitud
            LEFT JOIN dbo.tCTLusuarios ua WITH (NOLOCK)
                    ON ua.IdUsuario = ex.IdUsuarioAutorizacion
            WHERE ex.IdCuenta = @pIdCuenta

			RETURN 0		    
		END

	END

	IF(@pTipoOperacion='SOL')
	BEGIN
		IF (@pIdSesionSolicitud=0 OR @pIdUsuarioSolicitud=0)
		BEGIN
			THROW 50005, N'Algo ha ido mal, los datos de solicitud no pueden ser CERO', 1;

			RETURN -1
		END

		UPDATE ex SET ex.Solicitado=1, ex.IdUsuarioSolicitud=@pIdUsuarioSolicitud, ex.IdSesionSolicitud=@pIdSesionSolicitud
		FROM tCREDexcepcionesReglas ex
		INNER JOIN @pDatos d
			ON d.IdCuenta = ex.IdCuenta
				AND d.IdRegla = ex.IdRegla
		WHERE ex.IdCuenta=@pIdCuenta
	   
	    EXEC dbo.pCREDexcepcionesReglas @pTipoOperacion='OBT', @pidcuenta=@pIdCuenta--, @pDatos=@data

		RETURN 0
	END

	IF(@pTipoOperacion='AUT')
	BEGIN
		IF (@pIdSesionAutorizacion=0 OR @pIdUsuarioAutorizacion=0)
		BEGIN
			THROW 50005, N'Algo ha ido mal, los datos de solicitud no pueden ser CERO', 1;

			RETURN -1
		END

		UPDATE ex SET ex.Autorizado=1, ex.IdUsuarioAutorizacion=@pIdUsuarioAutorizacion, ex.IdSesionAutorizacion=@pIdSesionAutorizacion
		FROM tCREDexcepcionesReglas ex
		INNER JOIN @pDatos d
			ON d.IdCuenta = ex.IdCuenta
				AND d.IdRegla = ex.IdRegla
		WHERE ex.Solicitado=1
			and ex.IdCuenta=@pIdCuenta
	   
	    EXEC dbo.pCREDexcepcionesReglas @pTipoOperacion='OBT', @pidcuenta=@pIdCuenta--, @pDatos=@data

		RETURN 0
	END

END
GO














