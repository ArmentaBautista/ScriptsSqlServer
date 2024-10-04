

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pBKGgetClientsByDocument')
BEGIN
	DROP PROC pBKGgetClientsByDocument
	SELECT 'pBKGgetClientsByDocument BORRADO' AS info
END
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROC pBKGgetClientsByDocument
@DocumentType INT=0,
@DocumentId VARCHAR(24)='',
@Name AS VARCHAR(32)='',
@LastName AS VARCHAR(64)='',
@Mail AS VARCHAR(128)='',
@CellPhone AS VARCHAR(10)='',
@NoSocio AS VARCHAR(32)=''
AS
BEGIN

/*
	DECLARE @emails AS TABLE
	(
		IdRel INT,
		IdMail INT,
		IdListaD INT,
		Tipo VARCHAR(24),
		Email VARCHAR(128)
	)

	INSERT INTO @emails (IdRel, IdMail, IdListaD, Tipo, Email)
	SELECT m.IdRel, m.IdEmail, ld.IdListaD, ld.Descripcion, m.email 
	FROM dbo.tCATemails m  WITH(NOLOCK) 
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = m.IdListaD
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = m.IdEstatusActual AND ea.IdEstatus=1
	WHERE m.email=@mail

	DECLARE @telefonos AS TABLE
	(
		IdRel	INT, 
		IdTelefono	INT,
		IdListaD	INT,
		Tipo		VARCHAR(24),
		Telefono	VARCHAR(10)
	)

	INSERT INTO @telefonos (IdRel,IdTelefono,IdListaD,Tipo,Telefono)
	SELECT t.IdRel, t.IdTelefono, t.IdListaD, ld.Descripcion, t.Telefono
	FROM dbo.tCATtelefonos t  WITH(NOLOCK) 
	INNER JOIN dbo.tCTLestatusActual ea  WITH(NOLOCK) ON ea.IdEstatusActual = t.IdEstatusActual AND ea.IdEstatus=1
	INNER JOIN dbo.tCATlistasD ld  WITH(NOLOCK) ON ld.IdListaD = t.IdListaD
	WHERE t.IdListaD=-1339 AND t.Telefono = @cellPhone

	DECLARE @nombreBuscado AS VARCHAR(64)= CONCAT(@name, ' ', @lastName);
*/	

	SELECT 
	ClientBankIdentifier			= sc.Codigo,
	ClientName						= p.Nombre,
	ClientType						= 1,
	DocumentType					= @DocumentType,
	DocumentId						= @DocumentId
	FROM dbo.tSCSsocios sc  WITH(NOLOCK) 
	INNER JOIN dbo.tGRLpersonasFisicas p  WITH(NOLOCK) ON p.IdPersona = sc.IdPersona
	AND p.IFE=@DocumentId
	INNER JOIN dbo.tBKGcatalogoDocumentType dt  WITH(NOLOCK) ON dt.IdListaDidentificacion=p.IdTipoDidentificacion 
	AND dt.IdDocumentType=@DocumentType
	AND sc.Codigo=@NoSocio

	

END


GO