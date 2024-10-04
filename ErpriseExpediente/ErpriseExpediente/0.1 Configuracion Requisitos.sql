
USE ErpriseExpediente
GO

/*
Archivo de configuracion de requisitos
1. Crear los Agrupadores, estos encapsulan requisitos cuya finalidad esta relacionada como ejemplo, Documentos personales
2. Crear los Requisitos, representan un documento en si, como puede ser un Acta de Nacimiento
3. Crear la relación de Agrupadores y Requisitos
*/

/************************************     1     ****************************************/
INSERT INTO dbo.tDIGagrupadores (Codigo,Descripcion,EsObligatorio,IdEstatus) VALUES ('DOCPER','DOCUMENTOS PERSONALES',0,1)
GO

INSERT INTO dbo.tDIGagrupadores (Codigo,Descripcion,EsObligatorio,IdEstatus) VALUES ('DOCCAP','DOCUMENTOS DE CAPTACION',0,1)
GO

INSERT INTO dbo.tDIGagrupadores (Codigo,Descripcion,EsObligatorio,IdEstatus) VALUES ('DOCPLD','DOCUMENTACION DE PLD',0,1)
GO

INSERT INTO dbo.tDIGagrupadores (Codigo,Descripcion,EsObligatorio,IdEstatus) VALUES ('DOCCRED','DOCUMENTOS DE CREDITO',0,1)
GO

/************************************     2     ****************************************/
/************************************     Personales     ****************************************/
INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('IDEOFI','Identificacion Oficial',1, 0, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('ACTNAC','Acta de Nacimiento',1, 0, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('COMDOM','Comprobante de Domicilio',1, 0, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('CURP','Curp',1, 0, 0, 0, 0, 1, 1)
GO

/************************************     Captación     ****************************************/
INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('SOLADM','Solicitud de Admision',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('CARAPO','Certificado de Aportacion',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('CONUNI','Contrato Universal',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('APECAJ','Apertura Caja de Ahorro',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('ENGAR1','En Garantia 1',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('ENGAR2','En Garantia 2',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('ENGAR3','En Garantia 3',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('ENGAR4','En Garantia 4',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('ENGAR5','En Garantia 5',0, 1, 0, 0, 0, 1, 1)
GO

/************************************     PLD     ****************************************/
INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('FORPLD','Formato PLD',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('CONLPB','Consulta LPB',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('PROREA','Propietario Real',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('APOLEG','Apoderado Legal',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('FORI','Formulario I',0, 1, 0, 0, 0, 1, 1)
GO

INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('IDECON','Identificacion y Conocimiento PF',0, 1, 0, 0, 0, 1, 1)
GO

/************************************     CRÉDITO     ****************************************/
INSERT INTO dbo.tDIGrequisitos
(Codigo,Descripcion,AplicaIngreso,AplicaDisponibilidad,AplicaInversiones,AplicaCredito,EsObligatorio,PermiteMultiarchivo,IdEstatus)
VALUES('EXPCRE','Expediente de Crédito',0, 0, 0, 1, 0, 1, 1)
GO


