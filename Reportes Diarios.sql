

USE intelixReportes
GO

SELECT 
r.Login
,CAST(r.Fecha AS DATE) as FechaReporte 
--, r.Actividad, r.Comentarios
FROM [dbo].[tReportes] r  WITH(nolock) 
WHERE r.Fecha BETWEEN '20210116' AND '20210213'
--AND r.Login='janeth.r'
GROUP BY r.Login, CAST(r.Fecha AS DATE)
ORDER BY r.Login, FechaReporte 

