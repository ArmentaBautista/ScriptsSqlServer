DECLARE @IdEmpresa AS INT = 7

SELECT 
@IdEmpresa AS IdEmpresa,* 
FROM dbo.tAYCcarteraDiaria
WHERE FechaCartera BETWEEN '20210301'   AND GETDATE()
