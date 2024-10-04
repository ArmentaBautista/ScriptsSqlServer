 
 USE intelixDEV
 GO
 
 SELECT type, type_desc FROM sys.objects GROUP BY type, type_desc

 /* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
 -- FUNCIONES

 /*
		Funciones escalares (devuelve un valor �nico)
		Funciones de valor de tabla en l�nea (contiene una sola instrucci�n TSQL y devuelve un conjunto de tabla)
		Funciones de valor de tabla de m�ltiples declaraciones (contiene varias declaraciones TSQL y devuelve el conjunto de tablas)
 */

 -- Escalar
CREATE FUNCTION dbo.fnGetStockCount(@ProductID int)
RETURNS int
AS
BEGIN
    DECLARE @ret int;
    SELECT @ret = SUM(p.Quantity) FROM Production.ProductInventory p
    WHERE p.ProductID = @ProductID;
    RETURN @ret;
END;

-- Tabla en l�nea
CREATE FUNCTION dbo.ifGetContactInformation(@ContactID int)
RETURNS TABLE
AS
RETURN (
    SELECT FirstName, LastName, EmailAddress
    FROM Person.Person AS p
    JOIN Person.EmailAddress AS e ON e.BusinessEntityID = p.BusinessEntityID
    WHERE p.BusinessEntityID = @ContactID
);

-- Tabla multiples l�neas
CREATE FUNCTION dbo.tfnGetContactInformation(@ContactID int)
RETURNS @ret TABLE (
    FirstName nvarchar(50),
    LastName nvarchar(50),
    EmailAddress nvarchar(50)
)
AS
BEGIN
    INSERT INTO @ret (FirstName, LastName, EmailAddress)
        SELECT FirstName, LastName, EmailAddress FROM Person.Person AS p
        JOIN Person.EmailAddress AS e ON e.BusinessEntityID = p.BusinessEntityID
        WHERE p.BusinessEntityID = @ContactID;
    RETURN;
END;
