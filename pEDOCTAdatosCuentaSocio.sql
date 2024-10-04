

CREATE OR ALTER PROCEDURE dbo.pEDOCTAdatosCuentaSocio
@NoCuenta VARCHAR(30),
@Periodo VARCHAR(7)
AS
BEGIN

	DECLARE @bd AS VARCHAR(30) = (SELECT valor FROM tedoctaconfiguraciones c WITH(NOLOCK) WHERE c.id=1)

	DECLARE @sql AS NVARCHAR(max)='
			SELECT C.IdCuenta,
				   C.NoCuenta,
				   C.IdTipoDproducto,
				   C.TipoDProducto,
				   C.IdProductoFinanciero,
				   C.ProductoFinanciero,
				   C.InteresOrdinarioAnual,
				   C.GAT,
				   C.GATreal,
				   C.IdApertura,
				   C.AperturaFolio,
				   C.IdEstatus,
				   C.IdPeriodo,
				   C.Periodo,
				   C.DiasPeriodo,
				   soc.IdSocio,
				   soc.IdPersona,
				   soc.NoSocio,
				   soc.Nombre,
				   p.RFC,
				   soc.IdRelDomicilios,
				   dom.IdRel,
				   dom.CP,
				   dom.Calle,
				   dom.Colonia,
				   dom.Localidad,
				   dom.Municipio,
				   dom.Estado,
				   dom.NumeroExterior,
				   dom.NumeroInterior
			FROM dbo.tEDOCTAcaptacionCapital c WITH(NOLOCK)
			INNER JOIN dbo.tEDOCTAdatosSocio soc WITH(NOLOCK)
				ON soc.IdSocio = c.IdSocio
				   AND soc.Periodo = c.Periodo
			INNER JOIN ''' + @bd + '''.dbo.tGRLpersonas p WITH(NOLOCK)
				ON soc.IdPersona = p.IdPersona
			INNER JOIN dbo.tEDOCTAdomicilios dom WITH(NOLOCK)
				ON dom.IdRel = soc.IdRelDomicilios
				   AND dom.Periodo = soc.Periodo
			WHERE c.NoCuenta =''' + @NoCuenta + '''
				  AND c.Periodo =''' + @Periodo + ''
		
		EXEC sp_executesql @sql;
END 
GO
