
	IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pAYCImpresionEdosCta')
		DROP PROC pAYCImpresionEdosCta
	GO
	
CREATE PROC pAYCImpresionEdosCta
@TipoOperacion AS VARCHAR(20)
AS

	IF @TipoOperacion='Tipos'
	BEGIN
		SELECT d.IdTipoD, d.Descripcion AS Tipo, CASE
															WHEN d.IdTipoD= 144 THEN 'edoCuentaA.rtp'
															WHEN d.IdTipoD=143 THEN 'edoCtac.rpt'
														 END AS Formato
				FROM tctltiposd d  WITH(NOLOCK) 
				WHERE d.IdTipoD IN (144,143)
	end
	
	IF @TipoOperacion='Socio'
	BEGIN
	--IdSocio, Codigo, Nombre
	PRINT ''
	END


	IF @TipoOperacion='Ctas'
	BEGIN
	--IdCuenta, Codigo, Descripción, IdSocio
	PRINT ''
	END


