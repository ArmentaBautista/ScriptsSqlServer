
/********  JCA.2/5/2024.03:30 Info: Recursos del nivel0  ********/
SELECT * FROM dbo.tCTLtiposD t  WITH(NOLOCK) 
WHERE t.IdTipoD IN (
1
,2
,7
,4
,6
,1614
)

/********  JCA.2/5/2024.03:30 Info: Recursos del nivel1  ********/
SELECT * FROM dbo.tCTLtiposD t  WITH(NOLOCK) 
WHERE t.IdTipoD IN (
6
,2
,2262
,3
,7
,1
,8
,1614
,5
,2424
)