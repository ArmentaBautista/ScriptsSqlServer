
IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pCnAYCsolitudCredito')
BEGIN
	DROP PROC pCnAYCsolitudCredito
	SELECT 'pCnAYCsolitudCredito BORRADO' AS info
END
GO

CREATE PROC pCnAYCsolitudCredito
    @FechaInicial AS DATE = '19000101' ,
    @FechaFinal AS DATE = '19000101' 
AS
BEGIN

   
		IF (@FechaInicial='19000101' OR @FechaFinal='19000101')
		BEGIN
			SELECT 'Debe introducir un rando de fechas válidas'
			RETURN 0
		END

		
			
	SELECT [Folio] = apertura.Folio,
       [Número Socio] = socio.Codigo,
       [Nombre] = per.Nombre,
       [Código sucursal] = suc.Codigo,
       [Sucursal] = suc.Descripcion,
       [Producto] = pf.Descripcion,
       [Fecha Alta] = cuenta.FechaAlta,
       [Monto Solicitado] = cuenta.MontoSolicitado,
       [Clasificación] = tipoaic.Descripcion,
       [División] = division.Descripcion,
       [Finalidad] = finalidad.Descripcion,
       [Sub Finalidad 1] = fin1.Descripcion,
       [Sub Finalidad 2] = fin2.Descripcion,
       [N° Cuenta] = cuenta.Codigo,
       [Fecha Entrega (Programado)] = cuenta.FechaEntrega,
	   [Fecha Desembolso] = ce.FechaEntregada,
       [Monto Autorizado] = cuenta.Monto,
       [Dirección] = per.Domicilio,
       [Escolaridad] = escolaridad.Descripcion,
       [Actividad] = laboral.Actividad,
       [Estatus Civil] = esdocivil.Descripcion,
       [Nombre Cónyuge] = conyugue.NombreConyugue,
       [Fecha Nacimiento Cónyuge] = conyugue.FechaNacimientoConyugue,
       [Teléfono Cónyuge] = conyugue.TelefonoConyugue,
       [Tipo Vivienda] = ingresos.Residencia,
       [N° Dependientes] = dp.numero,
       [Valor] = ingresos.Vehiculos + ingresos.MueblesEnseresMaquinariaOtros + ingresos.Terrenos + ingresos.Vivienda,
       [Ingresos] = ingresos.Ingresos,
       [Nombre Aval1] = aval1.Nombre,
       [Domicilio Aval1] = aval1.Domicilio,
       [Escolaridad Aval1] = aval1.Escolaridad,
       [Estado Civil Aval1] = aval1.EstadoCivil,
       [Nombre Aval2] = aval2.Nombre,
       [Domicilio Aval2] = aval2.Domicilio,
       [Escolaridad Aval2] = aval2.Escolaridad,
       [Estado Civil Aval2] = aval2.EstadoCivil,
       [Nombre Aval3] = aval3.Nombre,
       [Domicilio Aval3] = aval3.Domicilio,
       [Escolaridad Aval3] = aval3.Escolaridad,
       [Estado Civil Aval3] = aval3.EstadoCivil
