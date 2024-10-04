
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

select col.[C�digo Sucursal Socio]
     , col.[Sucursal Socio]
     , col.Socio
     , col.Nombre
     , col.G�nero
     , col.Ocupaci�n
     , col.CURP
     , col.RFC
     , col.Municipio
     , col.Localidad
     , col.[C�digo Sucursal]
     , col.Sucursal
     , col.Folio
     , col.Cuenta
     , col.Producto
     , col.SubTipo
     , col.[Fecha Otorgamiento]
     , col.[Monto Solicitado]
     , col.[Monto Otorgado]
     , col.Plazo
     , col.[D�as por Plazo]
     , col.Vencimiento
     , col.[Tasa Anual]
     , col.Finalidad
     , col.[Finalidad Descripci�n]
     , col.Clasificaci�n
     , col.[Tabla de Estimaci�n]
     , col.Ejecutivo
     , col.Promotor
     , col.Autorizador
     , col.[Usuario Activ�]
     , col.[Estatus Actual]
     , col.[Estatus Per�odo]
     , col.[Ventas Netas]
     , col.[Giro Socio]
     , col.[Ingresos Declarados]
     , col.[Score Circulo de Credito]
     , col.[Empresa Convenio]
     , col.[Correo Electr�nico]
     , col.[Es Recompra]
     , col.[N�mero de Folio de Consulta SIC]
     , col.[Fecha de Consulta SIC]
     , col.EstatusCartera
     , col.[C�digo Producto Financiero]
     , col.Conteo 
from dbo.fnCnAYCcolocacion(@Sucursal,@FechaInicial,@FechaFinal) col

go

