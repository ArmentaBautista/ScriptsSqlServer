
/* =^..^=   =^..^=   =^..^=    =^..^=    =^..^=    =^..^=    =^..^= */
--  tBKGcatalogoDocumentType_DummyData

TRUNCATE TABLE dbo.tBKGcatalogoDocumentType
GO	

IF DB_NAME()='iERP_KFT'
begin

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 1, 'INE',-1357,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 2, 'IFE',-31,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 3, 'Cédula de Identidad',-32,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 10, 'Pasaporte',-33,1)

END
GO

IF DB_NAME()='iERP_DRA'
BEGIN

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 101, 'INE',-1357,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 102, 'IFE',-31,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 103, 'CÉDULA PROFESIONAL',-34,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 104, 'LICENCIA',-32,1)

	INSERT INTO dbo.tBKGcatalogoDocumentType (IdDocumentType,DocumentType,IdListaDidentificacion,IdEstatus) VALUES ( 105, 'PASAPORTE',-33,1)

END
GO


SELECT * FROM dbo.tBKGcatalogoDocumentType

--SELECT * FROM dbo.tCATlistasD ld  WITH(NOLOCK) WHERE ld.IdTipoE=173

GO
