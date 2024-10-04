


SELECT 
n1.Nivel1
,n2.Nivel2
,n3.Nivel3
--,n4.Nivel4
--,n5.Descripcion	
--,t5.IdTipoD
--,t5.Descripcion
,IIF(n4.Nivel4<>'',n4.Nivel4,n5.Descripcion) AS Nivel4
,IIF(n4.Nivel4<>'' AND n4.Nivel4=n5.Nivel4,n5.Descripcion,'') AS Nivel5
,IIF(n4.Nivel4<>'' AND n4.Nivel4=n5.Nivel4,t5.Descripcion,t4.Descripcion) AS Tipo
,IIF(n4.Nivel4<>'' AND n4.Nivel4=n5.Nivel4,t5.IdTipoD,t4.IdTipoD) AS IdTipo
FROM dbo.vCTLrecursosNivelesAgrupados n1  WITH(NOLOCK) 
INNER JOIN dbo.vCTLrecursosNivelesAgrupados n2 WITH(NOLOCK) 
	ON n2.IdRecurso = n1.IdRecurso
INNER JOIN dbo.vCTLrecursosNivelesAgrupados n3  WITH(NOLOCK) 
	ON n3.IdRecurso = n2.IdRecurso
INNER JOIN dbo.vCTLrecursosNivelesAgrupados n4  WITH(NOLOCK) 
	ON n4.IdRecurso = n3.IdRecurso
LEFT JOIN dbo.tCTLtiposD t4  WITH(NOLOCK) 
	ON t4.IdTipoD = n4.IdTipoD
INNER JOIN dbo.vCTLrecursosNivelesAgrupados n5  WITH(NOLOCK) 
	ON n5.IdRecurso = n4.IdRecurso
LEFT JOIN dbo.tCTLtiposD t5  WITH(NOLOCK) 
	ON t5.IdTipoD = n5.IdTipoD
WHERE IIF(n4.Nivel4<>'' AND n4.Nivel4=n5.Nivel4,t5.IdTipoD,t4.IdTipoD) NOT IN (1614,8,4,3,717)
ORDER BY 
n1.Nivel1
,n2.Nivel2
,n3.Nivel3
,Nivel4
,Nivel5

