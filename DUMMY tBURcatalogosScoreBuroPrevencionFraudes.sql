
TRUNCATE TABLE tBURcatalogosScoreBuroPrevencionFraudes
GO


INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-001','Consumidor fallecido.',0,1)  
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-008','Expediente no tiene al menos una cuenta actualizada en el �ltimo a�o o con antig�edad m�nima de 6 meses.',0,1) 
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion)
VALUES ('-009','Expediente sin cuentas para c�lculo del Score.',0,1)  

INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('01','La clave proporcionada no cuenta con permisos o privilegios para consultar este modelo estad�stico.',0,0,1,'Solicitud No Autorizada')  
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('02','En la informaci�n proporcionada se indic� un c�digo de producto inexistente en Bur� de Cr�dito. Nota: �nicamente aplica para consultas en formato INTL o XML. ',0,0,1,'Solicitud de Score inv�lida')  
INSERT INTO dbo.tBURcatalogosScoreBuroPrevencionFraudes(Codigo,Descripcion,EsRazon,EsExclusion,EsError,Mensaje)
VALUES ('03','No se encuentra disponible el sistema para calcular score o estimador solicitado. ',0,0,1,'Score No Disponible')  


SELECT * FROM tBURcatalogosScoreBuroPrevencionFraudes

