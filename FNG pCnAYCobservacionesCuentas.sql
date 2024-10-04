
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCobservacionesCuentas')
BEGIN
	DROP PROC pCnAYCobservacionesCuentas
	SELECT 'pCnAYCobservacionesCuentas BORRADO' AS info
END
GO

CREATE PROC pCnAYCobservacionesCuentas
@fechaInicio AS DATE='19000101',
@fechaFin AS DATE='19000101'
AS
BEGIN	
		--DECLARE @fechaInicio DATE='20230101'
		--DECLARE @fechaFin DATE='20230331'

		IF @fechaInicio='19000101' OR @fechaFin='19000101'
		begin
			SELECT 'Fechas de Inicio o Fin no válidas' AS Info; RETURN -1;
		END

		IF DATEDIFF(DAY,@fechaInicio,@fechaFin)>90
		BEGIN
			SELECT 'El número máximo de días a consultar es de 90, por favor ajuste el rango de fechas' AS info; RETURN -1;
		END


		DECLARE @ids AS TABLE
		(
			IdCuenta			INT,
			NoCuenta			VARCHAR(32),
			Producto			VARCHAR(92),
			IdSucursal			INT,
			IdSocio				INT,
			Folio				INT,
			IdEstatus			INT,
			IdEstatusEntrega	INT,
			Ids					VARCHAR(max)
		)

		DECLARE @observacionesE AS TABLE
		(
			IdCuenta			INT,
			NoCuenta			VARCHAR(32),
			Producto			VARCHAR(92),
			IdSucursal			INT,
			IdSocio				INT,
			Folio				INT,
			IdEstatus			INT,
			IdEstatusEntrega	INT,
			Id					INT
		)

						INSERT INTO @ids (IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio,IdEstatus,IdEstatusEntrega,Ids)
						SELECT c.IdCuenta, c.Codigo, c.Descripcion, c.IdSucursal, c.IdSocio, ta.Folio,c.IdEstatus, c.IdEstatusEntrega,
						CONCAT(ta.IdObservacionE,',',ta.IdObservacionEDominio,',',c.IdObservacionE,',',c.IdObservacionEDominio ,',',
						ea.IdObservacionE ,',',ea.IdObservacionEDominio,','  ) 
						FROM tAYCaperturas ta  WITH (NOLOCK)
						JOIN tAYCcuentas c		  WITH (NOLOCK)ON c.IdApertura=ta.IdApertura AND c.IdTipoDProducto=143 AND c.IdEstatus NOT IN (2,3,7,53,73)
						JOIN tAUTsolicitudes s	  WITH (NOLOCK)ON s.IdCuenta=c.IdCuenta
						JOIN tCTLestatusActual ea WITH (NOLOCK)ON ea.IdEstatusActual=s.IdEstatusActual
						WHERE ta.IdApertura<>0 
						AND ta.Fecha BETWEEN @fechaInicio AND @fechaFin

						DECLARE @idCuenta			INT
						DECLARE @NoCuenta			VARCHAR(24)
						DECLARE @Producto			VARCHAR(32)
						DECLARE @IdSucursal			INT
						DECLARE @IdSocio			INT
						DECLARE @Folio				INT
						DECLARE @IdEstatus			INT
						DECLARE @IdEstatusEntrega	INT
						DECLARE @idsList			VARCHAR(max)

						DECLARE cur  CURSOR LOCAL FAST_FORWARD FOR
						SELECT IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio,IdEstatus,IdEstatusEntrega, Ids FROM @ids 
						OPEN cur
						FETCH NEXT FROM cur INTO @idCuenta,@NoCuenta,@Producto,@IdSucursal,@IdSocio,@Folio,@IdEstatus,@IdEstatusEntrega, @idsList
						WHILE @@FETCH_STATUS = 0
						BEGIN
					
							INSERT INTO @observacionesE (IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio,IdEstatus,IdEstatusEntrega, Id)
							SELECT @idCuenta,@NoCuenta,@Producto,@IdSucursal,@IdSocio,@Folio,@IdEstatus,@IdEstatusEntrega, value FROM STRING_SPLIT(@idsList,',')
							WHERE value<>0
					
							FETCH NEXT FROM cur INTO @idCuenta,@NoCuenta,@Producto,@IdSucursal,@IdSocio,@Folio,@IdEstatus,@IdEstatusEntrega, @idsList 
						END

						CLOSE cur
						DEALLOCATE cur

				
						SELECT --i.IdCuenta,i.NoCuenta,i.Producto,i.IdSucursal,i.IdSocio,i.Folio,
						suc.Descripcion AS Sucursal, ec.Descripcion AS EstatusCuenta, ee.Descripcion AS EstatusEntrega,
						i.Folio, i.NoCuenta, i.Producto, sc.Codigo AS NoSocio, p.Nombre,
						u.Usuario,od.Texto, ea.Alta, ea.UltimoCambio, ea.IdEstatus
						FROM dbo.tCTLobservacionesD	od WITH (NOLOCK)  
						INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = od.IdEstatusActual
						INNER JOIN dbo.tCTLusuarios u  WITH(NOLOCK) ON u.IdUsuario = ea.IdUsuarioAlta
						INNER JOIN dbo.tCTLobservacionesE oe WITH (NOLOCK) ON oe.IdObservacionE = od.IdObservacionE 
						INNER JOIN (
									SELECT IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio,IdEstatus,IdEstatusEntrega, Id 
									FROM @observacionesE i 
									GROUP BY IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio,IdEstatus,IdEstatusEntrega, Id 
									) i ON i.Id=oe.IdObservacionE
						INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = i.IdSucursal
						INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = i.IdSocio
						INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
						INNER JOIN dbo.tCTLestatus eC  WITH(NOLOCK) ON eC.IdEstatus = i.IdEstatus
						INNER JOIN dbo.tCTLestatus eE  WITH(NOLOCK) ON eE.IdEstatus = i.IdEstatusEntrega
						WHERE oe.IdObservacionE!=0
						ORDER BY suc.Descripcion, i.IdCuenta, od.IdObservacionD

END