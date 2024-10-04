
-- [13] GetLoan

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoan')
BEGIN
	DROP PROC pBKGgetLoan
	SELECT 'pBKGgetLoan BORRADO' AS info
END
GO

CREATE PROC pBKGgetLoan
@ProductBankIdentifier AS VARCHAR(32),
@FeesStatus AS INT,
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=1,
@PageSize AS INT=999
AS
BEGIN

	DECLARE  @fechaTrabajo AS DATE=GETDATE();
	
	DECLARE @cuentas AS TABLE
	(
		IdSocio					INT,
		NoSocio					VARCHAR(24),
		Nombre					VARCHAR(250),
		ProductoDescripcion		VARCHAR(80),
		IdCuenta				INT,
		NoCuenta				VARCHAR(30),
		Monto					NUMERIC(18,2),
		Tasa					NUMERIC(18,2),
		Vencimiento				DATE,
		NumeroParcialidades		INT,
		IdTipoDProducto			INT,
		IdProductoFinanciero	INT,
		IdSucursal				INT,
		IdApertura				INT,
		SaldoCapital			NUMERIC(18,2),
		IdEstatus				INT
	)

	INSERT INTO @cuentas (IdSocio,NoSocio,Nombre,ProductoDescripcion,IdCuenta,NoCuenta,Monto,Tasa,Vencimiento,NumeroParcialidades,IdTipoDProducto,IdProductoFinanciero,IdSucursal,IdApertura,SaldoCapital,IdEstatus)
	SELECT sc.IdSocio,sc.Codigo,p.Nombre,pf.Descripcion,c.IdCuenta,c.Codigo,c.Monto,c.InteresOrdinarioAnual,c.Vencimiento,c.NumeroParcialidades,c.IdTipoDProducto,pf.IdProductoFinanciero,c.IdSucursal,c.IdApertura, c.SaldoCapital,c.IdEstatus
	FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio 
	INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)  ON pf.IdProductoFinanciero = c.IdProductoFinanciero
	WHERE c.Codigo=@ProductBankIdentifier
	
	DECLARE @parcialidades AS TABLE
	(
		[IdParcialidad]					[INT], 
		[NumeroParcialidad]				[INT],
		[DiasCalculados]				[INT] ,
		[Inicio]						[DATE] ,
		[Vencimiento]					[DATE] ,
		[IdPeriodo]						[INT] ,
		[CapitalInicial]				[NUMERIC] (23, 8) ,
		[Capital]						[NUMERIC] (23, 8) ,
		[CapitalFinal]					[NUMERIC] (23, 8) ,
		[InteresOrdinarioEstimado]		[NUMERIC] (23, 8) ,
		[IVAInteresOrdinarioEstimado]	[numeric] (23, 8) ,
		[TotalSinAhorro]				[NUMERIC] (23, 8) ,
		[Ahorro]						[NUMERIC] (23, 8) ,
		[Total]							[numeric] (23, 8) ,
		[Notas]							[varchar] (1024) ,
		[IdCuenta]						[INT] ,
		[IdBloque]						[INT] ,
		[NumeroBloque]					[INT] ,
		[InteresOrdinario]				[NUMERIC] ,
		[InteresMoratorio]				[NUMERIC] ,
		[IVAInteresOrdinario]			[NUMERIC] ,
		[IVAInteresMoratorio]			[NUMERIC] ,
		[CapitalPagado]					[NUMERIC] (23, 8) ,
		[InteresOrdinarioPagado]		[NUMERIC] (23, 8) ,
		[InteresMoratorioPagado]		[NUMERIC] (23, 8) ,
		[IVAInteresOrdinarioPagado]		[NUMERIC] (23, 8) ,
		[IVAInteresMoratorioPagado]		[NUMERIC] (23, 8) ,
		[CapitalCondonado]				[NUMERIC] (23, 8) ,
		[InteresOrdinarioCondonado]		[NUMERIC] (23, 8) ,
		[InteresMoratorioCondonado]		[NUMERIC] (23, 8) ,
		[IVAInteresOrdinarioCondonado]	[NUMERIC] (23, 8) ,
		[IVAInteresMoratorioCondonado]	[NUMERIC] (23, 8) ,
		[PagadoInteresOrdinario]		[DATE] ,
		[PagadoInteresMoratorio]		[DATE] ,
		[PagadoCapital]					[DATE] ,
		[UltimoCalculoInteresMoratorio]	[DATE] ,
		[EstaPagada]					[BIT] ,
		[Orden]							[INT] ,
		[Ahorrado]						[NUMERIC] (23, 8) ,
		[RelParcialidades]				[INT] ,
		[InteresOrdinarioCuentasOrden]	[NUMERIC] (23, 8) ,
		[InteresMoratorioCuentasOrden]	[NUMERIC] (23, 8) ,
		[NumeroEntrega]					[INT] ,
		[CapitalGenerado]				[NUMERIC] (23, 8) ,
		[Fin]							[DATE] ,
		[IdApertura]					[INT] ,
		[IdEstatus]						[INT] ,
		[VencimientoOriginal]			[DATE] ,
		[SaldoCargo1]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo1]				[NUMERIC] (18, 2) ,
		[SaldoCargo2]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo2]				[NUMERIC] (18, 2) ,
		[SaldoCargo3]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo3]				[NUMERIC] (18, 2) ,
		[SaldoCargo4]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo4]				[NUMERIC] (18, 2) ,
		[SaldoCargo5]					[NUMERIC] (18, 2) ,
		[SaldoIVAcargo5]				[NUMERIC] (18, 2) ,
		[PagoProgramado]				[NUMERIC] (18, 2) ,
		[FechaPago]						[DATE] ,
		[EsPeriodoGracia]				[INT] ,
		[InteresOrdinarioCalculado]		[NUMERIC] (18, 2) ,-- AS ([InteresOrdinario]+[InteresOrdinarioCuentasOrden]), REVISAR CON IMM
		[InteresMoratorioCalculado]		[NUMERIC] (18, 2) ,-- AS ([InteresMoratorio]+[InteresMoratorioCuentasOrden]), REVISAR CON IMM
		[EsPeriodoGraciaCapital]		[BIT] ,
		[TieneInteresesAplazados]		[BIT]
	)

	INSERT INTO @parcialidades
	(
	    IdParcialidad,
		NumeroParcialidad,
		DiasCalculados,
		Inicio,
		Vencimiento,
		IdPeriodo,
		CapitalInicial,
		Capital,
		CapitalFinal,
		InteresOrdinarioEstimado,
		IVAInteresOrdinarioEstimado,
		TotalSinAhorro,
		Ahorro,
		Total,
		Notas,
		IdCuenta,
		IdBloque,
		NumeroBloque,
		InteresOrdinario,
		InteresMoratorio,
		IVAInteresOrdinario,
		IVAInteresMoratorio,
		CapitalPagado,
		InteresOrdinarioPagado,
		InteresMoratorioPagado,
		IVAInteresOrdinarioPagado,
		IVAInteresMoratorioPagado,
		CapitalCondonado,
		InteresOrdinarioCondonado,
		InteresMoratorioCondonado,
		IVAInteresOrdinarioCondonado,
		IVAInteresMoratorioCondonado,
		PagadoInteresOrdinario,
		PagadoInteresMoratorio,
		PagadoCapital,
		UltimoCalculoInteresMoratorio,
		EstaPagada,
		Orden,
		Ahorrado,
		RelParcialidades,
		InteresOrdinarioCuentasOrden,
		InteresMoratorioCuentasOrden,
		NumeroEntrega,
		CapitalGenerado,
		Fin,
		IdApertura,
		IdEstatus,
		VencimientoOriginal,
		SaldoCargo1,
		SaldoIVAcargo1,
		SaldoCargo2,
		SaldoIVAcargo2,
		SaldoCargo3,
		SaldoIVAcargo3,
		SaldoCargo4,
		SaldoIVAcargo4,
		SaldoCargo5,
		SaldoIVAcargo5,
		PagoProgramado,
		FechaPago,
		EsPeriodoGracia,
		InteresOrdinarioCalculado,
		InteresMoratorioCalculado,
		EsPeriodoGraciaCapital,
		TieneInteresesAplazados
	)
	SELECT 
		p.IdParcialidad,
		p.NumeroParcialidad,
		p.DiasCalculados,
		p.Inicio,
		p.Vencimiento,
		p.IdPeriodo,
		p.CapitalInicial,
		p.Capital,
		p.CapitalFinal,
		p.InteresOrdinarioEstimado,
		p.IVAInteresOrdinarioEstimado,
		p.TotalSinAhorro,
		p.Ahorro,
		p.Total,
		p.Notas,
		p.IdCuenta,
		p.IdBloque,
		p.NumeroBloque,
		p.InteresOrdinario,
		p.InteresMoratorio,
		p.IVAInteresOrdinario,
		p.IVAInteresMoratorio,
		p.CapitalPagado,
		p.InteresOrdinarioPagado,
		p.InteresMoratorioPagado,
		p.IVAInteresOrdinarioPagado,
		p.IVAInteresMoratorioPagado,
		p.CapitalCondonado,
		p.InteresOrdinarioCondonado,
		p.InteresMoratorioCondonado,
		p.IVAInteresOrdinarioCondonado,
		p.IVAInteresMoratorioCondonado,
		p.PagadoInteresOrdinario,
		p.PagadoInteresMoratorio,
		p.PagadoCapital,
		p.UltimoCalculoInteresMoratorio,
		p.EstaPagada,
		p.Orden,
		p.Ahorrado,
		p.RelParcialidades,
		p.InteresOrdinarioCuentasOrden,
		p.InteresMoratorioCuentasOrden,
		p.NumeroEntrega,
		p.CapitalGenerado,
		p.Fin,
		p.IdApertura,
		p.IdEstatus,
		p.VencimientoOriginal,
		p.SaldoCargo1,
		p.SaldoIVAcargo1,
		p.SaldoCargo2,
		p.SaldoIVAcargo2,
		p.SaldoCargo3,
		p.SaldoIVAcargo3,
		p.SaldoCargo4,
		p.SaldoIVAcargo4,
		p.SaldoCargo5,
		p.SaldoIVAcargo5,
		p.PagoProgramado,
		p.FechaPago,
		p.EsPeriodoGracia,
		p.InteresOrdinarioCalculado,
		p.InteresMoratorioCalculado,
		p.EsPeriodoGraciaCapital,
		p.TieneInteresesAplazados
	FROM dbo.tAYCparcialidades p  WITH(NOLOCK) 
	INNER JOIN @cuentas c ON c.IdCuenta = p.IdCuenta
	AND c.IdApertura = p.IdApertura
	WHERE p.IdEstatus=1 

	DECLARE @fechaCartera AS DATE=(SELECT MAX(cartera.FechaCartera) FROM dbo.tAYCcartera cartera  WITH(NOLOCK)
									INNER JOIN @cuentas c ON c.IdCuenta = cartera.IdCuenta)

	-- Variables Calculadas
	DECLARE @parcialidadesVencidas AS INT=0
	DECLARE @parcialidadesPagadas AS INT=0

	SELECT @parcialidadesVencidas=COUNT(1) FROM @parcialidades p WHERE p.Fin<@fechaTrabajo AND p.EstaPagada=0
	SELECT @parcialidadesPagadas=COUNT(1) FROM @parcialidades p WHERE p.EstaPagada=1

