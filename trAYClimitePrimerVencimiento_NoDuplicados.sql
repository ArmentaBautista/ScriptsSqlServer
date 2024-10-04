

-- DROP trigger trAYCmimitePrimerVencimiento_NoDuplicados


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='trAYClimitePrimerVencimiento_NoDuplicados')
BEGIN
	DROP trigger trAYClimitePrimerVencimiento_NoDuplicados
	SELECT 'trAYClimitePrimerVencimiento_NoDuplicados BORRADO' AS info
END
GO

CREATE TRIGGER [dbo].trAYClimitePrimerVencimiento_NoDuplicados
ON [dbo].[tAYClimitePrimerVencimiento]
for insert, update
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM [dbo].[tAYClimitePrimerVencimiento] AS t
        INNER JOIN INSERTED AS i 
			on t.[IdTipoDmodalidad] = i.[IdTipoDmodalidad]
				AND t.[IdProductoFinanciero] = i.[IdProductoFinanciero]
					and t.[IdTipoDPlazo] = i.[IdTipoDPlazo]
						and t.[IdEstatus] = 1
        WHERE t.[Id] != i.[Id]
    )
    BEGIN
        THROW 99999, N'Ua existe un registro con la misma configuración', 1;
    END
END
go
   


