
DECLARE @FechaInicial AS DATE = '2024-03-01'
DECLARE @fechaFinal AS DATE = '2024-03-31'  
DECLARE @IdSocio AS INT = 0              
DECLARE @Fecha AS DATE = '2024-04-04'       
DECLARE @IdEmpresa AS INT= 1            
DECLARE @IdPeriodo AS INT= 315                


	SELECT
		 --[TIPO DE REPORTE]=2--1	
		 --,[PERIODO DEL REPORTE]=(CONVERT(VARCHAR(10), o.Alta, 112))--2
		 [IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
		 [FOLIO]=SUBSTRING(LEFT (REPLACE(STR(DENSE_RANK()OVER (ORDER BY o.IdOperacion ), 6), ' ', '0'), 6),1,6)	--3
		--,[ÓRGANO SUPERVISOR]='001002'--4
		,[CLAVE DEL SUJETO OBLIGADO]='001002'---5
		,[LOCALIDAD]=LEFT (REPLACE(str( lb.Clave , 8), ' ', '0'), 8)---6
		,[SUCURSAL]=   LEFT (REPLACE(str( SUBSTRING(suc.CodigoSucursalPLD,1,8) , 8), ' ', '0'), 8)--SUBSTRING(suc.Codigo,1,8)---7
		, t.IdTipoSubOperacion
		, tf.IdTipoSubOperacion
		,[Monto] = IIF(td.Monto=0,o.MontoReferencia,td.Monto), td.Monto, o.MontoReferencia
		,[TIPO DE OPERACION]=CASE 
								  WHEN t.IdTipoSubOperacion IN (500,511) THEN '01'
								  WHEN t.IdTipoSubOperacion=501 THEN '02' 
								  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=500 AND cta.IdTipoDProducto=143 THEN '09'
								  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=501 AND cta.IdTipoDProducto=143 THEN '08'
								  ELSE
		                          '01'
								  END ---8
		,[INSTRUMENTO MONETARIO]='01'---9
		,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERO DE SEGURIDAD SOCIAL]= ISNULL(REPLACE(cta.Codigo,'-',''),REPLACE(sociooperacion.Codigo,'-',''))---10
		,[MONTO]=IIF(CAST(td.Monto AS NUMERIC(16,2))=0,CAST(o.MontoReferencia AS NUMERIC(16,2)),0)   ---11
		,[MONEDA]=CASE T.IdDivisa
						WHEN 1 THEN '1'
						WHEN 2 THEN '2' ELSE '1'END--12
		,[FECHA DE LA OPERACION]= dbo.[fSITformatoFecha](IIF(ope.fecha IS NULL ,o.alta, OPE.Fecha))---13
		,[FECHA DE DETECCIÓN DE LA OPERACIÓN ]=dbo.[fSITformatoFecha]( o.Alta)---CAMPO OBLIGATORIO SOLO PARA OPERACIONES INUSUALUES Y PREOCUPANTES--14
		,[NACIONALIDAD]=CASE per.EsExtranjero
							WHEN 0 THEN 'MX'
							WHEN 1 THEN '0'
							ELSE '0'                            
							END---15
		,[TIPO DE PERSONA]=IIF(per.EsPersonaMoral=1,2,1)--16
		,[RAZÓN SOCIAL O DENOMINACIÓN]=IIF (PER.EsPersonaMoral=1,SUBSTRING(PER.Nombre,1,60),'')---17
		,[NOMBRE]=dbo.LimpiarCaracteres(IIF (PER.EsPersonaMoral=1,ISNULL(per.nombre,''), ISNULL(SUBSTRING(PF.Nombre,1,60),'')))--18
		,[APELLIDO PATERNO]=dbo.LimpiarCaracteres(IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60)))--19
		,[APELLIDO MATERNO]=dbo.LimpiarCaracteres(IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoMaterno,1,60)))--20
		,[RFC]=SUBSTRING(ISNULL (REPLACE(per.RFC,'XXX',''),''),1,13)--21
		,[CURP]=SUBSTRING(ISNULL(PF.CURP,''),1,18)--22
		,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=dbo.[fSITformatoFecha](IIF(PER.EsPersonaMoral=1,PM.FechaConstitucion,PF.FechaNacimiento))---23
		-- TRUNCAMOS EL DOMICILIO
		,[DOMICILIO]=dbo.LimpiarCaracteres(SUBSTRING(ISNULL(domiciliopersona.domicilioPersona,''),1,60))--24
		,[COLONIA]=dbo.LimpiarCaracteres(ISNULL(SUBSTRING(dr.Asentamiento,1,30),''))--25
		,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str( dr.ClaveLocalidad , 8), ' ', '0'), 8)---26
		,[TELEFONO]=SUBSTRING(ISNULL(IIF(per.IdRelTelefonos=0,'',(SELECT vcg.Telefono FROM vPLDtelefonoSocio vcg WHERE vcg.IdRel=per.IdRelTelefonos )),''), 1,40)---27
		,[ACTIVIDAD ECONOMICA]=LEFT (REPLACE(str( ISNULL(aec.clave,'0') , 7), ' ', '0'), 7)---28----FALTA LA CLAVE SEGUN EL CATALOGO CORRESPONDIENTE
		,[AGENTE O APODERADO DE SEGUROS Y/O FIANZAS**]=''--29
		,[APELLIDO PATERNO**]='xxxx'---30
		,[APELLIDO MATERNO**]=''--31
		,[RFC**]=''---32
		,[CURP**]=''--33
		,[CONSECUTIVO DE CUENTAS Y/O PERSONAS RELACIONADAS*]=''--34 de la columna 34 a la 41 no aplican para operaciones reelevantes
		,[NUMERO DE CUENTA, CONTRATO, OPERACIÓN, POLIZA O NÚMERO DE SEGURIDAD SOCIAL*]=''--35
		,[CLAVE DEL SUJETO OBLIGADO]=''--36
		,[NOMBRE DEL TITULAR DE LA CUENTA O DE LA PERSONA RELACIONADA*]=''--37
		,[APELLIDO PATERNO*]='xxxx'---38
		,[APELLIDO MATERNO*]=''---39
		,[DESCRIPCIÓN DE LA OPERACIÓN]=
		CONCAT('Sin Prioridad','//',IIF(pf.EsEmpleado=1,'Empleado',IIF(per.EsSocio=1,'Cliente','')),'//',
		tact.Descripcion,'//',CONCAT(nacionalidad.Descripcion,'//',pais.Descripcion,'//'
		,' ',tproducto.Descripcion,'//','',cta.FechaAlta,'//',' ',saldo.Saldo))
		--i.Descripcion--40
		,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=''---41
		
		FROM dbo.tPLDoperaciones o (NOLOCK)
		JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
		JOIN dbo.tCTLsesiones ses (NOLOCK)ON ses.IdSesion=o.IdSesion
		LEFT JOIN dbo.tSCSsocios sociooperacion WITH(NOLOCK)ON sociooperacion.IdSocio = o.IdSocio
		LEFT JOIN dbo.tGRLoperaciones ope (NOLOCK)ON ope.IdOperacion=o.IdOperacionOrigen AND o.IdOperacionOrigen!=0
		LEFT JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=IIF(ope.IdOperacion IS NULL,sociooperacion.IdSucursal ,ope.IdSucursal)
		LEFT JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
		LEFT JOIN dbo.tCTLmunicipios mun (NOLOCK)ON mun.IdMunicipio = dom.IdMunicipio
		LEFT JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
		LEFT JOIN dbo.tSDOtransaccionesD td (NOLOCK)ON td.IdTransaccionD=o.IdTransaccionD
		LEFT JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=ope.IdOperacion AND td.RelTransaccion=t.IdTransaccion
		LEFT JOIN (SELECT x.IdOperacion,x.IdCuenta,x.IdTipoSubOperacion,
			ROW_NUMBER()OVER(PARTITION BY x.IdOperacion ORDER BY x.MontoSubOperacion DESC) AS Numero
			FROM dbo.tSDOtransaccionesFinancieras x WITH (NOLOCK) ) AS tf ON tf.IdOperacion=ope.IdOperacion AND tf.numero=1
			
		LEFT JOIN dbo.tAYCcuentas cta (NOLOCK)ON cta.IdCuenta=tf.IdCuenta
		LEFT JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=cta.IdSocio
		LEFT JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=IIF(o.IdPersona=0,soc.IdPersona,o.IdPersona)
		LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersonaFisica=per.IdPersonaFisica
		LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersonaMoral = per.IdPersonaMoral
		LEFT JOIN dbo.vPLDdomiciliosPersonas domiciliopersona With (nolock) on domicilioPersona.IdRel=per.IdRelDomicilios 
		LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios
		lEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
		LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
		LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id = tact.IdCatalogoBanxico
		LEFT JOIN dbo.tCTLnacionalidades nacionalidad With (nolock) ON nacionalidad.IdNacionalidad = pf.IdNacionalidad
		LEFT JOIN dbo.tCTLpaises pais With (nolock) ON pais.IdPais = pf.IdPaisNacimiento
		LEFT JOIN dbo.tCTLtiposD tproducto With (nolock) ON tproducto.IdTipoD=cta.IdTipoDProducto
		LEFT JOIN dbo.tSDOsaldos saldo With (nolock) ON saldo.idsaldo=cta.IdSaldo
		WHERE o.IdTipoDoperacionPLD=1592  AND o.IdEstatusAtencion=68 AND o.IdEstatus=1
		AND ((ope.fecha IS NULL AND o.Alta BETWEEN @FechaInicial AND @fechaFinal) OR (NOT ope.Fecha IS NULL AND ope.Fecha BETWEEN @FechaInicial AND @fechaFinal))
		ORDER BY o.IdOperacion