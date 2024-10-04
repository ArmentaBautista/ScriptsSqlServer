


/*  (◕ᴥ◕)    JCA.06/10/2023.12:52 p. m. Nota: Agregar default a columna  */
BEGIN
	IF NOT EXISTS(
					SELECT 
					[Tabla]			= t.name, 
					[Columna]		= c.name,
					[Constraint]	= d.name
					FROM sys.default_constraints d 
					INNER JOIN sys.tables t
						ON t.object_id = d.parent_object_id
							AND t.name='tCATservidorSMTP'
					INNER JOIN sys.columns c  
						ON c.object_id = t.object_id 
							AND c.column_id = d.parent_column_id
								AND c.name = 'HabilitaSSL')
	BEGIN
		ALTER TABLE dbo.tCATservidorSMTP 
			ADD CONSTRAINT DF_tCATservidorSMTP_HabilitaSSL
				DEFAULT 1 FOR HabilitaSSL		
		SELECT [Info]='DEFAULT CREADO'
	END
	SELECT [Info]='DEFAULT YA EXISTE'
END
GO


