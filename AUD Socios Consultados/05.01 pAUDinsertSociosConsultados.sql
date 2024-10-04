IF (OBJECT_ID('pAUDinsertSociosConsultados') IS NOT NULL)
        BEGIN
            DROP PROC pAUDinsertSociosConsultados
            SELECT 'pAUDinsertSociosConsultados BORRADO' AS info
        END
GO

CREATE proc pAUDinsertSociosConsultados
@pIdSocio int=0,
@pNoSocio varchar(32)='',
@pIdSesion INT=0
as
begin
    DECLARE @IdSesion 	INT
    SET @IdSesion=@pIdSesion

    IF @IdSesion=0
	    SET @IdSesion = (SELECT ISNULL(IdSesion,0) FROM dbo.fCTLsesionDALBD())

	if(@pNoSocio<>'' AND @pIdSocio=0)
		SELECT @pIdSocio=sc.IdSocio from dbo.tscssocios sc with(nolock) where sc.codigo=@pNoSocio


	INSERT into tAUDsociosConsultados (idsocio, NoSocio,idsesion)
	select @pIdsocio,@pNoSocio, @Idsesion

end
GO
SELECT 'pAUDinsertSociosConsultados creado'
GO

