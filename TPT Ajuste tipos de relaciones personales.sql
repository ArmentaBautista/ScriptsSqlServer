

UPDATE td SET td.IdEstatus=2 FROM dbo.tctltiposd td  WITH(nolock) WHERE td.IdTipoE=43 AND td.IdTipoDPadre IN (749,0)
GO

UPDATE td SET td.IdEstatus=2 FROM dbo.tctltiposd td  WITH(nolock) WHERE td.IdTipoE=43 AND td.IdTipoD in (1617,2421)
GO

UPDATE td SET td.IdEstatus=1 FROM dbo.tctltiposd td  WITH(nolock) WHERE td.IdTipoE=43 AND td.IdTipoD in (2420,2421,750)
GO

SELECT * 
FROM dbo.tctltiposd td  WITH(nolock) 
WHERE td.IdTipoE=43 AND td.IdEstatus=1
ORDER BY td.IdTipoDPadre
GO

