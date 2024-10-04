
select sc.Codigo as NoSocio, p.Nombre
, suc.Descripcion as Sucursal
, cadol.Codigo as NoCuenta, cadol.Descripcion AS CtaDescripcion, cadol.SaldoCapital
, cmenor.Codigo AS NoCuentaMenor, cmenor.Descripcion AS CtaMenorDescripcion
, TfErp.UltMov AS UltMovMenor
from tAYCcuentas cadol with(nolock)
inner join tCTLsucursales suc with(nolock) on suc.IdSucursal=cadol.IdSucursal
inner join tSCSsocios sc with(nolock) on sc.IdSocio=cadol.IdSocio
inner join tGRLpersonas p with(nolock) on p.IdPersona=sc.IdPersona
left join tAYCcuentas cmenor with(nolock) on cmenor.IdSocio=sc.IdSocio AND cmenor.IdProductoFinanciero IN (5,6)
LEFT JOIN (
			SELECT tf.IdCuenta, MAX(tf.Fecha) AS UltMov 
			FROM dbo.tSDOtransaccionesFinancieras tf WITH(NOLOCK)
			left join tGRLoperaciones op with(nolock) on op.IdOperacion=tf.IdOperacion --and op.IdTipoOperacion in (1,10)
			INNER JOIN dbo.tAYCcuentas c  WITH(nolock) ON c.IdCuenta=tf.IdCuenta 
														AND c.IdProductoFinanciero IN (5,6) -- menores
														AND c.IdEstatus!=1
														--AND c.Codigo='27000006451'
			WHERE tf.IdTipoSubOperacion IN (500,501) AND tf.IdUsuarioAlta!=-1 and op.IdTipoOperacion  != 4
			GROUP BY tf.IdCuenta
			) AS TfErp ON TfErp.IdCuenta = cmenor.IdCuenta
where cadol.idestatus=1 and cadol.IdDivision=-25
order by UltMovMenor


