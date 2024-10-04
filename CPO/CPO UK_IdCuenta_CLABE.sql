

IF EXISTS(SELECT name FROM sys.indexes o WHERE o.name='UK_IdCuenta_CLABE')
BEGIN
	DROP INDEX UK_IdCuenta_CLABE ON dbo.tAYCcuentasCLABE
	SELECT 'UK_IdCuenta_CLABE BORRADO' AS info
END
GO

CREATE UNIQUE INDEX UK_IdCuenta_CLABE ON tAYCcuentasCLABE (idcuenta,clabe);
GO


