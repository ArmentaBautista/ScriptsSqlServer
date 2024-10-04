

IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCmenoresAhorradores')
BEGIN
	DROP PROC pCnAYCmenoresAhorradores
	SELECT 'pCnAYCmenoresAhorradores BORRADO' AS info
END
GO

CREATE PROC pCnAYCmenoresAhorradores
 @Sucursal AS VARCHAR(20)='*',
 @FechaInicial as date='19000101',
 @FechaFinal AS DATE='19000101'
AS

	BEGIN
		DECLARE  @Consulta AS nVARCHAR(MAX)=''
			SET @Consulta='SELECT [Tipo Menor]=tm.Descripcion  ,
			[No.Socio]=soc.Codigo
			,[Menor Ahorrador]= per.Nombre
			,[Fecha de Nacimiento]= pf.FechaNacimiento 
			,[Edad]=DATEDIFF(YEAR,pf.FechaNacimiento,GETDATE())
			,[Fecha Alta Menor] = soc.Alta
			,[Producto]=p.Descripcion
			,[No.cuenta]=cue.Codigo
			,[Saldo capital]=fSaldo.Saldo
			,[No. Socio Tutor]=x.CodigoReferencia
			,[Tutor]=x.Referencia
			,[Es Socio]=x.EsSocio
			,[Fecha Alta Tutor]= CONVERT(DATE,ISNULL(x.FechaAlta,''19000101''),121)
			,[Fecha Baja Tutor]= CONVERT(DATE,ISNULL(x.FechaBaja,''19000101''),121)
			 FROM dbo.tAYCcuentas cue With (nolock)
			 JOIN dbo.tAYCproductosFinancieros p With (nolock) ON cue.IdProductoFinanciero=p.IdProductoFinanciero
			JOIN dbo.tSCSsocios soc With (nolock) ON soc.IdSocio = cue.IdSocio
			JOIN dbo.tCTLtiposD tm With (nolock) ON tm.IdTipoD = soc.IdTipoDmenorAhorrador
			JOIN dbo.tGRLpersonas per With (nolock) ON per.IdPersona = soc.IdPersona
			JOIN dbo.tGRLpersonasFisicas pf With (nolock) ON pf.IdPersona = per.IdPersona
			INNER JOIN dbo.fAYCsaldo(0) fSaldo   ON fSaldo.IdCuenta = cue.IdCuenta
			JOIN dbo.tCTLsucursales suc With (nolock) ON suc.IdSucursal = cue.IdSucursal
			LEFT JOIN (
			SELECT r.RelReferenciasPersonales,perr.IdPersona,perr.Nombre AS Referencia,
			r.EsTutorPrincipal,socr.Codigo AS CodigoReferencia,IIF((socr.IdSocio=0 OR socr.IdSocio IS null),0,1) AS EsSocio,
			socr.FechaAlta,socr.FechaBaja
			 FROM dbo.tSCSpersonasFisicasReferencias r With (nolock)
			 JOIN dbo.tCTLestatusActual ea With (nolock) ON ea.IdEstatusActual = r.IdEstatusActual
			JOIN dbo.tGRLpersonas perr With (nolock) ON perr.IdPersona = r.IdPersona
			LEFT JOIN dbo.tSCSsocios socr With (nolock) ON socr.IdPersona = perr.IdPersona
			WHERE  EsTutorPrincipal=1 AND ea.IdEstatus=1
			) AS x ON x.RelReferenciasPersonales = pf.RelReferenciasPersonales
			WHERE exists (
									select 1 
									from dbo.tCTLempresaProductosFinancierosProcesos tmp 
									where tmp.idproductofinanciero = p.idproductofinanciero
									and tmp.idtipodproductoproceso = 2740
								)

			AND cue.IdEstatus=1'



			
		IF (@Sucursal!='*')
		BEGIN
			DECLARE @IdSucursal AS INT=0
			SET @IdSucursal=ISNULL((SELECT IdSucursal FROM dbo.tCTLsucursales WHERE codigo=@Sucursal ),0)
			SET @Consulta += ' and suc.IdSucursal =' + CAST(@IdSucursal AS VARCHAR(5))
		
		END
		IF (@FechaInicial !='19000101' AND  @FechaFinal !='19000101')
		BEGIN
			
			SET @Consulta +=' and cue.FechaActivacion BETWEEN ''' +CAST(@FechaInicial AS VARCHAR(30))+'''and '''+CAST(@FechaFinal AS VARCHAR(30))+''''
		END

		PRINT @Consulta;

		EXEC sp_executesql @Consulta;
	END



 



GO

