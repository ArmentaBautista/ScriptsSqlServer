

/*
Active este parámetro para evaluar el nivel de riesgo de los socios, con el método estandar 
*/
IF NOT EXISTS(SELECT IdConfiguracion FROM dbo.tCTLconfiguracion WHERE IdConfiguracion = 440)     
BEGIN
	INSERT INTO dbo.tCTLconfiguracion(IdConfiguracion, Descripcion, DescripcionLarga, Valor, ValorCodigo, ValorDescripcion, IdModulo, IdTipoDDato, IdTipoDOrigen, IdTipoDGrupo, IdTipoDCampoERP, IdTipoDDominio, IdTipoDconfiguracion, IdSucursal, Orden, Lista, IdConsulta, IdEstatus, EstatusAplicables, EsVisible)    
	VALUES (440, 'Usar Evaluación Nivel de Riesgo Estandar', 'Usar Evaluación Nivel de Riesgo Estandar', 'false', 'false', 'false', 33, 82, 88, 2443, 0, 208, 409, 0, 0, '', 0, 1, '', 1) 
END
GO
