
--USE iERP_CAZ
--GO

SELECT * FROM dbo.tCTLconfiguracion c  WITH(NOLOCK) WHERE c.IdConfiguracion=69

SELECT valor, * FROM dbo.tCTLtiposD td  WITH(NOLOCK) WHERE td.IdTipoE=85

UPDATE td SET td.Valor=7200 FROM dbo.tCTLtiposD td  WITH(NOLOCK) WHERE td.IdTipoD=745

SELECT valor, * FROM dbo.tCTLtiposD td  WITH(NOLOCK) WHERE td.IdTipoE=85



