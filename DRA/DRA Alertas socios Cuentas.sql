
USE iERP_DRA_TEST
go


DECLARE @tt_cuentas TABLE(
	IdSocio INT,
	Socio VARCHAR(100),
	Cuenta VARCHAR(100)
)


	INSERT INTO @tt_cuentas (IdSocio,Socio,Cuenta)
	SELECT c.IdSocio, sc.Codigo + ' - ' + p.Nombre, c.Codigo + ' - ' + c.Descripcion 
	FROM tayccuentas c  WITH(nolock) 
	INNER JOIN tscssocios sc  WITH(nolock) ON sc.idsocio=c.idsocio
	INNER JOIN dbo.tGRLpersonas p  WITH(nolock) ON p.IdPersona = sc.IdPersona
	WHERE c.IdEstatus=1 AND c.IdTipoDProducto IN (143)

/* declare variables */
DECLARE @idSocio INT=0
DECLARE @Socio VARCHAR(50)='';

DECLARE cur_sociosCuentas CURSOR LOCAL FAST_FORWARD READ_ONLY FOR (SELECT tt.IdSocio, tt.Socio FROM @tt_cuentas tt GROUP BY tt.IdSocio, tt.Socio)
OPEN cur_sociosCuentas
FETCH NEXT FROM cur_sociosCuentas INTO @idSocio,@Socio
WHILE @@FETCH_STATUS = 0
BEGIN
    
	DECLARE @msg AS VARCHAR(max)='';

	/* declare variables */
	DECLARE @variable VARCHAR(150);
	DECLARE cur_cuentas CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT cc.Cuenta  FROM @tt_cuentas cc WHERE cc.IdSocio=@idSocio
	OPEN cur_cuentas
	FETCH NEXT FROM cur_cuentas INTO @variable
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @msg=@msg + ' ' + @variable
	
	    FETCH NEXT FROM cur_cuentas INTO @variable
	END
	CLOSE cur_cuentas
	DEALLOCATE cur_cuentas

	PRINT @Socio + ' - ' + @msg

    FETCH NEXT FROM cur_sociosCuentas INTO @idSocio, @Socio
END
CLOSE cur_sociosCuentas
DEALLOCATE cur_sociosCuentas

