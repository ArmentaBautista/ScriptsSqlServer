USE ErpriseExpediente
GO

/*
Tipo: Vista
Objeto: vDIGrequisitosAgrupador
Resumen: Obtiene todos los requisitos con su respectivo agrupador
*/


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='vDIGrequisitosAgrupador')
BEGIN
	DROP VIEW vDIGrequisitosAgrupador
	SELECT 'vDIGrequisitosAgrupador BORRADO' AS info
END
GO

CREATE VIEW vDIGrequisitosAgrupador
AS
	SELECT 
	 AgrupadorCodigo = a.Codigo
	,AgrupadorDescripcion = a.Descripcion
	,Agrupador	= CONCAT(a.Codigo,'-',a.Descripcion)
	,AgrupadorObligatorio = a.EsObligatorio
	,RequisitoCodigo = r.Codigo
	,RequisitoDescripcion = r.Descripcion
	,Requisito	= CONCAT(r.Codigo,'-',r.Descripcion)
	,RequisitoObligatorio = r.EsObligatorio
	,AplicaIngreso = r.AplicaIngreso
	,AplicaDisponibilidad = r.AplicaDisponibilidad
	,AplicaInversiones = r.AplicaInversiones
	,AplicaCredito = r.AplicaCredito 
	,r.EsDocumental
	,a.IdAgrupador, r.IdRequisito
	FROM dbo.tDIGagrupadoresRequisitos ar  WITH(NOLOCK) 
	INNER JOIN dbo.tDIGagrupadores a  WITH(NOLOCK) ON a.IdAgrupador = ar.IdAgrupador
	INNER JOIN dbo.tDIGrequisitos r  WITH(NOLOCK) ON r.IdRequisito = ar.IdRequisito

GO