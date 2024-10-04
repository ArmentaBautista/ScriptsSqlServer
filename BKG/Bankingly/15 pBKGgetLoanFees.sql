
-- 15 pBKGgetLoanFees


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetLoanFees')
BEGIN
	DROP PROC pBKGgetLoanFees
	SELECT 'pBKGgetLoanFees BORRADO' AS info
END
GO

CREATE PROC pBKGgetLoanFees
@ProductBankIdentifier  AS VARCHAR(32),			-- Identificador interno del producto 
@FeesStatus	INT,								-- 0 = Todas	1 = Pagadas	2 = No pagadas
-- Paggin
@OrderByField AS VARCHAR(128)='',
@PageStartIndex AS INT=1,
@PageSize AS INT=999
--
,@LoanFeesCountOut INT OUTPUT
AS
BEGIN
    
--#region Documentación
	/*
	CapitalBalance		decimal?	Saldo o balance del capital del préstamo
	FeeNumber			int			Numero de cuota
	PrincipalAmount		decimal		Monto principal de la cuota
	DueDate				DateTime	Fecha de vencimiento de la cuota
	InterestAmount		decimal		Monto de interés
	OverdueAmount		decimal		Monto de mora
	FeeStatusId			byte		Estado de la cuota según LoanFeeStatus
	OthersAmount		decimal		Otros conceptos asociados a la cuota
	TotalAmount			decimal		Monto total de la cuota
	*/
--#endregion Documentación

	DECLARE @idCuenta AS INT=0
	DECLARE @LoanFeesCount AS INT=0
	SELECT @idcuenta=c.idcuenta, @LoanFeesCount=c.numeroparcialidades FROM dbo.tAYCcuentas c WITH(NOLOCK) WHERE c.Codigo=@ProductBankIdentifier
	SET @LoanFeesCountOut= @LoanFeesCount;

	DECLARE @CapitalBalance AS NUMERIC(23,8)
	
	SELECT TOP 1 @CapitalBalance = cartera.Capital FROM dbo.tAYCcartera cartera  WITH(NOLOCK) WHERE cartera.IdCuenta=@idCuenta ORDER BY cartera.FechaCartera DESC


DECLARE @query AS nVARCHAR(MAX) =''

SET @query = CONCAT('SELECT
    CapitalBalance  = ', @CapitalBalance,'
   ,FeeNumber       = p.NumeroParcialidad
   ,PrincipalAmount = CASE
                          WHEN ( p.CapitalPagado + p.CapitalCondonado ) > ( p.Capital ) THEN
                              p.Capital + (( p.CapitalPagado + p.CapitalCondonado ) - p.Capital )
                          ELSE
                              p.Capital
                      END
   ,DueDate         = p.Vencimiento
   ,InterestAmount  = p.InteresOrdinarioCalculado - p.InteresOrdinarioPagado - p.InteresOrdinarioCondonado
                      + p.IVAInteresOrdinario + ROUND(p.InteresOrdinarioCuentasOrden * cuenta.TasaIva, 2)
                      - p.IVAInteresOrdinarioPagado - p.IVAInteresOrdinarioCondonado
   ,OverdueAmount   = p.InteresMoratorioCalculado - p.InteresMoratorioPagado - p.InteresMoratorioCondonado
                      + p.IVAInteresMoratorio + ROUND(p.InteresMoratorioCuentasOrden * cuenta.TasaIva, 2)
                      - p.IVAInteresMoratorioPagado - p.IVAInteresMoratorioCondonado
   ,FeeStatusId     = IIF(p.EstaPagada = 0, 2, 3)
   ,OthersAmount    = p.SaldoCargo1 + p.SaldoIVAcargo1 + p.SaldoCargo2 + SaldoIVAcargo2 + p.SaldoCargo3 + SaldoIVAcargo3
   ,TotalAmount     = CASE
                          WHEN ( p.CapitalPagado + p.CapitalCondonado ) > ( p.Capital ) THEN
                              p.Capital + (( p.CapitalPagado + p.CapitalCondonado ) - p.Capital )
                          ELSE
                              p.Capital
                      END
                      + ( p.InteresOrdinarioCalculado - p.InteresOrdinarioPagado - p.InteresOrdinarioCondonado
                          + p.IVAInteresOrdinario + ROUND(p.InteresOrdinarioCuentasOrden * cuenta.TasaIva, 2)
                          - p.IVAInteresOrdinarioPagado - p.IVAInteresOrdinarioCondonado
                        )
                      + ( p.InteresMoratorioCalculado - p.InteresMoratorioPagado - p.InteresMoratorioCondonado )
                      + p.SaldoCargo1 + p.SaldoIVAcargo1 + p.SaldoCargo2 + SaldoIVAcargo2 + p.SaldoCargo3 + SaldoIVAcargo3
FROM
    dbo.tAYCparcialidades      p WITH ( NOLOCK )
    INNER JOIN dbo.tAYCcuentas cuenta WITH ( NOLOCK )
        ON cuenta.IdCuenta       = p.IdCuenta
           AND cuenta.IdApertura = p.IdApertura
           AND p.IdEstatus       = 1
WHERE
    p.IdCuenta =',@idCuenta)

	--PRINT @query

	-- Filtro adicional del estatus
	IF @FeesStatus=1
		SET @query=CONCAT(@query,' AND p.EstaPagada=1 ')

	IF @FeesStatus=2
		SET @query=CONCAT(@query,' AND p.EstaPagada=0 ')


	-- Establecer datos de la paginación
		DECLARE @offset INT
		SET @offset = (@PageStartIndex - 1) * @PageSize

		--Determinación de ORDER BY
		IF (@OrderByField is NULL OR @OrderByField='')
			SET @OrderByField='p.NumeroParcialidad ASC'

	
		-- Implementación de Ordenamiento dinámico
		SET @query = CONCAT(@query,
												' ORDER BY ', @OrderByField,
												' OFFSET ', @offset ,' ROWS ',
												' FETCH NEXT ', @PageSize ,' ROWS ONLY')
		--PRINT @query	

		EXEC sys.sp_executesql @query

END
GO
