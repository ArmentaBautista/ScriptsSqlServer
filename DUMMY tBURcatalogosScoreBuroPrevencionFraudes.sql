
TRUNCATE TABLE tBURcatalogosScoreBuroPrevencionFraudes
GO


INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-001','Consumidor fallecido.',0,1)  
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-008','Expediente no tiene al menos una cuenta actualizada en el último año o con antigüedad mínima de 6 meses.',0,1) 
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-009','Expediente sin cuentas para cálculo del Score.',0,1)  

INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('01','La clave proporcionada no cuenta con permisos o privilegios para consultar este modelo estadístico.',0,0,1,'Solicitud No Autorizada')  
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('02','En la información proporcionada se indicó un código de producto inexistente en Buró de Crédito. Nota: Únicamente aplica para consultas en formato INTL o XML. ',0,0,1,'Solicitud de Score inválida')  
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('03','No se encuentra disponible el sistema para calcular score o estimador solicitado. ',0,0,1,'Score No Disponible')  


SELECT * FROM tBURcatalogosScoreBuroPrevencionFraudes

