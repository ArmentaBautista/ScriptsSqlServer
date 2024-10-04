
/********  JCA.19/3/2024.10:38 Info:Borrado y creación de la tabla de límites de primer vencimiento, para agregar Identity  ********/
BEGIN TRY
	BEGIN TRANSACTION;
   
   declare @tmp as table(
		IdTipoDmodalidad			int,
		IdProductoFinanciero		int,
		IdTipoDPlazo				int,
		DiasMaximoPrimerVencimiento int,
		IdUsuarioAlta				int,
		Alta						datetime,
		IdSesion					int,
		IdEstatus					int
   )

   insert into @tmp
   (
       IdTipoDmodalidad			
     , IdProductoFinanciero		
     , IdTipoDPlazo				
     , DiasMaximoPrimerVencimiento 
     , IdUsuarioAlta				
     , Alta						
     , IdSesion					
     , IdEstatus					
   )
   select  
    IdTipoDmodalidad			
   ,IdProductoFinanciero		
   ,IdTipoDPlazo				
   ,DiasMaximoPrimerVencimiento 
   ,IdUsuarioAlta				
   ,Alta						
   ,IdSesion					
   ,IdEstatus					
   from dbo.tAYClimitePrimerVencimiento

	drop table dbo.tAYClimitePrimerVencimiento;
	
	create table dbo.tAYClimitePrimerVencimiento(
		Id							int primary key identity,
		IdTipoDmodalidad			int foreign key references dbo.tCTLtiposD(IdTipoD),
		IdProductoFinanciero		int foreign key references dbo.tAYCproductosFinancieros(IdProductoFinanciero),
		IdTipoDPlazo				int foreign key references dbo.tCTLtiposD(IdTipoD),
		DiasMaximoPrimerVencimiento int,
		IdUsuarioAlta				int foreign key references dbo.tCTLusuarios(IdUsuario),
		Alta						datetime default getdate(),
		IdSesion					int,
		IdEstatus					int
	);
	
	insert into dbo.tAYClimitePrimerVencimiento 
	(
		  IdTipoDmodalidad			
		, IdProductoFinanciero		
		, IdTipoDPlazo				
		, DiasMaximoPrimerVencimiento 
		, IdUsuarioAlta				
		, Alta						
		, IdSesion					
		, IdEstatus					
	)
	select 
	  IdTipoDmodalidad			
	, IdProductoFinanciero		
	, IdTipoDPlazo				
	, DiasMaximoPrimerVencimiento 
	, IdUsuarioAlta				
	, Alta						
	, IdSesion					
	, IdEstatus					
	from @tmp

	COMMIT TRANSACTION;		

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;
	
	 SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;	
END CATCH;
go

