



 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000000675'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000017 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000002510'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000020 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000001970'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000033 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='16-000175'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000046 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000001877'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000091 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000011820'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000305 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000004266'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000279 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000400334'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006053')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='0-046253'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006066')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000005543'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006079')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000013000'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006082')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000000335'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006095')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='0-051220'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800000253 ')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000400890'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006105')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
 DECLARE @idcuenta INT =0;
SELECT @idcuenta= c.IdCuenta FROM tayccuentas c  WITH(NOLOCK) WHERE c.codigo='24000000516'

IF @idcuenta<>0
BEGIN
	INSERT INTO tAYCcuentasCLABE (IdCuenta,CLABE)
	VALUES (@idcuenta,'646180221800006118')

	SELECT sc.Codigo, per.Nombre, c.Codigo, cc.CLABE FROM tayccuentas c  WITH(NOLOCK) 
	INNER JOIN dbo.tAYCcuentasCLABE cc  WITH(NOLOCK) ON cc.IdCuenta = c.IdCuenta
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) ON sc.IdSocio = c.IdSocio
	INNER JOIN dbo.tGRLpersonas per  WITH(NOLOCK) ON per.IdPersona = sc.IdPersona
	WHERE c.IdCuenta=@idcuenta

	END
GO 
