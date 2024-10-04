






--SELECT c.IdCuenta, c.Codigo, c.Descripcion, c.IdTipoDProducto, c.Vencimiento 
--from tAYCcuentas c  WITH(NOLOCK) 
--where c.IdEstatus=1 
--	and c.Vencimiento in('20240318','20240328','20240329','20240330')			





SELECT c.IdCuenta, c.Codigo, c.Descripcion, c.IdTipoDProducto, p.Vencimiento 
-- begin  TRAN UPDATE p SET p.Vencimiento='20240401'
from tAYCcuentas c  WITH(NOLOCK) 
INNER JOIN dbo.tAYCparcialidades p  WITH(NOLOCK) 
	on p.IdCuenta = c.IdCuenta
		and p.IdEstatus=1
where c.IdEstatus=1 
	and p.Vencimiento in ('20240318','20240328','20240329','20240330')


-- COMMIT 

-- ROLLBACK
