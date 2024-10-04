SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER FUNCTION dbo.fnADMfragmentacionIndices()
RETURNS TABLE
AS
RETURN

	SELECT --S.name as 'Schema',
	T.name as 'Table',
	I.name as 'Index',
	DDIPS.avg_fragmentation_in_percent,
	DDIPS.page_count,
	Query = 'ALTER INDEX ['+ i.name +'] ON ['+ s.name +'].['+ t.name +'] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)'
	FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
	INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
	INNER JOIN sys.schemas S on T.schema_id = S.schema_id
	INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
	AND DDIPS.index_id = I.index_id
	WHERE DDIPS.database_id = DB_ID()
	and I.name is not null
	AND DDIPS.avg_fragmentation_in_percent > 0
			
      
GO

