
DECLARE @pElementoBuscado AS VARCHAR(20)='lopez';

SELECT 
suc.Descripcion AS Sucursal,
sc.Codigo AS NoSocio,
p.Nombre,
p.Domicilio,
nombre
FROM tGRLpersonas p
INNER JOIN tSCSsocios sc
  ON sc.IdPersona = p.IdPersona
INNER JOIN tCTLsucursales suc
  ON sc.IdSucursal = suc.IdSucursal
WHERE p.Nombre LIKE '%'+@pElementoBuscado+'%'

