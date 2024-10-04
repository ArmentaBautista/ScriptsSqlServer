
SELECT a.IdSocio, pf.RelReferenciasPersonales,  c.*
FROM dbo.tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCaperturas a  WITH(NOLOCK) 
	ON a.IdApertura = c.IdApertura	
		AND A.Folio=227466
INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
	ON sc.IdSocio = c.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) 
	ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) 
	ON pf.IdPersona = p.IdPersona
WHERE c.IdEstatus=1
	


SELECT r.EsBeneficiario, * 
FROM dbo.vAYCreferenciasAsignadasGUI r  WITH(NOLOCK) 
WHERE r.RelReferenciasAsignadas=742658




SELECT * 
-- BEGIN TRAN UPDATE ra SET ra.IdEstatus=1, ra.EsBeneficiario=1
FROM dbo.tAYCreferenciasAsignadas ra  WITH(NOLOCK)  WHERE ra.RelReferenciasAsignadas=742658




SELECT rpf.EstatusDescripcion, rpf.EsBeneficiario, rpf.EsCotitular, * 
FROM vSCSpersonasFisicasReferenciasGUI rpf  WITH(NOLOCK) 
WHERE rpf.RelReferenciasPersonales = 187686


