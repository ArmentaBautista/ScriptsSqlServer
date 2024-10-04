
/* JCA.17/4/2024.02:55 
Nota: Soporta las operaciones y consultas del Módulo de confirmación de Saldos
*/

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pAYCconfirmacionSaldos')
BEGIN
	DROP PROC pAYCconfirmacionSaldos
	SELECT 'pAYCconfirmacionSaldos BORRADO' AS info
END
GO

CREATE PROC pAYCconfirmacionSaldos
@RETURN_MESSAGE			VARCHAR(MAX)='' OUTPUT,
@pTipoOperacion			VARCHAR(24)='',
@pIdSocio				INT= 0,
@pIdConfirmacionSaldos	INT = 0 OUTPUT,
@pFechaTrabajo			DATE = '19000101',
@pFechaCorte			DATE = '19000101' OUTPUT,
@pIdSesion				INT=0,
@pIdUsuario				INT=0,
@pIdConfirmacionSaldosD	INT = 0,
@pEstaConforme			BIT	 = 0,
@pEstaImpreso			BIT	= 0,
@pCadenaBusqueda		VARCHAR(16)=''
AS
BEGIN
	IF @pTipoOperacion='C'
	BEGIN	

		IF NOT EXISTS(
			SELECT 1
			FROM dbo.tAYCcuentas c  WITH(NOLOCK)
			WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (144,143,398) AND c.IdSocio=@pIdSocio)
		BEGIN
			--RAISERROR('No existen cuentas Activas',16,1)
			SET @RETURN_MESSAGE='No existen cuentas Activas'
			RETURN -1
        END


		BEGIN TRY
			BEGIN TRANSACTION;
   
			 SET @pFechaCorte=(SELECT MAX(ct.FechaCartera) FROM dbo.tAYCcartera ct  WITH(NOLOCK))

			INSERT INTO dbo.tAYCconfirmacionSaldosE (FechaCorte,FechaTrabajo,IdSocio,IdSesion,IdUsuario)
			VALUES(@pFechaCorte, @pFechaTrabajo, @pIdSocio, @pIdSesion,@pIdUsuario)

			SET @pIdConfirmacionSaldos = SCOPE_IDENTITY()

			INSERT INTO dbo.tAYCconfirmacionSaldosD
			(
				IdConfirmacionSaldos,
				IdCuenta,
				IdTipoDproducto,
				Capital,
				InteresOrdinarioAlDia,
				InteresMoratorio,
				Saldo
			)
			SELECT
			@pIdConfirmacionSaldos,
			c.IdCuenta,
			c.IdTipoDProducto,
			IIF(c.IdTipoDProducto=143,ct.CapitalAlDia,c.SaldoCapital),
			ct.InteresOrdinarioTotalAtrasado,
			ct.InteresMoratorioTotal,
			IIF(c.IdTipoDProducto=143,ct.CapitalAlDia,c.SaldoCapital)
			FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
			LEFT JOIN dbo.tAYCcartera ct  WITH(NOLOCK) 
				ON ct.IdCuenta=c.IdCuenta
					AND ct.FechaCartera=@pFechaCorte
			WHERE c.IdEstatus=1 
				AND c.IdTipoDProducto IN (144,143,398)
				AND c.IdSocio=@pIdSocio
		
		COMMIT TRANSACTION;

			SELECT 
				   csd.IdConfirmacionSaldosD,
				   csd.IdConfirmacionSaldos,
				   csd.Tipo,
				   csd.Producto,
				   csd.NoCuenta,
				   csd.Capital,
				   csd.InteresOrdinarioAlDia,
				   csd.InteresMoratorio,
				   csd.Saldo,
				   csd.EstaConforme
			FROM dbo.fnAYCconfirmacionSaldosD(@pIdConfirmacionSaldos) csd  

			
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH;

		RETURN 0
	END

	IF @pTipoOperacion='CONFORME'
	BEGIN
		
		UPDATE csd SET csd.EstaConforme=@pEstaConforme
		FROM dbo.tAYCconfirmacionSaldosD csd WHERE csd.IdConfirmacionSaldosD=@pIdConfirmacionSaldosD

		SELECT 
			   csd.IdConfirmacionSaldosD,
			   csd.IdConfirmacionSaldos,
               csd.Tipo,
               csd.Producto,
               csd.NoCuenta,
               csd.Capital,
               csd.InteresOrdinarioAlDia,
               csd.InteresMoratorio,
               csd.Saldo,
               csd.EstaConforme
		FROM dbo.fnAYCconfirmacionSaldosD(@pIdConfirmacionSaldos) csd  

		RETURN 0
    END

	IF @pTipoOperacion='ASENTAR'
	BEGIN
		
		UPDATE e SET e.IdEstatus=1
		FROM dbo.tAYCconfirmacionSaldose e WHERE e.IdConfirmacionSaldos=@pIdConfirmacionSaldos
		
		RETURN 0
    END

	IF @pTipoOperacion='F3_FOLIO'
	BEGIN
		
		SELECT 
		[Folio] = cse.IdConfirmacionSaldos,
		[NoSocio]	= sc.Codigo,
		p.Nombre,
		cse.FechaCorte,
		cse.FechaTrabajo,
		[Estatus] = e.Descripcion
		FROM dbo.tAYCconfirmacionSaldosE cse  WITH(NOLOCK) 
		INNER JOIN dbo.tCTLestatus e  WITH(NOLOCK) 
			ON e.IdEstatus = cse.IdEstatus
	 	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = cse.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		WHERE sc.Codigo LIKE '%' + @pCadenaBusqueda + '%'
			OR p.Nombre LIKE '%' + @pCadenaBusqueda + '%'
			OR cse.IdConfirmacionSaldos = TRY_CAST(@pCadenaBusqueda AS INT)
		ORDER BY Folio DESC	

		RETURN 0
    END

	IF @pTipoOperacion='F3_SOCIO'
	BEGIN
		
		SELECT sc.IdSocio, sc.Codigo, p.Nombre
		FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
		WHERE p.Nombre LIKE '%' + @pCadenaBusqueda + '%'
			OR sc.Codigo LIKE '%' + @pCadenaBusqueda + '%'
		
		RETURN 0
    END

	IF @pTipoOperacion='OBT_E'
	BEGIN
		
		SELECT 
		cse.IdConfirmacionSaldos,
		cse.IdSocio,
		[NoSocio]	= sc.Codigo,
		p.Nombre,
		cse.FechaCorte,
		cse.FechaTrabajo,
		cse.YaImpreso,
		cse.IdEstatus
		FROM dbo.tAYCconfirmacionSaldosE cse  WITH(NOLOCK) 
	 	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = cse.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona
		WHERE cse.IdConfirmacionSaldos = @pIdConfirmacionSaldos

		RETURN 0
    END

	IF @pTipoOperacion='OBT_D'
	BEGIN
		
		SELECT 
		csd.IdConfirmacionSaldosD,
		csd.IdConfirmacionSaldos,
        csd.Tipo,
        csd.Producto,
        csd.NoCuenta,
        csd.Capital,
        csd.InteresOrdinarioAlDia,
        csd.InteresMoratorio,
        csd.Saldo,
        csd.EstaConforme
		FROM dbo.fnAYCconfirmacionSaldosD(@pIdConfirmacionSaldos) csd
		
		RETURN 0
    END

	IF @pTipoOperacion='OBT'
	BEGIN
		
		SELECT 
		cse.IdConfirmacionSaldos,
		cse.FechaCorte,
		cse.FechaTrabajo,
		cse.IdSocio,
		[NoSocio]	= sc.Codigo,
		p.Nombre,
		cse.YaImpreso,
		csd.IdConfirmacionSaldosD,
        csd.Tipo,
        csd.Producto,
        csd.NoCuenta,
        csd.Capital,
        csd.InteresOrdinarioAlDia,
        csd.InteresMoratorio,
        csd.Saldo,
        csd.EstaConforme
		FROM dbo.tAYCconfirmacionSaldosE cse  WITH(NOLOCK) 
	 	INNER JOIN dbo.fnAYCconfirmacionSaldosD(@pIdConfirmacionSaldos) csd
			ON csd.IdConfirmacionSaldos = cse.IdConfirmacionSaldos
		INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
			ON sc.IdSocio = cse.IdSocio
		INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
			ON p.IdPersona = sc.IdPersona

		RETURN 0
    END

	IF @pTipoOperacion='IMP'
	BEGIN

		UPDATE cse SET cse.YaImpreso=1 
		FROM dbo.tAYCconfirmacionSaldosE cse WHERE cse.IdConfirmacionSaldos=@pIdConfirmacionSaldos

		RETURN 0
	END

END
GO