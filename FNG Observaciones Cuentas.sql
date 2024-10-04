
-- EXECUTE [dbo].[pLSTobservacionDConjunto] @TipoOperacion = 'LST', @IdRegistro = 106992, @IdDominio = 436

DECLARE @idregistro AS INT=106992
DECLARE @consulta AS VARCHAR(max)


DECLARE @fechaInicio DATE='20230102'
DECLARE @fechaFin DATE='20230102'

DECLARE @ids AS TABLE
(
	IdCuenta	INT,
	NoCuenta	VARCHAR(24),
	Producto	VARCHAR(32),
	IdSucursal	INT,
	IdSocio		INT,
	Folio		INT,
	Ids			VARCHAR(max)
)

DECLARE @observacionesE AS TABLE
(
	IdCuenta	INT,
	NoCuenta	VARCHAR(24),
	Producto	VARCHAR(32),
	IdSucursal	INT,
	IdSocio		INT,
	Folio		INT,
	Id			INT
)



/*
				set @consulta =(SELECT concat(ta.IdObservacionE,',',ta.IdObservacionEDominio,',',c.IdObservacionE,',',c.IdObservacionEDominio ,',',
				ea.IdObservacionE ,',',ea.IdObservacionEDominio,','  ) 
				FROM tAYCaperturas ta  WITH (NOLOCK)
				JOIN tAYCcuentas c		  WITH (NOLOCK)ON c.IdApertura=ta.IdApertura
				JOIN tAUTsolicitudes s	  WITH (NOLOCK)ON s.IdCuenta=c.IdCuenta
				JOIN tCTLestatusActual ea WITH (NOLOCK)ON ea.IdEstatusActual=s.IdEstatusActual
				WHERE ta.IdApertura<>0 
				--AND ta.IdApertura=@idregistro
				AND ta.Fecha BETWEEN '20230301' AND '20230315'
				FOR XML PATH('')) 
				
				--(SELECT *FROM dbo.fSplitString(isnull(@consulta,''),',') fss)

				SELECT IdObservacionD, ObservacionesDIdObservacionE, Observacion, IdEstatusActual, IdEstatus, ObservacionesEPermiteHistorial, ObservacionesEPermiteCambios, 
				UsuarioAlta, Alta, UsuarioCambio, UltimoCambio, IdTipoDDominio, 
				TipoDominioCodigo, TipoDominioDescripcion, EstatusCodigo, EstatusDescripcion, EstatusColor, IdObservacionE, IdObservacionEDominio, TieneObservaciones, IdSesion,Texto
				FROM [dbo].[vCTLobservacionesGUI]
				WHERE ObservacionesDIdObservacionE IN  (SELECT *FROM dbo.fSplitString(isnull(@consulta,''),',') fss) AND not IdObservacionD=0
				ORDER BY alta 
*/


				INSERT INTO @ids (IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio,Ids)
				SELECT c.IdCuenta, c.Codigo, c.Descripcion, c.IdSucursal, c.IdSocio, ta.Folio,
				CONCAT(ta.IdObservacionE,',',ta.IdObservacionEDominio,',',c.IdObservacionE,',',c.IdObservacionEDominio ,',',
				ea.IdObservacionE ,',',ea.IdObservacionEDominio,','  ) 
				FROM tAYCaperturas ta  WITH (NOLOCK)
				JOIN tAYCcuentas c		  WITH (NOLOCK)ON c.IdApertura=ta.IdApertura AND c.IdTipoDProducto=143 AND c.IdEstatus NOT IN (2,3,7,53,73)
				JOIN tAUTsolicitudes s	  WITH (NOLOCK)ON s.IdCuenta=c.IdCuenta
				JOIN tCTLestatusActual ea WITH (NOLOCK)ON ea.IdEstatusActual=s.IdEstatusActual
				WHERE ta.IdApertura<>0 
				AND ta.IdApertura=@idregistro
				--AND ta.Fecha BETWEEN @fechaInicio AND @fechaFin

				SELECT * FROM @ids

				DECLARE @idCuenta	INT
				DECLARE @NoCuenta	VARCHAR(24)
				DECLARE @Producto	VARCHAR(32)
				DECLARE @IdSucursal	INT
				DECLARE @IdSocio	INT
				DECLARE @Folio		INT
				DECLARE @idsList	VARCHAR(max)

				DECLARE cur CURSOR FOR
				SELECT IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio, Ids FROM @ids GROUP BY IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio, Ids
				OPEN cur
				FETCH NEXT FROM cur INTO @idCuenta,@NoCuenta,@Producto,@IdSucursal,@IdSocio,@Folio, @idsList
				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					INSERT INTO @observacionesE (IdCuenta,NoCuenta,Producto,IdSucursal,IdSocio,Folio, Id)
					SELECT @idCuenta,@NoCuenta,@Producto,@IdSucursal,@IdSocio,@Folio, value FROM STRING_SPLIT(@idsList,',')
					WHERE value<>0

					FETCH NEXT FROM cur INTO @idCuenta,@NoCuenta,@Producto,@IdSucursal,@IdSocio,@Folio, @idsList 
				END

				CLOSE cur
				DEALLOCATE cur

				
				
				-- SELECT * FROM @observacionesE  

				SELECT i.*,
				o.IdObservacionD, o.ObservacionesDIdObservacionE, o.UsuarioAlta, o.Alta, o.UsuarioCambio, o.UltimoCambio, o.IdSesion,o.Texto
				FROM [dbo].[vCTLobservacionesGUI] o
				INNER JOIN @observacionesE i ON i.Id=o.ObservacionesDIdObservacionE
				WHERE o.ObservacionesDIdObservacionE!=0
				ORDER BY o.Alta









				/*
				INSERT INTO @idsObservacionesE (aIdObservacionE,aIdObservacionEDominio,cIdObservacionE,cIdObservacionEDominio,eaIdObservacionE,eaIdObservacionEDominio)
				SELECT ta.IdObservacionE,ta.IdObservacionEDominio,c.IdObservacionE,c.IdObservacionEDominio, ea.IdObservacionE ,ea.IdObservacionEDominio
				FROM tAYCaperturas ta  WITH (NOLOCK)
				JOIN tAYCcuentas c		  WITH (NOLOCK)ON c.IdApertura=ta.IdApertura
				JOIN tAUTsolicitudes s	  WITH (NOLOCK)ON s.IdCuenta=c.IdCuenta
				JOIN tCTLestatusActual ea WITH (NOLOCK)ON ea.IdEstatusActual=s.IdEstatusActual
				WHERE ta.IdApertura<>0 
				AND ta.IdApertura=@idregistro
				AND ta.Fecha BETWEEN '20230301' AND '20230315'

				
				SELECT IdObservacionD, ObservacionesDIdObservacionE, Observacion, IdEstatusActual, IdEstatus, ObservacionesEPermiteHistorial, ObservacionesEPermiteCambios, 
				UsuarioAlta, Alta, UsuarioCambio, UltimoCambio, IdTipoDDominio, 
				TipoDominioCodigo, TipoDominioDescripcion, EstatusCodigo, EstatusDescripcion, EstatusColor, IdObservacionE, IdObservacionEDominio, TieneObservaciones, IdSesion,Texto
				FROM [dbo].[vCTLobservacionesGUI] o
				INNER JOIN @idsObservacionesE i ON i.aIdObservacionE=o.ObservacionesDIdObservacionE
				OR i.aIdObservacionEDominio=o.ObservacionesDIdObservacionE
				OR i.cIdObservacionE=o.ObservacionesDIdObservacionE
				OR i.cIdObservacionEDominio=o.ObservacionesDIdObservacionE
				OR i.eaIdObservacionE = o.ObservacionesDIdObservacionE
				OR i.eaIdObservacionEDominio = o.ObservacionesDIdObservacionE
				WHERE o.ObservacionesDIdObservacionE!=0
				ORDER BY alta 
*/
				
				