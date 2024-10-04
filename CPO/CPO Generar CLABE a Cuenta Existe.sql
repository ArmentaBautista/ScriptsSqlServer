
DECLARE @noSocio AS VARCHAR(30)='0-006352';
DECLARE @noCuenta AS VARCHAR(30)='0-069250';

DECLARE @idCuenta AS INT=0;
DECLARE @Socio AS VARCHAR(30)='';
DECLARE @Cuenta AS VARCHAR(30)='';


SELECT @idCuenta=cta.IdCuenta , @Socio=p.Nombre, @Cuenta=cta.Descripcion
FROM dbo.tAYCcuentas cta  WITH(NOLOCK) 
INNER JOIN dbo.tSCSsocios socio  WITH(NOLOCK) ON socio.IdSocio = cta.IdSocio AND socio.codigo=@noSocio
INNER JOIN dbo.tGRLpersonas p WITH(NOLOCK) ON p.IdPersona = socio.IdPersona
WHERE cta.Codigo=@noCuenta

SELECT @idCuenta, @Socio, @Cuenta

DECLARE @IdCuentaCLABE INT,
        @CLABE VARCHAR(18);
EXEC dbo.pCRUDcuentaCLABE @TipoOperacion = 'C',                   
                          @IdCuentaCLABE = @IdCuentaCLABE OUTPUT, 
                          @CLABE = @CLABE OUTPUT,                 
                          @IdCuenta = @idCuenta                   

SELECT cta.Codigo, cta.Descripcion, cb.CLABE
FROM dbo.tAYCcuentas cta  WITH(NOLOCK) 
INNER JOIN dbo.tAYCcuentasCLABE cb  WITH(NOLOCK) ON cb.IdCuenta = cta.IdCuenta 
WHERE cta.IdCuenta=@idCuenta


