

IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tAYCcaptacion')
BEGIN
	-- DROP TABLE tAYCcaptacion
	
	CREATE TABLE [dbo].[tAYCcaptacion](
		[Fecha]								DATE,
		IdTipoDproducto						INT,
		[IdCuenta]							[int] NOT NULL,
		[IdSaldo]							[INT] NOT NULL,
		[Capital]							[NUMERIC](25, 8) NULL,
		[InteresOrdinario]					[NUMERIC](25, 8) NULL,
		[InteresPendienteCapitalizar]		[NUMERIC](23, 8) NOT NULL,
		[MontoBloqueado]					[NUMERIC](23, 8) NOT NULL,
		[MontoDisponible]					[NUMERIC](38, 8) NULL,
		[Saldo]								[NUMERIC](38, 8) NULL,
		[SaldoBalanceCuentasOrden]			[NUMERIC](38, 8) NULL,
		[IdEstatus]							[INT] NOT NULL,
		[Alta]								DATETIME	
	)

	SELECT 'OBJETO tAYCcaptacion Creado' AS info

END
GO

SELECT 'OBJETO tAYCcaptacion Existente' AS info
GO
