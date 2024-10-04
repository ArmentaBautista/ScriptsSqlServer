


IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pAgregarInstruccionE')
BEGIN
	DROP PROC pAgregarInstruccionE
END
GO

CREATE PROC pAgregarInstruccionE
@RFC [varchar] (14),
@IdEmpresa [int],
@Descripcion [varchar] (256) ,
@Periodicidad [int]
AS
BEGIN
    INSERT INTO dbo.tBIinstruccionesE
    (
        IdEmpresa,
        RFC,
        Descripcion,
        Periodicidad,
        IdEstatus,
        Alta
    )
    VALUES
    (   @IdEmpresa,        -- IdEmpresa - int
        @RFC,       -- RFC - varchar(14)
        @Descripcion,       -- Descripcion - varchar(256)
        @Periodicidad,        -- Periodicidad - int
        1,        -- IdEstatus - int
        GETDATE() -- Alta - date
        )
END