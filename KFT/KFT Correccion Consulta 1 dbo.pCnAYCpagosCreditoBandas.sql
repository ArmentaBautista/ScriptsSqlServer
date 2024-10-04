
IF EXISTS(SELECT name FROM sys.objects o  WITH(nolock) WHERE name ='pCnAYCpagosCreditoBandas')
BEGIN
	DROP PROC pCnAYCpagosCreditoBandas
END
GO

CREATE PROC [dbo].[pCnAYCpagosCreditoBandas] 
@Usuario AS VARCHAR(25)='*',
@fechaInicio as date='19000101',
@fechaFinal as date='19000101'
AS
BEGIN

/* 
Reporte que  muestre los movimientos  Pago de Crédito por banda realizados por medio de ventanilla.
pCnAYCpagosCreditoBandas
[dbo] indicar el esquema al que pertenece el objeto en la base de datos
*/

	if @fechaFinal='19000101'
			SET @fechaFinal=GETDATE()

	IF @Usuario IS NULL OR @Usuario=''
		SET @Usuario='*'

SELECT --1
   [Código Suc]  = suc.Codigo
  ,[Sucursal]   = suc.Descripcion
  ,[Coodigo Cajero] = u.Usuario
  ,[Cajero] = pu.nombre   
  ,[Ticket]   = o.folio
  ,[Fecha]   = o.fecha
  ,[Monto]   = tf.montosuboperacion
  ,[Producto]   = pf.descripcion 
  ,[Cuenta]   = c.Codigo
  ,[Socio]   = p.Nombre
  ,[Estatus Cartera] = ec.Descripcion
  ,[Dias de Mora]  = tf.DiasMora
  ,CASE WHEN tf.DiasMora = 0 THEN 'SIN MORA' 
        WHEN tf.DiasMora > 0  AND tf.DiasMora <8 THEN '1 A 7' 
        WHEN tf.DiasMora > 7  AND tf.DiasMora <31 THEN '8 A 30'
        WHEN tf.DiasMora > 30 AND tf.DiasMora <61 THEN '31 A 60' 
        WHEN tf.DiasMora > 60 AND tf.DiasMora <91 THEN '61 A 90'
        WHEN tf.DiasMora > 90 AND tf.DiasMora <121 THEN '91 A 120'
        WHEN tf.DiasMora > 120 AND tf.DiasMora <181 THEN '121 O 180'
        WHEN tf.DiasMora > 180  THEN '181-mas'
   END as Banda              
FROM dbo.tGRLoperaciones o WITH(NOLOCK)  
INNER JOIN dbo.tSDOtransaccionesFinancieras tf  WITH(NOLOCK) ON tf.IdOperacion = o.IdOperacion 
															 AND tf.IdTipoSubOperacion=500  
															 AND tf.idestatus = 1
inner join tayccuentas c      WITH(nolock) on c.idcuenta=tf.idcuenta 
												AND c.idtipoDProducto =143
inner join tAYCproductosFinancieros pf   WITH(nolock) on pf.idProductoFinanciero = c.idproductofinanciero
inner join tCTLusuarios u      WITH(nolock) on u.IdUsuario=tf.IdUsuarioAlta 
												   AND (u.Usuario = @Usuario OR @Usuario = '*')
inner join tgrlpersonas pu    with(nolock) on pu.idpersona =u .idpersonafisica
inner join tSCSsocios s       WITH(nolock) on s.IdSocio=c.IdSocio
inner join tGRLpersonas p      WITH(nolock) on p.IdPersona=s.IdPersona
inner join tCTLsucursales suc     WITH(nolock) on suc.IdSucursal=s.IdSucursal
INNER JOIN dbo.tCTLestatus ec     WITH(NOLOCK) ON ec.IdEstatus = c.IdEstatusCartera
WHERE o.idoperacion != 0 and o.IdTipoOperacion=1 and o.idestatus=1
AND tf.Fecha BETWEEN @FechaInicio AND @FechaFinal
ORDER BY suc.IdSucursal, tf.Fecha, u.IdUsuario

END



GO


