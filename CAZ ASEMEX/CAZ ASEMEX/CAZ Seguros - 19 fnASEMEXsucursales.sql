

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnASEMEXsucursales')
BEGIN
	DROP function fnASEMEXsucursales
	SELECT 'fnASEMEXsucursales BORRADO' AS info
END
GO

CREATE function dbo.fnASEMEXsucursales()
returns @sucusales table(
						IdSucursal int primary key,
						CodigoAsemex int
						)
AS
BEGIN
	INSERT INTO @sucusales ([IdSucursal], CodigoAsemex)
	VALUES
	( 2, 2 ),
	( 3, 3 ),
	( 4, 4 ),
	( 5, 5 ),
	( 6, 6 ),
	( 7, 7 ),
	( 8, 8 ),
	( 9, 9 ),
	( 11, 10 ),
	( 12, 11),
	( 13, 12),
	( 14, 1 ),
	( 15, 16),
	( 16, 13 ),
	( 17, 14),
	( 18, 15)

	return;
END
go


