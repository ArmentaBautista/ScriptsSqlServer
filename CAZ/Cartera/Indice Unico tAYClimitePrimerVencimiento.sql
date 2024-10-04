

if exists(select 1 
			from sys.indexes i
			where name ='UQ_tAYClimitePrimerVencimiento')
begin
	drop index UQ_tAYClimitePrimerVencimiento on dbo.tAYClimitePrimerVencimiento
	print 'Índice Único UQ_tAYClimitePrimerVencimiento BORRADO'
end
go

create unique index UQ_tAYClimitePrimerVencimiento 
	on dbo.tAYClimitePrimerVencimiento (IdProductoFinanciero,IdTipoDPlazo,IdEstatus,IdTipoDmodalidad)
go

print 'Índice Único UQ_tAYClimitePrimerVencimiento CREADO'




