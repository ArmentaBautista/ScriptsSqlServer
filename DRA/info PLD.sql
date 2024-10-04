

SELECT s.Codigo AS NoSocio, p.Nombre, p.Domicilio, IIF(d.IdTipoD=11,'PRINCIPAL/FISCAL','ADICIONAL/LABORAL') AS TipoDomicilio, pf.IdCatalogoSITIpersonaRelacionada, cat.Descripcion
, IIF(terceros.IdPersonaTercero IS NULL,'PROPIOS','REPRESENTA UN TERCERO') AS Actuacion
, IIF(ppe.IdSocio IS NULL,'','PPE') AS PPE
, alertas.NoAlertas	
, moda.AlertaMasRecurrente
FROM dbo.tGRLpersonas p  WITH(NOLOCK) 
INNER JOIN dbo.tGRLpersonasFisicas pf  WITH(NOLOCK) ON pf.IdPersona = p.IdPersona
INNER JOIN dbo.tSCSsocios s  WITH(NOLOCK) ON s.IdPersona = p.IdPersona AND s.EsSocioValido=1
INNER JOIN dbo.tCTLrelaciones rel  WITH(NOLOCK) ON rel.IdRel = p.IdRelDomicilios
LEFT JOIN (
			SELECT dom.IdRel, dom.Descripcion, dom.IdTipoD
			FROM dbo.tCATdomicilios dom  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = dom.IdEstatusActual AND ea.IdEstatus=1
			WHERE dom.IdTipoD=11
			) d ON d.IdRel = rel.IdRel
INNER JOIN dbo.tSITcatalogos cat  WITH(NOLOCK) ON cat.IdCatalogoSITI = pf.IdCatalogoSITIpersonaRelacionada
LEFT JOIN dbo.tPLDsocioTerceros terceros  WITH(NOLOCK) ON terceros.IdPersonaSocio = p.IdPersona
LEFT JOIN dbo.tPLDppe ppe  WITH(NOLOCK) ON ppe.IdPersona = p.IdPersona
LEFT JOIN (
			SELECT op.IdSocio, tipo.Descripcion AS Tipo, 
			COUNT(IdOperacion) AS NoAlertas
			FROM dbo.tPLDoperaciones op  WITH(NOLOCK) 
			INNER JOIN dbo.tCTLtiposD tipo  WITH(NOLOCK) ON tipo.IdTipoD = op.IdTipoDoperacionPLD
			WHERE op.IdEstatus=1 
			GROUP BY op.IdSocio, tipo.Descripcion 
			) alertas ON alertas.IdSocio = s.IdSocio
left JOIN (
			SELECT grupo.IdSocio, MAX(grupo.Tipo) AS AlertaMasRecurrente
			FROM (
					SELECT op.IdSocio, tipo.Descripcion AS Tipo, COUNT(op.IdOperacion) Conteo
						FROM dbo.tPLDoperaciones op  WITH(NOLOCK) 
						INNER JOIN dbo.tCTLtiposD tipo  WITH(NOLOCK) ON tipo.IdTipoD = op.IdTipoDoperacionPLD
						WHERE op.IdEstatus=1 
						GROUP BY op.IdSocio, tipo.Descripcion 
				) grupo
			GROUP BY grupo.IdSocio
			) moda  ON moda.IdSocio = s.IdSocio
			






