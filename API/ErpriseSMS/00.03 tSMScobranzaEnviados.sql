-- 03 tSMScobranzaEnviados


if not exists(select name from sys.tables where name='tSMScobranzaEnviados')
begin
	create table [dbo].tSMScobranzaEnviados
	(
		Id						bigint primary key identity,
		Fecha 					date default getdate(),
		Telefono				varchar(20),
		Respuesta				nvarchar(max),
		IdCuenta				int foreign key references dbo.tAYCcuentas (IdCuenta),
		Mensaje					varchar(max),
		Alta					DATETIME DEFAULT GETDATE()
		)
		
		SELECT 'Tabla tSMScobranzaEnviados Creada' AS info
END
ELSE 
	-- DROP TABLE tSMScobranzaEnviados
	SELECT 'tSMScobranzaEnviados Existe'
GO


