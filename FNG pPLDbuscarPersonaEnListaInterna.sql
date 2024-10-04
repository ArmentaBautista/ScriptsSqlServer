

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDbuscarPersonaEnListaInterna')
BEGIN
	DROP PROC pPLDbuscarPersonaEnListaInterna
	SELECT 'pPLDbuscarPersonaEnListaInterna BORRADO' AS info
END
GO

CREATE PROC pPLDbuscarPersonaEnListaInterna
@pValorBuscado VARCHAR(32)
AS
BEGIN
	
	DECLARE @valorBuscado VARCHAR(32)=@pValorBuscado


	DECLARE @p TABLE(
		Id				INT,
		Caracter		VARCHAR(1024),
		Nombre			VARCHAR(1500),
		RFC				VARCHAR(20),
		FechaNacimiento DATE,
		Complementarios VARCHAR(max),
		IdSesion		INT
	)

	INSERT INTO @p
	SELECT l.id, l.Caracter, CONCAT(l.nombre,' ',l.paterno,' ',l.materno),l.RFC,l.FechaNacimiento,l.Complementarios,l.IdSesion
	FROM dbo.tpldlistasbloqueadas l  WITH(NOLOCK) 
	WHERE l.IdEstatus=1

	SELECT *
	FROM @p p
	WHERE p.Nombre LIKE '%' + @valorBuscado + '%'

END
GO
