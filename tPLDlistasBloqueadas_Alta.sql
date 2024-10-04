

-- tPLDlistasBloqueadas_Alta

IF NOT EXISTS(
				SELECT o.name, c.name FROM sys.tables o 
				INNER JOIN sys.columns c  ON c.object_id = o.object_id AND c.name='Alta'
				WHERE o.name='tPLDlistasBloqueadas'
			 )
BEGIN 
			ALTER TABLE dbo.tPLDlistasBloqueadas ADD Alta DATETIME NULL 
				CONSTRAINT DF_tPLDlistasBloqueadas_Alta DEFAULT CURRENT_TIMESTAMP
END
GO






