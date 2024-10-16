﻿
TRUNCATE TABLE tBURcatalogosScoreBuroTelecomunicaciones
GO

INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('50','Poca antigüedad en cuentas abiertas.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('51','Morosidades moderadas y recurrentes en el histórico de pago.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('52','Poco historial crediticio.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('53','Poco historial crediticio en cuentas revolventes.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('54','Muchas cuentas aperturadas recientemente y aún activas.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('55','Poca antigüedad.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('56','Alta exposición del cliente.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('57','Poca antigüedad promedio en cuentas abiertas.')  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('58','Morosidades en pocos meses de abierto el crédito.')  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('59','Muestra cuentas recién aperturadas que alcanzan morosidad.')
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('60','El cliente presenta alto índice de morosidad.')  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('61','El cliente presenta morosidades a corto plazo.')  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('62','Presenta créditos con alta utilización.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('63','Presenta primer pago vencido a corto plazo.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('64','El cliente presenta sobre endeudamiento.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('65','Presenta poca diversificación de crédito.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('66','Presenta saldos vencidos.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('67','Presenta varias cuentas activas con morosidad.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('68','Baja utilización de sus cuentas y buen comportamiento de pago.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('69','Alta utilización de sus cuentas y comportamiento de pago regular.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('70','Baja utilización de sus cuentas y morosidades moderadas recientes.')   
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('71','Baja utilización de sus cuentas y morosidades recientes.')  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion)
VALUES ('72','Alta utilización de sus cuentas y morosidades recientes.')  

INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-001','Consumidor fallecido.',0,1)  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-005','Un archivo de crédito donde todas las cuentas están actualmente cerradas y por lo menos una cuenta con más de 90 días o más de morosidad. MOP ≥ 04.',0,1)
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-006','Un archivo de crédito donde todas las cuentas han sido abiertas en los últimos 6 meses y por lo menos  una cuenta con más de 60 días o más de morosidad MOP ≥ 03.',0,1)  
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-007','Un archivo de crédito donde todas las cuentas han sido abiertas en los últimos 6 meses y por lo menos una cuenta tiene 30 días o más de morosidad. MOP ≥ 02.',0,1) 
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-008','El archivo de crédito no tiene por lo menos una cuenta actualizada en los últimos 12 meses o por lo que menos una cuenta abierta en los últimos 6 meses ("Criterios mínimos de calificación").',0,1)
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-009','El archivo de crédito no tiene cuentas para calcular el Score.',0,1)
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('01','La clave proporcionada no cuenta con permisos o privilegios para consultar este modelo estadístico.',0,0,1,'Solicitud NO Autorizada')
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje) 
VALUES ('02','En la información proporcionada se indicó un código de producto inexistente en Buró de Crédito. Nota: Únicamente aplica para consultas en formato INTL o XML.',0,0,1,'Solicitud de Score inválida')
INSERT INTO dbo.tBURcatalogosScoreBuroTelecomunicaciones(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('03','No se encuentra disponible el sistema para calcular score o estimador solicitado.',0,0,1,'Score No Disponible')


SELECT * FROM dbo.tBURcatalogosScoreBuroTelecomunicaciones

