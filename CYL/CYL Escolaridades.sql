



 SELECT * FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 ORDER BY l.Descripcion
 GO
 
 SELECT * FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 
 GO


/*
UPDATE l SET l.Descripcion='01 SIN ESCOLARIDAD NO SABE LEER NI ESCRIBIR' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-1341
GO
UPDATE l SET l.Descripcion='02 SIN ESCOLARIDAD SABE LEER Y ESCRIBIR' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-1342
GO
UPDATE l SET l.Descripcion='03 PREESCOLAR' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-1353
GO
UPDATE l SET l.Descripcion='04 PRIMARIA' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-26
GO
UPDATE l SET l.Descripcion='05 SECUNDARIA' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-27
GO
UPDATE l SET l.Descripcion='06 BACHILLERATO (MEDIA SUPERIOR)' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-28
GO
UPDATE l SET l.Descripcion='07 CARRERA TÉCNICA' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-1343
GO
UPDATE l SET l.Descripcion='08 LICENCIATURA (UNIVERSITARIA)' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-29
GO
UPDATE l SET l.Descripcion='09 MAESTRÍA' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-1344
GO
UPDATE l SET l.Descripcion='10 POSGRADO' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-30
GO
UPDATE l SET l.Descripcion='11 DOCTORADO' FROM dbo.tCATlistasD l  WITH(NOLOCK) WHERE l.IdTipoE=34 and l.IdListaD=-1345
GO

UPDATE ea SET ea.IdEstatus=1
FROM dbo.tCATlistasD l  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(nolock) ON ea.IdEstatusActual = l.IdEstatusActual
WHERE l.IdTipoE=34 AND ea.IdEstatus=2

*/


