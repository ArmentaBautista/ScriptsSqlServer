
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionFactoresParaNivelRiesgo')
BEGIN
	CREATE TABLE [dbo].[tPLDmatrizConfiguracionFactoresParaNivelRiesgo]
	(
		IdElemento INT PRIMARY KEY,
		IdFactor INT NOT NULL,
		Factor VARCHAR(64) NOT NULL DEFAULT '',
		Elemento VARCHAR(64) NOT NULL DEFAULT '',
		IdEstatus INT NOT NULL DEFAULT 1,
				
		CONSTRAINT FK_tPLDmatrizConfiguracionFactoresParaNivelRiesgo_IdEstatus FOREIGN KEY (IdEstatus) 
			REFERENCES dbo.tCTLestatus (IdEstatus)		
		)
		
		SELECT 'Tabla Creada tPLDmatrizConfiguracionFactoresParaNivelRiesgo' AS info

		CREATE UNIQUE INDEX UK_tPLDmatrizConfiguracionFactoresParaNivelRiesgo_Factor_Elemento 
			ON tPLDmatrizConfiguracionFactoresParaNivelRiesgo (Factor,Elemento)

		SELECT 'Llave unica creada' AS Info		
END
ELSE 
	-- DROP TABLE tPLDmatrizConfiguracionFactoresParaNivelRiesgo
	SELECT 'tPLDmatrizConfiguracionFactoresParaNivelRiesgo Existe'
GO

/********  JCA.6/8/2024.16:46 Info: INSERT DE SISTEMA  ********/

BEGIN TRY
	BEGIN TRANSACTION;
			INSERT INTO tPLDmatrizConfiguracionFactoresParaNivelRiesgo ([IdElemento], [IdFactor], [Factor], [Elemento], [IdEstatus])
			VALUES
			( 1, 1, 'Socio', 'Edad', 1 ),
			( 2, 1, 'Socio', 'Tiposocio', 1 ),
			( 3, 1, 'Socio', 'Género', 1 ),
			( 4, 2, 'Geografía', 'Sucursal del Socio', 1 ),
			( 5, 2, 'Geografía', 'Entidad de Nacimiento', 1 ),
			( 6, 2, 'Geografía', 'Municipio Residencia', 1 ),
			( 7, 2, 'Geografía', 'Municipio Sucursal', 1 ),
			( 8, 2, 'Geografía', 'Estado Sucursal', 1 ),
			( 9, 2, 'Geografía', 'País Nacimiento', 1 ),
			( 10, 2, 'Geografía', 'Nacionalidad', 1 ),
			( 11, 2, 'Geografía', 'Municipio Origen Depósitos', 1 ),
			( 12, 2, 'Geografía', 'Municipio Destino Retiros', 1 ),
			( 13, 3, 'Listas y Terceros', 'Propietario Real', 1 ),
			( 14, 3, 'Listas y Terceros', 'Proveedor de Recursos', 1 ),
			( 15, 3, 'Listas y Terceros', 'PEP', 1 ),
			( 16, 3, 'Listas y Terceros', 'Lista Bloqueada', 1 ),
			( 17, 4, 'Recursos', 'Rango Ingresos PF', 1 ),
			( 18, 4, 'Recursos', 'Rango Ingresos PM', 1 ),
			( 19, 4, 'Recursos', 'Ocupación', 1 ),
			( 20, 4, 'Recursos', 'Actividad', 1 ),
			( 21, 4, 'Recursos', 'Origen Recursos', 1 ),
			( 22, 4, 'Recursos', 'Destino Recursos', 1 ),
			( 23, 5, 'Transaccionalidad', 'Monto Depositos Declarados - Soc. Menores', 1 ),
			( 24, 5, 'Transaccionalidad', 'Monto Retiros Declarados - Soc. Menores', 1 ),
			( 25, 5, 'Transaccionalidad', 'Monto Depositos Declarados - Soc. Mayores', 1 ),
			( 26, 5, 'Transaccionalidad', 'Monto Retiros Declarados - Soc. Mayores', 1 ),
			( 27, 5, 'Transaccionalidad', 'Monto Depositos Declarados - Soc. Morales', 1 ),
			( 28, 5, 'Transaccionalidad', 'Monto Retiros Declarados - Soc. Morales', 1 ),
			( 29, 5, 'Transaccionalidad', 'Número Depositos Declarados - Soc. Menores', 1 ),
			( 30, 5, 'Transaccionalidad', 'Número Retiros Declarados - Soc. Menores', 1 ),
			( 31, 5, 'Transaccionalidad', 'Número Depositos Declarados - Soc. Mayores', 1 ),
			( 32, 5, 'Transaccionalidad', 'Número Retiros Declarados - Soc. Mayores', 1 ),
			( 33, 5, 'Transaccionalidad', 'Número Depositos Declarados - Soc. PM', 1 ),
			( 34, 5, 'Transaccionalidad', 'Número Retiros Declarados - Soc. PM', 1 ),
			( 35, 5, 'Transaccionalidad', 'Monto Depositos Operados - Soc. Menores', 1 ),
			( 36, 5, 'Transaccionalidad', 'Monto Retiros Operados - Soc. Menores', 1 ),
			( 37, 5, 'Transaccionalidad', 'Monto Depositos Operados - Soc. Mayores', 1 ),
			( 38, 5, 'Transaccionalidad', 'Monto Retiros Operados - Soc. Mayores', 1 ),
			( 39, 5, 'Transaccionalidad', 'Monto Depositos Operados - Soc. Morales', 1 ),
			( 40, 5, 'Transaccionalidad', 'Monto Retiros Operados - Soc. Morales', 1 ),
			( 41, 5, 'Transaccionalidad', 'Número Depositos Operados - Soc. Menores', 1 ),
			( 42, 5, 'Transaccionalidad', 'Número Retiros Operados - Soc. Menores', 1 ),
			( 43, 5, 'Transaccionalidad', 'Número Depositos Operados - Soc. Mayores', 1 ),
			( 44, 5, 'Transaccionalidad', 'Número Retiros Operados - Soc. Mayores', 1 ),
			( 45, 5, 'Transaccionalidad', 'Número Depositos Operados - Soc. Morales', 1 ),
			( 46, 5, 'Transaccionalidad', 'Número Retiros Operados - Soc. Morales', 1 ),
			( 47, 5, 'Transaccionalidad', 'Abonos Anticipados (% del Crédito)', 1 ),
			( 48, 5, 'Transaccionalidad', 'Liquidación Anticipada (% Monto Total)', 1 ),
			( 49, 6, 'Productos y Servicios', 'Servicios', 1 ),
			( 50, 6, 'Productos y Servicios', 'Productos', 1 ),
			( 51, 7, 'Canales e Instrumentos', 'Instrumentos', 1 ),
			( 52, 7, 'Canales e Instrumentos', 'Canales', 1 )
			 		
	COMMIT TRANSACTION;		

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;	
	 SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
	
END CATCH;


