IF EXISTS(SELECT name FROM sys.tables t WHERE t.name='tCTLmensajesBorrados')
BEGIN
	SELECT 'ya existe la tabla tCTLmensajesBorrados'  AS Info
	GOTO SALIR;
END


CREATE TABLE [dbo].[tCTLmensajesBorrados]
(
	[IdMensaje] [int],
	[Mensaje] [nvarchar] (max),
	[IdTipoDmensaje] [INT], 
	[IdTipoDinstruccion] [INT],
	[IdTipoDdespliegue] [int] ,
	[UsuarioEmisor] [int] ,
	[UsuarioReceptor] [int] ,
	[IdTipoDdominio] [int] ,
	[IdDominio] [int] ,
	[UsaVigencia] [bit] ,
	[InicioVigencia] [datetime] ,
	[FinVigencia] [DATETIME], 
	[IdEstatus] [int] ,
	[Alta] [datetime] ,
	[UsuarioBaja] [int] ,
	[Baja] [datetime] ,
	[NotaBaja] [nvarchar] (max) ,
	[IdTipoDalerta] [int] ,
	[Agrupador] [varchar] (256) ,
	[Referencia] [varchar] (256) ,
	[Concepto] [varchar] (256)
)


SELECT 'Tabla tCTLmensajesBorrados creada' AS Info

SALIR: