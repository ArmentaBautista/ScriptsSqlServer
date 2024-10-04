


IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCmdAYCactualizarEtiquetaCuenta')
	DROP PROC pCmdAYCactualizarEtiquetaCuenta
GO

CREATE PROC pCmdAYCactualizarEtiquetaCuenta
@Cuenta AS VARCHAR(50),
@Etiqueta AS VARCHAR(50)
AS
BEGIN
	IF @Etiqueta IS NULL OR @Etiqueta=''
	BEGIN
		SELECT 'Debe indicar la Etiqueta que se asignará a la cuenta';
		RETURN 0	
	END
        
	DECLARE @IdCuenta AS INT=0
	SELECT @IdCuenta=Idcuenta FROM dbo.tayccuentas c  WITH(NOLOCK) WHERE c.Codigo=@Cuenta

	IF @IdCuenta=0
		SELECT 'LA CUENTA ' + @Cuenta + ' NO FUE LOCALIZADA PARA ETIQUETAR';
	ELSE
    BEGIN
		UPDATE c SET c.DescripcionLarga=@Etiqueta FROM dbo.tayccuentas c  WITH(NOLOCK) WHERE c.IdCuenta=@IdCuenta;
		
		SELECT c.Codigo AS Cuenta, c.DescripcionLarga AS Etiqueta FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.IdCuenta=@IdCuenta
	END

END	

