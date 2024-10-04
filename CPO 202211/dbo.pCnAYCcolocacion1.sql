SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO



ALTER Proc [dbo].[pCnAYCcolocacion]
@Sucursal VARCHAR(100),
@FechaInicial DATE,
@FechaFinal DATE
AS	

Set Transaction Isolation Level Read Uncommitted; 
Set NoCount On; 

DECLARE @FechaInicio DATE=@FechaInicial,@FechaFin DATE=@FechaFinal,@CodigoSucursal VARCHAR(100)=@Sucursal

SELECT [Código Sucursal Socio] = sucsocio.Codigo,
       sucsocio.Descripcion AS [Sucursal Socio],
       Socio = soc.Codigo,
       Nombre = psn.Nombre,
       CASE WHEN persF.Sexo = 'M' THEN 'MASCULINO'
            ELSE 'FEMENINO'
       END AS [Género],
       [Ocupación] = ocupacion.Descripcion,
       [CURP] = persF.CURP,
       [RFC] = psn.RFC,
       [Municipio] = domicilio.Municipio,
       [Localidad] = IIF(domicilio.Asentamiento = '' OR domicilio.Asentamiento IS NULL, domicilio.Ciudad, domicilio.Asentamiento),
       [Código Sucursal] = suc.Codigo,
       Sucursal = suc.Descripcion,
       [Folio] = ISNULL (aperturas.Folio, 0),
       Cuenta = c.Codigo,
       Producto = pr.Descripcion,
       SubTipo = td.Descripcion,
       [Fecha Otorgamiento] = c.FechaEntrega,
       [Monto Solicitado] = aperturas.MontoSolicitado,
       [Monto Otorgado] = c.MontoEntregado,
       [Plazo] = c.NumeroParcialidades,
       [Días por Plazo] = IIF(c.NumeroParcialidades = 1, DATEDIFF (d, c.FechaEntrega, c.Vencimiento), c.Dias),
       Vencimiento = c.Vencimiento,
       [Tasa Anual] = c.InteresOrdinarioAnual * 100,
       Finalidad = IIF(c.IdFinalidad != 0, fn.Descripcion, c.DescripcionLarga),
       [Finalidad Descripción] = c.DescripcionLarga,
       [Clasificación] = clasificacion.Descripcion,
       [Tabla de Estimación] = estimacion.Descripcion,
       Ejecutivo = ejp.Nombre,
       Promotor = prop.Nombre,
       Autorizador = up.Nombre,
       [Usuario Activó] = uap.Nombre,
       [Estatus Actual] = st.Descripcion,
       [Estatus Período] = esthis.Descripcion,
       [Ventas Netas] = MontoEgresoExtraordinarios,
       [Giro Socio] = InfoAdicionalSocio.Giro,
       [Ingresos Declarados] = InfoAdicionalSocio.IngresosDeclarados,
       [Score Circulo de Credito] = InfoAdicionalSocio.ScoreCirculo,
       [Empresa Convenio] = InfoAdicionalSocio.EmpresaConvenio,
       [Correo Electrónico] = InfoAdicionalSocio.EmailsSocio,
       --,[Es Recompra]=IIF(Recompra.NumCredito=1,'NO','SI'),
       [Es Recompra] = IIF(Recompra.primerEntrega = c.Alta, 'NO', 'SI'),
       EstatusCartera = estatuscartera.Descripcion,
	   [Codigo Sucursal Desembolso] = sucop.codigo,
	   [Sucursal Desembolso] = sucop.Descripcion,
       Conteo = 1,
	   [Es Persona Relacionada]=ISNULL(persF.EsPersonaRelacionada,0),
	   [Tipo]=catalogo.Descripcion

FROM tAYCcuentas c WITH ( NOLOCK )
INNER JOIN dbo.tSDOtransaccionesFinancieras financieras WITH ( NOLOCK ) ON financieras.IdCuenta = c.IdCuenta 
                                                                                                  AND financieras.IdEstatus = 1 
																								  AND financieras.IdTipoSubOperacion = 501
