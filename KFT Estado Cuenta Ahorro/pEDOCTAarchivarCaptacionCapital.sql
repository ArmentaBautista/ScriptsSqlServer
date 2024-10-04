


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pEDOCTAarchivarCaptacionCapital')
BEGIN
	DROP PROC pEDOCTAarchivarCaptacionCapital
	SELECT 'pEDOCTAarchivarCaptacionCapital BORRADO' AS info
END
GO

CREATE PROC pEDOCTAarchivarCaptacionCapital
AS
BEGIN
	
	DECLARE @pFecha DATETIME=GETDATE()-1;

	DECLARE 
	@periodo VARCHAR(18)='',
	@idPeriodo INT,
	@fechaInicioPeriodo DATE,
	@fechaFinPeriodo DATE,
	@diasPeriodo INT

	SELECT @idPeriodo=per.IdPeriodo, @periodo=per.Codigo, @fechaInicioPeriodo=per.Inicio, @fechaFinPeriodo=per.Fin 
	FROM dbo.tCTLperiodos per  WITH(NOLOCK) 
	WHERE per.EsAjuste=0  
	AND @pFecha BETWEEN per.Inicio AND per.Fin

	SET @diasPeriodo=DAY(EOMONTH(@fechaFinPeriodo))

	/*  (◕ᴥ◕)    JCA.19/09/2023.02:45 a. m. Nota: Cuentas Activas  */
	INSERT INTO iERP_KFT_EC.dbo.tEDOCTAcaptacionCapital	
	SELECT
	c.IdCuenta,
	c.Codigo,
	c.IdSocio,
	c.IdTipoDProducto,
	tp.Descripcion,			
	pf.IdProductoFinanciero,
	pf.Descripcion,
	c.InteresOrdinarioAnual,
	ISNULL(c.GAT,0),
	ISNULL(c.GATreal,0),
	a.IdApertura,
	a.Folio,
	c.IdEstatus,
	@IdPeriodo,
	@Periodo,
	@diasPeriodo
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
		ON tp.IdTipoD = c.IdTipoDProducto
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
		ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	LEFT JOIN dbo.tAYCaperturas a  WITH(NOLOCK) 
		ON a.IdApertura = c.IdApertura
	WHERE c.IdTipoDProducto IN (144,398,716,2621)
		AND c.FechaAlta BETWEEN @fechaInicioPeriodo AND @fechaFinPeriodo
		AND c.IdEstatus=1

	/* ฅ^•ﻌ•^ฅ   JCA.19/09/2023.02:53 a. m. Nota: Cuentas Cerradas   */
	INSERT INTO iERP_KFT_EC.dbo.tEDOCTAcaptacionCapital	
	SELECT
	c.IdCuenta,
	c.Codigo,
	c.IdSocio,
	c.IdTipoDProducto,
	tp.Descripcion,			
	pf.IdProductoFinanciero,
	pf.Descripcion,
	c.InteresOrdinarioAnual,
	ISNULL(c.GAT,0),
	ISNULL(c.GATreal,0),
	a.IdApertura,
	a.Folio,
	c.IdEstatus,
	@IdPeriodo,
	@Periodo,
	@diasPeriodo
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLtiposD tp  WITH(NOLOCK) 
		ON tp.IdTipoD = c.IdTipoDProducto
	INNER JOIN dbo.tAYCcuentasEstadisticas e  WITH(NOLOCK) 
		ON e.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) 
		ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	LEFT JOIN dbo.tAYCaperturas a  WITH(NOLOCK) 
		ON a.IdApertura = c.IdApertura
	WHERE c.IdTipoDProducto IN (144,398,716,2621)
		AND e.FechaBaja BETWEEN @fechaInicioPeriodo AND @fechaFinPeriodo
		AND c.IdEstatus=7

	/* ฅ^•ﻌ•^ฅ   JCA.19/09/2023.11:05 a. m. Nota: Estadisticos Parte1   */
	INSERT INTO iERP_KFT_EC.dbo.tEDOCTAcaptacionCapitalEstadisticos
	(
		IdCuenta, 					
		IdPeriodo,	
		IdSucursal,
		FechaAperturaReinversion,
		InteresesDevengados,			
		InteresesPagados,			
		Comisiones,						
		Vencimiento,		
		SaldoPromedio,				
		SaldoInicial,				
		SaldoInicialCapital,			
		SaldoInteresInicial,			
		SaldoCapital,				
		SaldoInteres,				
		SaldoFinal
	)
	select 
		ha.IdCuenta, 					
		ha.IdPeriodo,
		ha.IdSucursal,
		ha.FechaAperturaReinversion,
		ha.InteresesDevengados,			
		ha.InteresesPagados,			
		ha.Comisiones,						
		ha.Vencimiento,		
		ha.SaldoPromedio,				
		ha.SaldoInicial,				
		ha.SaldoInicialCapital,			
		ha.SaldoInteresInicial,			
		ha.SaldoCapital,				
		ha.SaldoInteres,				
		ha.SaldoFinal					
	FROM dbo.tsdohistorialacreedoras ha WITH(NOLOCK) 
	WHERE idperiodo=@IdPeriodo


END
GO