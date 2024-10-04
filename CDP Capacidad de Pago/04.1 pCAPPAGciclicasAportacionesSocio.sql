
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCAPPAGciclicasAportacionesSocio')
BEGIN
	DROP PROC pCAPPAGciclicasAportacionesSocio
	SELECT 'pCAPPAGciclicasAportacionesSocio BORRADO' AS info
END
GO

CREATE PROCEDURE pCAPPAGciclicasAportacionesSocio
    @TipoOperacion VARCHAR(10)='', 
    @IdAportacionSocio INT = NULL,
    @IdCapacidadPago INT = NULL,
    @Concepto VARCHAR(32) = NULL,
    @Monto NUMERIC(11,2) = NULL
AS
BEGIN
	IF @TipoOperacion = ''
		RETURN 0

    IF @TipoOperacion = 'C'
    BEGIN
        INSERT INTO dbo.tCAPPAGciclicasAportacionesSocio (IdCapacidadPago, Concepto, Monto)
        VALUES (@IdCapacidadPago, @Concepto, @Monto);

		RETURN 1;
    END
    
	IF @TipoOperacion = 'D'
    BEGIN
        DELETE FROM dbo.tCAPPAGciclicasAportacionesSocio WHERE IdAportacionSocio = @IdAportacionSocio;

		RETURN 1;
    END
    
	IF @TipoOperacion = 'LST'
    BEGIN
        SELECT 
		cs.IdAportacionSocio,
        cs.IdCapacidadPago,
        cs.Concepto,
        cs.Monto
        FROM dbo.tCAPPAGciclicasAportacionesSocio cs WITH(NOLOCK) 
        WHERE IdCapacidadPago = @IdCapacidadPago;

		RETURN 1;
    END
    
END;