INNER JOIN tCTLtiposD td WITH ( NOLOCK ) ON c.IdTipoDAIC = td.IdTipoD AND c.IdTipoDProducto = 143
INNER JOIN tCTLestatus st WITH ( NOLOCK ) ON c.IdEstatus = st.IdEstatus AND st.IdEstatus IN (1, 7, 53)
INNER JOIN tCTLestatus eEntrega WITH ( NOLOCK ) ON eEntrega.IdEstatus = c.IdEstatusEntrega AND c.IdEstatusEntrega = 20
INNER JOIN tAYCfinalidades fn WITH ( NOLOCK ) ON c.IdFinalidad = fn.IdFinalidad
INNER JOIN tSCSsocios soc WITH ( NOLOCK ) ON c.IdSocio = soc.IdSocio
INNER JOIN tCTLsucursales sucsocio WITH ( NOLOCK ) ON sucsocio.IdSucursal = soc.IdSucursal
INNER JOIN tAYCcuentasEstadisticas ce WITH ( NOLOCK ) ON c.IdCuenta = ce.IdCuenta AND ce.IdApertura = c.IdApertura
INNER JOIN tGRLpersonas psn WITH ( NOLOCK ) ON soc.IdPersona = psn.IdPersona
INNER JOIN tCTLusuarios ej WITH ( NOLOCK ) ON c.IdUsuarioAlta = ej.IdUsuario
INNER JOIN tGRLpersonas ejp WITH ( NOLOCK ) ON ej.IdPersonaFisica = ejp.IdPersona
INNER JOIN tCOMvendedores pro WITH ( NOLOCK ) ON c.IdVendedor = pro.IdVendedor
INNER JOIN tGRLpersonas prop WITH ( NOLOCK ) ON pro.IdPersona = prop.IdPersona
INNER JOIN tCTLusuarios u WITH ( NOLOCK ) ON c.IdUsuarioAutorizo = u.IdUsuario
INNER JOIN tGRLpersonas up WITH ( NOLOCK ) ON u.IdPersonaFisica = up.IdPersona
INNER JOIN tCTLusuarios ua WITH ( NOLOCK ) ON ce.IdUsuarioActivo = ua.IdUsuario
INNER JOIN tGRLpersonas uap WITH ( NOLOCK ) ON ua.IdPersonaFisica = uap.IdPersona
INNER JOIN tCTLsucursales suc WITH ( NOLOCK ) ON c.IdSucursal = suc.IdSucursal
INNER JOIN tAYCproductosFinancieros pr WITH ( NOLOCK ) ON c.IdProductoFinanciero = pr.IdProductoFinanciero
INNER JOIN dbo.tCTLperiodos per WITH ( NOLOCK ) ON c.FechaActivacion BETWEEN per.Inicio AND per.Fin AND per.EsAjuste = 0
INNER JOIN (
           --SELECT cuentas.IdSocio,COUNT(cuentas.IdCuenta) AS NumCredito
           SELECT cuentas.IdSocio,
                  MIN (cuentas.Alta) primerEntrega,
                  COUNT (cuentas.IdCuenta) AS NumCredito --,cuentas.Alta
           FROM dbo.tAYCcuentas cuentas WITH ( NOLOCK )
           WHERE cuentas.IdTipoDProducto = 143
           GROUP BY cuentas.IdSocio ) Recompra ON Recompra.IdSocio = soc.IdSocio
