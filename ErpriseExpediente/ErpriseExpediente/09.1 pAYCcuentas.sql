
USE ErpriseExpediente
GO

/*
Tipo: Procedimiento
Objeto: pAYCcuentas
Resumen: Concentra las operaciones sobre cuentas.
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCcuentas')
BEGIN
	DROP PROC pAYCcuentas
	SELECT 'pAYCcuentas BORRADO' AS info
END
GO

CREATE PROC pAYCcuentas
@TipoOperacion AS VARCHAR(20)='',
@IdPersona AS INT=0,
@IdTipoDproducto AS INT=0,
@IdEstatus AS INT=0
AS
BEGIN
	IF @TipoOperacion='' OR @IdPersona=0 OR @IdTipoDproducto=0 OR @IdEstatus=0
	BEGIN
		RAISERROR ( 'Oops (>_<) Tipo de Operacioón, Socio, Tipo de Producto o Estatus, NO PROVISTO.',18,1)
		RETURN -1
	END

	IF @TipoOperacion='LIST'
	BEGIN	
			SELECT c.IdCuenta, c.NumeroCuenta, c.Descripcion, c.DescripcionLarga, c.Resumen
			FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = c.IdPersona
			WHERE p.IdPersona=@IdPersona AND c.IdEstatus=@IdEstatus AND c.IdTipoD=@IdTipoDproducto
	
			RETURN 0
	END

END