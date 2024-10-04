

declare @ultimasCB as table(
	IdSocio int primary key,
	IdRespuestaConsultaEncabezado	int unique
)

insert into @ultimasCB
select 
sc.IdSocio,max(burEnc.IdRespuestaConsultaEncabezado )
from dbo.tBURrespuestaConsultaEncabezado               burEnc with (nolock)
    inner join dbo.tBURpeticionConsultaPersonaBuro     petBur with (nolock)
        on petBur.IdPeticionConsultaPersonaBuro = burEnc.IdPeticionConsultaPersonaBuro
    inner join dbo.tBURrespuestaConsultaResumenReporte resRep with (nolock)
        on resRep.IdPeticionConsultaPersonaBuro = petBur.IdPeticionConsultaPersonaBuro
    inner join dbo.tGRLpersonasFisicas                 perFis with (nolock)
        on perFis.IdPersona = petBur.IdPersona
	INNER JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		on sc.IdPersona = perFis.IdPersona
group by sc.IdSocio



SELECT distinct
IdConsulta =petBur.IdPeticionConsultaPersonaBuro
			,[Folio Consulta]=burEnc.NumeroControlConsulta
			,Producto=burEnc.ProductoRequerido
			,[Responsabilidad]=tResCue.IndicadorTipoResponsabilidad
			,[Número de Contrato]=burEnc.TipoContrato
			,[No Socio]	= sc.Codigo
			,[Apellido Paterno]=petBur.ApellidoPaterno
			,[Apellido Materno]=petBur.ApellidoMaterno
			,[Primer Nombre]=petBur.PrimerNombre
			,[Segundo Nombre]=petBur.SegundoNombre
			,[Fecha Nacimiento]=perFis.FechaNacimiento
			,petBur.RFC
			,[Estado Civil]=tdEstcivil.Descripcion
			,[Género]=perFis.Sexo
			,[N° Identificación]=perFis.IFE
			,CURP=perFis.CURP
			,[Dirección]=CONCAT(tdDom.Calle,tdDom.NumeroInterior,tdDom.NumeroExterior)-- petBur.Direccion1
			,[Dirección Complemento]= tdDom.Domiciliocompleto-- CONCAT(direccio '')
			,Colonia=petBur.ColoniaPoblacion
			,Ciudad=petBur.Ciudad
			,Estado=petBur.Estado
			,CP=petBur.CP
			,[Fecha Residencia]=''
			,Teléfono=ISNULL(telAgr.Telefonos,'NO PROPORCIONADO')
			,[Tipo domicilio]=tdDom.TipoDomicilio
			,Fecha=dbo.fCTLstrToDate(resRep.FechaSolicitudReporteMasReciente)
			,Hora=CONVERT(VARCHAR(10),resRep.Alta,114)
			,usu.Usuario
	from @ultimasCB ult
	INNER JOIN dbo.tBURrespuestaConsultaEncabezado burEnc  WITH(NOLOCK) 
		on burEnc.IdRespuestaConsultaEncabezado = ult.IdRespuestaConsultaEncabezado
	INNER JOIN dbo.tBURpeticionConsultaPersonaBuro petBur With(Nolock) ON petBur.IdPeticionConsultaPersonaBuro = burEnc.IdPeticionConsultaPersonaBuro
	INNER JOIN dbo.tBURrespuestaConsultaResumenReporte resRep With(Nolock) ON resRep.IdPeticionConsultaPersonaBuro = petBur.IdPeticionConsultaPersonaBuro
	INNER JOIN dbo.tGRLpersonasFisicas perFis With(Nolock) ON perFis.IdPersona = petBur.IdPersona
	INNER JOIN dbo.tGRLpersonas per With(Nolock) ON per.IdPersona = petBur.IdPersona
	/********  JCA.16/3/2024.11:53 Info:se agrega socios  ********/
	inner JOIN dbo.tSCSsocios sc  WITH(NOLOCK) 
		on sc.IdPersona = per.IdPersona
			and per.IdPersona<>0
	INNER JOIN dbo.tCTLsesiones secc With(Nolock) ON secc.IdSesion = burEnc.IdSesion
	INNER JOIN dbo.tCTLusuarios usu With(Nolock) ON usu.IdUsuario = secc.IdUsuario
	left JOIN(SELECT cueBur.IdPeticionConsultaPersonaBuro,cueBur.IndicadorTipoResponsabilidad
						,NumeroResponsabilidad=COUNT(cueBur.IndicadorTipoResponsabilidad)
	           from dbo.tBURrespuestaConsultaCuentas cueBur With(Nolock)
			   GROUP BY cueBur.IdPeticionConsultaPersonaBuro,cueBur.IndicadorTipoResponsabilidad
			   ) tResCue ON tResCue.IdPeticionConsultaPersonaBuro = burEnc.IdPeticionConsultaPersonaBuro
	LEFT JOIN dbo.vCATtelefonosAgrupados telAgr ON telAgr.IdRel=per.IdRelTelefonos
	LEFT JOIN dbo.tCTLtiposD tdEstcivil With(Nolock) ON tdEstcivil.IdTipoD = perFis.IdTipoDEstadoCivil 
	LEFT JOIN (SELECT dom.IdRel,TipoDomicilio=tdDom.Descripcion
					,dom.Domicilio,dom.Calle,dom.NumeroExterior
					,dom.NumeroInterior,Domiciliocompleto=dom.Descripcion
	           from dbo.tCATdomicilios dom With(Nolock)
			   INNER JOIN dbo.tCTLtiposD tdDom With(Nolock) ON tdDom.IdTipoD = dom.IdTipoD
			   WHERE tdDom.IdTipoD=11
			  ) tdDom ON tdDom.IdRel=per.IdRelDomicilios


