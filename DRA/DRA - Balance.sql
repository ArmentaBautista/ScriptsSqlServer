
-- SELECT * FROM dbo.tCTLejercicios e WHERE e.Codigo='2021'


 SELECT "tCTLperiodos"."Codigo", "tCNTcuentas"."Codigo", "tCNTacumuladosContables"."SaldoFinal",
 "tCTLperiodos"."Descripcion", "tCNTcuentas"."IdCuentaContable", "tCNTacumuladosContables"."IdSucursal",
 "tCTLsucursales"."Descripcion", "tCTLperiodos"."Fin"
 FROM   (("iERP_DRA"."dbo"."tCNTacumuladosContables" "tCNTacumuladosContables" 
 INNER JOIN "iERP_DRA"."dbo"."tCNTcuentas" "tCNTcuentas" ON "tCNTacumuladosContables"."IdCuentaContable"="tCNTcuentas"."IdCuentaContable") 
 INNER JOIN "iERP_DRA"."dbo"."tCTLperiodos" "tCTLperiodos" ON "tCNTacumuladosContables"."IdPeriodo"="tCTLperiodos"."IdPeriodo") 
 INNER JOIN "iERP_DRA"."dbo"."tCTLsucursales" "tCTLsucursales" ON "tCNTacumuladosContables"."IdSucursal"="tCTLsucursales"."IdSucursal"
-- WHERE  "tCTLperiodos"."Codigo"='2022-01'
 WHERE  tCTLperiodos.IdEjercicio IN (2020,2021,2022)
 AND tCTLperiodos.Codigo NOT IN ('2022-09','2022-10','2022-11','2022-12','2022-13')
 ORDER BY  tCTLperiodos.IdEjercicio ASC, tCTLperiodos.IdPeriodo ASC,tCNTacumuladosContables.IdSucursal ASC, tCNTcuentas.Codigo ASC


