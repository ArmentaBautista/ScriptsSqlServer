

IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCmdAYCeliminarReciprocidadRenovaciones')
	DROP PROC pCmdAYCeliminarReciprocidadRenovaciones 
GO

CREATE PROC pCmdAYCeliminarReciprocidadRenovaciones
@Folio AS INT,
@Cuenta AS VARCHAR(30)
AS	

		-- SELECT c.Reciprocidad, *
		UPDATE c SET c.Reciprocidad=0
		FROM dbo.tAYCcuentas c  WITH(NOLOCK)
		INNER JOIN dbo.tAYCaperturas a  WITH(NOLOCK) ON a.IdApertura = c.IdApertura AND a.Folio=@Folio 
		WHERE c.Codigo=@Cuenta




