

SELECT cfg.IdConfiguracion, cfg.Descripcion
FROM dbo.tCTLconfiguracion cfg  WITH(NOLOCK) 
WHERE cfg.IdTipoDconfiguracion = 409
AND NOT EXISTS (SELECT 1 FROM [1G_DESARROLLO].dbo.tCTLconfiguracion c  WITH(NOLOCK) WHERE c.IdTipoDconfiguracion=409 AND c.IdConfiguracion=cfg.IdConfiguracion)




SELECT cfg.IdConfiguracion, cfg.Descripcion
FROM [1G_DESARROLLO].dbo.tCTLconfiguracion cfg  WITH(NOLOCK) 
WHERE cfg.IdTipoDconfiguracion = 409
AND NOT EXISTS (SELECT 1 FROM dbo.tCTLconfiguracion c  WITH(NOLOCK) WHERE c.IdTipoDconfiguracion=409 AND c.IdConfiguracion=cfg.IdConfiguracion)


SELECT 
cfg.IdConfiguracion AS IdConfiguracion_IntelixDev,
cfg.Descripcion AS Descripcion_IntelixDev,
c.IdConfiguracion AS IdConfiguracion_CO,
c.Descripcion as Descipcion_CO
FROM dbo.tCTLconfiguracion cfg  WITH(NOLOCK) 
INNER JOIN [1G_DESARROLLO].dbo.tCTLconfiguracion c  WITH(NOLOCK) 
	ON c.IdTipoDconfiguracion=409 
		AND c.IdConfiguracion=cfg.IdConfiguracion
			AND c.Descripcion<>cfg.Descripcion
WHERE cfg.IdTipoDconfiguracion = 409

