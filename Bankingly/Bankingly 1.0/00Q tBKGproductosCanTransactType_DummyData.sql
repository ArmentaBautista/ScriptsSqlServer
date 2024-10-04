
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
-- tBKGproductosCanTransactType_DummyData
 TRUNCATE TABLE dbo.tBKGproductosCanTransactType
 GO
/*
	SELECT
	'INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) ' + 
	CONCAT('VALUES (',pf.IdProductoFinanciero,',)'), pf.Descripcion, c.IdTipoDProducto
	FROM dbo.tAYCproductosFinancieros pf 
	INNER JOIN dbo.tAYCcuentas c ON c.IdProductoFinanciero = pf.IdProductoFinanciero AND c.IdEstatus=1
	GROUP BY pf.IdProductoFinanciero, pf.Descripcion,c.IdTipoDProducto
	ORDER BY c.IdTipoDProducto
*/


SELECT * FROM dbo.tBKGproductosCanTransactType
GO
/*
SELECT
pf.IdProductoFinanciero, pf.Descripcion, ct.CanTransactType, ct.CanTransctName, ct.Descripcion, pf.IdTipoDDominioCatalogo
FROM dbo.tAYCproductosFinancieros pf 
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK)  ON c.IdProductoFinanciero = pf.IdProductoFinanciero AND c.IdEstatus=1
INNER JOIN tBKGproductosCanTransactType pct WITH(NOLOCK) ON pct.IdProducto = pf.IdProductoFinanciero
INNER JOIN tBKGcatalogoCanTransactType ct  WITH(NOLOCK) ON ct.CanTransactType = pct.CanTransactType
GROUP BY pf.IdProductoFinanciero, pf.Descripcion, ct.CanTransactType, ct.CanTransctName, ct.Descripcion, pf.IdTipoDDominioCatalogo
ORDER BY pf.IdTipoDDominioCatalogo
*/

IF DB_NAME()='iERP_KFT'
BEGIN

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (7,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (13,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (11,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (6,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (10,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (41,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (8,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (14,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (9,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (12,2)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (2,1)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (1,0)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (45,1)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (3,1)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (4,0)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (27,0)

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType)
VALUES (28,0)

END

IF DB_NAME()='iERP_DRA'
BEGIN

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (1,2) 
 
INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (2,2) 
 
INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (3,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (4,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (5,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (6,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (7,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (9,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (10,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (11,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (12,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (18,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (20,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (21,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (26,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (37,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (40,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (43,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (45,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (48,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (49,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (50,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (54,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (59,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (70,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (74,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (75,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (102,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (104,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (106,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (131,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (142,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (143,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (145,2) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (101,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (144,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (133,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (134,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (138,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (92,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (93,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (94,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (95,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (96,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (97,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (98,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (99,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (140,0) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (144,1) 

INSERT INTO dbo.tBKGproductosCanTransactType (IdProducto,CanTransactType) VALUES (146,1) 

END
GO





