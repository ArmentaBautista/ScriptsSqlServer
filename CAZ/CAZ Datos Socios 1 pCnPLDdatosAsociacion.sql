

IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnPLDdatosAsociacion')
BEGIN
	DROP PROC pCnPLDdatosAsociacion
END
GO

CREATE PROC dbo.pCnPLDdatosAsociacion
    @Socio AS    VARCHAR(50) = '',
    @Sucursal AS VARCHAR(50) = ''
AS
BEGIN

    IF @Socio <> ''
       AND @Socio <> '*'
        BEGIN
            DECLARE @IdSocio AS INT;
            SET @IdSocio =
                (
                    SELECT
                        IdSocio
                    FROM
                        dbo.tSCSsocios s WITH (NOLOCK)
                    WHERE
                        s.Codigo = @Socio
                );
            				SELECT 
			   datos.Sucursal,
			   datos.NumeroSocio,
			   datos.NumeroSocio,
               datos.FechaIngreso,
               datos.FechaBaja,
               datos.TipoFisicaActEmpresarial,
               datos.NombreCompleto,
               datos.Nombre,
               datos.ApellidoPaterno,
               datos.ApellidoMaterno,
               datos.Genero,
               datos.FechaNacimiento,
               datos.FechaConstitucion,
               datos.EntidadFederativaNacimiento,
               datos.PaisNacimiento,
               datos.Ocupacion,
               datos.Profesion,
               datos.ActividadGiroNegocio,
               datos.Calle,
               datos.NumeroExterior,
               datos.NumeroInterior,
               datos.Asentamiento,
               datos.Municipio,
               datos.Ciudad,
               datos.Estado,
               datos.CodigoPostal,
               datos.Pais,
               datos.Nacionalidad,
               datos.EstadoCivil,
               datos.Escolaridad,
               datos.CURP,
               datos.RFC,
               datos.Emails,
               datos.Telefonos,
               datos.IFE,
               datos.EsRepresentanteTercero,
               datos.EsPersonaPoliticamenteEspuesta,
               datos.NievelRiesgo,
               datos.TipoEmpleo,
               datos.SectorEconomico,
               datos.Ambito,
               datos.TiempoActividad,
               datos.GiroMercantil,
               datos.ActividadVulnerable
		FROM vCnDatosIngresoSocios datos  WITH(nolock) 
        WHERE datos.IdSocio = @IdSocio;
        END;
    ELSE IF @Sucursal <> ''
            AND @Sucursal <> '*'
             BEGIN
                 DECLARE @IdSucursal AS INT;
                 SET @IdSucursal =
                     (
                         SELECT
                             s.IdSucursal
                         FROM
                             dbo.tCTLsucursales s WITH (NOLOCK)
                         WHERE
                             s.Codigo = @Sucursal
                     );
                 
				SELECT 
			   datos.Sucursal,
			   datos.NumeroSocio,
			   datos.NumeroSocio,
               datos.FechaIngreso,
               datos.FechaBaja,
               datos.TipoFisicaActEmpresarial,
               datos.NombreCompleto,
               datos.Nombre,
               datos.ApellidoPaterno,
               datos.ApellidoMaterno,
               datos.Genero,
               datos.FechaNacimiento,
               datos.FechaConstitucion,
               datos.EntidadFederativaNacimiento,
               datos.PaisNacimiento,
               datos.Ocupacion,
               datos.Profesion,
               datos.ActividadGiroNegocio,
               datos.Calle,
               datos.NumeroExterior,
               datos.NumeroInterior,
               datos.Asentamiento,
               datos.Municipio,
               datos.Ciudad,
               datos.Estado,
               datos.CodigoPostal,
               datos.Pais,
               datos.Nacionalidad,
               datos.EstadoCivil,
               datos.Escolaridad,
               datos.CURP,
               datos.RFC,
               datos.Emails,
               datos.Telefonos,
               datos.IFE,
               datos.EsRepresentanteTercero,
               datos.EsPersonaPoliticamenteEspuesta,
               datos.NievelRiesgo,
               datos.TipoEmpleo,
               datos.SectorEconomico,
               datos.Ambito,
               datos.TiempoActividad,
               datos.GiroMercantil,
               datos.ActividadVulnerable
		FROM vCnDatosIngresoSocios datos  WITH(nolock) 
		WHERE datos.IdSucursal =  @IdSucursal
        
       END
    ELSE
        SELECT 
			   datos.Sucursal,
			   datos.NumeroSocio,
			   datos.NumeroSocio,
               datos.FechaIngreso,
               datos.FechaBaja,
               datos.TipoFisicaActEmpresarial,
               datos.NombreCompleto,
               datos.Nombre,
               datos.ApellidoPaterno,
               datos.ApellidoMaterno,
               datos.Genero,
               datos.FechaNacimiento,
               datos.FechaConstitucion,
               datos.EntidadFederativaNacimiento,
               datos.PaisNacimiento,
               datos.Ocupacion,
               datos.Profesion,
               datos.ActividadGiroNegocio,
               datos.Calle,
               datos.NumeroExterior,
               datos.NumeroInterior,
               datos.Asentamiento,
               datos.Municipio,
               datos.Ciudad,
               datos.Estado,
               datos.CodigoPostal,
               datos.Pais,
               datos.Nacionalidad,
               datos.EstadoCivil,
               datos.Escolaridad,
               datos.CURP,
               datos.RFC,
               datos.Emails,
               datos.Telefonos,
               datos.IFE,
               datos.EsRepresentanteTercero,
               datos.EsPersonaPoliticamenteEspuesta,
               datos.NievelRiesgo,
               datos.TipoEmpleo,
               datos.SectorEconomico,
               datos.Ambito,
               datos.TiempoActividad,
               datos.GiroMercantil,
               datos.ActividadVulnerable
		FROM vCnDatosIngresoSocios datos  WITH(nolock) 

END

GO

