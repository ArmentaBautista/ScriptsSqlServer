

IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='tPLDdesagregadoOperacionesProductosFinancierosMetodoPago')
BEGIN

		CREATE TABLE tPLDdesagregadoOperacionesProductosFinancierosMetodoPago(
				Id	INT	PRIMARY KEY IDENTITY,
				Fecha	DATE,
				Alta	DATETIME,
				CodigoSucursal	VARCHAR(12),
				Sucursal	VARCHAR(80),
				TipoOperacion	VARCHAR(30),
				Folio	INT,
				TipoMovimiento	VARCHAR(30),
				MetodoPago	VARCHAR(30),
				PagadoCapital	NUMERIC(13,2),
				PagadoIO	NUMERIC(13,2),
				PagadoIM	NUMERIC(13,2),
				PagadoIVA	NUMERIC(13,2),
				SaldoCapitalAnterior	NUMERIC(13,2),
				Total	NUMERIC(13,2),
				MontoSubOperacion	NUMERIC(13,2),
				SaldoCapital	NUMERIC(13,2),
				NoSocio	VARCHAR(24),
				Nombre	VARCHAR(128),
				RFC	VARCHAR(32),
				NoCuenta	VARCHAR(24),
				Producto	VARCHAR(80),
				TipoProducto	VARCHAR(250),
				Usuario	VARCHAR(40),
				NivelRiesgo	VARCHAR(250)
		)

END
GO

