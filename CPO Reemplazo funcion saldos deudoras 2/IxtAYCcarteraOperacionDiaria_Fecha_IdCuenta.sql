
IF EXISTS(SELECT name FROM sys.indexes o WHERE o.name='IxtAYCcarteraOperacionDiaria_Fecha_IdCuenta')
BEGIN
	DROP INDEX IxtAYCcarteraOperacionDiaria_Fecha_IdCuenta ON dbo.tAYCcarteraOperacionDiaria 
	SELECT 'IxtAYCcarteraOperacionDiaria_Fecha_IdCuenta BORRADO' AS info
END
GO

CREATE INDEX IxtAYCcarteraOperacionDiaria_Fecha_IdCuenta 
ON dbo.tAYCcarteraOperacionDiaria (Fecha,IdCuenta)
go


