
USE iERP_CPA

SELECT 
 [TipoMenor] = td.Descripcion 
,[NoSocio] = sc.Codigo 
,[MenorAhorrador] = p.Nombre
,[Edad] = DATEDIFF(YEAR,f.FechaNacimiento,GETDATE())
,[Producto] = pf.Descripcion
,[NoCuenta] = c.Codigo
,[SaldoCapital] = c.SaldoCapital
,[NoSocioTutor] = stutor.Codigo
,[Tutor] = ptutor.Nombre
,[EsSocio] = stutor.EsSocioValido
FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
INNER JOIN dbo.tCTLtiposD td  WITH(NOLOCK) ON td.IdTipoD = sc.IdTipoDmenorAhorrador AND sc.IdTipoDmenorAhorrador <> 0
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas f  WITH(NOLOCK) ON f.IdPersonaFisica=p.IdPersonaFisica
INNER JOIN dbo.tAYCcuentas c  WITH(NOLOCK) ON c.IdSocio = sc.IdSocio AND c.IdEstatus=1
INNER JOIN dbo.tAYCproductosFinancieros pf  WITH(NOLOCK) ON pf.IdProductoFinanciero = c.IdProductoFinanciero
														AND pf.Codigo='AHME'
LEFT JOIN dbo.tSCSpersonasFisicasReferencias ref  WITH(NOLOCK) ON ref.RelReferenciasPersonales = f.RelReferenciasPersonales AND ref.EsTutorPrincipal=1
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = pf.IdEstatusActual AND ea.IdEstatus=1
INNER JOIN dbo.tGRLpersonas ptutor  WITH(NOLOCK) ON ptutor.IdPersona = ref.IdPersona
left JOIN dbo.tSCSsocios stutor  WITH(NOLOCK) ON stutor.IdPersona = ptutor.IdPersona
ORDER BY Edad DESC


