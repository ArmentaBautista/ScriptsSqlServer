
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnSCSoperacionesSocioAltoRiesgo')
BEGIN
	DROP PROC pCnSCSoperacionesSocioAltoRiesgo
	SELECT 'pCnSCSoperacionesSocioAltoRiesgo BORRADO' AS info
END
GO

CREATE PROC [dbo].[pCnSCSoperacionesSocioAltoRiesgo]
	@fechaInicial DATE,
	@fechaFinal DATE,
	@Socio AS VARCHAR(30)
	AS
		BEGIN

			DECLARE @socios AS TABLE
			(
				IdSocio				INT,
				IdPersona			INT,
				NoSocio				VARCHAR(20),
				EsPEP				BIT,
				IdListaDnivelRiesgo INT
			)

			INSERT INTO @socios
			SELECT 
			sc.IdSocio,
			sc.IdPersona,
			sc.Codigo,
			0,
			sc.IdListaDnivelRiesgo
			FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
			WHERE sc.IdSocio<>0
				AND sc.IdListaDnivelRiesgo=-44
					AND ((sc.Codigo = @Socio AND  @Socio!='*') OR @Socio='*')  

			MERGE INTO @socios sc
			USING (
					SELECT 
					sc.IdSocio,
					sc.IdPersona,
					sc.Codigo,
					1 AS EsPEP,
					sc.IdListaDnivelRiesgo
					FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
					INNER JOIN dbo.tPLDppe pep  WITH(NOLOCK) 
						ON pep.IdSocio = sc.IdSocio
							AND pep.IdEstatus=1
					WHERE sc.IdSocio<>0
						AND ((sc.Codigo = @Socio AND  @Socio!='*') OR @Socio='*')
			) AS pep ON pep.IdSocio = sc.IdSocio
			WHEN MATCHED THEN
					UPDATE SET sc.EsPEP = 1
			WHEN NOT MATCHED THEN
					INSERT (IdSocio,IdPersona,NoSocio,EsPEP,IdListaDnivelRiesgo) VALUES (pep.IdSocio, pep.IdPersona,pep.Codigo,1,pep.IdListaDnivelRiesgo);

			--SELECT * FROM @socios
			--RETURN

				SELECT 
				 tf.Fecha
				, suc.Descripcion AS Sucursal
				, s.NoSocio
				, p.Nombre
				, s.EsPEP
				, nr.Descripcion AS NivelRiesgo
				, c.Codigo AS Cuenta
				, pf.Descripcion AS Producto
				, too.Codigo
				, o.Folio
				, too.Descripcion AS Operación
				, tto.Descripcion AS Tipo
				, tf.TotalCargos
				, tf.TotalAbonos
				, tf.Referencia
				, tf.Concepto
				FROM dbo.tSDOtransaccionesFinancieras tf   WITH(NOLOCK) 
				JOIN dbo.tGRLoperaciones o With (nolock) ON o.IdOperacion = tf.IdOperacion
				JOIN dbo.tCTLtiposOperacion too With (nolock) ON too.IdTipoOperacion = o.IdTipoOperacion
				JOIN dbo.tAYCcuentas c With (nolock) ON c.IdCuenta = tf.IdCuenta
				JOIN dbo.tAYCproductosFinancieros pf With (nolock) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
				JOIN @socios s ON s.IdSocio = c.IdSocio
				JOIN dbo.tGRLpersonas p With (nolock) ON p.IdPersona = s.IdPersona
				JOIN dbo.tCTLsucursales suc With (nolock) ON suc.IdSucursal = tf.IdSucursal
				JOIN dbo.tCTLtiposOperacion tto With (nolock) ON tto.IdTipoOperacion = tf.IdTipoSubOperacion
				JOIN dbo.tCATlistasD nr  WITH(NOLOCK) 
					ON nr.IdListaD=s.IdListaDnivelRiesgo
				WHERE tf.IdEstatus=1
				AND tf.Fecha BETWEEN @fechaInicial AND @fechaFinal 
				ORDER BY tf.Fecha, o.Folio

	END







GO


IF NOT EXISTS(SELECT 1 FROM dbo.tPLDobjetosModulo om  WITH(NOLOCK) 
			WHERE om.Nombre='pCnSCSoperacionesSocioAltoRiesgo')
BEGIN	
	INSERT INTO tPLDobjetosModulo(Nombre) 
	Values ('pCnSCSoperacionesSocioAltoRiesgo')
END
GO

