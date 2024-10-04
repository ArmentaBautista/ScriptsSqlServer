
USE iERP_KFT
GO


IF EXISTS(SELECT name FROM sys.objects o WHERE o.name='pPLDgenerarReporteOperaciones')
BEGIN
	DROP PROC pPLDgenerarReporteOperaciones
	SELECT 'pPLDgenerarReporteOperaciones BORRADO' AS info
END
GO

CREATE PROC pPLDgenerarReporteOperaciones
@TipoOperacion AS VARCHAR(10)='',
@FechaInicial AS DATE='19000101',
@fechaFinal AS DATE='19000101',
@IdSocio AS INT=0,
@Fecha AS DATE='19000101',
@IdEmpresa INT = 1,
@IdPeriodo INT = 0
AS
BEGIN
	
	IF (@TipoOperacion='')
	BEGIN
		SELECT 
			[TIPO DE REPORTE]=1--1 	
			,[PERIODO DEL REPORTE]=(select convert(char(6), dateadd(MM, 0, ope.Fecha), 112))--2
			 --[IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
			, [FOLIO]=LEFT (REPLACE(str(DENSE_RANK()OVER (ORDER BY ope.IdOperacion ), 6), ' ', '0'), 6)	--3
			,[ÓRGANO SUPERVISOR]='001002'--4
			,[CLAVE DEL SUJETO OBLIGADO]='029164'---5
			,[LOCALIDAD]=LEFT (REPLACE(str(lb.clave, 8), ' ', '0'),8 )---6
			,[SUCURSAL]=suc.Codigo---7
			,[TIPO DE OPERACION]=CASE 
									  WHEN t.IdTipoSubOperacion IN (500,511) THEN '01'
									  WHEN t.IdTipoSubOperacion=501 THEN '02' 
									  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=500 AND cta.IdTipoDProducto=143 THEN '09'
									  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=501 AND cta.IdTipoDProducto=143 THEN '08'
									  END ---8
			,[INSTRUMENTO MONETARIO]='01'---9
			,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERO DE SEGURIDAD SOCIAL]= ISNULL(REPLACE(cta.Codigo,'-',''),'')---10
			,[MONTO]=CAST(td.Monto AS NUMERIC(14,2))---11
			,[MONEDA]=CASE T.IdDivisa
							WHEN 1 THEN '1'
							WHEN 2 THEN '2' END--12
			,[FECHA DE LA OPERACION]=CONVERT(VARCHAR(10), OPE.Fecha, 112)---13
			,[FECHA DE DETECCIÓN DE LA OPERACIÓN ]=''---CAMPO OBLIGATORIO SOLO PARA OPERACIONES INUSUALUES Y PREOCUPANTES--14
			,[NACIONALIDAD]=CASE per.EsExtranjero
								WHEN 0 THEN 'MX'
								WHEN 1 THEN '0'
								ELSE '0'
								END---15
			,[TIPO DE PERSONA]=IIF(per.EsPersonaMoral=1,2,1)--16
			,[RAZÓN SOCIAL O DENOMINACIÓN]=IIF (PER.EsPersonaMoral=1,SUBSTRING(PER.Nombre,1,60),'')---17
			,[NOMBRE]=ISNULL(SUBSTRING(PF.Nombre,1,60),'')--18
			,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--19
			,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoMaterno,1,60))--20
			,[RFC]=isnull (per.RFC,'')--21
			,[CURP]=ISNULL(PF.CURP,'')--22
			,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=ISNULL(IIF (PER.EsPersonaMoral=1,CONVERT(VARCHAR(10), PM.FechaConstitucion, 112),CONVERT(VARCHAR(10), PF.FechaNacimiento, 112)),'')---23
			--TRUNCAMOS EL DOMICILIO
			,[DOMICILIO]=SUBSTRING(ISNULL(PER.Domicilio,''), 1, 60) --24
			,[COLONIA]=ISNULL(SUBSTRING(dr.Asentamiento,1,30),'')--25
			,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str(dr.ClaveLocalidad, 8), ' ', '0'), 8)---26----FALTA ESPECIFICAR LA CLAVE DE LA LOCALIDAD
			,[TELEFONO]=ISNULL(IIF(per.IdRelTelefonos=0,'',(SELECT CAST(vcg.Telefono AS VARCHAR(max))+CHAR(10)
															   FROM vCATtelefonosGUI vcg WHERE vcg.IdRel=per.IdRelTelefonos FOR XML PATH (''))),'')---27
			,[ACTIVIDAD ECONOMICA]=LEFT (REPLACE(str(ISNULL(aec.clave,'0') , 7), ' ', '0'), 7)---28----
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
			,[DESCRIPCIÓN DE LA OPERACIÓN]=''--40
			,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=''---41
			FROM dbo.tPLDoperaciones o (NOLOCK)
			JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
			JOIN dbo.tGRLoperaciones ope (NOLOCK)ON ope.IdOperacion=o.IdOperacionOrigen AND ope.IdOperacion!=0
			JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=ope.IdSucursal
			JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
			JOIN dbo.tCTLmunicipios mun WITH (nolock) ON mun.IdMunicipio = dom.IdMunicipio
			JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
			JOIN dbo.tSDOtransaccionesD td (NOLOCK)ON td.IdTransaccionD=o.IdTransaccionD
			JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=ope.IdOperacion AND td.RelTransaccion=t.IdTransaccion
			LEFT JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=ope.IdOperacion
			LEFT JOIN dbo.tAYCcuentas cta (NOLOCK)ON cta.IdCuenta=tf.IdCuenta
			LEFT JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=cta.IdSocio
			LEFT JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=soc.IdPersona
			LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersona=per.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersona = per.IdPersona
			LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios
			LEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
			LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
			LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id=tact.IdCatalogoBanxico
			WHERE o.IdTipoDoperacionPLD=1594 
			AND ope.Fecha BETWEEN @FechaInicial AND @fechaFinal
			ORDER BY ope.IdOperacion

			PRINT 'operacion vacia'
			RETURN
	END
	
	IF (@TipoOperacion='SOC')
	BEGIN
		
		SELECT 
		[TIPO DE REPORTE]=2,
		[PERIODO DEL REPORTE]=(select convert(char(6), dateadd(MM, 0, @Fecha), 112)),
		[Folio]='000001',
		[ORGANO SUPERVISOR]='001002',
		[CLAVE DEL SUJETO OBLIGADO]='029164',
		[LOCALIDAD]=dom.Ciudad,
		[SUCURSAL***]=tc.Codigo,
		[TIPO DE OPERACION]='00',
		[INSTRUMENTO MONETARIO]='00',
		[NUMERO DE CUENTA, CONTRATO U OPERACIÓN, POLIZA O NUMERO DE S.S.]=ts.Codigo,
		[MONTO]=0,
		[MONEDA]=0,
		[FECHA DE LA OPERACION]=CONVERT(VARCHAR(10), ts.FechaAlta, 112),
		[FECHA DE DETECCION DE LA OPERACIÓN*]=CONVERT(VARCHAR(10), ts.FechaAlta, 112),
		[PAÍS DE NACIONALIDAD]=CASE  tg.EsExtranjero WHEN 0 THEN 'MX' else '0' END,
		[TIPO DE PERSONA]=CASE  tg.EsPersonaMoral WHEN 1  THEN 2 else 1 END,
		[RAZON SOCIAL O DENOMINACION]=Iif(tg.EsPersonaMoral=1,tg.Nombre,''),
		[NOMBRE]=pf.Nombre,
		[APELLIDO PATERNO]=pf.ApellidoPaterno,
		[APELLIDO MATERNO]=pf.ApellidoMaterno,
		[RFC]=tg.RFC,
		[CURP]=pf.CURP,
		[FECHA DE NACIMIENTO O CONSTITUCION]=ISNULL(IIF (tg.EsPersonaMoral=1,CONVERT(VARCHAR(10), m.FechaConstitucion, 112),CONVERT(VARCHAR(10), pf.FechaNacimiento, 112)),''),
		--TRUNCAMOS EL DOMICILIO
		[DOMICILIO]=SUBSTRING(tg.Domicilio, 1 , 60),
		[COLONIA]=tas.ClaveSEPOMEX,
		[CIUDAD O POBLACION]=dom.Ciudad,
		[TELEFONO OFICINA/PARTICULAR]=ISNULL(IIF(tg.IdRelTelefonos=0,'',tel.Telefonos),''),---27
		[ACTIVIDAD ECONOMICA]=LEFT (REPLACE(str( ISNULL(aec.clave,'0') , 7), ' ', '0'), 7),
		[AGENTE O APODERADO DE SEGUROS Y/O FIANZAS, O AGENTE RELACIONADO DEL TRANSMISOR DE DINERO NOMBRE**]='0',
		[APELLIDO PARTERNO**]='0',
		[APELLIDO MATERNO**]='0',
		[RFC**]='0',
		[CURP**]='0',
		[CONSECUTIVO DE CUENTASY/O PERSONAS RELACIONADAS*] ='0',
		[NUMERO DE CUENTA, CONTRATO, OPERACION, POLIZA O NUMERO DE SEGURIDAD SOCIAL*]='0',
		[CLAVE DEL SUJETO OBLIGADO*]='0',
		[NOMBRE DEL TITULAR DE LA CUENTA O DE LA PERSONA RELACIONADA*]='0',
		[APELLIDO PATERNO*]='0',
		[APELLIDO MATERNO*]='0',
		[DESCRIPCION DE LA OPERACION*]='',
		[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O INTERNA PREOCUPANTE*]='0'
		fROM tSCSsocios ts
		JOIN tGRLpersonas tg(NOLOCK)ON tg.IdPersona=ts.IdPersona
		left JOIN tGRLpersonasFisicas pf (NOLOCK)ON pf.IdPersonaFisica=ts.IdPersona
		LEFT JOIN tCTLlaborales lab (NOLOCK)ON lab.IdPersona=tg.IdPersona
		LEFT JOIN dbo.tCATlistasD tp(NOLOCK)ON tp.IdListaD=lab.IdListaDactividadEmpresa
		LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id=tp.IdCatalogoBanxico
		left JOIN tGRLpersonasMorales m(NOLOCK)ON m.IdPersonaMoral=ts.IdPersona
		JOIN tCTLsucursales tc(NOLOCK)ON tc.IdSucursal=ts.IdSucursal
		JOIN tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=tc.IdDomicilio
		JOIN tCTLasentamientos tas(NOLOCK)ON tas.IdAsentamiento=dom.IdAsentamiento
		LEFT JOIN dbo.vCATtelefonosAgrupadosPLD tel WITH (nolock) ON tel.IdRel = tg.IdRelTelefonos
		WHERE ts.IdSocio=@IdSocio

	END
	--- opción para la pantalla
	IF (@TipoOperacion='REL')
	BEGIN 
		SELECT 
			 [TIPO DE REPORTE]=1--1 	
			,[PERIODO DEL REPORTE]=(select convert(char(6), dateadd(MM, 0, ope.Fecha), 112))--2
			 --[IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
			, [FOLIO]=LEFT (REPLACE(str(DENSE_RANK()OVER (ORDER BY ope.IdOperacion ), 6), ' ', '0'), 6)	--3
			,[ÓRGANO SUPERVISOR]='001002'--4
			,[CLAVE DEL SUJETO OBLIGADO]='029164'---5
			,[LOCALIDAD]=LEFT (REPLACE(str( lb.Clave , 8), ' ', '0'), 8)---6
			,[SUCURSAL]=suc.Codigo---7
			,[TIPO DE OPERACION]=CASE 
									  WHEN t.IdTipoSubOperacion IN (500,511) THEN '01'
									  WHEN t.IdTipoSubOperacion=501 THEN '02' 
									  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=500 AND cta.IdTipoDProducto=143 THEN '09'
									  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=501 AND cta.IdTipoDProducto=143 THEN '08'
									  END ---8
			,[INSTRUMENTO MONETARIO]='01'---9
			,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERO DE SEGURIDAD SOCIAL]= ISNULL(REPLACE(cta.Codigo,'-',''),'')---10
			,[MONTO]=CAST(td.Monto AS NUMERIC(14,2))---11
			,[MONEDA]=CASE T.IdDivisa
							WHEN 1 THEN '1'
							WHEN 2 THEN '2' END--12
			,[FECHA DE LA OPERACION]=CONVERT(VARCHAR(10), OPE.Fecha, 112)---13
			,[FECHA DE DETECCIÓN DE LA OPERACIÓN ]=''---CAMPO OBLIGATORIO SOLO PARA OPERACIONES INUSUALUES Y PREOCUPANTES--14
			,[NACIONALIDAD]=CASE per.EsExtranjero
								WHEN 0 THEN 'MX'
								WHEN 1 THEN '0'
								ELSE '0'
								END---15
			,[TIPO DE PERSONA]=IIF(per.EsPersonaMoral=1,2,1)--16
			,[RAZÓN SOCIAL O DENOMINACIÓN]=IIF (PER.EsPersonaMoral=1,SUBSTRING(PER.Nombre,1,60),'')---17
			,[NOMBRE]=ISNULL(SUBSTRING(PF.Nombre,1,60),'')--18
			,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--19
			,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoMaterno,1,60))--20
			,[RFC]=isnull (per.RFC,'')--21
			,[CURP]=ISNULL(PF.CURP,'')--22
			,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=ISNULL(IIF (PER.EsPersonaMoral=1,CONVERT(VARCHAR(10), PM.FechaConstitucion, 112),CONVERT(VARCHAR(10), PF.FechaNacimiento, 112)),'')---23
			--TRUNCAMOS EL DOMICILIO
			,[DOMICILIO]=SUBSTRING(ISNULL(PER.Domicilio,''), 1, 60) --24
			,[COLONIA]=ISNULL(SUBSTRING(dr.Asentamiento,1,30),'')--25
			,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str(dr.ClaveLocalidad , 8), ' ', '0'), 8)---26----FALTA ESPECIFICAR LA CLAVE DE LA LOCALIDAD
			,[TELEFONO]=ISNULL(IIF(per.IdRelTelefonos=0,'',tel.Telefonos),'')---27
			,[ACTIVIDAD ECONOMICA]=LEFT (REPLACE(str( ISNULL(aec.clave,'0') , 7), ' ', '0'), 7)---28----
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
			,[DESCRIPCIÓN DE LA OPERACIÓN]=''--40
			,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=''---41
			FROM dbo.tPLDoperaciones o (NOLOCK)
			JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
			JOIN dbo.tGRLoperaciones ope (NOLOCK)ON ope.IdOperacion=o.IdOperacionOrigen AND ope.IdOperacion!=0
			JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=ope.IdSucursal
			JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
			JOIN dbo.tCTLmunicipios mun WITH (nolock) ON mun.IdMunicipio = dom.IdMunicipio
			JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
			JOIN dbo.tSDOtransaccionesD td (NOLOCK)ON td.IdTransaccionD=o.IdTransaccionD
			JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=ope.IdOperacion AND td.RelTransaccion=t.IdTransaccion
			LEFT JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=ope.IdOperacion
			LEFT JOIN dbo.tAYCcuentas cta (NOLOCK)ON cta.IdCuenta=tf.IdCuenta
			LEFT JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=cta.IdSocio
			LEFT JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=soc.IdPersona
			LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersona=per.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersona = per.IdPersona
			LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios
			LEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
			LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
			LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id=tact.IdCatalogoBanxico
			LEFT JOIN dbo.vCATtelefonosAgrupadosPLD tel WITH (nolock) ON tel.IdRel = per.IdRelTelefonos
			WHERE o.IdTipoDoperacionPLD=1594 
			AND ope.Fecha BETWEEN @FechaInicial AND @fechaFinal
			ORDER BY ope.IdOperacion
			RETURN
	END

	--- opción para el excel
	IF (@TipoOperacion='REL-XLS')
	BEGIN 
	SELECT 
		 [IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
			 [FOLIO]=LEFT (REPLACE(str(DENSE_RANK()OVER (ORDER BY ope.IdOperacion ), 6), ' ', '0'), 6)	--3
			,[ÓRGANO SUPERVISOR]='001002'--4
			--,[CLAVE DEL SUJETO OBLIGADO]='029016'---5
			,[LOCALIDAD]=LEFT (REPLACE(str( lb.Clave , 8), ' ', '0'), 8)---6
			,[SUCURSAL]=suc.Codigo---7
			,[TIPO DE OPERACION]=CASE 
									  WHEN t.IdTipoSubOperacion IN (500,511) THEN '01'
									  WHEN t.IdTipoSubOperacion=501 THEN '02' 
									  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=500 AND cta.IdTipoDProducto=143 THEN '09'
									  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=501 AND cta.IdTipoDProducto=143 THEN '08'
									  END ---8
			,[INSTRUMENTO MONETARIO]='01'---9
			,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERO DE SEGURIDAD SOCIAL]
			=IIF(LEN(ISNULL(REPLACE(cta.Codigo,'-',''),''))<=16
				, ISNULL(REPLACE(cta.Codigo,'-',''),'')
				,SUBSTRING(ISNULL(REPLACE(cta.Codigo,'-',''),''), 1, LEN(ISNULL(REPLACE(cta.Codigo,'-',''),'')) - 2))    ---10
			,[MONTO]=CAST(CAST(o.Monto AS NUMERIC(14,2)) AS VARCHAR(90))---11
			,[MONEDA]=CASE T.IdDivisa
							WHEN 1 THEN '1'
							WHEN 2 THEN '2' END--12
			,[FECHA DE LA OPERACION]=CONVERT(VARCHAR(10), OPE.Fecha, 112)---13
			,[FECHA DE DETECCIÓN DE LA OPERACIÓN ]=''---CAMPO OBLIGATORIO SOLO PARA OPERACIONES INUSUALUES Y PREOCUPANTES--14
			,[NACIONALIDAD]=CASE per.EsExtranjero
								WHEN 0 THEN 'MX'
								WHEN 1 THEN '0'
								ELSE '0'
								END---15
			,[TIPO DE PERSONA]=IIF(per.EsPersonaMoral=1,2,1)--16
			,[RAZÓN SOCIAL O DENOMINACIÓN]=IIF (PER.EsPersonaMoral=1,SUBSTRING(PER.Nombre,1,60),'')---17
			,[NOMBRE]=ISNULL(SUBSTRING(PF.Nombre,1,60),'')--18
			,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'',SUBSTRING(pf.ApellidoPaterno,1,60))--19
			,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'',SUBSTRING(pf.ApellidoMaterno,1,60))--20
			,[RFC]=isnull (per.RFC,'')--21
			,[CURP]=ISNULL(PF.CURP,'')--22
			,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=ISNULL(IIF (PER.EsPersonaMoral=1,CONVERT(VARCHAR(10), PM.FechaConstitucion, 112),CONVERT(VARCHAR(10), PF.FechaNacimiento, 112)),'')---23
			--TRUNCAMOS EL DOMICILIO
			,[DOMICILIO]=SUBSTRING(ISNULL(REPLACE(PER.Domicilio,'.',' '),''), 1, 60) --24
			,[COLONIA]=ISNULL(SUBSTRING(dr.municipio,1,30),'')--25
			,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str(IIF(dr.ClaveLocalidad='',lb.Clave,ISNULL(dr.ClaveLocalidad,0)) , 8), ' ', '0'), 8)---26----FALTA ESPECIFICAR LA CLAVE DE LA LOCALIDAD
			,[TELEFONO]=ISNULL(IIF(per.IdRelTelefonos=0,'',tel.Telefonos),'')---27
			,[ACTIVIDAD ECONOMICA]=LEFT (REPLACE(str(ISNULL(aec.clave,'0') , 7), ' ', '0'), 7)---28----
			,[AGENTE O APODERADO DE SEGUROS Y/O FIANZAS**]=''--29
			,[APELLIDO PATERNO**]=''---30
			,[APELLIDO MATERNO**]=''--31
			,[RFC**]=''---32
			,[CURP**]=''--33
			,[CONSECUTIVO DE CUENTAS Y/O PERSONAS RELACIONADAS*]=''--34 de la columna 34 a la 41 no aplican para operaciones reelevantes
			,[NUMERO DE CUENTA, CONTRATO, OPERACIÓN, POLIZA O NÚMERO DE SEGURIDAD SOCIAL*]=''--35
			,[CLAVE DEL SUJETO OBLIGADO]=''--36
			,[NOMBRE DEL TITULAR DE LA CUENTA O DE LA PERSONA RELACIONADA*]=''--37
			,[APELLIDO PATERNO*]=''---38
			,[APELLIDO MATERNO*]=''---39
			,[DESCRIPCIÓN DE LA OPERACIÓN]=''--40
			,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=''---41
			
			FROM dbo.tPLDoperaciones o (NOLOCK)
			JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
			JOIN dbo.tGRLoperaciones ope (NOLOCK)ON ope.IdOperacion=o.IdOperacionOrigen AND ope.IdOperacion!=0
			JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=ope.IdSucursal
			JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
			JOIN dbo.tCTLmunicipios mun WITH (nolock) ON mun.IdMunicipio = dom.IdMunicipio
			JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
			JOIN dbo.tSDOtransaccionesD td (NOLOCK)ON td.IdTransaccionD=o.IdTransaccionD
			JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=ope.IdOperacion AND td.RelTransaccion=t.IdTransaccion
			LEFT JOIN (SELECT x.IdOperacion,x.IdCuenta,x.IdTipoSubOperacion,
			ROW_NUMBER()OVER(PARTITION BY x.IdOperacion ORDER BY x.MontoSubOperacion DESC) AS Numero
			FROM dbo.tSDOtransaccionesFinancieras x WITH (NOLOCK) ) AS tf ON tf.IdOperacion=ope.IdOperacion AND tf.numero=1
			LEFT JOIN dbo.tAYCcuentas cta (NOLOCK)ON cta.IdCuenta=tf.IdCuenta
			LEFT JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=cta.IdSocio
			LEFT JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=soc.IdPersona
			LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersona=per.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersona = per.IdPersona
			LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios AND dr.numero=1
			LEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
			LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
			LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id=tact.IdCatalogoBanxico
			LEFT JOIN dbo.vCATtelefonosAgrupadosPLD tel WITH (nolock) ON tel.IdRel = per.IdRelTelefonos
			WHERE o.IdTipoDoperacionPLD=1594 
			AND ope.Fecha BETWEEN @FechaInicial AND @fechaFinal AND o.IdEstatus!=2
			ORDER BY ope.IdOperacion
			RETURN
	END

	IF (@TipoOperacion='INU')
	BEGIN		
		--OPERACIONES INUSUALES
		SELECT
		 [TIPO DE REPORTE]=2--1	
		 ,[PERIODO DEL REPORTE]=(CONVERT(VARCHAR(10), o.Alta, 112))--2
		 --[IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
		 ,[FOLIO]=SUBSTRING(LEFT (REPLACE(str(DENSE_RANK()OVER (ORDER BY o.IdOperacion ), 6), ' ', '0'), 6),1,6)	--3
		,[ÓRGANO SUPERVISOR]='001002'--4
		,[CLAVE DEL SUJETO OBLIGADO]='029164'---5
		,[LOCALIDAD]=LEFT (REPLACE(STR( lb.Clave , 8), ' ', '0'), 8)---6
		,[SUCURSAL]=SUBSTRING(suc.Codigo,1,8)---7
		,[TIPO DE OPERACION]=CASE 
								  WHEN t.IdTipoSubOperacion IN (500,511) THEN '01'
								  WHEN t.IdTipoSubOperacion=501 THEN '02' 
								  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=500 AND cta.IdTipoDProducto=143 THEN '09'
								  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=501 AND cta.IdTipoDProducto=143 THEN '08'
								  ELSE
		                          '00'
								  END ---8
		,[INSTRUMENTO MONETARIO]='01'---9
		,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERO DE SEGURIDAD SOCIAL]= ''--ISNULL(REPLACE(cta.Codigo,'-',''),'0')---10
		,[MONTO]=0--CAST(td.Monto AS NUMERIC(16,2))---11
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
		,[NOMBRE]=IiF (PER.EsPersonaMoral=1,ISNULL(per.nombre,''), ISNULL(SUBSTRING(PF.Nombre,1,60),''))--18
		,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--19
		,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--20
		,[RFC]=SUBSTRING(isnull (per.RFC,''),1,13)--21
		,[CURP]=SUBSTRING(ISNULL(PF.CURP,''),1,18)--22
		,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=dbo.[fSITformatoFecha](IIF(PER.EsPersonaMoral=1,PM.FechaConstitucion,PF.FechaNacimiento))---23
		-- TRUNCAMOS EL DOMICILIO
		,[DOMICILIO]=SUBSTRING(ISNULL(PER.Domicilio,''),1,60)--24
		,[COLONIA]=ISNULL(SUBSTRING(dr.Asentamiento,1,30),'')--25
		,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str(dr.claveLocalidad , 8), ' ', '0'), 8)---26
		,[TELEFONO]=''--SUBSTRING(ISNULL(IIF(per.IdRelTelefonos=0,'',(SELECT CAST(vcg.Telefono AS VARCHAR(max))+CHAR(10)														   FROM vCATtelefonosGUI vcg WHERE vcg.IdRel=per.IdRelTelefonos FOR XML PATH (''))),''), 1,40)---27
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
		,[DESCRIPCIÓN DE LA OPERACIÓN]=''--i.Descripcion--40
		,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=''--o.TipoIndicador---41
		
		FROM dbo.tPLDoperaciones o (NOLOCK)
		JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
		JOIN dbo.tCTLsesiones ses (NOLOCK)ON ses.IdSesion=o.IdSesion
		LEFT JOIN dbo.tGRLoperaciones ope (NOLOCK)ON ope.IdOperacion=o.IdOperacionOrigen AND o.IdOperacionOrigen!=0
		LEFT JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=IIF(ope.IdOperacion IS NULL,ses.IdSucursal ,ope.IdSucursal)
		LEFT JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
		LEFT JOIN dbo.tCTLmunicipios mun (NOLOCK)ON mun.IdMunicipio = dom.IdMunicipio
		LEFT JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
		LEFT JOIN dbo.tSDOtransaccionesD td (NOLOCK)ON td.IdTransaccionD=o.IdTransaccionD
		LEFT JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=ope.IdOperacion AND td.RelTransaccion=t.IdTransaccion
		LEFT JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=ope.IdOperacion
		LEFT JOIN dbo.tAYCcuentas cta (NOLOCK)ON cta.IdCuenta=tf.IdCuenta
		LEFT JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=cta.IdSocio
		LEFT JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=IIF(o.IdPersona=0,soc.IdPersona,o.IdPersona)
		LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersonaFisica=per.IdPersonaFisica
		LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersonaMoral = per.IdPersonaMoral
		LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios
		lEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
		LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
		LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id = tact.IdCatalogoBanxico
		WHERE o.IdTipoDoperacionPLD=1592  
		AND ((ope.fecha IS NULL AND o.Alta BETWEEN @FechaInicial AND @fechaFinal) OR (NOT ope.Fecha IS NULL AND ope.Fecha BETWEEN @FechaInicial AND @fechaFinal))
		ORDER BY o.IdOperacion
		RETURN
    END

	IF (@TipoOperacion='INU-XLS')
	BEGIN
		
		--OPERACIONES INUSUALES
		SELECT
		 --[TIPO DE REPORTE]=2--1	
		 --,[PERIODO DEL REPORTE]=(CONVERT(VARCHAR(10), o.Alta, 112))--2
		 [IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
		 [FOLIO]=SUBSTRING(LEFT (REPLACE(str(DENSE_RANK()OVER (ORDER BY o.IdOperacion ), 6), ' ', '0'), 6),1,6)	--3
		--,[ÓRGANO SUPERVISOR]='001002'--4
		,[CLAVE DEL SUJETO OBLIGADO]='029164'---5
		,[LOCALIDAD]=LEFT (REPLACE(str( lb.Clave , 8), ' ', '0'), 8)---6
		,[SUCURSAL]=SUBSTRING(suc.Codigo,1,8)---7
		,[TIPO DE OPERACION]=CASE 
								  WHEN t.IdTipoSubOperacion IN (500,511) THEN '01'
								  WHEN t.IdTipoSubOperacion=501 THEN '02' 
								  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=500 AND cta.IdTipoDProducto=143 THEN '09'
								  WHEN tf.IdTipoSubOperacion != NULL AND tf.IdTipoSubOperacion=501 AND cta.IdTipoDProducto=143 THEN '08'
								  ELSE
		                          '00'
								  END ---8
		,[INSTRUMENTO MONETARIO]='01'---9
		,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERO DE SEGURIDAD SOCIAL]= ''--ISNULL(REPLACE(cta.Codigo,'-',''),'0')---10
		,[MONTO]=0--CAST(td.Monto AS NUMERIC(16,2))---11
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
		,[NOMBRE]=IiF (PER.EsPersonaMoral=1,ISNULL(per.nombre,''), ISNULL(SUBSTRING(PF.Nombre,1,60),''))--18
		,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--19
		,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--20
		,[RFC]=SUBSTRING(isnull (per.RFC,''),1,13)--21
		,[CURP]=SUBSTRING(ISNULL(PF.CURP,''),1,18)--22
		,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=dbo.[fSITformatoFecha](IIF(PER.EsPersonaMoral=1,PM.FechaConstitucion,PF.FechaNacimiento))---23
		-- TRUNCAMOS EL DOMICILIO
		,[DOMICILIO]=SUBSTRING(ISNULL(PER.Domicilio,''),1,60)--24
		,[COLONIA]=ISNULL(SUBSTRING(dr.Asentamiento,1,30),'')--25
		,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str( dr.ClaveLocalidad , 8), ' ', '0'), 8)---26
		,[TELEFONO]=''--SUBSTRING(ISNULL(IIF(per.IdRelTelefonos=0,'',(SELECT CAST(vcg.Telefono AS VARCHAR(max))+CHAR(10)														   FROM vCATtelefonosGUI vcg WHERE vcg.IdRel=per.IdRelTelefonos FOR XML PATH (''))),''), 1,40)---27
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
		,[DESCRIPCIÓN DE LA OPERACIÓN]=''--i.Descripcion--40
		,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=''--o.TipoIndicador---41
		
		FROM dbo.tPLDoperaciones o (NOLOCK)
		JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
		JOIN dbo.tCTLsesiones ses (NOLOCK)ON ses.IdSesion=o.IdSesion
		LEFT JOIN dbo.tGRLoperaciones ope (NOLOCK)ON ope.IdOperacion=o.IdOperacionOrigen AND o.IdOperacionOrigen!=0
		LEFT JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=IIF(ope.IdOperacion IS NULL,ses.IdSucursal ,ope.IdSucursal)
		LEFT JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
		LEFT JOIN dbo.tCTLmunicipios mun (NOLOCK)ON mun.IdMunicipio = dom.IdMunicipio
		LEFT JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
		LEFT JOIN dbo.tSDOtransaccionesD td (NOLOCK)ON td.IdTransaccionD=o.IdTransaccionD
		LEFT JOIN dbo.tSDOtransacciones t (NOLOCK)ON t.IdOperacion=ope.IdOperacion AND td.RelTransaccion=t.IdTransaccion
		LEFT JOIN dbo.tSDOtransaccionesFinancieras tf (NOLOCK)ON tf.IdOperacion=ope.IdOperacion
		LEFT JOIN dbo.tAYCcuentas cta (NOLOCK)ON cta.IdCuenta=tf.IdCuenta
		LEFT JOIN dbo.tSCSsocios soc (NOLOCK)ON soc.IdSocio=cta.IdSocio
		LEFT JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=IIF(o.IdPersona=0,soc.IdPersona,o.IdPersona)
		LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersonaFisica=per.IdPersonaFisica
		LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersonaMoral = per.IdPersonaMoral
		LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios
		lEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
		LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
		LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id = tact.IdCatalogoBanxico
		WHERE o.IdTipoDoperacionPLD=1592  
		AND ((ope.fecha IS NULL AND o.Alta BETWEEN @FechaInicial AND @fechaFinal) OR (NOT ope.Fecha IS NULL AND ope.Fecha BETWEEN @FechaInicial AND @fechaFinal))
		ORDER BY o.IdOperacion
		RETURN
    END

	IF (@TipoOperacion='PRE')
	BEGIN
	
			--OPERACIONES PREOCUPANTES
			SELECT  
			 --[IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
			 [TIPO DE REPORTE]=3--1    	
			 ,[PERIODO DEL REPORTE]=(SELECT CONVERT(VARCHAR(10),o.Alta , 112))--2
			 ,[FOLIO]=   LEFT(REPLACE(STR(ROW_NUMBER()OVER (ORDER BY o.IdOperacion ), 6), ' ', '0'), 6)	--3
			,[ÓRGANO SUPERVISOR]='001002'--4
			-- SE LA QUITAMOS, NO SE REQUIERE,[CLAVE DEL SUJETO OBLIGADO]='029164'---5
			,[LOCALIDAD]=LEFT (REPLACE(str( lb.Clave , 8), ' ', '0'), 8)---6
			,[SUCURSAL]=suc.Codigo---7
			,[TIPO DE OPERACION]=''---8 que va en el caso de operaciones Preocupantes
			,[INSTRUMENTO MONETARIO]=''---9 que va en el caso de operaciones Preocupantes
			,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERP DE SEGURIDAD SOCIAL]= '0'---10
			,[MONTO]=0---11
			,[MONEDA]=0---12 que va en el caso de operaciones Preocupantes
			,[FECHA DE LA OPERACION]=CONVERT(VARCHAR(10), o.Alta, 112)---13
			,[FECHA DE DETECCIÓN DE LA OPERACIÓN ]=CONVERT(VARCHAR(10), o.Alta, 112)---CAMPO OBLIGATORIO SOLO PARA OPERACIONES INUSUALUES Y PREOCUPANTES--14
			,[NACIONALIDAD]=CASE PF.IdNacionalidad
								WHEN 0 THEN 'MX'
								WHEN 1 THEN '0'
								ELSE '0'
								END---15
			,[TIPO DE PERSONA]=IIF(per.EsPersonaMoral=1,2,1)--16
			,[RAZÓN SOCIAL O DENOMINACIÓN]=IIF (PER.EsPersonaMoral=1,SUBSTRING(PER.Nombre,1,60),'')---17
			,[NOMBRE]=ISNULL(SUBSTRING(PF.Nombre,1,60),'')--18
			,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--19
			,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoMaterno,1,60))--20
			,[RFC]=ISNULL (per.RFC,'')--21
			,[CURP]=ISNULL(PF.CURP,'')--22
			,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=ISNULL(IIF (PER.EsPersonaMoral=1,CONVERT(VARCHAR(10), PM.FechaConstitucion, 112),CONVERT(VARCHAR(10), PF.FechaNacimiento, 112)),'')---23
			,[DOMICILIO]=SUBSTRING(ISNULL(PER.Domicilio,''),1,60)--24
			,[COLONIA]=ISNULL(SUBSTRING(dr.Asentamiento,1,30),'')--25
			,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str( dr.ClaveLocalidad , 8), ' ', '0'), 8)---26----FALTA ESPECIFICAR LA CLAVE DE LA LOCALIDAD
			,[TELEFONO]=ISNULL(IIF(per.IdRelTelefonos=0,'',tel.Telefonos),'')---27
			,[ACTIVIDAD ECONOMICA]=LEFT (REPLACE(str(ISNULL(aec.clave,'0') , 7), ' ', '0'), 7)---28----FALTA LA CLAVE SEGUN EL CATALOGO CORRESPONDIENTE
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
			,[DESCRIPCIÓN DE LA OPERACIÓN]=o.Texto--40
			,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=o.TipoIndicador---41
			FROM dbo.tPLDoperaciones o (NOLOCK)
			JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
			JOIN dbo.tCTLsesiones ses (NOLOCK)ON ses.IdSesion = o.IdSesion
			JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=ses.IdSucursal
			JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
			JOIN dbo.tCTLmunicipios mun (NOLOCK)ON mun.IdMunicipio = dom.IdMunicipio
			JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
			JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=o.IdPersona
			LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersona=per.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersona = per.IdPersona
			LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios
			JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
			JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
			LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id = tact.IdCatalogoBanxico
			LEFT JOIN dbo.vCATtelefonosAgrupadosPLD tel WITH (nolock) ON tel.IdRel = per.IdRelTelefonos
			WHERE o.IdTipoDoperacionPLD=1596 AND o.Alta BETWEEN @FechaInicial AND @fechaFinal
			ORDER BY o.IdOperacion

			RETURN
	END

	IF (@TipoOperacion='PRE-XLS')
	BEGIN
	
				--OPERACIONES PREOCUPANTES
			SELECT  
			 [IdEmpresa] = @IdEmpresa, [IdPeriodo] = @IdPeriodo,
			 --[TIPO DE REPORTE]=3--1    	
			 --[PERIODO DEL REPORTE]=(SELECT CONVERT(VARCHAR(10),o.Alta , 112))--2
			 [FOLIO]=   LEFT(REPLACE(STR(ROW_NUMBER()OVER (ORDER BY o.IdOperacion ), 6), ' ', '0'), 6)	--3
			,[ÓRGANO SUPERVISOR]='001002'--4
			-- SE LA QUITAMOS, NO SE REQUIERE,[CLAVE DEL SUJETO OBLIGADO]='029164'---5
			,[LOCALIDAD]=LEFT (REPLACE(str( lb.Clave, 8), ' ', '0'), 8)---6
			,[SUCURSAL]=suc.Codigo---7
			,[TIPO DE OPERACION]=''---8 que va en el caso de operaciones Preocupantes
			,[INSTRUMENTO MONETARIO]=''---9 que va en el caso de operaciones Preocupantes
			,[NÚMERO DE CUENTA,CONTRATO, OPERACIÓN,PÓLZA O NÚMERP DE SEGURIDAD SOCIAL]= '0'---10
			,[MONTO]=0---11
			,[MONEDA]=0---12 que va en el caso de operaciones Preocupantes
			,[FECHA DE LA OPERACION]=CONVERT(VARCHAR(10), o.Alta, 112)---13
			,[FECHA DE DETECCIÓN DE LA OPERACIÓN ]=CONVERT(VARCHAR(10), o.Alta, 112)---CAMPO OBLIGATORIO SOLO PARA OPERACIONES INUSUALUES Y PREOCUPANTES--14
			,[NACIONALIDAD]=CASE PF.IdNacionalidad
								WHEN 0 THEN 'MX'
								WHEN 1 THEN '0'
								ELSE '0'
                                END---15
			,[TIPO DE PERSONA]=IIF(per.EsPersonaMoral=1,2,1)--16
			,[RAZÓN SOCIAL O DENOMINACIÓN]=IIF (PER.EsPersonaMoral=1,SUBSTRING(PER.Nombre,1,60),'')---17
			,[NOMBRE]=ISNULL(SUBSTRING(PF.Nombre,1,60),'')--18
			,[APELLIDO PATERNO]=IIF(PF.ApellidoPaterno IS NULL OR PF.ApellidoPaterno='' ,'xxxx',SUBSTRING(pf.ApellidoPaterno,1,60))--19
			,[APELLIDO MATERNO]=IIF(PF.ApellidoMaterno IS NULL OR PF.ApellidoMaterno='' ,'xxxx',SUBSTRING(pf.ApellidoMaterno,1,60))--20
			,[RFC]=ISNULL (per.RFC,'')--21
			,[CURP]=ISNULL(PF.CURP,'')--22
			,[FECHA DE NACIMIENTO O CONSTITUCIÓN]=ISNULL(IIF (PER.EsPersonaMoral=1,CONVERT(VARCHAR(10), PM.FechaConstitucion, 112),CONVERT(VARCHAR(10), PF.FechaNacimiento, 112)),'')---23
			,[DOMICILIO]=SUBSTRING(ISNULL(PER.Domicilio,''),1,60)--24
			,[COLONIA]=ISNULL(SUBSTRING(dr.Asentamiento,1,30),'')--25
			,[CIUDAD O POBLACIÓN]=LEFT (REPLACE(str( dr.ClaveLocalidad , 8), ' ', '0'), 8)---26----FALTA ESPECIFICAR LA CLAVE DE LA LOCALIDAD
			,[TELEFONO]=ISNULL(IIF(per.IdRelTelefonos=0,'',tel.Telefonos),'')---27
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
			,[DESCRIPCIÓN DE LA OPERACIÓN]=o.Texto--40
			,[RAZONES POR LAS QUE EL ACTO U OPERACION SE CONSIDERA INUSUAL O PREOCUPANTE*]=o.TipoIndicador---41
			FROM dbo.tPLDoperaciones o (NOLOCK)
			JOIN dbo.tPLDinusualidades I (NOLOCK)ON I.IdInusualidad = o.IdInusualidad
			JOIN dbo.tCTLsesiones ses (NOLOCK)ON ses.IdSesion = o.IdSesion
			JOIN dbo.tCTLsucursales suc (NOLOCK)ON suc.IdSucursal=ses.IdSucursal
			JOIN dbo.tCATdomicilios dom(NOLOCK)ON dom.IdDomicilio=suc.IdDomicilio
			JOIN dbo.tCTLmunicipios mun (NOLOCK)ON mun.IdMunicipio = dom.IdMunicipio
			JOIN dbo.tBNXlocalidades lb With (nolock) ON lb.IdLocalidadBanxico = mun.IdLocalidadBanxico
			JOIN dbo.tGRLpersonas per (NOLOCK)ON per.IdPersona=o.IdPersona
			LEFT JOIN dbo.tGRLpersonasFisicas pf (NOLOCK)ON PF.IdPersona=per.IdPersona
			LEFT JOIN dbo.tGRLpersonasMorales PM (NOLOCK)ON PM.IdPersona = per.IdPersona
			LEFT JOIN dbo.vPLDdomiciliosReportes dr  WITH(NOLOCK)ON dr.IdRel=per.IdRelDomicilios AND dr.numero=1
			LEFT JOIN dbo.tCTLlaborales LAB (NOLOCK)ON LAB.IdPersona = per.IdPersona
			LEFT JOIN dbo.tCATlistasD tact (NOLOCK)ON tact.IdListaD=lab.IdListaDactividadEmpresa
			LEFT JOIN dbo.tBNXactividadesEconomicas aec With (nolock) ON aec.Id = tact.IdCatalogoBanxico
			LEFT JOIN dbo.vCATtelefonosAgrupadosPLD tel WITH (nolock) ON tel.IdRel = per.IdRelTelefonos
			WHERE o.IdTipoDoperacionPLD in (1596) AND o.Alta BETWEEN @FechaInicial AND @fechaFinal
			ORDER BY o.IdOperacion
	END


END









GO

