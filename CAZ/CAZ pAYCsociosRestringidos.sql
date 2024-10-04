


alter PROCEDURE pAYCsociosRestringidos
AS
	BEGIN
	
	DECLARE @MontoSaldoSociosRestringidos AS NUMERIC(18,2)=100000

	-- Borrado de los elementos actuales
	UPDATE tAYCsociosRestringidos SET IdEstatus=2 WHERE TipoBloqueo!=3

	-- Socios con Saldo Igual o Mayor a X
	INSERT INTO tAYCsociosRestringidos (IdSocio,TipoBloqueo)
	SELECT sc.IdSocio,1 -- Por Saldo
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio AND c.IdTipoDProducto IN (144,398) AND c.IdEstatus=1
	INNER JOIN dbo.tSDOsaldos sdo  WITH(NOLOCK) ON sdo.IdCuenta = c.IdCuenta 
	WHERE sc.EsSocioValido=1
	GROUP BY sc.IdSocio
	HAVING SUM(sdo.Saldo)>=@MontoSaldoSociosRestringidos

	-- Socios que se encuentran en puestos de Nivel Organizacional 1 y 2
	INSERT INTO tAYCsociosRestringidos (IdSocio,TipoBloqueo)
	SELECT sc.IdSocio, 2 -- Por Nivel
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = sc.IdPersona
	INNER JOIN dbo.tPERempleados emp  WITH(NOLOCK) ON emp.IdPersonaFisica = pf.IdPersonaFisica
	INNER JOIN dbo.tPERpuestos puesto  WITH(NOLOCK) ON puesto.IdPuesto = emp.IdPuesto
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = emp.IdEstatusActual AND ea.IdEstatus=1
	WHERE puesto.IdTipoDnivelOrganizacional IN (2179,2178)

	-- Se agrega por requerimiento para todos los socios con creditos superiores a 100000 de saldo 
	 
		DECLARE @hoy AS DATE=GETDATE()
		DECLARE @maxima AS DATE = (SELECT TOP 1 MAX(cs.FechaCartera) FROM dbo.tAYCcartera cs  WITH(NOLOCK))
		DECLARE @fechaCartera AS DATE = (SELECT TOP 1 cs.FechaCartera FROM dbo.tAYCcartera cs  WITH(NOLOCK) WHERE cs.FechaCartera IN (@hoy, @maxima) ORDER BY cs.FechaCartera ASC)

		INSERT INTO tAYCsociosRestringidos (IdSocio,TipoBloqueo)
		SELECT c.IdSocio,1 -- Por Saldo
		FROM dbo.tAYCcartera ct  WITH(NOLOCK) 
		INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdCuenta=ct.IdCuenta
		WHERE ct.FechaCartera=@fechaCartera AND (ct.Capital+ ct.InteresOrdinario+ct.IVAInteresOrdinario) >= @MontoSaldoSociosRestringidos



END 



