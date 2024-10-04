

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCAPPAGciclicas')
BEGIN
	DROP PROC pCAPPAGciclicas
	SELECT 'pCAPPAGciclicas BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pCAPPAGciclicas
    @TipoOperacion VARCHAR(10) = '', 
    @IdItemCiclica INT = NULL,
    @IdCapacidadPago INT = NULL,
    @Tipo BIT = NULL,
    @Concepto VARCHAR(32) = NULL,
    @Cantidad NUMERIC(8,2) = NULL,
    @UnidadMedida VARCHAR(8) = NULL,
    @PrecioUnitario NUMERIC(11,2) = NULL,
    @MesFecha01 DATE = NULL,
    @MesMonto01 NUMERIC(11,2) = NULL,
    @MesFecha02 DATE  = NULL,
	@MesMonto02	NUMERIC(11,2) = NULL,
	@MesFecha03	DATE  = NULL,
	@MesMonto03	NUMERIC(11,2) = NULL,
	@MesFecha04	DATE  = NULL,
	@MesMonto04	NUMERIC(11,2) = NULL,
	@MesFecha05	DATE  = NULL,
	@MesMonto05	NUMERIC(11,2) = NULL,
	@MesFecha06	DATE  = NULL,
	@MesMonto06	NUMERIC(11,2) = NULL,
	@MesFecha07	DATE  = NULL,
	@MesMonto07	NUMERIC(11,2) = NULL,
	@MesFecha08	DATE  = NULL,
	@MesMonto08	NUMERIC(11,2) = NULL,
	@MesFecha09	DATE  = NULL,
	@MesMonto09	NUMERIC(11,2) = NULL,
	@MesFecha10	DATE  = NULL,
	@MesMonto10	NUMERIC(11,2) = NULL,
	@MesFecha11	DATE  = NULL,
	@MesMonto11	NUMERIC(11,2) = NULL,
	@MesFecha12	DATE  = NULL,
	@MesMonto12	NUMERIC(11,2) = NULL,
	@MesFecha13	DATE  = NULL,
	@MesMonto13	NUMERIC(11,2) = NULL,
	@MesFecha14	DATE  = NULL,
	@MesMonto14	NUMERIC(11,2) = NULL,
	@MesFecha15	DATE  = NULL,
	@MesMonto15	NUMERIC(11,2) = NULL,
	@MesFecha16	DATE  = NULL,
	@MesMonto16	NUMERIC(11,2) = NULL,
	@MesFecha17	DATE  = NULL,
	@MesMonto17	NUMERIC(11,2) = NULL,
	@MesFecha18	DATE  = NULL,
	@MesMonto18	NUMERIC(11,2) = NULL
AS
BEGIN
	IF @TipoOperacion = ''
		RETURN 0

    IF @TipoOperacion = 'C'
    BEGIN
        INSERT INTO dbo.tCAPPAGciclicas
        (
            IdCapacidadPago,
            Tipo,
            Concepto,
            Cantidad,
            UnidadMedida,
            PrecioUnitario,
            MesFecha01, MesMonto01, MesFecha02, MesMonto02,MesFecha03,MesMonto03,MesFecha04,MesMonto04,MesFecha05,MesMonto05,MesFecha06,MesMonto06,
			MesFecha07,MesMonto07,MesFecha08,MesMonto08,MesFecha09,MesMonto09,MesFecha10,MesMonto10,MesFecha11,MesMonto11,MesFecha12,MesMonto12,
			MesFecha13,MesMonto13,MesFecha14,MesMonto14,MesFecha15,MesMonto15,MesFecha16,MesMonto16,MesFecha17,MesMonto17, MesFecha18, MesMonto18
        )
        VALUES 
		(
			@IdCapacidadPago, @Tipo, @Concepto, @Cantidad, @UnidadMedida, @PrecioUnitario,
            @MesFecha01, @MesMonto01, @MesFecha02, @MesMonto02,@MesFecha03,@MesMonto03,@MesFecha04,@MesMonto04,@MesFecha05,@MesMonto05,@MesFecha06,@MesMonto06,
			@MesFecha07,@MesMonto07,@MesFecha08,@MesMonto08,@MesFecha09,@MesMonto09,@MesFecha10,@MesMonto10,@MesFecha11,@MesMonto11,@MesFecha12,@MesMonto12,
			@MesFecha13,@MesMonto13,@MesFecha14,@MesMonto14,@MesFecha15,@MesMonto15,@MesFecha16,@MesMonto16,@MesFecha17,@MesMonto17, @MesFecha18, @MesMonto18
		);

		RETURN 1;
    END
    
	IF @TipoOperacion = 'D'
    BEGIN
        DELETE FROM dbo.tCAPPAGciclicas WHERE IdItemCiclica = @IdItemCiclica;
		RETURN 1;
    END
    
	IF @TipoOperacion = 'LST'
    BEGIN
        SELECT c.IdItemCiclica,
               c.IdCapacidadPago,
               c.Tipo,
               c.Concepto,
               c.Cantidad,
               c.UnidadMedida,
               c.PrecioUnitario,
               c.Total,
               c.MesFecha01,
               c.MesMonto01,
               c.MesFecha02,
               c.MesMonto02,
               c.MesFecha03,
               c.MesMonto03,
               c.MesFecha04,
               c.MesMonto04,
               c.MesFecha05,
               c.MesMonto05,
               c.MesFecha06,
               c.MesMonto06,
               c.MesFecha07,
               c.MesMonto07,
               c.MesFecha08,
               c.MesMonto08,
               c.MesFecha09,
               c.MesMonto09,
               c.MesFecha10,
               c.MesMonto10,
               c.MesFecha11,
               c.MesMonto11,
               c.MesFecha12,
               c.MesMonto12,
               c.MesFecha13,
               c.MesMonto13,
               c.MesFecha14,
               c.MesMonto14,
               c.MesFecha15,
               c.MesMonto15,
               c.MesFecha16,
               c.MesMonto16,
               c.MesFecha17,
               c.MesMonto17,
               c.MesFecha18,
               c.MesMonto18
        FROM dbo.tCAPPAGciclicas c  WITH(NOLOCK) 
        WHERE IdCapacidadPago = @IdCapacidadPago;

		RETURN 1;
    END
    
END;
