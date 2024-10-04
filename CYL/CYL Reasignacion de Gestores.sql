USE iERP_CYL_GP3
GO

DECLARE @GestorOrigen AS VARCHAR(32)=''
DECLARE @GestorDestino AS VARCHAR(32)=''

DECLARE @IdGestorOrigen AS INT=(SELECT idgestor FROM dbo.tGYCgestores g  WITH(NOLOCK)  WHERE g.Codigo=@GestorOrigen)
DECLARE @IdGestorDestino AS INT=(SELECT idgestor FROM dbo.tGYCgestores g  WITH(NOLOCK)  WHERE g.Codigo=@GestorDestino)

SELECT *
FROM dbo.tGYCasignacionCarteraD asig  WITH(NOLOCK) 
WHERE asig.IdEstatus=1
	AND asig.IdGestor=@IdGestorOrigen

