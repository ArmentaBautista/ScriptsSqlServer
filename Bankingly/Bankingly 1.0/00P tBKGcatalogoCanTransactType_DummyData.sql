
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- select * from tBKGcatalogoCanTransactType 
-- tBKGcatalogoCanTransactType_DummyData
 TRUNCATE TABLE dbo.tBKGcatalogoCanTransactType
 GO

INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (0,'NoTransactions','Solo consulta, ninguna transacci�n habilitada')
GO
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (1,'AllTransactions','Todas las transacciones habilitadas')
GO
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (2,'OnlyCredits','Solo cr�ditos.')
GO
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (3,'OnlyDebits','Solo d�bitos')
GO
INSERT into dbo.tBKGcatalogoCanTransactType (CanTransactType,CanTransctName,Descripcion)
VALUES (4,'InternalNoTransactions','Interno, solo consulta')
GO

select * from tBKGcatalogoCanTransactType 
GO
