
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCRUDsesiones')
BEGIN
	DROP PROC pCRUDsesiones
	SELECT 'pCRUDsesiones BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pCRUDsesiones
    @TipoOperacion varchar(5),
    @IdSesion as int = 0 output,
    @IdUsuario as int = 0,
    @IdPerfil as int = 0,
    @IdSucursal as int = 0,
    @IP as varchar(20) = '',
    @Host as varchar(80) = '',
    @Inicio as datetime = '19000101' output,
    @Fin as datetime = '19000101' output,
    @FechaTrabajo as date = '19000101',
    @IdVersion as int = 0,
	@Version VARCHAR(12) =''

AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON
	SET DATEFIRST 1

	IF @IdUsuario!=0 
	BEGIN    
		IF EXISTS(select *
		          FROM dbo.tCTLusuarios usu WITH(NOLOCK)
				  INNER JOIN dbo.tCTLestatusActual estAct WITH(NOLOCK) ON estAct.IdEstatusActual = usu.IdEstatusActual
				  WHERE estAct.IdEstatus!=1 AND usu.IdUsuario=@IdUsuario)
		BEGIN
		    RAISERROR('El usuario no esta activo por lo que no puede acceder al sistema. ', 16, 1)
			RETURN

		END
		
		IF @IdUsuario NOT IN (2008,3029,3109,4196,4338,4480,4255,4256,4360,4600,-1,4718,4409) AND @FechaTrabajo='20231029'
		BEGIN 
			DECLARE @msjError AS VARCHAR(MAX)=CONCAT('No puede acceder al sistema Fecha=',@FechaTrabajo);
			RAISERROR(@msjError, 16, 1)
			RETURN
		END
	END 

	IF (@TipoOperacion='C')
	BEGIN

			 IF @IdUsuario NOT IN (2008,3029,3109,4196,4338,4480,4255,4256,4360,4600,-1,4718,4409)
			 BEGIN 
				IF dbo.fnValidarDiaHorarioSesion(@IdSucursal) = 0
				BEGIN		   
					RAISERROR('No permite el acceso al sistema con un  horario mayor al configurado en el parametro Hora Off Line del sistema',16,8) 
					RETURN -1			
				END	
			 END

			 
		

		IF @IdSesion = 0
		  BEGIN
				SET @Inicio = CURRENT_TIMESTAMP
				INSERT INTO [dbo].[tCTLsesiones] (IdUsuario, IdPerfil, IdSucursal, IP, Host, Inicio, Fin, FechaTrabajo, IdVersion ,Version)
				VALUES (@IdUsuario, @IdPerfil, @IdSucursal,  @IP, @Host, @Inicio, @Fin, @FechaTrabajo, @IdVersion, @Version)
				set @IdSesion = SCOPE_IDENTITY()
			END
		ELSE
		   BEGIN
			INSERT INTO [dbo].[tCTLsesiones] (IdSesion, IdUsuario, IdPerfil, IdSucursal, IP, Host, Inicio, Fin, FechaTrabajo, IdVersion, Version)
			VALUES (@IdSesion, @IdUsuario, @IdPerfil, @IdSucursal,  @IP, @Host, @Inicio, @Fin, @FechaTrabajo, @IdVersion,@Version)
		   END
		  
		---EXEC pActualizarSesiones @IdSesion = @IdSesion
	END
	
	IF (@TipoOperacion='R')
	BEGIN
		SELECT IdSesion, IdUsuario, IdPerfil, IdSucursal, Version, IP, Host, Inicio, Fin, FechaTrabajo, Usuario, PerfilCodigo, PerfilDescripcion, IdEmpresa, EmpresaCodigo, EmpresaNombreComercial, SucursalCodigo, SucursalDescripcion
		FROM [dbo].[vCTLsesionesGUI]
		WHERE (IdSesion=@IdSesion)
	END

	IF (@TipoOperacion='U')
	BEGIN
		If @Fin = '19000101'
			SET @Fin = CURRENT_TIMESTAMP 
		UPDATE [dbo].[tCTLsesiones] 
		SET  Fin=@Fin
		WHERE (IdSesion=@IdSesion)
	END 


GO

