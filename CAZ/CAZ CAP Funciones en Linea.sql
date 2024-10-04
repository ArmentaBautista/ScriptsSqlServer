CREATE OR ALTER VIEW vJCAcuentas
AS
	SELECT C.codigo, C.descripcion, c.idestatus
	FROM tayccuentas C  WITH(NOLOCK) 
GO

CREATE OR ALTER FUNCTION dbo.fnJCAcuentas(@IdEstatus INT, @IdTipoDProducto INT)
RETURNS TABLE
AS
RETURN(
	SELECT C.codigo AS NoCuenta, C.descripcion AS Producto, c.idestatus
	, sc.Codigo AS NoSocio, fin.Descripcion
	FROM tayccuentas C  WITH(NOLOCK)
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		ON sc.IdSocio = C.IdSocio
	INNER JOIN dbo.tAYCfinalidades fin  WITH(NOLOCK) 
		ON fin.IdFinalidad = C.IdFinalidad
	WHERE c.idestatus=@IdEstatus
	AND C.IdTipoDProducto=@IdTipoDProducto
);


SELECT * FROM dbo.fnJCAcuentas(1,143)

SELECT * FROM dbo.fnJCAcuentas(7,398)