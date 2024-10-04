
IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionOrigenDestinoRecursos')
BEGIN
	-- DROP TABLE tPLDmatrizConfiguracionOrigenDestinoRecursos
	CREATE TABLE [dbo].tPLDmatrizConfiguracionOrigenDestinoRecursos
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT null , -- Ingresos = 1,  Egresos = 2
		IdValor1		 INT NOT NULL , -- En 0 ya se compara por el nombre del campo
		IdValor2		 INT NULL ,		-- En 0 ya se compara por el nombre del campo
		ValorDescripcion VARCHAR(128) NULL,
		Puntos			 NUMERIC(5,2) NOT NULL DEFAULT 0,
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) ON [PRIMARY]

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionOrigenDestinoRecursos')

	SELECT 'Tabla Creada' AS info
END
GO

IF EXISTS(SELECT 1 FROM tPLDmatrizConfiguracionOrigenDestinoRecursos)
BEGIN
	SELECT 'La tabla ya contienen datos, no es posible insertar los valores iniciales';
END
ELSE
BEGIN
    
	INSERT INTO tPLDmatrizConfiguracionOrigenDestinoRecursos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos)
	VALUES
	(1,0,0,'Sueldo',1),
	(1,0,0,'Comisiones',1),
	(1,0,0,'HonorariosProfesionales',1),
	(1,0,0,'InteresesInversiones',1),
	(1,0,0,'Arrendamientos',1),
	--(1,0,0,'OtrosIngresos',1),
	--(1,0,0,'ConyugueSueldo',1),
	--(1,0,0,'ConyugueComisiones',1),
	--(1,0,0,'ConyugueHonorariosProfecionales',1),
	(1,0,0,'Becas',1),
	(1,0,0,'Donativos',1),
	(1,0,0,'Fideicomiso',1),
	(1,0,0,'Herencia',1),
	(1,0,0,'LiquidacionFiniquito',1),
	(1,0,0,'Pension',1),
	(1,0,0,'Premios',1),
	(1,0,0,'Remesas',1),
	(1,0,0,'Seguros',1),
	(1,0,0,'Subsidio',1),
	(1,0,0,'Dividendos',1),
	(1,0,0,'ProyectoAgricola',1),
	--(1,0,0,'UtilidadNegocio',1),
	(1,0,0,'VentasComercializacion',1),
	(1,0,0,'VentaBienesInmuebles',1),
	(1,0,0,'VentaBienesMuebles',1),
	(1,0,0,'Aguinaldo',1),
	(1,0,0,'ProvienePrestamo',1),
	(1,0,0,'AhorroInversionOtraInstitucion',1),
	(1,0,0,'AhorroIngresos',1)

	SELECT 'Ingresos insertados'

	INSERT INTO tPLDmatrizConfiguracionOrigenDestinoRecursos (Tipo,IdValor1,IdValor2,ValorDescripcion,Puntos)
	VALUES
	(2,0,0,'Alimentos',1),
	(2,0,0,'LuzAgua',1),
	(2,0,0,'Transporte',1),
	(2,0,0,'Vivienda',1),
	(2,0,0,'Combustible',1),
	(2,0,0,'Extraordinarios',1),
	(2,0,0,'CooperativasBancos',1),
	(2,0,0,'TarjetaCredito',1),
	(2,0,0,'Almacenes',1),
	(2,0,0,'CostosOperacion',1),
	(2,0,0,'CostosVentas',1),
	(2,0,0,'Educacion',1),
	(2,0,0,'OtrosEgresos',1)

	SELECT 'Egresos insertados'

END
GO

SELECT * FROM dbo.tPLDmatrizConfiguracionOrigenDestinoRecursos
GO
