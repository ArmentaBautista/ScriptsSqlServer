
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCcolocacion')
BEGIN
	DROP PROC pCnAYCcolocacion
	SELECT 'pCnAYCcolocacion BORRADO' AS info
END
GO

CREATE PROCEDURE pCnAYCcolocacion
@Sucursal varchar(100),
@FechaInicial date,
@FechaFinal date
as	

select col.[Código Sucursal Socio]
     , col.[Sucursal Socio]
     , col.Socio
     , col.Nombre
     , col.Género
     , col.Ocupación
     , col.CURP
     , col.RFC
     , col.Municipio
     , col.Localidad
     , col.[Código Sucursal]
     , col.Sucursal
     , col.Folio
     , col.Cuenta
     , col.Producto
     , col.SubTipo
     , col.[Fecha Otorgamiento]
     , col.[Monto Solicitado]
     , col.[Monto Otorgado]
     , col.Plazo
     , col.[Días por Plazo]
     , col.Vencimiento
     , col.[Tasa Anual]
     , col.Finalidad
     , col.[Finalidad Descripción]
     , col.Clasificación
     , col.[Tabla de Estimación]
     , col.Ejecutivo
     , col.Promotor
     , col.Autorizador
     , col.[Usuario Activó]
     , col.[Estatus Actual]
     , col.[Estatus Período]
     , col.[Ventas Netas]
     , col.[Giro Socio]
     , col.[Ingresos Declarados]
     , col.[Score Circulo de Credito]
     , col.[Empresa Convenio]
     , col.[Correo Electrónico]
     , col.[Es Recompra]
     , col.[Número de Folio de Consulta SIC]
     , col.[Fecha de Consulta SIC]
     , col.EstatusCartera
     , col.[Código Producto Financiero]
     , col.Conteo 
from dbo.fnCnAYCcolocacion(@Sucursal,@FechaInicial,@FechaFinal) col

go