FROM dbo.tAYCcuentas cuenta WITH (NOLOCK)
    INNER JOIN dbo.tAYCcuentasEstadisticas ce WITH (NOLOCK)
        ON ce.IdCuenta = cuenta.IdCuenta
    JOIN dbo.tAYCaperturas apertura WITH (NOLOCK)
        ON apertura.IdApertura = cuenta.IdApertura
    JOIN dbo.tSCSsocios socio WITH (NOLOCK)
        ON socio.IdSocio = cuenta.IdSocio
    JOIN dbo.tGRLpersonas per WITH (NOLOCK)
        ON per.IdPersona = socio.IdPersona
    JOIN dbo.tCTLsucursales suc WITH (NOLOCK)
        ON suc.IdSucursal = cuenta.IdSucursal
    JOIN dbo.tAYCproductosFinancieros pf WITH (NOLOCK)
        ON pf.IdProductoFinanciero = cuenta.IdProductoFinanciero
    JOIN dbo.tCTLtiposD tipoaic WITH (NOLOCK)
        ON tipoaic.IdTipoD = cuenta.IdTipoDAIC
    JOIN dbo.tCNTdivisiones division WITH (NOLOCK)
        ON division.IdDivision = cuenta.IdDivision
    JOIN dbo.tAYCfinalidades finalidad WITH (NOLOCK)
        ON finalidad.IdFinalidad = cuenta.IdFinalidad
    JOIN dbo.tAYCSubFinalidades1 fin1 WITH (NOLOCK)
        ON fin1.IdSubFinalidad1 = cuenta.IdSubFinalidad1
    JOIN dbo.tAYCSubFinalidades2 fin2 WITH (NOLOCK)
        ON fin2.IdSubFinalidad2 = cuenta.IdSubFinalidad2
    LEFT JOIN dbo.tGRLpersonasFisicas perfis WITH (NOLOCK)
        ON perfis.IdPersonaFisica = per.IdPersonaFisica
    LEFT JOIN dbo.tCATlistasD escolaridad WITH (NOLOCK)
        ON escolaridad.IdListaD = perfis.IdListaDEscolaridad
    LEFT JOIN dbo.tCTLtiposD esdocivil WITH (NOLOCK)
        ON esdocivil.IdTipoD = perfis.IdTipoDEstadoCivil
    LEFT JOIN vAYCdatosConyugue conyugue WITH (NOLOCK)
        ON conyugue.RelReferenciasPersonales = perfis.RelReferenciasPersonales
    LEFT JOIN
    (
        SELECT analisis.IdApertura,
               analisis.RelAnalisisCrediticio,
               Vehiculos,
               MueblesEnseresMaquinariaOtros,
               Terrenos,
               Vivienda,
               vivienda.Descripcion AS Residencia,
               (ingreso.Monto + ingreso1.Monto) AS Ingresos
        FROM dbo.tAYCanalisisCrediticio analisis WITH (NOLOCK)
            JOIN dbo.tCTLtiposD vivienda WITH (NOLOCK)
                ON vivienda.IdTipoD = analisis.IdTipoDResidencia
            JOIN dbo.tAYCanalisisIngresosEgresos ingreso WITH (NOLOCK)
                ON ingreso.RelAnalisisIngresosEgresos = analisis.RelAnalisisIngresosEgresos
                   AND ingreso.IdTipoDIngresoEgreso = 2548
            JOIN dbo.tAYCanalisisIngresosEgresos ingreso1 WITH (NOLOCK)
                ON ingreso1.RelAnalisisIngresosEgresos = analisis.RelAnalisisIngresosEgresos
                   AND ingreso1.IdTipoDIngresoEgreso = 2549
    ) AS ingresos
        ON ingresos.IdApertura = apertura.IdApertura
           AND ingresos.RelAnalisisCrediticio = cuenta.IdCuenta
    LEFT JOIN
    (
        SELECT lab.IdPersona,
               tact.Descripcion AS Actividad
        FROM dbo.tCTLlaborales lab WITH (NOLOCK)
            JOIN dbo.tCTLestatusActual ea WITH (NOLOCK)
                ON ea.IdEstatusActual = lab.IdEstatusActual
                   AND ea.IdEstatus = 1
            JOIN dbo.tCATlistasD tact WITH (NOLOCK)
                ON tact.IdListaD = lab.IdListaDactividadEmpresa
    ) AS laboral
        ON laboral.IdPersona = per.IdPersona
    LEFT JOIN dbo.vAYCaval1 aval1 WITH (NOLOCK)
        ON aval1.RelAvales = cuenta.RelAvales
    LEFT JOIN dbo.vAYCaval2 aval2 WITH (NOLOCK)
        ON aval2.RelAvales = cuenta.RelAvales
    LEFT JOIN dbo.vAYCaval3 aval3 WITH (NOLOCK)
        ON aval3.RelAvales = cuenta.RelAvales
    LEFT JOIN vAYCdependientesEconomicos dp WITH (NOLOCK)
        ON dp.RelReferenciasPersonales = perfis.RelReferenciasPersonales
	WHERE cuenta.IdTipoDProducto = 143
		AND cuenta.FechaAlta BETWEEN @FechaInicial AND @FechaFinal;

       
        
   END
GO

