

INSERT INTO dbo.tAYCproductosFinancierosPermitenEstadosCuenta
(
    IdProductoFinanciero,
    IdEstatus,
    Alta,
    IdSesion
)
VALUES
(   2,         -- IdProductoFinanciero - int
    1,         -- IdEstatus - int
    GETDATE(), -- Alta - datetime
    NULL          -- IdSesion - int
    )

---- 

INSERT INTO dbo.tAYCproductosFinancierosPermitenEstadosCuenta
(
    IdProductoFinanciero,
    IdEstatus,
    Alta,
    IdSesion
)
VALUES
(   43,         -- IdProductoFinanciero - int
    1,         -- IdEstatus - int
    GETDATE(), -- Alta - datetime
    NULL          -- IdSesion - int
    )





