

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCAPPAG5cs')
BEGIN
	DROP PROC pCAPPAG5cs
	SELECT 'pCAPPAG5cs BORRADO' AS info
END
GO

CREATE PROCEDURE pCAPPAG5cs
    @TipoOperacion VARCHAR(10), 
    @Id5Cs INT = NULL OUTPUT,
    @IdCapacidadPago INT = NULL,
    @Caracter VARCHAR(MAX) = NULL,
    @CapacidadPagoGestion VARCHAR(MAX) = NULL,
    @Capital VARCHAR(MAX) = NULL,
    @Colateral VARCHAR(MAX) = NULL,
    @Condiciones VARCHAR(MAX) = NULL,
    @Aplicacion VARCHAR(MAX) = NULL
AS
BEGIN
    IF @TipoOperacion = 'C'
    BEGIN
		EXEC pCAPPAG5cs @TipoOperacion='D',@IdCapacidadPago=@IdCapacidadPago

        INSERT INTO dbo.tCAPPAG5cs (IdCapacidadPago, Caracter, CapacidadPagoGestion, Capital, Colateral, Condiciones, Aplicacion)
        VALUES (@IdCapacidadPago, @Caracter, @CapacidadPagoGestion, @Capital, @Colateral, @Condiciones, @Aplicacion);

		SET @Id5Cs=SCOPE_IDENTITY();
		
		RETURN 1
    END
    
	IF @TipoOperacion = 'D'
    BEGIN
        DELETE FROM dbo.tCAPPAG5cs 
		WHERE IdCapacidadPago = @IdCapacidadPago
			AND Id5Cs=@Id5Cs;

		RETURN @@ROWCOUNT;
    END
    
	IF @TipoOperacion = 'R'
    BEGIN
        SELECT Id5Cs,
               IdCapacidadPago,
               Caracter,
               CapacidadPagoGestion,
               Capital,
               Colateral,
               Condiciones,
               Aplicacion
        FROM dbo.tCAPPAG5cs  WITH(NOLOCK) 
        WHERE IdCapacidadPago = @IdCapacidadPago;

		RETURN 1
    END
END;
