
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEMbusquedaListaCuentas2')
BEGIN
	DROP PROC pEMbusquedaListaCuentas2
	SELECT 'pEMbusquedaListaCuentas2 BORRADO' AS info
END
GO

CREATE PROC pEMbusquedaListaCuentas2
@Socio AS VARCHAR(50)='',
@TipoCuenta AS VARCHAR(3)='',
@EstatusCuenta AS VARCHAR(20)=''
AS
SET NOCOUNT ON
	SET XACT_ABORT ON	

	BEGIN
		
		DECLARE @idestatus AS INT=0
		DECLARE @IdTipoDproducto AS INT=0
		DECLARE @NumeroRegistros AS INT=0
		SET  @idestatus=CASE @EstatusCuenta WHEN 'Open' THEN 1 WHEN 'Closed' THEN 7 ELSE 1 END 
		SET @IdTipoDproducto=CASE @TipoCuenta WHEN 'PSV' THEN 144 WHEN 'PLN' THEN 143 WHEN 'PIN' THEN 398 END 
		
		DECLARE @TipoSaldo AS VARCHAR(60)=''
		SET @TipoSaldo=CASE @TipoCuenta 
							WHEN 'PDD' 
								THEN 'Avail' 
							WHEN 'PSV' 
								THEN 'Avail' 
							WHEN 'PIN' 
								THEN 'Current' 
							WHEN 'PLN' 
								THEN 'PayoffAmt' 
						END 
		
		
		DECLARE @IdSocio AS INT=0
		SELECT @IdSocio=soc.IdSocio FROM dbo.tSCSsocios soc WITH(NOLOCK)WHERE soc.Codigo=@Socio

		SELECT @NumeroRegistros=COUNT(1)
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tSCSsocios s WITH(NOLOCK)ON s.IdSocio = c.IdSocio
											AND s.IdSocio=@IdSocio
		WHERE c.IdEstatus=@idestatus AND c.IdTipoDProducto=@IdTipoDproducto
		
		SELECT 
		c.idcuenta,s.idsocio,s.codigo AS SocioCodigo,  @TipoCuenta AS TipoCuenta,c.Codigo AS CuentaCodigo ,
		pf.codigo AS IdentificadorProducto
		,CASE WHEN pme.PermiteDepositos=1 AND pme.PermiteRetiros=1 THEN '002'
			  WHEN pme.PermiteDepositos=1 AND pme.PermiteRetiros=0 THEN '003'
			  WHEN pme.PermiteDepositos=0 AND pme.PermiteRetiros=1 THEN '004'
			  WHEN pme.PermiteDepositos=0 AND pme.PermiteRetiros=0 THEN '001'
			END AS ClasificacionProducto	
		,'' AS CodigoRelacionCuentas,
		YEAR(c.FechaActivacion) AS FechaAperturaAño
		,FORMAT(MONTH(c.FechaActivacion),'00') AS FechaAperturaMes
		,FORMAT(DAY(c.FechaActivacion),'00') AS FechaAperturaDia
		,YEAR(c.Vencimiento) AS FechaVencimientoAño
		,FORMAT(MONTH(c.Vencimiento), '00') AS FechaVencimientoMes
		,FORMAT(DAY(c.Vencimiento), '00') AS FechaVencimientoDia
		,@EstatusCuenta AS EstatusCuenta
		,C.Descripcion AS CuentaDescripcion 
		,CAST( sd.Saldo  AS NUMERIC(38,2)) AS Saldo
		,@NumeroRegistros AS NumeroRegistros
		,@TipoSaldo AS TipoSaldo
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)ON pf.IdProductoFinanciero=c.IdProductoFinanciero
		JOIN tAYCproductosFinancierosMontosEntumovil pme WITH (NOLOCK) ON pme.IdProductoFinanciero = c.IdProductoFinanciero 
																		AND pme.IdEstatus=1
																		AND pme.EsVisibleMovil=1
		JOIN dbo.tSCSsocios s WITH(NOLOCK)ON s.IdSocio = c.IdSocio
											AND s.IdSocio = @IdSocio
		JOIN dbo.tSDOsaldos sd WITH(NOLOCK)ON sd.IdSaldo=c.IdSaldo
		WHERE c.IdEstatus=@idestatus AND c.IdTipoDProducto=@IdTipoDproducto
		  
		
		

	END
 









GO

