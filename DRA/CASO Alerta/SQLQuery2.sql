

select 
d.Descripcion, sc.Codigo as Nosocio, op.IdSocio,
op.*
from dbo.tPLDoperaciones op  WITH(NOLOCK) 
INNER JOIN  dbo.tSCSsocios sc  WITH(NOLOCK) 
	on sc.IdSocio = op.IdSocio
INNER JOIN dbo.tGRLpersonas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
INNER JOIN dbo.tCTLtiposD d  WITH(NOLOCK) 
	on d.IdTipoD = op.IdTipoDoperacionPLD
where p.Nombre like '%brisa aleja%'


/*
Porcentaje de incremento considerable en Retiros .Suma de monto en el mes: 44,104.00000000 retiros promedio 12 meses 10,713.98181818
*/


exec dbo.pAYCdesagregadoOperacionesProductosFinancierosMetodoPago @FechaInicial = '2024-02-01' 
                                                                , @FechaFinal = '2024-02-29'   
                                                                , @NoSocio = '101-000958' 



exec dbo.pAYCdesagregadoOperacionesProductosFinancierosMetodoPago @FechaInicial = '2023-01-20' 
                                                                , @FechaFinal = '2024-01-20'   
                                                                , @NoSocio = '101-000958' 
																

exec dbo.pPLDrepotarInusualidadTMP @fecha = '2024-02-29' -- date
                                 , @pIdSocio = 28848         -- int
