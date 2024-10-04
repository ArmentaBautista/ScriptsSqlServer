
use jcDB
go

if exists(select 1 from sys.objects o where name ='tSaldoPrestamos')
BEGIN
    drop table dbo.tSaldoPrestamos
end

if not exists(select 1 from sys.objects o where name ='tSaldoPrestamos')
begin
	create table tSaldoPrestamos(
		Id			int primary key identity,
		Persona		varchar(64),
		Saldo		float
	)

	insert into dbo.tSaldoPrestamos(Persona, Saldo) values ('Alfonso Ramirez',45897.68)
	insert into dbo.tSaldoPrestamos(Persona, Saldo) values ('Diana Ramirez',90784.97)
	insert into dbo.tSaldoPrestamos(Persona, Saldo) values ('Alicia Bautista',3784.55)
	insert into dbo.tSaldoPrestamos(Persona, Saldo) values ('Alfonso Hernandez',8444.55)

end


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pSaldosPrestamos')
BEGIN
	DROP PROC pSaldosPrestamos
	SELECT 'pSaldosPrestamos BORRADO' AS info
END
GO

CREATE PROC pSaldosPrestamos
AS
BEGIN
	select sp.id,sp.Persona,sp.Saldo 
	from dbo.tSaldoPrestamos sp  WITH(NOLOCK) 
END
go

exec dbo.pSaldosPrestamos

exec dbo.pSaldosPrestamos
with result sets
(
	(
		Identificador Int,
		Acreditado varchar(64),
		Saldo numeric(13,2)
	)
)


exec dbo.pSaldosPrestamos
with result sets
(
	(
		Identificador Int,
		Acreditado varchar(64),
		Saldo int
	)
)