--#region Definicion
	/*
		AccountBankIdentifier		string					Identificador interno de la cuenta asociada al préstamo
		CurrentBalance				decimal					Saldo o balance actual del préstamo
		CurrentRate  				decimal					Tasa de interés aplicada al préstamo
		FeesDue						int?					Cantidad de cuotas vencidas
		FeesDueData					FeesDueData				Información sobre los vencimientos de las cuotas
		LoanStatusId				byte					Estado del Préstamo (catálogo ProductStatus)
		NextFee						LoanFee					Información de la próxima cuota
		OriginalAmount				decimal					Capital original del préstamo
		OverdueDays					int?					Cantidad de días de atraso
		PaidFees					int						Cuotas pagadas
		PayoffBalance				decimal					Monto para liquidar/cancelar el préstamo (no es un saldo)
		PrepaymentAmount			decimal?				Monto para pago anticipado (total o parcial)
		ProducttBankIdentifier		string					Identificador del préstamo en el Core o Backend
		Term						int						Cantidad de cuotas del préstamo
		ShowPrincipalInformation	bool					Muestra la tabla con la información principal del préstamo, en detalle de préstamo
		GetLoanFeesResult			GetLoanFeesResult		Información sobre el resultado de las cuotas
		GetLoanRatesResult			GetLoanRatesResult		Información sobre el resultado de las tasas de interés
		GetLoanPaymentsResult		GetLoanPaymentsResult	Información sobre el resultado de los préstamos
	*/
