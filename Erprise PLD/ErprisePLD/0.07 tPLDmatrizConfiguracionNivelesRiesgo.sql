


IF EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionNivelesRiesgo')
begin
	print 'tPLDmatrizConfiguracionNivelesRiesgo Existe';

	if exists(SELECT count(1) as contador FROM tPLDmatrizConfiguracionNivelesRiesgo having count(1)>0)
	begin
		print 'tPLDmatrizConfiguracionNivelesRiesgo ya tiene registros';

		IF OBJECT_ID('tempdb..#tPLDmatrizConfiguracionNivelesRiesgo') IS NOT NULL 
		begin
			print 'Borrando tempdb..tPLDmatrizConfiguracionNivelesRiesgo';
			drop TABLE #tPLDmatrizConfiguracionNivelesRiesgo
		end

		select * INTO #tPLDmatrizConfiguracionNivelesRiesgo FROM dbo.tPLDmatrizConfiguracionNivelesRiesgo
		print 'Registros respaldados';
	
		drop TABLE tPLDmatrizConfiguracionNivelesRiesgo
		print 'tPLDmatrizConfiguracionNivelesRiesgo borrada';
	end
	else 
	begin
		drop TABLE tPLDmatrizConfiguracionNivelesRiesgo
		print 'tPLDmatrizConfiguracionNivelesRiesgo borrada';
	end
END	
GO

IF NOT EXISTS(SELECT name FROM sys.tables WHERE name='tPLDmatrizConfiguracionNivelesRiesgo')
BEGIN

	CREATE TABLE [dbo].tPLDmatrizConfiguracionNivelesRiesgo
	(
		Id 				 INT NOT NULL PRIMARY KEY IDENTITY,
		Tipo			 INT NOT NULL , -- 1. Menores, 2. Mayores, 3. Morales
		TipoDescripcion	 VARCHAR(128) NULL,
		NivelRiesgo		 INT NOT null , -- 1. Bajo, 2. Medio, 3. Alto
		NivelRiesgoDescripcion		 VARCHAR(128) NULL,
		Valor1			 NUMERIC(8,2) NOT NULL ,
		Valor2			 NUMERIC(8,2) NOT NULL ,	
		Alta			 DATETIME	 NOT NULL DEFAULT GetDate(),
		IdEstatus 		 INT NOT NULL DEFAULT 1
	) ON [PRIMARY]

INSERT INTO tPLDobjetosModulo(Nombre) 
Values ('tPLDmatrizConfiguracionNivelesRiesgo')

	print 'tPLDmatrizConfiguracionNivelesRiesgo Creada';
END
GO

IF OBJECT_ID('tempdb..#tPLDmatrizConfiguracionNivelesRiesgo') IS NOT NULL
begin
	print 'Hay Tabla de respaldo';

	IF (SELECT COUNT(1) FROM #tPLDmatrizConfiguracionNivelesRiesgo)>0
	BEGIN	
		print 'Hay registros respaldados';
		INSERT INTO dbo.tPLDmatrizConfiguracionNivelesRiesgo(Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2,Alta,IdEstatus)
		SELECT Tipo,TipoDescripcion,NivelRiesgo,NivelRiesgoDescripcion,Valor1,Valor2,Alta,IdEstatus FROM #tPLDmatrizConfiguracionNivelesRiesgo
	
		print 'Volcado Listo';
	END
END	
GO

SELECT * FROM tPLDmatrizConfiguracionNivelesRiesgo





