
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEMbusquedaListaCuentas')
BEGIN
	DROP PROC pEMbusquedaListaCuentas
	SELECT 'pEMbusquedaListaCuentas BORRADO' AS info
END
GO

CREATE PROC [dbo].[pEMbusquedaListaCuentas]
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
		SET @TipoSaldo=CASE @TipoCuenta WHEN 'PDD' THEN 'Avail' WHEN 'PSV' THEN 'Avail' WHEN 'PIN' THEN 'Current' WHEN 'PLN' THEN 'PayoffAmt' END 
		

		DECLARE @IdSocio AS INT=0

		SET @IdSocio=ISNULL((SELECT soc.IdSocio FROM dbo.tSCSsocios soc WITH(NOLOCK)WHERE soc.Codigo=@Socio),0)

		SELECT @NumeroRegistros=COUNT(c.IdSocio)
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tSCSsocios s WITH(NOLOCK)ON s.IdSocio = c.IdSocio
		WHERE c.IdSocio =@IdSocio
			AND c.IdEstatus=@idestatus 
				AND c.IdTipoDProducto=@IdTipoDproducto
					AND c.EsMancomunada=0 /* @^..^@   JCA.15/02/2024.04:55 p. m. Nota: Excluir las mancomunadas   */
		
		
		
		SELECT c.idcuenta,s.idsocio,s.codigo AS SocioCodigo,  @TipoCuenta AS TipoCuenta,c.Codigo AS CuentaCodigo ,
		pf.codigo AS IdentificadorProducto
		,CASE WHEN pme.PermiteDepositos=0 AND pme.PermiteRetiros=0 THEN '001'
		      WHEN pme.PermiteDepositos=1 AND pme.PermiteRetiros=1 THEN '002'
			  WHEN pme.PermiteDepositos=1 AND pme.PermiteRetiros=0 THEN '003'
			  WHEN pme.PermiteDepositos=0 AND pme.PermiteRetiros=1 THEN '004'
			  END AS ClasificacionProducto
		
		,'' AS CodigoRelacionCuentas,
		YEAR(c.FechaActivacion) AS FechaAperturaAño,LEFT (REPLACE(STR(MONTH(c.FechaActivacion), 2), ' ', '0'),2 ) AS FechaAperturaMes,LEFT (REPLACE(STR(DAY(c.FechaActivacion), 2), ' ', '0'),2 ) AS FechaAperturaDia
		,YEAR(c.Vencimiento) AS FechaVencimientoAño,LEFT (REPLACE(STR(MONTH(c.Vencimiento), 2), ' ', '0'),2 ) AS FechaVencimientoMes,LEFT (REPLACE(STR(DAY(c.Vencimiento), 2), ' ', '0'),2 ) AS FechaVencimientoDia
		,@EstatusCuenta AS EstatusCuenta,pf.Descripcion AS CuentaDescripcion 
		,CAST( sd.Saldo  AS NUMERIC(38,2)) AS Saldo, @NumeroRegistros AS NumeroRegistros,@TipoSaldo AS TipoSaldo
		FROM dbo.tAYCcuentas c WITH(NOLOCK)
		JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)ON pf.IdProductoFinanciero=c.IdProductoFinanciero
		JOIN tAYCproductosFinancierosMontosEntumovil pme WITH (NOLOCK) ON pme.IdProductoFinanciero = pf.IdProductoFinanciero 
		JOIN dbo.tSCSsocios s WITH(NOLOCK)ON s.IdSocio = c.IdSocio
		JOIN dbo.tSDOsaldos sd WITH(NOLOCK)ON sd.IdSaldo=c.IdSaldo
		WHERE c.IdSocio =@IdSocio
		AND c.IdEstatus=@idestatus AND c.IdTipoDProducto=@IdTipoDproducto
		AND pme.IdEstatus=1 AND pme.EsVisibleMovil=1
		AND NOT EXISTS(SELECT 1 FROM tAYCmovimientosContingenciaE contingencia  WITH(NOLOCK)  WHERE contingencia.IdCuenta=c.IdCuenta)
			AND c.EsMancomunada=0 /* @^..^@   JCA.15/02/2024.04:55 p. m. Nota: Excluir las mancomunadas   */
			                      
		
		

	END
 









GO

