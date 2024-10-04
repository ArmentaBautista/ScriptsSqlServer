/********  JCA.19/8/2024.23:43 Info: Primero debe revisarse que las descripciones sean las correctas, caso contrario hacer el fix siguiente  ********/

UPDATE ld SET ld.Descripcion='VENTANILLA (VENTA)' FROM dbo.tCATlistasD ld WHERE ld.IdListaD = -1398
UPDATE ld SET ld.Descripcion='CTA CONCENTRADORA (MOV.BCO)' FROM dbo.tCATlistasD ld WHERE ld.IdListaD = -1399
UPDATE ld SET ld.Descripcion='CTA CONCENTRADORA (TRN)' FROM dbo.tCATlistasD ld WHERE ld.IdListaD = -1400
UPDATE ld SET ld.Descripcion='SUCURSAL (TRSP.CTA)' FROM dbo.tCATlistasD ld WHERE ld.IdListaD = -1401
UPDATE ld SET ld.Descripcion='VENTANILLA (TICKET)' FROM dbo.tCATlistasD ld WHERE ld.IdListaD = -1402

/********  JCA.19/8/2024.23:43 Info: Activar los canales correctos  ********/

SELECT e.IdTipoE, e.Descripcion , ld.IdListaD, ld.codigo, ld.Descripcion, ea.IdEstatusActual, ea.IdEstatus
FROM dbo.tCATlistasD ld  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = ld.IdEstatusActual
INNER JOIN dbo.tCTLtiposE e  WITH(NOLOCK) 
	ON e.IdTipoE = ld.IdTipoE
WHERE e.IdTipoE=181

SELECT e.IdTipoE, e.Descripcion , ld.IdListaD, ld.Descripcion, ea.IdEstatusActual, ea.IdEstatus
-- begin tran UPDATE ea SET ea.IdEstatus=1
FROM dbo.tCATlistasD ld  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = ld.IdEstatusActual
INNER JOIN dbo.tCTLtiposE e  WITH(NOLOCK) 
	ON e.IdTipoE = ld.IdTipoE
WHERE e.IdTipoE=181
AND ld.IdListaD in (-1402,-1401,-1400,-1399,-1398)

-- commit

SELECT e.IdTipoE, e.Descripcion , ld.IdListaD, ld.Descripcion, ea.IdEstatusActual, ea.IdEstatus
-- begin tran UPDATE ea SET ea.IdEstatus=2
FROM dbo.tCATlistasD ld  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = ld.IdEstatusActual
INNER JOIN dbo.tCTLtiposE e  WITH(NOLOCK) 
	ON e.IdTipoE = ld.IdTipoE
WHERE e.IdTipoE=181
AND ld.IdListaD not in (-1402,-1401,-1400,-1399,-1398)

-- COMMIT

SELECT e.IdTipoE, e.Descripcion , ld.IdListaD, ld.Descripcion, ea.IdEstatusActual, ea.IdEstatus
FROM dbo.tCATlistasD ld  WITH(NOLOCK) 
INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) 
	ON ea.IdEstatusActual = ld.IdEstatusActual
INNER JOIN dbo.tCTLtiposE e  WITH(NOLOCK) 
	ON e.IdTipoE = ld.IdTipoE
WHERE e.IdTipoE=181
ORDER BY ea.IdEstatus

