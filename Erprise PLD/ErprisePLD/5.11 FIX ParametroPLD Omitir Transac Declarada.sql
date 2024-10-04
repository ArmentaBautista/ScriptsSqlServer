
/********  JCA.13/8/2024.19:26 Info: 5.09 Nuevo par�metro para controlar si se desea excluir la transaccionalidad declarada a partir del segundo c�lculo por socio.  ********/

IF NOT EXISTS(SELECT 1
				FROM dbo.tPLDconfiguracion c  WITH(NOLOCK)
				WHERE c.Codigo='ONCETRANDEC')
BEGIN
	INSERT INTO dbo.tPLDconfiguracion (Codigo,Descripcion,Valor,IdEstatus,IdTipo,Categoria1,Categoria2)
	VALUES ('ONCETRANDEC','La transaccionalidad declarada solo se usa en el �rimer c�lculo por Socio','0',1,409,'C�lculo Nivel de Riesgo','')

	SELECT 'Par�metro creado' AS Info
END
ELSE
	SELECT 'El Par�metro ya existe' AS Info
GO






