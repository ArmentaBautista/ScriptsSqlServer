
/* JCA.19/7/2024.14:38 
Nota: Procedimiento usado en el formato y pantalla "Simulador de Rendimientos de CDP"
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCsimuladorRendimientoCaptacion')
BEGIN
	DROP PROC pAYCsimuladorRendimientoCaptacion
	SELECT 'pAYCsimuladorRendimientoCaptacion BORRADO' AS info
END
GO

CREATE PROC pAYCsimuladorRendimientoCaptacion
@pMonto AS NUMERIC(12,2)
AS
BEGIN
    DECLARE  @MontoExento NUMERIC(9,2);
    SELECT @MontoExento =isnull((VecesSalario * 365 ),198140.25)
    FROM dbo.fTBLvecesSalario(5,current_timestamp)

	DECLARE @Monto AS NUMERIC(12,2)=@pMonto

	DECLARE @t AS TABLE(
	[TipoProducto]		VARCHAR(32), --X
	[CodigoProducto]	VARCHAR(24), --X
	[Producto]			VARCHAR(64),
	[Periodo]			VARCHAR(24), --X
	[DiasPeriodo]		INT,
	[TasaAnual]			NUMERIC(4,2),
	[Monto]				NUMERIC(12,2),--X
    [MontoExento]       NUMERIC(12,2),
	[Rendimiento]		AS Monto * DiasPeriodo * (TasaAnual/365),
	[RetencionISR]      as CASE WHEN ((Monto - MontoExento) * (DiasPeriodo * (TasaAnual/365)))<0 THEN 0 ELSE ((Monto - MontoExento) * (DiasPeriodo * (TasaAnual/365))) END
	--,[RendimientoNeto]   as Rendimiento - RetencionISR
	)

	INSERT INTO @t
	SELECT
	[TipoProducto]			= tprod.Descripcion,
	[CodigoProducto]		= p.Codigo,
	[Producto]				= p.Descripcion,
	[Periodo]				= IIF(tp.Dias=0 AND p.IdTipoDDominioCatalogo=144,'MENSUAL',tipop.Descripcion),
	[DiasPeriodo]			= IIF(tp.Dias=0 AND p.IdTipoDDominioCatalogo=144,30,tp.Dias),
	[TasaAnual]				= t.TasaInteresOrdinarioAnual,
	[Monto]					= @Monto,
	[MontoExento]           = @MontoExento
	FROM dbo.tAYCproductosFinancieros p  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLproductosFinancierosTasas t  WITH(NOLOCK)
		ON t.RelTasas=p.RelTasas
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
		ON ea.IdEstatusActual = p.IdEstatusActual
			AND ea.IdEstatus=1
	INNER JOIN dbo.tCTLtiposD tprod  WITH(NOLOCK) 
		ON tprod.IdTipoD = p.IdTipoDDominioCatalogo
	INNER JOIN dbo.tCTLtasasPlazos tp  WITH(NOLOCK) 
		ON tp.RelPlazos = t.RelPlazos
	INNER JOIN dbo.tCTLestatusActual eap  WITH(NOLOCK) 
		ON eap.IdEstatusActual = tp.IdEstatusActual
			AND eap.IdEstatus=1
	INNER JOIN dbo.tCTLtiposD tipop  WITH(NOLOCK) 
		ON tipop.IdTipoD = tp.IdTipoD
	WHERE p.IdTipoDDominioCatalogo IN (144,398)
	ORDER BY p.IdTipoDDominioCatalogo, p.Descripcion,tp.Dias, t.TasaInteresOrdinarioAnual

	SELECT 
	t.TipoProducto,
	t.CodigoProducto,
	t.Producto,
	t.Periodo,
	t.DiasPeriodo,
	t.TasaAnual,
	[Monto]			= FORMAT(t.Monto,'C','es-MX'),
	MontoExento,
	[Rendimiento]	= FORMAT(t.Rendimiento,'C','es-MX'),
	[RetencionISR] = FORMAT(t.RetencionISR,'C','es-MX'),
	[RendimientoNeto]   = FORMAT(Rendimiento - RetencionISR,'C','es-MX')
	FROM @t t

END