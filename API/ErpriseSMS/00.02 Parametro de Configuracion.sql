
BEGIN 

/* JCA.16/4/2024.19:35 
Nota: Parámetro de configuración para la API gateway para los SMS de bonsaif
*/

IF NOT EXISTS(SELECT 1 FROM dbo.tCTLconfiguracion c WHERE c.IdConfiguracion=1645)
	INSERT INTO dbo.tCTLconfiguracion
	(
		[IdConfiguracion],
		[Descripcion],
		[DescripcionLarga],
		[Valor],
		[ValorCodigo],
		[ValorDescripcion],
		[IdModulo],
		[IdTipoDDato],
		[IdTipoDOrigen],
		[IdTipoDGrupo],
		[IdTipoDCampoERP],
		[IdTipoDDominio],
		[IdTipoDconfiguracion],
		[IdSucursal],
		[Orden],
		[Lista],
		[IdConsulta],
		[IdEstatus],
		[EstatusAplicables],
		[EsVisible],
		[Cliente]
	)
	VALUES
	(1645, 'URL API envío de SMS', 'URL API envío de SMS', 'http://10.10.1.3:8094/ErpriseSMS/', '',
	 'http://10.10.1.3:8094/ErpriseSMS/', 35, 78, 88, 877, 0, 0, 409, 0, 0, N'', 0, 1, '', 1, NULL);

END
GO

select *
from dbo.tCTLconfiguracion c WITH (NOLOCK) where IdConfiguracion=1645
GO
