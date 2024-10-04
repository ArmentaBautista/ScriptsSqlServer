

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCagregarCargosFactorSeguro')
BEGIN
	DROP PROC pAYCagregarCargosFactorSeguro
	SELECT 'pAYCagregarCargosFactorSeguro BORRADO' AS info
END
GO

CREATE PROC pAYCagregarCargosFactorSeguro
@IdCuenta int=0
AS


		--IF dbo.fnIdentificarClienteERPRISE('FNG')=0
		--	RETURN;


		DECLARE @IdSocio AS INT;
		DECLARE @producto AS VARCHAR(10)='';		
		DECLARE @TipoProducto AS INT=0
		DECLARE @MontoAutorizado AS NUMERIC(18,2)=0
		DECLARE @factorSeguro AS NUMERIC(23,8)=0
		DECLARE @NumeroPlazos AS INT=0
		DECLARE @IdTipoDplazo AS INT=0
		DECLARE @FechaEntrega AS DATE='19000101'
		DECLARE @fechaAlta AS DATE='19000101'
		DECLARE @Vencimiento AS DATE='19000101'
		DECLARE @Edad AS INT=0
		DECLARE @FechaAltaSocio AS DATE='19000101'



		SELECT @IdSocio=c.IdSocio,  @producto=pf.Codigo,@TipoProducto=c.IdTipoDProducto,@MontoAutorizado=c.Monto
		,@factorSeguro=IIF(c.Monto>5500000,0.0059,ISNULL(pf.FactorSeguro,0))
		,@NumeroPlazos=ISNULL(c.NumeroParcialidades,0),@IdTipoDplazo=ISNULL(c.IdTipoDPlazo,0)
		,@FechaEntrega=c.FechaEntrega,@fechaAlta=c.FechaAlta,@Vencimiento=c.Vencimiento,
		@FechaAltaSocio=soc.FechaAlta
		FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
		INNER JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = c.IdSocio
		WHERE c.idcuenta=@idcuenta

		SELECT @Edad=dbo.fGRLcalcularEdad(pf.FechaNacimiento, @FechaAltaSocio)
		FROM dbo.tSCSsocios s With (nolock)  
		JOIN dbo.tGRLpersonasFisicas pf With (nolock) ON pf.IdPersona = s.IdPersona
		WHERE s.IdSocio=@IdSocio
		
		IF @TipoProducto!=143
		RETURN

		----valida la edad de la persona
		IF (@Edad>67)
		return

				
		
			

			DECLARE @IdCargo AS INT;
			DECLARE @IdRel AS INT=0;
			DECLARE @IdCargoComicion AS INT;
			DECLARE @monto AS NUMERIC(18,2)=1;
			DECLARE @notas AS VARCHAR(128)=CONCAT('SEGURO DE CREDITO FACTOR SEGURO ',@IdSocio,' | ',@idcuenta);
			DECLARE @fecha AS DATE=GETDATE();
			DECLARE @idImpuesto AS INT;
			DECLARE @numPagos AS INT;



			SELECT @IdCargo=ISNULL(bs.IdBienServicio,0), @idImpuesto=bs.IdImpuesto,
			@monto=CASE WHEN @NumeroPlazos=1 
						THEN CAST(DATEDIFF(DAY,@fechaAlta,@Vencimiento)/360.00 AS DECIMAL(4,3))*@MontoAutorizado*@factorSeguro
						ELSE CAST(@NumeroPlazos/12.00 AS numeric(5,3))*@factorSeguro*@MontoAutorizado
						end                       
			FROM dbo.tGRLbienesServicios bs  WITH(NOLOCK)
			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = bs.IdEstatusActual AND ea.IdEstatus=1 
			WHERE bs.Codigo='CAR-001'
	
				
			IF ((@IdCargo=0  OR @IdCargo IS NULL) OR  (@factorSeguro=0)	 )
			return

			INSERT INTO dbo.tAYCcargosComisionesAsignados
			(
				IdRel,
				Numero,
				IdBienServicioCargoComision,
				IdTipoDcalculo, -- fijo
				Monto,
				IdTipoDAplicacion, -- única
				FechaAplicacion, 
				IdEstatus,
				IdCuentaAutorizacion,
				IdSocio,
				Notas
			)
			VALUES
			(@IdRel, 1, @IdCargo, 491, @monto, 841, @fecha, 7, @IdCuenta, @IdSocio, @notas); --se coloca el estatus 7 para que ya no vuelva agenerar los cargos en el proceso que se corre cuando se agrega un cargo manual  

			SET @IdCargoComicion=SCOPE_IDENTITY()
  
			INSERT INTO dbo.tSDOcargosDescuentos
			(
				IdCargoComision,
				Fecha,
				
				IdBienServicio,
				IdTipoDconcepto, -- CARGOS
				IdTipoDmovimiento, -- CARGO
				Monto,
				Porcentaje,
				Estimado,
				Generado,
				EstimadoPorcentajeDescuento,
				EstimadoMontoDescuento,
				EstimadoPorcentajeCondonado,
				EstimadoMontoCondonado,
				PorcentajeDescontado,
				PorcentajeCondonado,
				Descontado,
				Condonado,
				Pagado,
				IdEstatus,
				IdUsuarioAlta,
				Alta,
				IdImpuesto,
				FechaAplicacion,
				DomiciliarCargos,
				Notas
			)
			VALUES
			(@IdCargoComicion, @fecha,@IdCargo, 710, 711, @monto, 0, @monto, @monto, 0, 0, 0, 0,
			 0  , 0, 0, 0, 0, 1, -1, CURRENT_TIMESTAMP, @idImpuesto, @fecha, 0, @notas);


			
			
      
		   










GO

