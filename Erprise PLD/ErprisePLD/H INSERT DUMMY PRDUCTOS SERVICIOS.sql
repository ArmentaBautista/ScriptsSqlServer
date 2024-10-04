


/* INSERT DUMMY PRDUCTOS SERVICIOS */
-- SELECT FLOOR(rand()*101)
-- -- Productos = 1,  Servicios = 2,
-- SELECT * FROM tPLDmatrizConfiguracionProductosServicios
 TRUNCATE TABLE tPLDmatrizConfiguracionProductosServicios
GO

 /* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
 /* PRODUCTOS */

/* 1. Consulta de productos de cuentas activas */
IF OBJECT_ID('tempdb..#tmpProductosCuentasActivas') IS NOT NULL DROP TABLE #tmpProductosCuentasActivas

SELECT c.IdProductoFinanciero INTO #tmpProductosCuentasActivas FROM dbo.tAYCcuentas c  WITH(NOLOCK) WHERE c.IdEstatus=1

-- cursor de inserci�n para generar el puntaje  dummy
DECLARE @IdRegistro INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR SELECT pf.IdProductoFinanciero, pf.Descripcion 
																FROM dbo.tAYCproductosFinancieros pf  WITH(NOLOCK)
																INNER JOIN #tmpProductosCuentasActivas tmpp  WITH(NOLOCK) ON tmpp.IdProductoFinanciero = pf.IdProductoFinanciero
																GROUP BY pf.IdProductoFinanciero, pf.Descripcion
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdRegistro,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionProductosServicios (Tipo,IdValor1,ValorDescripcion,Puntos) VALUES(1,@IdRegistro,@descripcion,1)

    FETCH NEXT FROM miCursor INTO @IdRegistro,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor

-- Borrado de tabla
DROP TABLE #tmpProductosCuentasActivas
GO

 /* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
/* SERVICIOS */


-- cursor de inserci�n para generar el puntaje  dummy
DECLARE @IdRegistro INT
DECLARE @descripcion VARCHAR(128)
DECLARE miCursor CURSOR local FAST_FORWARD READ_ONLY FOR SELECT cps.IdAuxiliar,aux.Descripcion 
															FROM tCOMconfiguracionPagoServicios cps WITH (NOLOCK)
															INNER JOIN tCNTauxiliares aux WITH (NOLOCK) ON cps.IdAuxiliar = aux.IdAuxiliar
															INNER JOIN tGRLbienesServicios bs WITH (NOLOCK) ON cps.IdBienServicio = bs.IdBienServicio
															WHERE cps.IdEstatus=1
OPEN miCursor
FETCH NEXT FROM miCursor INTO @IdRegistro,@descripcion
WHILE @@FETCH_STATUS = 0
BEGIN    
	INSERT INTO dbo.tPLDmatrizConfiguracionProductosServicios (Tipo,IdValor1,ValorDescripcion,Puntos) VALUES(2,@IdRegistro,@descripcion,1)

    FETCH NEXT FROM miCursor INTO @IdRegistro,@descripcion
END
CLOSE miCursor
DEALLOCATE miCursor
GO



SELECT * FROM tPLDmatrizConfiguracionProductosServicios
GO