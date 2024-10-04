
USE jcDB
GO







  DECLARE @str NVARCHAR(MAX);
 
  SELECT @str = COALESCE(@str + ', ', '') + usuario
    FROM dbo.usuarios
  ORDER BY usuario;


