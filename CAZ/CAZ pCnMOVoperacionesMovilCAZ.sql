
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnMOVoperacionesMovilCAZ')
BEGIN
	DROP PROC pCnMOVoperacionesMovilCAZ
	SELECT 'pCnMOVoperacionesMovilCAZ BORRADO' AS info
END
GO

CREATE PROC pCnMOVoperacionesMovilCAZ
@FechaInicial	AS DATE		='19000101',
@FechaFinal		AS DATE		='19000101'
AS
	
	IF @FechaInicial<>'19000101' AND @FechaFinal<>'19000101' 
	BEGIN
		SELECT  p.Terminal 
		,poliza.folio AS [Folio de la póliza]
		,ope.Folio AS [Operación]
		,ope.Fecha
		,t.Descripcion AS [Tipo de Operación]
		,p.Referencia AS Referencia
		,p.IdCuentaOrigen
		,p.CuentaOrigen
		,[NoSocioOrigen]	= so.Codigo
		,[SocioOrigen]		= po.Nombre
		,p.IdCuentaDestino
		,p.CuentaDestino
		,[NoSocioDestino] = sd.Codigo
		,[SocioDestino]		= pd.Nombre
		,p.Monto,p.Comision			
		FROM dbo.tMOVpeticiones p  WITH(NOLOCK)
		 JOIN dbo.tCTLtiposD t WITH(NOLOCK)ON t.IdTipoD = p.IdTipoDpeticion
		 JOIN dbo.tGRLoperaciones ope WITH(NOLOCK)ON ope.IdOperacion = p.IdOperacion
		 JOIN dbo.tCNTpolizasE poliza WITH(NOLOCK)ON poliza.IdPolizaE = ope.IdPolizaE
		 LEFT JOIN  dbo.tAYCcuentas co  WITH(NOLOCK) 
			ON co.IdCuenta=p.IdCuentaOrigen
		 LEFT JOIN dbo.tSCSsocios so WITH(NOLOCK)
			ON so.IdSocio = co.IdSocio
		 LEFT JOIN dbo.tGRLpersonas po  WITH(NOLOCK) 
			ON po.IdPersona=so.IdPersona
		 LEFT JOIN dbo.tAYCcuentas cd WITH(NOLOCK)
			ON cd.IdCuenta=p.IdCuentaDestino
		 LEFT JOIN dbo.tSCSsocios sd WITH(NOLOCK)
			ON sd.IdSocio = cd.IdSocio
		 LEFT JOIN dbo.tGRLpersonas pd  WITH(NOLOCK) 
			ON pd.IdPersona=sd.IdPersona
		WHERE ISNULL(p.OrigenOperacion,'')!='ATM' AND p.IdEstatus=42
		AND ope.Fecha BETWEEN @FechaInicial AND @FechaFinal

	END
	
GO

