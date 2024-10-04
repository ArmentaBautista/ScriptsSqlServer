

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCAPPAGgestionSumador')
BEGIN
	DROP PROC pCAPPAGgestionSumador
	SELECT 'pCAPPAGgestionSumador BORRADO' AS info
END
GO

CREATE PROCEDURE pCAPPAGgestionSumador
    @TipoOperacion VARCHAR(10), 
    @IdItem INT = 0 OUTPUT,
    @IdCapacidadPago INT = 0,
    @Año SMALLINT = 0,
    @Mes TINYINT = 0,
    @Fecha DATE ='19000101',
    @Concepto VARCHAR(160) ='',
    @TipoComprobante VARCHAR(32) = '',
    @Monto NUMERIC(10,2) = 0,
    @IdEstatus INT = 1,
    @IdSesion INT  = 1
AS
BEGIN
    IF @TipoOperacion = 'C'
    BEGIN
        INSERT INTO tCAPPAGsumador (IdCapacidadPago, Año, Mes, Fecha, Concepto, TipoComprobante, Monto, IdSesion)
        VALUES (@IdCapacidadPago, @Año, @Mes, @Fecha, @Concepto, @TipoComprobante, @Monto, @IdSesion);

		SET @IdItem = SCOPE_IDENTITY();

		EXEC dbo.pCAPPAGgestionSumador @TipoOperacion='R',@IdCapacidadPago=@IdCapacidadPago

		RETURN 1
    END
    
	IF @TipoOperacion = 'D'
    BEGIN
        UPDATE s SET s.IdEstatus=2 FROM tCAPPAGsumador s WHERE IdItem = @IdItem AND s.IdEstatus<>2;

		EXEC dbo.pCAPPAGgestionSumador @TipoOperacion='R',@IdCapacidadPago=@IdCapacidadPago

		RETURN @@ROWCOUNT
    END
    
	IF @TipoOperacion = 'R'
    BEGIN
        IF @IdItem<>0
		BEGIN
			SELECT s.IdItem,
                   s.IdCapacidadPago,
                   s.Año,
                   s.Mes,
                   s.Fecha,
                   s.Concepto,
                   s.TipoComprobante,
                   s.Monto
			FROM dbo.tCAPPAGsumador s  WITH(NOLOCK)
			WHERE s.IdEstatus=1
				AND s.IdItem=@IdItem

			RETURN 1
        END
		
		IF @IdCapacidadPago<>0
        BEGIN
            SELECT s.IdItem,
                   s.IdCapacidadPago,
                   s.Año,
                   s.Mes,
                   s.Fecha,
                   s.Concepto,
                   s.TipoComprobante,
                   s.Monto
			FROM dbo.tCAPPAGsumador s  WITH(NOLOCK)
			WHERE s.IdEstatus=1
				AND s.IdCapacidadPago=@IdCapacidadPago

			RETURN 1
        END

    END
END;

