

IF EXISTS (SELECT name FROM sys.objects o WHERE o.name='pCnGYCconvenios')
	DROP PROC pCnGYCconvenios 
GO

CREATE PROC pCnGYCconvenios
@FechaInicial AS DATE='19000101',
@FechaFinal AS DATE='19000101'
AS

			SELECT cc.Folio, cc.FechaConvenio, cc.FechaVigencia, cc.Monto
			, s.Codigo AS NoSocio
			, p.Nombre, c.Codigo AS NoCuenta, c.Descripcion
			, tel.Telefonos, ps.Domicilio
			FROM dbo.tGYCconveniosCuentas cc  WITH(NOLOCK) 
			INNER JOIN dbo.tGYCgestores ges  WITH(NOLOCK) ON ges.IdGestor = cc.IdGestor
			INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = ges.IdPersona
			INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta = cc.IdCuenta
			INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdSocio = c.IdSocio
			INNER JOIN dbo.tGRLpersonas ps  WITH(NOLOCK) ON ps.IdPersona = s.IdPersona
			INNER JOIN dbo.tCTLrelaciones rel	 WITH(NOLOCK) ON rel.IdRel = p.IdRelTelefonos
			INNER JOIN dbo.vCATtelefonosAgrupados tel  WITH(NOLOCK) ON tel.IdRel = rel.IdRel 
			WHERE cc.FechaVigencia BETWEEN @FechaInicial AND @FechaFinal



