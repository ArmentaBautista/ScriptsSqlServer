
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pGRLauxiliarCBCDVentanillaSucursal')
BEGIN
	DROP PROC pGRLauxiliarCBCDVentanillaSucursal
	SELECT 'pGRLauxiliarCBCDVentanillaSucursal BORRADO' AS info
END
GO

CREATE PROCEDURE dbo.pGRLauxiliarCBCDVentanillaSucursal
@SucursalCodigo as varchar(20)=''
AS 
BEGIN
	 DECLARE @Fecha AS DATE='19000101'
	 SET @Fecha=(SELECT FechaTrabajo FROM dbo.vSISsesion)

	 IF (@Fecha='19000101' OR @Fecha IS null)
	 SET @Fecha=GETDATE()

	 DECLARE @IdSaldos AS VARCHAR(max)=''
	 DECLARE @IdSucursal AS INT=ISNULL((SELECT IdSucursal FROM dbo.tCTLsucursales WHERE Codigo=@SucursalCodigo),0)

	 SELECT @IdSaldos = COALESCE(@IdSaldos + ',', '') +CAST(idsaldo  AS VARCHAR(50))
	 fROM dbo.vSDOresumenCuentaABCDVentanilla C
	 WHERE C.IdSucursal=@IdSucursal
	 SET @IdSaldos=SUBSTRING(@IdSaldos,2,LEN(@IdSaldos))

	

	  DECLARE @SQL AS VARCHAR(MAX)='';
	  


		 SET @SQL='SELECT c.CuentaABCDcodigo as Ventanilla
					, FORMAT(ISNULL(x.saldo,0), ''C'') AS Saldo 
					FROM vSDOresumenCuentaABCDVentanilla c
					LEFT JOIN (SELECT t.IdSaldoDestino,
							        t.Saldo,
							        t.Fecha
							 FROM ( SELECT Transaccion.IdSaldoDestino,
							               Transaccion.Saldo,
							               Transaccion.Fecha,
							               Transaccion.IdTransaccion,
							               ROW_NUMBER () OVER ( PARTITION BY Transaccion.IdSaldoDestino
							                                    ORDER BY Transaccion.Fecha DESC,
							                                             Transaccion.IdTransaccion DESC ) AS numero
							        FROM tSDOtransacciones Transaccion WITH ( NOLOCK )
							        WHERE Transaccion.IdEstatus NOT IN (18, 25) 
									AND transaccion.IdSaldoDestino IN( '+@IdSaldos+')
									AND Transaccion.Fecha <= '''+CAST(@Fecha AS VARCHAR(25))+''' AND Transaccion.IdTipoDDominioDestino = 851
									)  AS t
									WHERE t.numero=1
							 ) AS x ON x.IdSaldoDestino=c.IdSaldo 
					WHERE c.IdSucursal='+CAST(@IdSucursal AS VARCHAR(10))+'
					order by c.CuentaABCDcodigo'

		 
            PRINT @SQL;

            EXEC ( @SQL );



end

GO