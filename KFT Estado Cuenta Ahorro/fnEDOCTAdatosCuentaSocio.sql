
/*  (◕ᴥ◕)    JCA.19/09/2023.12:43 a. m. Nota: Sección de datos generales del socio y de la cuenta  

 SELECT "vFMTdomiciliosGUI"."Calle", "vFMTdomiciliosGUI"."NumeroExterior", "vFMTdomiciliosGUI"."NumeroInterior", "vFMTdomiciliosGUI"."Calles", "vFMTdomiciliosGUI"."CodigoPostal", "vFMTdomiciliosGUI"."Asentamiento", "vFMTdomiciliosGUI"."Ciudad", "vFMTdomiciliosGUI"."Municipio", "vFMTdomiciliosGUI"."Estado", "vFMTcuentaBAS"."TipoDProductoDescripcion", "vFMTcuentaBAS"."InteresOrdinarioAnual", "vFMTcuentaBAS"."GAT", "vFMTcuentaBAS"."RFC", "vFMTcuentaBAS"."SocioCodigo", "vFMTcuentaBAS"."Codigo", "vFMTcuentaBAS"."IdTipoDProducto", "vFMTcuentaBAS"."IdCuenta", "vFMTcuentaBAS"."AperturaFolio", "vFMTcuentaBAS"."ProductosFinancieroDescripcion", "vFMTcuentaBAS"."SocioPersonaNombre", "vFMTcuentaBAS"."GATreal"
 FROM   "iERP_KFT"."dbo"."vFMTcuentaBAS" "vFMTcuentaBAS" LEFT OUTER JOIN "iERP_KFT"."dbo"."vFMTdomiciliosGUI" "vFMTdomiciliosGUI" ON "vFMTcuentaBAS"."IdRelDomicilios"="vFMTdomiciliosGUI"."IdRel"
 WHERE  "vFMTcuentaBAS"."Codigo"='098578-00015126-1201' AND "vFMTcuentaBAS"."IdTipoDProducto"<>143
*/

 -- Cambiar por...


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnEDOCTAdatosCuentaSocio')
BEGIN
	DROP FUNCTION dbo.fnEDOCTAdatosCuentaSocio
	SELECT 'fnEDOCTAdatosCuentaSocio BORRADO' AS info
END
GO

CREATE FUNCTION dbo.fnEDOCTAdatosCuentaSocio(
@NoCuenta VARCHAR(30),
@IdPeriodo INT
)
RETURNS TABLE
RETURN(
	 SELECT c.IdCuenta,
            c.NoCuenta,
            c.IdTipoDproducto,
            c.TipoDProducto,
            c.IdProductoFinanciero,
            c.ProductoFinanciero,
            c.InteresOrdinarioAnual,
            c.GAT,
            c.GATreal,
            c.IdApertura,
            c.AperturaFolio,
            c.IdEstatus,
            c.IdPeriodo,
            c.Periodo,
            c.DiasPeriodo,
            soc.IdSocio,
            soc.IdPersona,
            soc.NoSocio,
            soc.Nombre,
            soc.IdRelDomicilios,
            dom.IdDomicilio,
            dom.IdRel,
            dom.CP,
            dom.Calle,
            dom.Colonia,
            dom.Localidad,
            dom.Municipio,
            dom.Estado,
            dom.NumeroExterior,
            dom.NumeroInterior
	 FROM dbo.tEDOCTAcaptacionCapital c  WITH(NOLOCK) 
	 INNER JOIN dbo.tEDOCTAdatosSocio soc  WITH(NOLOCK) 
		ON soc.IdSocio = c.IdSocio
			AND soc.IdPeriodo=c.IdPeriodo
	INNER JOIN dbo.tEDOCTAdomicilios dom  WITH(NOLOCK) 
		ON dom.IdRel=soc.IdRelDomicilios
			AND dom.IdPeriodo = soc.IdPeriodo
	WHERE c.NoCuenta=@NoCuenta
		AND c.IdPeriodo=@IdPeriodo
)
GO




