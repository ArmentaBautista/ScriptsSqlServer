
USE ErpriseExpediente
GO


/*
INSERT INTO dbo.tGRLpersonas(
IdentificadorPersona,
NumeroSocio,Tipo,Nombre,Nombre2,ApellidoPaterno,ApellidoMaterno,FechaNacimiento,Genero,CURP,RFC,
RFCValidado,EstadoNacimiento,TipoIdentificacion,NoIdentificacion,NivelEstudios,Profesion,Ocupacion,
EsExtranjero,IdFiscal,CalidadMigratoria,ActividadEmpresarial,EstadoCivil,TipoRelacionado,IdEstatus
)
SELECT 
IdentificadorPersona,
IdentificadorPersona,Tipo,Nombre,Nombre2,ApellidoPaterno,ApellidoMaterno,FechaNacimiento,Genero,CURP,RFC,
RFCValidado,EstadoNacimiento,TipoIdentificacion,NoIdentificacion,NivelEstudios,Profesion,Ocupacion,
EsExtranjero,IdFiscal,CalidadMigratoria,ActividadEmpresarial,EstadoCivil,TipoRelacionado,1
FROM migra_persona WITH(NOLOCK) 
*/


-- SELECT * FROM tGRLpersonas where idpersona=40

-- SELECT * FROM dbo.tAYCcuentas

/*
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (9,'01-0012365','CREDI CONSUMO','12 MESES TASA 12% ANUAL',1)
GO
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (9,'01-6846461','CREDI COMERCIO','36 QUINCENAS TASA 22% ANUAL',1)
GO
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (9,'01-87653165','CREDI HIPOTECARIO','180 MESES TASA 11% ANUAL',1)
GO
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (9,'01-584684664','CREDI AUTO','60 MESES TASA 13% ANUAL',2)
GO

INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (40,'10-657457','CREDI CONSUMO','12 MESES TASA 12% ANUAL',1)
GO
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (40,'10-56765567','CREDI COMERCIO','36 QUINCENAS TASA 22% ANUAL',1)
GO
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (40,'10-17869435','CREDI HIPOTECARIO','180 MESES TASA 11% ANUAL',1)
GO
INSERT INTO dbo.tAYCcuentas (IdPersona,NumeroCuenta,Descripcion,DescripcionLarga,IdEstatus)
VALUES (40,'10-8735437429','CREDI AUTO','60 MESES TASA 13% ANUAL',2)
GO

*/