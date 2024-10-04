IF (OBJECT_ID('pSCSreactivarSocio') IS NOT NULL)
    BEGIN
        DROP PROC pSCSreactivarSocio
        SELECT 'pSCSreactivarSocio BORRADO' AS info
    END
GO

CREATE PROC pSCSreactivarSocio
@pNoSocio as varchar(32)='',
@pApellidoPaterno as VARCHAR(24)=''
AS
BEGIN
    if @pNoSocio ='' or @pApellidoPaterno=''
    begin
        select 'Debe proporcionar los parámetros solicitados' AS Info
        RETURN -1
    END

    update sc set idestatus=1
    from dbo.tscssocios sc
    INNER JOIN dbo.tgrlpersonasfisicas pf WITH (NOLOCK)
        on pf.idpersona=sc.idpersona
            and pf.apellidoPaterno=@pApellidoPaterno
    where sc.codigo=@pNoSocio
END
GO

SELECT 'pSCSreactivarSocio CREADO' AS info
GO

