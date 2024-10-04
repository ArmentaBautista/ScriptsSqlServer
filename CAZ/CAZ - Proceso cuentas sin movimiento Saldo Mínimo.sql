
/*!! TODO !! JCA:18/3/2024.19:57 Refactorizar el nombre de las variables  */

declare @IdPeriodo as int=0
declare @pDebug as bit=1

BEGIN TRY
	
		declare @fechaTrabajo as date='19000101'
		declare @FechaHora as datetime=getdate();
		set @fechaTrabajo=(select Fin from dbo.tCTLperiodos (nolock) where IdPeriodo=@IdPeriodo and EsAjuste=0)


		/********  JCA.18/3/2024.14:06 Info:Obtener producto acreedor Cuentas Sin Movimientos Saldo Mínimo  ********/
		DECLARE @IdProducto AS INT;
		DECLARE @Producto AS VARCHAR(32)='';

		SELECT @IdProducto=TRY_CAST(cfg.ValorId AS INT), @Producto=cfg.ValorDescripcion 
		FROM dbo.tCTSMconfiguraciones cfg  WITH(NOLOCK) 
		WHERE cfg.IdConfiguracion=4

		/********  JCA.18/3/2024.14:20 Info: Se crea IdSesion para el proceso, anteriormente se hacía con un negativo por ser de sistema, 
		sin embargo implica deshabilitar el Identity por lo que opto por no hacerlo.  ********/
		DECLARE @idsesion AS INT =0

		insert INTO tCTLsesiones(IdUsuario,IdPerfil,IdSucursal,IP,Host,	Inicio,Fin,FechaTrabajo,IdVersion)
		select -1,-1,0,'CTASSMOV_SDOMIN',HOST_NAME(),@FechaHora,@FechaHora,@FechaHora,0

		SET @idsesion=SCOPE_IDENTITY();

		/********  JCA.18/3/2024.14:42 Info:Creación de Cuentas del Producto Acreedor  ********/
		DECLARE @idTipoDproucto AS INT=0
		DECLARE @idTipoDtasa AS INT=0
		DECLARE @TipoAIC AS INT=0
		DECLARE @IdRelCatalogosAsignados AS INT=0
		DECLARE @IdDivision AS INT=0
		DECLARE @idTasa AS INT=0
		DECLARE @DiasTipoAñio AS INT=0
		DECLARE @IdImpuesto AS INT=0
		DECLARE @Descripcion AS VARCHAR(500)=''
		DECLARE @IdTipoDIncremental AS INT=407


		SELECT 
		 @idTipoDproucto=taf.IdTipoDDominioCatalogo
		,@idTipoDtasa=taf.IdTipoDTasa
		,@IdRelCatalogosAsignados=taf.IdRelDivisionesAsignadas
		,@Descripcion=taf.Descripcion  
		FROM dbo.tAYCproductosFinancieros taf (nolock)
		WHERE taf.IdProductoFinanciero=@idproducto

		SELECT  
		 @tipoAIC=catA.IdTipoDCredito
		,@IdDivision=da.IdDivision
		FROM dbo.tGRLdivisionesAsignadas da
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatus = da.IdEstatus
				AND ea.IdEstatus=1
		INNER JOIN dbo.tCNTdivisiones dv 
			ON dv.IdDivision = da.IdDivision 
		INNER JOIN dbo.tCTLestatusActual eaDv
			on eaDv.IdEstatusActual = dv.IdEstatusActual
				AND eaDv.IdEstatus = 1 
		INNER JOIN dbo.tCNTcatalogosAsignados catA 
			ON catA.RelCatalogosAsignados = dv.RelCatalogosAsignados
				AND catA.IdEstatus=1
		WHERE da.IdRel=@IdRelCatalogosAsignados	

		SET @DiasTipoAñio=CAST((SELECT valor FROM tCTLconfiguracion tc  WITH(NOLOCK) WHERE idconfiguracion=62) AS INT)

		SET @IDImpuesto=CAST((SELECT valor FROM tCTLconfiguracion tc WHERE idconfiguracion=89) AS INT)

		/*!! TODO !! JCA:18/3/2024.19:55 Revisar si se elimina la búsqueda de tasa ya que el producto acreedor del que se creara la cuenta, usualmente no tiene tasa  */				
		SELECT 
		@idTasa=pt.Id
		FROM dbo.tCTLproductosFinancierosTasas pt WITH(NOLOCK) 
		INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
			ON ea.IdEstatusActual = pt.IdEstatusActual
				AND ea.IdEstatus=1
		WHERE pt.RelTasas=@IdProducto

		/********  JCA.18/3/2024.21:06 Info:Obtener cuentas con saldo inferior al saldo mínimo  ********/

		declare @cuentasSdoMin as table(
			Numero	int,
			Descripcion	varchar(128),
			FechaAutorizacion	date,
			idsocio	int,
			IdUsuarioAutorizo	int,
			IdTipoDproducto	int,
			IdTipoDTasa	int,
			IdTipoDAIC	int,
			ExentaIVA	bit,
			IdDivision	int,
			IdTasa		int,
			IdEstatus	int,
			IdProductoFinanciero	int,
			divisa	int,
			FactorDivisa	int,	
			IdSucursal	int,
			FechaActivacion		date,
			FechaUltimoCalculo	date,
			DiasTipoAñio	int,
			EsAutoapertura	bit,
			IdImpuesto		int,
			IdUsuarioAlta	int,
			FechaAlta	date,
			IdUsuarioCambio		int,
			UltimoCambio	datetime,
			IdTipoDdominio	int,
			IdTipoDAICclasificacion	int,
			Alta	datetime,
			IdSesion	int,
			NoCuentaOrigen	varchar(30),
			IdCuenta	int
		)

		insert into @cuentasSdoMin
		select 
		(ROW_NUMBER() over (PARTITION BY c.IdSucursal ORDER BY c.IdSucursal ) + (SELECT dbo.fObtenerIncremental(c.idsucursal,232)))-1 AS Numero
		, @Descripcion as Descripcion
		,@fechaTrabajo as FechaAutorizacion
		, c.idsocio
		,-1 as IdUsuarioAutorizo
		,@idTipoDproucto as IdTipoDproducto
		,@idtipodtasa as IdTipoDTasa
		,@TipoAIC as IdTipoDAIC
		,c.ExentaIVA as ExentaIVA
		,@IdDivision as IdDivision 
		,@IdTasa as IdTasa
		,1 as IdEstatus
		,@IdProducto as IdProductoFinanciero
		,1 as divisa
		,1 as FactorDivisa
		,c.IdSucursal
		,@fechaTrabajo as FechaActivacion
		,dateadd(day,-1,@fechaTrabajo )as FechaUltimoCalculo
		,@DiasTipoAñio as DiasTipoAñio
		,1 as EsAutoapertura
		,@IDImpuesto as IdImpuesto
		,-1 as IdUsuarioAlta
		,@fechaTrabajo as FechaAlta
		,-1 as IdUsuarioCambio
		,getdate() as UltimoCambio
		,@idTipoDproucto as IdTipoDdominio
		,@TipoAIC as IdTipoDAICclasificacion
		,getdate() as Alta
		,@idsesion as IdSesion
		,c.Codigo as NoCuentaOrigen
		,c.IdCuenta
		from dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
			on pf.IdProductoFinanciero = c.IdProductoFinanciero
		where c.IdEstatus=1
			and c.IdTipoDProducto in (144,398)
				and c.SaldoCapital < pf.SaldoMinimoIndividual

		if @pDebug=1 select * from @cuentasSdoMin

		/********  JCA.26/3/2024.00:12 Info:Insertar Nuevas Cuentas en la tabla de cuentas con el producto configurado  ********/
		if @pDebug=1
		begin
			select 
			(select dbo.ObtenerCodigoIncremental('CUENTA', @IdTipodIncremental, t.IdSucursal, 232,t.Numero)) 
			,numero,t.Descripcion,concat('CuentaOrigen: ',t.NoCuentaOrigen),t.FechaAutorizacion,t.idsocio,t.IdUsuarioAutorizo,t.IdTipoDproducto,t.IdTipoDTasa,t.IdTipoDAIC,t.ExentaIVA,t.IdDivision,t.IdTasa,t.IdEstatus,t.IdProductoFinanciero,1
			,t.FactorDivisa,t.IdSucursal,t.FechaActivacion,t.FechaUltimoCalculo,t.DiasTipoAñio,t.EsAutoapertura,t.IdImpuesto,-1,@fechaTrabajo,-1,@fechaTrabajo,@fechaTrabajo,@idsesion,@idTipoDproucto,@TipoAIC
			from @cuentasSdoMin t
		end
		else
		begin
			insert into dbo.tayccuentas (codigo,[Incremental],Descripcion,DescripcionLarga,FechaAutorizacion,IdSocio,IdUsuarioAutorizo,IdTipoDProducto,IdTipoDTasa,IdTipoDAIC,ExentaIVA,IdDivision,IdTasa,IdEstatus,IdProductoFinanciero,IdDivisa
			,FactorDivisa,IdSucursal,FechaActivacion,FechaUltimoCalculo,DiasTipoAnio,EsAutoApertura,IdImpuesto,IdUsuarioAlta,FechaAlta,IdUsuarioCambio,UltimoCambio,Alta,idsesion,IdTipoDAICclasificacion,IdTipoDDominio) 
			select 
			(select dbo.ObtenerCodigoIncremental('CUENTA', @IdTipodIncremental, t.IdSucursal, 232,t.Numero)) 
			,numero,t.Descripcion,concat('CuentaOrigen: ',t.NoCuentaOrigen),t.FechaAutorizacion,t.idsocio,t.IdUsuarioAutorizo,t.IdTipoDproducto,t.IdTipoDTasa,t.IdTipoDAIC,t.ExentaIVA,t.IdDivision,t.IdTasa,t.IdEstatus,t.IdProductoFinanciero,1
			,t.FactorDivisa,t.IdSucursal,t.FechaActivacion,t.FechaUltimoCalculo,t.DiasTipoAñio,t.EsAutoapertura,t.IdImpuesto,-1,@fechaTrabajo,-1,@fechaTrabajo,@fechaTrabajo,@idsesion,@idTipoDproucto,@TipoAIC
			from @cuentasSdoMin t

			-- Actualizar incrementales
			exec dbo.pCTLincrementales @TipoOperacion = 'UPD', -- varchar(5)
										@IdTipoDdominio = 232, -- int
										@IdSucursal = 0, -- int
										@IdTipoDincremental = @IdTipoDIncremental, -- int
										@Incremental = 0 -- int
		end

		/********  JCA.26/3/2024.01:01 Info:Creación de Saldos  ********/
		if @pDebug=1
		begin
			select 
				 ta.IdTipoDProducto
				 , -14          as IDAuxiliar
				 , -8           as IdEstructuraContable
				 , ta.IdSucursal
				 , ta.IdSocio
				 , vsb.IdPersona
				 , ta.IdDivision
				 , ta.IdDivisa
				 , ta.FechaAlta
				 , 1            as IdEstatus
				 , ta.IdCuenta
				 , 1
				 , -1
				 , @IdPeriodo
				 , 1
				 , -1
				 , -1
				 , @fechaTrabajo
				 , @fechaTrabajo
				 , @idsesion
				 , @Descripcion
				 , ta.Codigo
			from tAYCcuentas ta  WITH(NOLOCK) 
			inner join dbo.tSCSsocios vsb (nolock)
					on vsb.IdSocio = ta.IdSocio
			left join tSDOsaldos ts (nolock)
					on ts.IdCuenta = ta.IdCuenta
			where ta.IdSesion = @idsesion
				and ta.IdProductoFinanciero = @IdProducto
					and ts.IdSaldo is null
						and ta.FechaAlta = @fechaTrabajo;
		end
		else
		BEGIN
		    insert into tsdosaldos(IdTipoDDominioCatalogo,IdAuxiliar,IdEstructuraContable,IdSucursal,IdSocio,IdPersona,IdDivision,IdDivisa,Fecha,IdEstatus,IdCuenta,FactorDivisa,Naturaleza,IdPeriodo,Factor,IdUsuarioAlta,IdUsuarioUltimoCambio,alta,UltimaModificacion,IdSesion,Descripcion,Codigo)
			select 
				 ta.IdTipoDProducto
				 , -14          as IDAuxiliar
				 , -8           as IdEstructuraContable
				 , ta.IdSucursal
				 , ta.IdSocio
				 , vsb.IdPersona
				 , ta.IdDivision
				 , ta.IdDivisa
				 , ta.FechaAlta
				 , 1            as IdEstatus
				 , ta.IdCuenta
				 , 1
				 , -1
				 , @IdPeriodo
				 , 1
				 , -1
				 , -1
				 , @fechaTrabajo
				 , @fechaTrabajo
				 , @idsesion
				 , @Descripcion
				 , ta.Codigo
			from tAYCcuentas ta  WITH(NOLOCK) 
			inner join dbo.tSCSsocios vsb (nolock)
					on vsb.IdSocio = ta.IdSocio
			left join tSDOsaldos ts (nolock)
					on ts.IdCuenta = ta.IdCuenta
			where ta.IdSesion = @idsesion
				and ta.IdProductoFinanciero = @IdProducto
					and ts.IdSaldo is null
						and ta.FechaAlta = @fechaTrabajo;

			-- Actualización del IdSaldo en la Cuenta
			update ta set IdSaldo = ts.IdSaldo
			from tAYCcuentas ta
			inner join tSDOsaldos ts (nolock) on ts.IdCuenta=ta.IdCuenta
			where ta.IdProductoFinanciero=@IdProducto 
				and ta.IdSesion=@idsesion 
					and ts.Fecha=@fechaTrabajo 
						and ta.IdSaldo=0
		END

		/********  JCA.26/3/2024.09:38 Info:Devengamiento de Interéses  ********/
		exec pAYCejecutarProvisionAcreedoras
					@TipoOperacion = 'BJCTAMAS',
					@FechaTrabajo = @fechaTrabajo,
					@IdCuenta = 0,
					@Decimales = 2,
					@EsFinMes = 1,
					@DevengarIntereses = 0,
					@CapitalizarIntereses = 0,
					@IdImpuesto = 6,
					@IdSucursal = 0,
					@IdSucursalProceso = 1,
					@IdUsuario = -1,
					@IdSesion = @idsesion,
					@MontoRetirar = 0

		declare @IdPeridodoTrabajo as int=@IdPeriodo
		declare @IdPeridoSiguiente as int
		declare @FechaInicio as date 
		declare @fechaFin as date
		declare @folio_output as int
		declare @IdOperacion_output as int

		/********  JCA.26/3/2024.22:41 Info: Obtener Cuentas Nuevas @IdProducto y las cuentas con saldo Mínimo  ********/

		declare @ctasSinMovimientos  as table(
			IdCuenta	int,
			NoCuentaOrigen	varchar(30),
			Descripcion	varchar(128),
			IdSucursal	int,
			IdCentroCostos	int,
			IdDivision	int,
			Saldo numeric(15,2),
			IdSaldo	int,
			IdAuxiliar	int,
			IdEstructuraContable	int,
			IdDivisa	int
		)





END TRY
BEGIN CATCH
	
	 SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
	
END CATCH;