--#endregion Definicion


	--Tabla del tipo getLoan
	DECLARE @tabla AS BKGgetLoan;

	INSERT INTO @tabla
	(
	    AccountBankIdentifier,
	    CurrentBalance,
	    CurrentRate,
	    FeesDue,
	    FeesDueInterestAmount,
	    FeesDueOthersAmount,
	    FeesDueOverdueAmount,
	    FeesDuePrincipalAmount,
	    FeesDueTotalAmount,
	    LoanStatusId,
	    CapitalBalance,
	    FeeNumber,
	    PrincipalAmount,
	    DueDate,
	    InterestAmount,
	    OverdueAmount,
	    FeeStatusId,
	    OthersAmount,
	    TotalAmount,
	    OriginalAmount,
	    OverdueDays,
	    PaidFees,
	    PayoffBalance,
	    PrepaymentAmount,
	    ProducttBankIdentifier,
	    Term,
	    ShowPrincipalInformation
	)
	SELECT 
	AccountBankIdentifier				= c.NoCuenta,
	CurrentBalance						= cartera.Capital + cartera.InteresOrdinario 
											+ cartera.InteresMoratorioVigente + cartera.InteresMoratorioVencido + cartera.InteresMoratorioCuentasOrden 
											+ cartera.IVAInteresOrdinario + cartera.IVAinteresMoratorio + cartera.Cargos + cartera.CargosImpuestos,
	CurrentRate  						= c.Tasa,
	FeesDue								= @parcialidadesVencidas, 

	-- BEGIN FeesDueData						
	FeesDueInterestAmount				=cartera.InteresOrdinarioTotalAtrasado,
	FeesDueOthersAmount					=cartera.CargosTotal,
	FeesDueOverdueAmount				=cartera.InteresMoratorioTotal,
	FeesDuePrincipalAmount				=cartera.CapitalAtrasado,
	FeesDueTotalAmount					=cartera.CapitalAtrasado+cartera.InteresOrdinarioTotalAtrasado+cartera.InteresMoratorioTotal+cartera.CargosTotal,
	-- END FeesDueData

	LoanStatusId						= pe.ProductStatusId,

	-- BEGIN NextFee - LoanFee
	CapitalBalance						= cartera.Capital,
	FeeNumber							= NoPagadas.NumeroParcialidad,
	PrincipalAmount						= NoPagadas.Capital-NoPagadas.CapitalPagado,
	DueDate								= NoPagadas.Fin,
	InterestAmount						= NoPagadas.InteresOrdinario - NoPagadas.InteresOrdinarioCondonado - NoPagadas.InteresOrdinarioPagado,
	OverdueAmount						= NoPagadas.InteresMoratorio - NoPagadas.InteresMoratorioPagado - NoPagadas.InteresMoratorioCondonado,
	FeeStatusId							= IIF(NoPagadas.Fin<@fechaTrabajo AND NoPagadas.EstaPagada=0,2,3),
	OthersAmount						= NoPagadas.SaldoCargo1 + NoPagadas.SaldoCargo2 + NoPagadas.SaldoCargo3,
	TotalAmount							= NoPagadas.Total - NoPagadas.CapitalPagado - NoPagadas.InteresOrdinarioPagado - NoPagadas.InteresMoratorioPagado
											- NoPagadas.CapitalCondonado - NoPagadas.InteresOrdinarioCondonado - NoPagadas.InteresMoratorioPagado
											- NoPagadas.IVAInteresOrdinarioPagado - NoPagadas.IVAInteresMoratorioPagado,	
	-- END NextFee - LoanFee

	OriginalAmount						= c.Monto,
	OverdueDays							= IIF(cartera.DiasMoraCapital>cartera.DiasMoraInteres,cartera.DiasMoraCapital,cartera.DiasMoraInteres),
	PaidFees							= @parcialidadesPagadas,
	PayoffBalance						= cartera.Capital + cartera.InteresOrdinario 
											+ cartera.InteresMoratorioVigente + cartera.InteresMoratorioVencido + cartera.InteresMoratorioCuentasOrden 
											+ cartera.IVAInteresOrdinario + cartera.IVAinteresMoratorio + cartera.Cargos + cartera.CargosImpuestos,
	PrepaymentAmount					= 0, -- Preguntar
	ProducttBankIdentifier				= c.NoCuenta,
	Term								= c.NumeroParcialidades,
	ShowPrincipalInformation			= 1  -- Preguntar
	FROM @cuentas c
	INNER JOIN dbo.tBKGcatalogoProductTypes pt  WITH(NOLOCK) ON pt.IdTipoDproducto = c.IdTipoDProducto
	INNER JOIN dbo.tBKGproductosCanTransactType t  WITH(NOLOCK) ON t.IdProducto = c.IdProductoFinanciero
	INNER JOIN dbo.tBKGcatalogoProductStatus pe  WITH(NOLOCK) ON pe.IdEstatus = c.idestatus
	INNER JOIN dbo.tCTLsucursales suc  WITH(NOLOCK) ON suc.IdSucursal = c.IdSucursal
	LEFT JOIN dbo.tAYCcartera cartera  WITH(NOLOCK) ON cartera.IdCuenta = c.IdCuenta
													AND cartera.FechaCartera=@fechaCartera
	LEFT JOIN (
				SELECT IdCuenta, IdApertura, COUNT(1) ppagadas FROM @parcialidades 
				WHERE EstaPagada=1
				GROUP BY IdApertura, IdCuenta
				) pagadas ON pagadas.IdApertura = c.IdApertura AND pagadas.IdCuenta = c.IdCuenta
	LEFT JOIN (
				SELECT *
					FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY IdCuenta ORDER BY p.NumeroParcialidad ASC) AS Id, *
						FROM @parcialidades p  
						WHERE p.EstaPagada=0 AND p.IdParcialidad<>0
					) np WHERE np.Id=1
				) NoPagadas ON NoPagadas.IdApertura = c.IdApertura AND NoPagadas.IdCuenta = c.IdCuenta

		-- Establecer datos de la paginación
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Determinación de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='AccountBankIdentifier ASC'

	
		-- Implementación de Ordenamiento dinámico
		DECLARE @query AS nVARCHAR(MAX) = CONCAT('SELECT * FROM @tabla ',
												'ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,' ROWS ONLY')
		--PRINT @query	

		EXEC sys.sp_executesql @query, N'@Tabla BKGgetLoan readonly',@tabla

	
END
GO