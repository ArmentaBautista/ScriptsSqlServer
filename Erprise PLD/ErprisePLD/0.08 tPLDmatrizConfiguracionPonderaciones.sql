



IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionPonderaciones')
BEGIN
	
	CREATE TABLE [dbo].tPLDmatrizConfiguracionPonderaciones
	(
		IdFactor			INT NOT NULL PRIMARY KEY,
		-- 1. Socio, 2. Geografía, 3. Listas y Terceros, 4. Ingresos
		-- 5. Transaccionalidad, 6. Productos y Servicios, 7. Canales de Distribución
		Factor				VARCHAR(64) NOT NULL, 
		PonderacionFactor	NUMERIC(4,3) NULL,
		Alta				DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 			INT NOT NULL DEFAULT 1
	) ON [PRIMARY]

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionPonderaciones')

	SELECT 'Tabla Creada' AS info
END
GO

