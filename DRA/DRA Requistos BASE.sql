
use iERP_CPA
GO


SELECT 
--CASE
--	WHEN padre.IdTipoDdominio IS NULL THEN regreq.IdTipoDdominio
--	ELSE padre.IdTipoDdominio
--END AS IdTipoDdominio,
cuenta.FechaAlta, apertura.Folio,
cuentaE.FechaConsultaSIC,cuentaE.FolioConsultaSIC,
cuenta.Codigo, cuenta.Descripcion AS Producto,
regreq.Descripcion AS Nombre, 
--req.Descripcion AS Requisito, 
ldoc.Descripcion AS Documento,
archivo.Fecha, archivo.Nombre
-- ,CONCAT(cuentaE.FolioConsultaSIC,'.',archivo.Extension) AS  NombreDescarga
,regreq.IdRegistro AS RequisitoIdRequisito,
padre.IdRegistro AS PadreIdRequisito,
regreq.IdTipoDdominio AS RequisitoIdTipoDdominio,
padre.IdTipoDdominio AS PadreIdTipoDdominio,
regreq.IdRegistro AS RequisitoIdRegisto,
padre.IdRegistro AS PadreIdRegistro

FROM dbo.tDIGregistrosRequisitos regreq  WITH(NOLOCK) 
INNER JOIN dbo.tDIGrequisitos req  WITH(NOLOCK) ON req.IdRequisito = regreq.IdRequisito 
													AND req.EsDocumentable=1 -- filtro
INNER JOIN dbo.tDIGRequisitosD reqD  WITH(NOLOCK) ON reqD.IdRequisitoD = regreq.IdRequisitoD
INNER JOIN dbo.tCATlistasD ldoc  WITH(NOLOCK) ON ldoc.IdListaD = reqD.IdListaDdocumento
												--AND ldoc.IdListaD = 962 -- Filtro
INNER JOIN dbo.tCTLestatusActual ereq  WITH(NOLOCK) ON ereq.IdEstatusActual = req.IdEstatusActual
INNER JOIN dbo.tDIGregistrosDocumentos regDoc  WITH(NOLOCK) ON regDoc.IdRegistroDocumento = regreq.IdRegistroDocumento
INNER JOIN dbo.tDIGarchivos archivo  WITH(NOLOCK) ON archivo.IdArchivo = regDoc.IdArchivo 
														AND archivo.IdEstatusSincronizacion=4 -- filtro
LEFT JOIN dbo.tDIGregistrosRequisitos padre  WITH(NOLOCK) ON padre.IdRegistroRequisito = regreq.IdRegistroRequisitoPadre
															AND regreq.IdRegistroRequisitoPadre!=0 -- filtro
INNER JOIN dbo.tAYCcuentas cuenta  WITH(NOLOCK) ON cuenta.IdCuenta=padre.IdRegistro
INNER JOIN dbo.tAYCcuentasEstadisticas cuentaE  WITH(NOLOCK) ON cuentaE.IdCuenta = cuenta.IdCuenta
INNER JOIN dbo.tAYCaperturas apertura  WITH(NOLOCK) ON apertura.IdApertura = cuenta.IdApertura
WHERE regreq.IdEstatus=1 
AND apertura.Folio=11096
ORDER BY cuenta.FechaAlta desc