LEFT JOIN dbo.tAYCaperturas aperturas WITH ( NOLOCK ) ON aperturas.IdApertura = c.IdApertura
LEFT JOIN dbo.tSDOhistorialDeudoras h WITH ( NOLOCK ) ON h.IdCuenta = c.IdCuenta AND per.IdPeriodo = h.IdPeriodo
LEFT JOIN dbo.tCTLestatus esthis WITH ( NOLOCK ) ON esthis.IdEstatus = h.IdEstatus
LEFT JOIN ( SELECT labSocio.Giro,
                   IngresosDeclarados = CAST(ISNULL (socPerSocio.IngresosOrdinarios, 0) + ISNULL (socPerSocio.IngresosExtraordinarios, 0) AS NUMERIC(18, 6)),
                   cueEstSocio.ClavePrevencionSIC,
                   ScoreCirculo = cue.CalificacionSIC, --scoreSocio.ScoreFinalFV
                   EmpresaConvenio = perEmpresas.Nombre,
                   EmailsSocio = emails.Emails,
                   cue.IdSocio,
                   cue.IdCuenta
            FROM dbo.tAYCcuentas cue WITH ( NOLOCK )
            INNER JOIN dbo.tSCSsocios soc WITH ( NOLOCK ) ON soc.IdSocio = cue.IdSocio AND cue.IdTipoDProducto = 143 AND cue.IdEstatus IN (1, 53, 73)
            INNER JOIN dbo.tGRLpersonas persocio WITH ( NOLOCK ) ON persocio.IdPersona = soc.IdPersona AND soc.EsSocioValido = 1 AND soc.IdEstatus = 1
            INNER JOIN dbo.tAYCcuentasEstadisticas cueEstSocio WITH ( NOLOCK ) ON cueEstSocio.IdCuenta = cue.IdCuenta AND cueEstSocio.IdApertura = cue.IdApertura
            LEFT JOIN dbo.vCATEmailsAgrupados emails ON emails.IdRel = persocio.IdRelEmails
            LEFT JOIN dbo.tCTLlaborales labSocio WITH ( NOLOCK ) ON labSocio.IdPersona = persocio.IdPersona
            LEFT JOIN dbo.tSCSpersonasSocioeconomicos socPerSocio WITH ( NOLOCK ) ON socPerSocio.IdSocioeconomico = persocio.IdSocioeconomico
            LEFT JOIN dbo.tSCSconveniosCreditosEmpresas conEmpresas WITH ( NOLOCK ) ON conEmpresas.IdConvenioCreditoEmpresa = cueEstSocio.IdConvenioCreditoEmpresa
            LEFT JOIN dbo.tGRLpersonas perEmpresas WITH ( NOLOCK ) ON perEmpresas.IdPersona = conEmpresas.IdPersona
--LEFT JOIN dbo.tmpTscoreCredito scoreSocio WITH(nolock) ON scoreSocio.IdSocio = soc.IdSocio
) InfoAdicionalSocio ON InfoAdicionalSocio.IdCuenta = c.IdCuenta AND InfoAdicionalSocio.IdSocio = soc.IdSocio
LEFT JOIN dbo.tGRLpersonasFisicas persF WITH ( NOLOCK ) ON persF.IdPersona = psn.IdPersona
LEFT JOIN dbo.tCATlistasD ocupacion WITH ( NOLOCK ) ON ocupacion.IdListaD = persF.IdListaDOcupacion
LEFT JOIN dbo.tCTLestatusActual estatusOcupacion WITH ( NOLOCK ) ON estatusOcupacion.IdEstatusActual = ocupacion.IdEstatusActual AND estatusOcupacion.IdEstatus = 1
--LEFT JOIN dbo.tCATdomicilios		domicilio    WITH (NOLOCK) ON domicilio.IdRel =psn.IdRelDomicilios AND domicilio.IdTipoD = 11
--INNER JOIN dbo.tCTLestatusActual    estatusDom   WITH (NOLOCK) ON estatusDom.IdEstatusActual = domicilio.IdEstatusActual AND estatusDom.IdEstatus=1
LEFT JOIN dbo.vCTLDomiciliosPrincipales domicilio WITH(NOLOCK) ON domicilio.IdRel = psn.IdRelDomicilios
LEFT JOIN ( SELECT crediticio.IdApertura,
                   SUM (ISNULL (analisis.Monto, 0)) AS MontoEgresoExtraordinarios
            FROM dbo.tAYCanalisisIngresosEgresos analisis WITH ( NOLOCK )
            JOIN dbo.tCTLtiposD tipo WITH ( NOLOCK ) ON tipo.IdTipoD = analisis.IdTipoDIngresoEgreso
            JOIN tAYCanalisisCrediticio crediticio WITH ( NOLOCK ) ON crediticio.IdAnalisisCrediticio = analisis.RelAnalisisIngresosEgresos
            WHERE analisis.IdTipoDIngresoEgreso IN (2551, 2549, 2550, 2548)
            GROUP BY crediticio.IdApertura ) Ventas ON Ventas.IdApertura = aperturas.IdApertura
LEFT JOIN dbo.tCTLtiposD clasificacion WITH ( NOLOCK ) ON clasificacion.IdTipoD = c.IdTipoDAIC
LEFT JOIN dbo.tCTLtiposD estimacion WITH ( NOLOCK ) ON estimacion.IdTipoD = c.IdTipoDTablaEstimacion
LEFT JOIN dbo.tCTLestatus estatuscartera WITH ( NOLOCK ) ON estatuscartera.IdEstatus = c.IdEstatusCartera
LEFT JOIN dbo.tGRLoperaciones op  WITH(NOLOCK) ON op.IdOperacion = financieras.IdOperacion
LEFT JOIN dbo.tCTLsucursales sucop  WITH(NOLOCK) ON sucop.IdSucursal=op.IdSucursal
LEFT JOIN dbo.tSITcatalogos catalogo WITH (NOLOCK) ON catalogo.IdCatalogoSITI = persF.IdCatalogoSITIpersonaRelacionada
WHERE  (@CodigoSucursal = '*'OR [Suc].Codigo = @CodigoSucursal)
       AND (c.FechaEntrega BETWEEN @FechaInicio AND @FechaFin)
	   
GO

