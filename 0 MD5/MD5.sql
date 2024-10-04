

	DECLARE @Socio AS VARCHAR(100)='10801-1234567810'
	DECLARE @Cuenta AS VARCHAR(100)='10803-01268'
	DECLARE @Clave AS VARCHAR(100)='MiClaveUnica'

	EXEC dbo.pOBTmd5SocioCuenta @Socio = @Socio,
	                            @Cuenta = @Cuenta, 
	                            @Clave = @Clave   

	

