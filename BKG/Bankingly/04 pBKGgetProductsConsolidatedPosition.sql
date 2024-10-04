

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetProductsConsolidatedPosition')
BEGIN
	DROP PROC pBKGgetProductsConsolidatedPosition
	SELECT 'pBKGgetProductsConsolidatedPosition BORRADO' AS info
END
GO

CREATE PROC pBKGgetProductsConsolidatedPosition
@ClientBankIdentifiers AS VARCHAR(24),
@ProductTypes AS VARCHAR(7)=''
AS
BEGIN

	

	DECLARE @cuentas AS TABLE
	(
		IdSocio					INT,
		NoSocio					VARCHAR(24),
		Nombre					VARCHAR(250),
		ProductoDescripcion		VARCHAR(80),
		IdCuenta				INT,
		NoCuenta				VARCHAR(30),
		Tasa					NUMERIC(8,5),
		Vencimiento				DATE,
		NumeroParcialidades		INT,
		IdTipoDProducto			INT,
		IdProductoFinanciero	INT,
		IdSucursal				INT,
		IdApertura				INT,
		SaldoCapital			NUMERIC(18,2),
		SaldoDisponible			NUMERIC(18,2)
	)

	INSERT INTO @cuentas (IdSocio,NoSocio,Nombre,ProductoDescripcion,IdCuenta,NoCuenta,Tasa,Vencimiento,NumeroParcialidades,IdTipoDProducto,IdProductoFinanciero,IdSucursal,IdApertura,SaldoCapital,SaldoDisponible)
	SELECT sc.IdSocio,sc.Codigo,p.Nombre,pf.Descripcion,c.IdCuenta,c.Codigo,c.InteresOrdinarioAnual,c.Vencimiento,c.NumeroParcialidades,c.IdTipoDProducto,pf.IdProductoFinanciero,c.IdSucursal,c.IdApertura, c.SaldoCapital
	,fs.MontoDisponible
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio 
												AND sc.IdEstatus=1 
												AND sc.Codigo= @ClientBankIdentifiers
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	INNER JOIN dbo.fAYCsaldo(0) fs ON fs.IdCuenta = c.IdCuenta
	WHERE c.IdEstatus=1

	DECLARE @parcialidades AS TABLE
	(
		IdParcialidad				INT,
		NumeroParcialidad			INT,
		DiasCalculados				INT,
		Inicio						DATE,
		Vencimiento					DATE,
		IdPeriodo					INT,
		IdCuenta					INT,
		EstaPagada					BIT,
		Fin							DATE,
		IdApertura					INT,
		IdEstatus					INT,
		FechaPago					DATE,
		EsPeriodoGracia				INT,
		EsPeriodoGraciaCapital		BIT
	)

	INSERT INTO @parcialidades
	(
	    IdParcialidad,
	    NumeroParcialidad,
	    DiasCalculados,
	    Inicio,
	    Vencimiento,
	    IdPeriodo,
	    IdCuenta,
	    EstaPagada,
	    Fin,
	    IdApertura,
	    IdEstatus,
	    FechaPago,
	    EsPeriodoGracia,
	    EsPeriodoGraciaCapital
	)
	SELECT p.IdParcialidad,
		   p.NumeroParcialidad,
		   p.DiasCalculados,
		   p.Inicio,
		   p.Vencimiento,
		   p.IdPeriodo,
		   p.IdCuenta,
		   p.EstaPagada,
		   p.Fin,
		   p.IdApertura,
		   p.IdEstatus,
		   p.FechaPago,
		   p.EsPeriodoGracia,
		   p.EsPeriodoGraciaCapital
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	INNER JOIN @cuentas c ON c.IdCuenta = p.IdCuenta
	AND c.IdApertura = p.IdApertura
	AND c.IdTipoDProducto=143
	WHERE p.IdEstatus=1 

	DECLARE @fechaCartera AS DATE=(SELECT MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(NOLOCK)
									INNER JOIN @cuentas c ON c.IdCuenta = cartera.IdCuenta)

	SELECT 
	ClientBankIdentifier				= c.NoSocio,
	ProductBankIdentifier				= c.NoCuenta,
	ProductTypeId						= pt.ProductTypeId,
	ProductAlias						= c.ProductoDescripcion,
	ProductNumber						= c.NoCuenta,
	LocalCurrencyId						= '484',
	LocalBalance						= CASE
											WHEN c.IdTipoDProducto=143
											THEN Capital + InteresOrdinario + InteresMoratorioVigente + InteresMoratorioVencido + InteresMoratorioCuentasOrden + IVAInteresOrdinario + IVAinteresMoratorio + Cargos + CargosImpuestos
											ELSE c.SaldoDisponible
											END ,
	InternationalCurrencyId				= '840',
	InternationalBalance				= CASE
											WHEN c.IdTipoDProducto=143
											THEN Capital + InteresOrdinario + InteresMoratorioVigente + InteresMoratorioVencido + InteresMoratorioCuentasOrden + IVAInteresOrdinario + IVAinteresMoratorio + Cargos + CargosImpuestos
											ELSE c.SaldoDisponible
											END ,
	Rate								= c.Tasa,
	ExpirationDate						= c.Vencimiento,
	PaidFees							= pagadas.ppagadas,
	Term								= c.NumeroParcialidades,
	NextFeeDueDate						= cartera.ProximoVencimiento,
	ProductOwnerName					= c.Nombre,
	ProductBranchName					= suc.Descripcion,
	CanTransact							= t.CanTransactType,
	SubsidiaryId						= '1', -- suc.Codigo,
	SubsidiaryName						= suc.Descripcion,
	BackendId							= c.IdCuenta
	FROM @cuentas c
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = c.IdProductoFinanciero
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
	LEFT JOIN dbo.tAYCcartera cartera  WITH(NOLOCK) ON cartera.IdCuenta = c.IdCuenta
	AND cartera.FechaCartera=@fechaCartera
	LEFT JOIN (
				SELECT IdCuenta, IdApertura, COUNT(1) ppagadas FROM @parcialidades 
				WHERE EstaPagada=1
				GROUP BY IdApertura, IdCuenta
				) pagadas ON pagadas.IdApertura = c.IdApertura AND pagadas.IdCuenta = c.IdCuenta
				

END
GO

