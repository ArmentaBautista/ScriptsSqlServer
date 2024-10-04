

/* JCA.18/4/2024.21:20 
Nota: Para CDP módulo Encuesta de baja de socios. Usado para operaciones de grabado y recuperación desde código
*/
IF EXISTS(SELECT name FROM sys.types o WHERE o.name='tpRespuestasEncuestaBajaSocio')
BEGIN
	DROP TYPE tpRespuestasEncuestaBajaSocio
	SELECT 'tpRespuestasEncuestaBajaSocio BORRADO' AS info
END
GO

CREATE TYPE tpRespuestasEncuestaBajaSocio
AS TABLE
(
	IdReactivo				INT,
	IdRespuesta				INT,
	IdDominio				INT,
	TextoRespuesta			VARCHAR(250),	
	IdSocio					INT
)
GO



