



UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='PREOCUPANTES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-35;
-- Crear Operaci�n presunta preocupante cuando se detecte una operaci�n inusual de un empleado

UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='INUSUALES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-34;
-- Crear Operaci�n Inusual cuando se detecte una operaci�n Relevante

UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='RELEVANTES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-33;
-- Monto en d�lares para considerar una operacion Relevante

UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='INUSUALES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-32;
-- Monto en d�lares, para inusualidades por acumulaci�n de montos fraccionados en un mes calendario

UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='INUSUALES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-30;
-- Monto de dep�sitos para escalamiento de Operaciones de Personas Morales

UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='INUSUALES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-29;
-- Monto de dep�sitos para escalamiento de Operaciones de Personas F�sicas

UPDATE c SET c.Categoria1='ALERTAMIENTOS', c.Categoria2='RELEVANTES' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-25;
-- Permitir M�todo de Pago Efectivo para Personas Morales

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-14;
-- Fecha de Nacimiento

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-13;
-- RFC

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-12;
-- Donde contenga el valor

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-11;
-- Coincidencia Exacta

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-10;
-- Apellido Materno

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-9;
-- Apellido Paterno

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='INTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=-8;
-- Nombre

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='EXTERNAS' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=2;
-- Proveedor de Listas de Riesgo

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='CONDOR' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=3;
-- Usar RFC en Listas de Riesgo Condor

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='CONDOR' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=4;
-- Porcentaje B�squeda Listas de Riesgo Condor

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='CONDOR' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=5;
-- Token Listas de Riesgo Condor

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='QEQ' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=6;
-- Cliente Id web api QQ

UPDATE c SET c.Categoria1='LISTAS DE RIESGO', c.Categoria2='QEQ' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=7;
-- Id Secreto web api QQ

UPDATE c SET c.Categoria1='MATRIZ NIVEL RIESGO', c.Categoria2='SOCIO' FROM dbo.tPLDconfiguracion c WHERE c.IdParametro=8;
-- La transaccionalidad declarada solo se usa en el �rimer c�lculo por Socio

