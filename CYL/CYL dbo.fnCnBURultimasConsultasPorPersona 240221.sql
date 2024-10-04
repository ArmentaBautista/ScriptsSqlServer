

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='fnCnBURultimasConsultasPorPersona')
BEGIN
	DROP function dbo.fnCnBURultimasConsultasPorPersona
	select 'fnCnBURultimasConsultasPorPersona BORRADO' as info
end
go

create function dbo.fnCnBURultimasConsultasPorPersona()
returns @UltimasConsultasPersonas table(
	IdPersona					int,
	IdCalificacionClasificacion	int,
	Clasificacion				varchar(5),
	FechaConsultaBuroCredito	datetime
)
as
begin

			declare @Ultimas table(
				IdPersona					int,
				IdCalificacionClasificacion	int
			)

			insert into @ultimas
			select 
			 b.Idpersona
			,max(b.IdCalificacionClasificacion)
			from dbo.tBURcalificacionClasificacion b WITH(NOLOCK)
			where b.Idpersona>0
			group by b.Idpersona

			insert into @UltimasConsultasPersonas
			select 
			 u.IdPersona
			,u.IdCalificacionClasificacion
			,c.Clasificacion
			,c.FechaConsultaBuroCredito
			from @Ultimas u 
			INNER JOIN dbo.tBURcalificacionClasificacion c  WITH(NOLOCK) 
				on c.IdCalificacionClasificacion = u.IdCalificacionClasificacion

		return;
end
go
