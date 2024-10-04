


IF EXISTS(SELECT 1 FROM sys.columns c 
				INNER JOIN sys.tables t
					ON t.object_id = c.object_id
						AND t.name='tbl_wfsEncabezado'
				WHERE c.name='UUID'
					AND c.is_nullable=1)
BEGIN
	ALTER TABLE dbo.tbl_wfsEncabezado
		ALTER COLUMN UUID varchar(50) NOT NULL
	
	SELECT 'UUID modificado a Not Null en tbl_wfsEncabezado' AS info
END
GO


IF NOT EXISTS(SELECT name FROM sys.objects o WHERE o.name='PK_tbl_wfsEncabezado_UUID')
BEGIN
	ALTER TABLE dbo.tbl_wfsEncabezado
	ADD CONSTRAINT PK_tbl_wfsEncabezado_UUID PRIMARY KEY (UUID)
	
	SELECT 'Llave primaria agregada en tbl_wfsEncabezado' AS info
END
GO
