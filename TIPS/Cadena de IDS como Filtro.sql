

USE jcDB
GO

CREATE TABLE [dbo].[Orders](
    [OrderID] INT NOT NULL IDENTITY,
    [CustomerID] INT NOT NULL,
    [OrderDate] DATETIME NOT NULL,
    [Total] MONEY NOT NULL
);

INSERT INTO [dbo].[Orders]([CustomerID], [OrderDate], [Total])
VALUES
(1, '2023-09-28', 100.00),
(2, '2023-09-29', 200.00),
(3, '2023-09-30', 300.00);


DECLARE @ids VARCHAR(100)='1,2'

SELECT
    *
FROM
    Orders
WHERE OrderID IN (
        select CAST(value AS INT) from STRING_SPLIT(@ids,',')
    );


