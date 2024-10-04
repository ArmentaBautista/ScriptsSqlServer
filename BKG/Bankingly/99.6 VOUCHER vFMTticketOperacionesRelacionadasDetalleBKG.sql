
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vFMTticketOperacionesRelacionadasDetalleBKG')
BEGIN
	DROP VIEW vFMTticketOperacionesRelacionadasDetalleBKG
	SELECT 'vFMTticketOperacionesRelacionadasDetalleBKG BORRADO' AS info
END
GO

CREATE VIEW [dbo].vFMTticketOperacionesRelacionadasDetalleBKG
	AS
SELECT 
  Descripcion  = Detalle.DescripcionBienServicio,
  Cantidad  = Detalle.Cantidad,
  PrecioCimptos = Detalle.PrecioConImpuestos,
  Total   = Detalle.Total,
  OperacionPadre.IdOperacion,
  Operacion.RelOperaciones,
  SocioCodigo = Socio.Codigo,
  SocioNombre = Persona.Nombre    

FROM tGRLoperaciones  OperacionPadre WITH (NOLOCK) INNER JOIN
  tGRLoperaciones  Operacion         WITH (NOLOCK) ON Operacion.IdOperacionPadre = OperacionPadre.IdOperacion INNER JOIN 
  tGRLoperacionesD Detalle           WITH (NOLOCK) ON Detalle.RelOperacionD = Operacion.IdOperacion INNER JOIN
  tGRLbienesServicios BienServicio   WITH (NOLOCK) ON BienServicio.IdBienServicio = Detalle.IdBienServicio
  INNER JOIN tSCSsocios Socio        WITH (NOLOCK) ON Socio.IdSocio = Operacion.IdSocio
  INNER JOIN tGRLpersonas Persona    WITH (NOLOCK) ON Persona.IdPersona = Socio.IdPersona
  
WHERE --OperacionPadre.IdTipoOperacion in (1) and 
Operacion.IdTipoOperacion in (1,17) AND Detalle.IdEstatus = 1 --AND Operacion.RelOperacionesD != 0
 
GO
