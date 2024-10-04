SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROC pCTLgenerarEstadisticasTablas 
AS
	DECLARE @BD AS VARCHAR(20) ='';

	-- Transaccional
	SET  @BD='iERP_OBL'
	INSERT INTO	iERP_OBL_HST.dbo.tCTLestadisticaTamañoTablas (BaseDatos,Tabla,Registros,KB,MB,GB)
	SELECT BaseDatos = @BD,
		   Tabla     = t.name,
		   Registros = p.rows,
		   KB        = SUM (a.total_pages) * 8,
		   MB        = (SUM (a.total_pages) * 8) / 1024,
		   GB        = ((SUM (a.total_pages) * 8) / 1024) / 1024
	FROM IERP_OBL.sys.tables           t
	JOIN IERP_OBL.sys.indexes          i ON t.object_id = i.object_id
	JOIN IERP_OBL.sys.partitions       p ON i.object_id = p.object_id AND i.index_id = p.index_id
	JOIN IERP_OBL.sys.allocation_units a ON p.partition_id = a.container_id
	WHERE t.is_ms_shipped = 0 AND i.object_id > 255
	GROUP BY t.name, p.rows
	--ORDER BY KB DESC;

	-- RPT
	SET  @BD='iERP_OBL_RPT'
	INSERT INTO	iERP_OBL_HST.dbo.tCTLestadisticaTamañoTablas (BaseDatos,Tabla,Registros,KB,MB,GB)
	SELECT BaseDatos = @BD,
		   Tabla     = t.name,
		   Registros = p.rows,
		   KB        = SUM (a.total_pages) * 8,
		   MB        = (SUM (a.total_pages) * 8) / 1024,
		   GB        = ((SUM (a.total_pages) * 8) / 1024) / 1024
	FROM iERP_OBL_RPT.sys.tables           t
	JOIN iERP_OBL_RPT.sys.indexes          i ON t.object_id = i.object_id
	JOIN iERP_OBL_RPT.sys.partitions       p ON i.object_id = p.object_id AND i.index_id = p.index_id
	JOIN iERP_OBL_RPT.sys.allocation_units a ON p.partition_id = a.container_id
	WHERE t.is_ms_shipped = 0 AND i.object_id > 255
	GROUP BY t.name, p.rows

	-- HST
		SET  @BD='iERP_OBL_HST'
	INSERT INTO	iERP_OBL_HST.dbo.tCTLestadisticaTamañoTablas (BaseDatos,Tabla,Registros,KB,MB,GB)
	SELECT BaseDatos = @BD,
		   Tabla     = t.name,
		   Registros = p.rows,
		   KB        = SUM (a.total_pages) * 8,
		   MB        = (SUM (a.total_pages) * 8) / 1024,
		   GB        = ((SUM (a.total_pages) * 8) / 1024) / 1024
	FROM iERP_OBL_HST.sys.tables           t
	JOIN iERP_OBL_HST.sys.indexes          i ON t.object_id = i.object_id
	JOIN iERP_OBL_HST.sys.partitions       p ON i.object_id = p.object_id AND i.index_id = p.index_id
	JOIN iERP_OBL_HST.sys.allocation_units a ON p.partition_id = a.container_id
	WHERE t.is_ms_shipped = 0 AND i.object_id > 255
	GROUP BY t.name, p.rows

	-- REG
		SET  @BD='iERP_OBL_REG'
	INSERT INTO	iERP_OBL_HST.dbo.tCTLestadisticaTamañoTablas (BaseDatos,Tabla,Registros,KB,MB,GB)
	SELECT BaseDatos = @BD,
		   Tabla     = t.name,
		   Registros = p.rows,
		   KB        = SUM (a.total_pages) * 8,
		   MB        = (SUM (a.total_pages) * 8) / 1024,
		   GB        = ((SUM (a.total_pages) * 8) / 1024) / 1024
	FROM iERP_OBL_REG.sys.tables           t
	JOIN iERP_OBL_REG.sys.indexes          i ON t.object_id = i.object_id
	JOIN iERP_OBL_REG.sys.partitions       p ON i.object_id = p.object_id AND i.index_id = p.index_id
	JOIN iERP_OBL_REG.sys.allocation_units a ON p.partition_id = a.container_id
	WHERE t.is_ms_shipped = 0 AND i.object_id > 255
	GROUP BY t.name, p.rows

GO

