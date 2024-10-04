

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='trValidarChequeEmitido')
BEGIN
	DROP TRIGGER [trValidarChequeEmitido] 
	SELECT 'trValidarChequeEmitido BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE TRIGGER dbo.trValidarChequeEmitido
ON dbo.tSDOtransaccionesD
AFTER INSERT, UPDATE
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @Err AS VARCHAR(MAX) = '';

	IF EXISTS (SELECT IdScript FROM dbo.tSPTejecutarScript WHERE Nombre = 'dbo.trValidarChequeEmitido' AND Ejecutar = 0)
		RETURN;

	IF EXISTS(SELECT 1
				FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
				INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK) ON operacion.IdOperacion = td.IdOperacion
																		AND operacion.IdTipoOperacion = 10
				INNER JOIN Inserted ins ON ins.IdCheque = td.IdCheque)
		RETURN
	

		SELECT TOP (1)
               @Err = ISNULL(CONCAT('CodEx|02355|Validar cheque emitido|', operacion.Folio),'')
        FROM dbo.tSDOtransaccionesD td  WITH(NOLOCK) 
            INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = td.IdEstatusActual
            INNER JOIN dbo.tGRLoperaciones operacion  WITH(NOLOCK) ON operacion.IdOperacion = td.IdOperacion
            INNER JOIN Inserted ins ON ins.IdCheque = td.IdCheque
        WHERE td.IdCheque != 0 AND ea.IdEstatus = 1
        GROUP BY td.IdCheque,
                 operacion.Fecha,
                 operacion.Folio
        HAVING COUNT(td.IdCheque) > 1;



    -- Insert statements for trigger here	
    IF LEN(@Err) > 0
    BEGIN       

        RAISERROR(@Err, 16, 8);
    END;

END;
GO
