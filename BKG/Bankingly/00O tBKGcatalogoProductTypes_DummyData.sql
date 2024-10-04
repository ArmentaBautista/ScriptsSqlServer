
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- select * from tBKGcatalogoProductTypes
--  tBKGcatalogoProductTypes_DummyData
-- 

TRUNCATE TABLE dbo.tBKGcatalogoProductTypes
GO

INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(0,'Undefined','Indefini',0)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(1,'CurrentAccount','Cuenta corriente',144)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(2,'SavingsAccount','Cuenta o caja de ahorros',0)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(3,'CreditCard','Tarjeta de crédito',0)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(4,'FixedTermDeposit','Certificado de depósito a plazo fijo',398)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(5,'Loan','Préstamo',143)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(6,'CreditLine','Línea de crédito',0)
GO
INSERT INTO dbo.tBKGcatalogoProductTypes(ProductTypeId,ProductTypeName,Descripcion,IdTipoDproducto)
VALUES(7,'Investment','Inversión o fondeo',0)
GO




SELECT * FROM dbo.tBKGcatalogoProductTypes
GO
