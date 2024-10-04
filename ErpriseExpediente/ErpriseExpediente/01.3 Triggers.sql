

/*
Tipo: Trigger
Objeto:
Objeto Padre: tDIGarchivos
Resumen: al insertar un nuevo archivo cambia el estatus de todos los archivos del mismo  requisito para dejar solo el último como activo
*/


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='trNuevoArchivo')
BEGIN
	DROP TRIGGER trNuevoArchivo 
	SELECT 'trNuevoArchivo BORRADO' AS info
END
GO

CREATE TRIGGER trNuevoArchivo ON dbo.tDIGarchivos
AFTER INSERT
AS
BEGIN
	UPDATE a SET a.IdEstatus=2
	FROM dbo.tDIGarchivos a  WITH(NOLOCK) 
	INNER JOIN Inserted i  WITH(NOLOCK) ON i.IdExpediente = a.IdExpediente AND i.IdRequisito=a.IdRequisito
END
