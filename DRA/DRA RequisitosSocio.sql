

-- Socios
SELECT socio.Codigo, regreq.Descripcion AS Nombre, 
req.Descripcion,
ldoc.Descripcion AS Documento,
archivo.Fecha, archivo.Nombre
FROM dbo.tDIGregistrosRequisitos regreq  WITH(NOLOCK) 
INNER JOIN dbo.tDIGrequisitos req  WITH(NOLOCK) ON req.IdRequisito = regreq.IdRequisito AND req.EsDocumentable=1
INNER JOIN dbo.tDIGRequisitosD reqD  WITH(NOLOCK) ON reqD.IdRequisitoD = regreq.IdRequisitoD
INNER JOIN dbo.tCATlistasD ldoc  WITH(NOLOCK) ON ldoc.IdListaD = reqD.IdListaDdocumento
INNER JOIN dbo.tCTLestatusActual ereq  WITH(NOLOCK) ON ereq.IdEstatusActual = req.IdEstatusActual AND ereq.IdEstatus=1
INNER JOIN dbo.tDIGregistrosDocumentos regDoc  WITH(NOLOCK) ON regDoc.IdRegistroDocumento = regreq.IdRegistroDocumento
INNER JOIN dbo.tDIGarchivos archivo  WITH(NOLOCK) ON archivo.IdArchivo = regDoc.IdArchivo AND archivo.IdEstatusSincronizacion=5
INNER JOIN dbo.tCATlistasD listaArchivo  WITH(NOLOCK) ON listaArchivo.IdListaD = archivo.IdListaD
INNER JOIN  dbo.tSCSsocios  socio  WITH(NOLOCK) ON socio.IdSocio=regreq.IdRegistro
WHERE regreq.IdEstatus=1 and regreq.IdTipoDdominio IN (208) AND regreq.IdRegistroRequisitoPadre=0