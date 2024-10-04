


 SELECT "vFMTdomiciliosGUI"."Calle", "vFMTdomiciliosGUI"."NumeroExterior", "vFMTdomiciliosGUI"."NumeroInterior", "vFMTdomiciliosGUI"."Calles", "vFMTdomiciliosGUI"."CodigoPostal", "vFMTdomiciliosGUI"."Asentamiento", "vFMTdomiciliosGUI"."Ciudad", "vFMTdomiciliosGUI"."Municipio", "vFMTdomiciliosGUI"."Estado", "vFMTcuentaBAS"."TipoDProductoDescripcion", "vFMTcuentaBAS"."InteresOrdinarioAnual", "vFMTcuentaBAS"."GAT", "vFMTcuentaBAS"."RFC", "vFMTcuentaBAS"."SocioCodigo", "vFMTcuentaBAS"."Codigo", "vFMTcuentaBAS"."IdTipoDProducto", "vFMTcuentaBAS"."SucursalDescripcion", "vFMTcuentaBAS"."IdCuenta", "vFMTcuentaBAS"."AperturaFolio", "vFMTcuentaBAS"."ProductosFinancieroDescripcion", "vFMTcuentaBAS"."SocioPersonaNombre", "vFMTcuentaBAS"."GATreal", "vFMTcuentaBAS"."PersonaFisicaFechaNacimiento", "vFMTcuentaBAS"."FechaAlta", "vFMTdomiciliosGUI"."IdEstatus", "vFMTcuentaBAS"."ClabeInterbancaria"
 FROM   "dbo"."vFMTcuentaBAS" "vFMTcuentaBAS" 
 INNER JOIN "dbo"."vFMTdomiciliosGUI" "vFMTdomiciliosGUI" ON "vFMTcuentaBAS"."IdRelDomicilios"="vFMTdomiciliosGUI"."IdRel"
 WHERE  "vFMTcuentaBAS"."Codigo"='566565' AND "vFMTcuentaBAS"."IdTipoDProducto"<>143 AND "vFMTdomiciliosGUI"."IdEstatus"=1



 SELECT "vFMTempresa"."Domicilio", "vFMTempresa"."SitioWEB", "vFMTempresa"."Nombre", "vFMTempresa"."IdEstatus", "vFMTempresa"."NombreComercial", "vFMTempresa"."Telefonos"
 FROM   "dbo"."vFMTempresa" "vFMTempresa"
 WHERE  "vFMTempresa"."IdEstatus"=1



SELECT *FROM dbo.ffmtInformes(0,571)