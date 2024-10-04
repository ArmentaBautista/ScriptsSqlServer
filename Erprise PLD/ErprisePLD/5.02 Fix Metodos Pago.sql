




SELECT 
 ea.IdEstatusActual, ea.IdEstatus, mp.* 
--ea.*
-- BEGIN TRAN UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATmetodosPago mp  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = mp.IdEstatusActual
		AND ea.IdEstatus=1
WHERE mp.IdMetodoPago IN (-8,-7,-6,-5,-4)




-- COMMIT



INSERT INTO dbo.tCTLestatusActual
(
    IdEstatus,
    IdUsuarioAlta,
    Alta,
    IdUsuarioCambio,
    UltimoCambio,
    IdTipoDDominio,
    IdObservacionE,
    IdObservacionEDominio,
    IdSesion
)
SELECT
1, -1, N'20240411', 0, N'1900-01-01T00:00:00', 204, 0, 0, 0

SELECT SCOPE_IDENTITY()

-- 12633
/*

select * 
-- UPDATE mp SET mp.IdEstatusActual=12633
FROM dbo.tCATmetodosPago mp WHERE mp.IdMetodoPago=-10

*/