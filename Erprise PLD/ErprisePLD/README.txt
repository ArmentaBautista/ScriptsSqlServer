
Version: 1.1.1.4
Notas
1. Se crea el script [0.17 ADD COLUMN Tipo ConfiguracionEdades] para agregar la columna [Tipo] en el �rden correcto de la tabla.
2. Se modifica el script [3.01 pPLDevaluacionDeRiesgo] agregando a la evaluaci�n de Edad, la condici�n del Tipo, basado en el campo [EsMoral] se filtra uno u otro tipo.
3. Se modifica [pPLDf3] para agregar filtro de socios v�lidos y/o menores y descartar todas las demas personas en el F3 de Socios.
	3.1 Se agregan campos [EsSocioValido], [EsPersonaMoral]
4. Modificaci�n del script [C INSERT DUMMY GEOGRAF�A]. Se agrega variable de tabla para los asentamientos de socios activos, y se reuse en los llenados posteriores. 
	4.1 Se eliminarn los [GO] entre cursores para dar visiblidad a la variable de tabla.
	4.2 Se cambian los nombres de las variables del �ltimo cursor para evitar conflicto con las anteriores, dado el nuevo scope del script
	4.3 Se agrega validaci�n de existencia en los insertados.
5. [2.02 fnPLDobtenerUltimoPerfilSocios]


Version: 1.1.1.5
Notas
1. Crear tabla [0.18 tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones]
2. Ejecutar M. INSERT DUMMY TRANSACCIONALIDAD NUMERO DE OPERACIONES
3. Actualizar [3.01 pPLDevaluacionDeRiesgo]
	3.1 Se agrego la secci�n para evaluar el n�mero de transacciones del mes, para menores, mayores y morales.
	3.2 Se modifica la variable de tabla de Financieras para incluir la sucursal.
	3.3 Se agrega una tabla para los EstatusActual de los domicilios, ya que se consultan vearias veces y esa tabla en particular es pesada
	3.4 Se agregan las secciones de Origen y Destino de dep�sitos y retiros ligados al domicilio de la sucursal de las transacciones. No requiere tabla de configuraci�n.
	3.5 Ejecutar las secciones de pa�s y nacionalidad del archivo [C INSERT DUMMY GEOGRAF�A.sql] para llenar los cat�logos
	3.6 Se agrega IdPaisNacimiento a [@socios y @sociosGeneral], y en las inserciones.
	3.7 Se agrega evaluaci�n de la nacionalidad basandose en aquellas que esten indicadas como GAFI
	3.8 Se agrega la evaludaci�n del n�mero de operaciones, de dep�sito y de retiro para el total de las cuentas del socios en el mes calendario.
	3.9 Se condiciona el grabado en Bd a que tengan valor las 3 tablas de calificaciones, pues se estaban generando encabezados sin detalle.
4. Se modifica el script [0.07 tPLDmatrizConfiguracionNivelesRiesgo] para que las columnas de valor sea decimales, pero validando que si la tabla ya tiene configuraciones las vuelva a colocar en la tabla.

Versi�n: 1.1.1.6
Notas
1. Se agrega funci�n 2.03 fnPLDultimaEvaluacionPorSocio para obtener el nivel de riesgo de uno o todos los socios dependiendo de su �ltima evaluaci�n.
2. Se crea �ndice 0.19 IX_tSDOtransaccionesFinancieras_INC_IdOperacion_IdCuenta
3. Se agrega consulta 3.06 pCnPLDoperacionesMetodoPago
4. Se agrega 2.04 fnPLDemailsCCC para obtener correos del CCC para env�o de correos
5. Se agrega 4.01 trAlertasOficialCumplimiento para detectar alertamientos del oficial de cumplimiento y mandar correo a los miembros del CCC
6. Actualizaci�n 0.21 ALTER COLUMN VALOR 230111 Modificaci�n del tama�o del campo Valor de tPLDmatrizEvaluacionesRiesgoCalificaciones, anteriormente estaba en 10, 
pero empez� a generar un error de desbordamiento cuando se insertaban cantidades muy grandes. No requiere compilaci�n

Versi�n: 1.1.1.7
Notas
1. Se agrega tabla 0.22 tPLDmatrizConfiguracionOrigenDestinoRecursos con los valores iniciales de acuerdo a los dados ded alta en el sistema
2. Se agregan las funciones 2.05 fnPLDorigenesRecursosSocios y 2.06 fnPLDdestinosRecursosSocios que devuelven como filas, las fuentes de ingresos y egresos de los socios. Se acota a que el analisis crediticio pertenezca un un socio y que no sea cero y que el monto en la fuente sea mayor a cero
3. Se agrega la evaluaci�n de la fuentes de ingreso egreso al c�lculo del nivel de riesgo en 3.01 pPLDevaluacionDeRiesgo
4. Se agrega N INSERT DUMMY CANALES con los valores para el tipo 2 de la tabla tPLDmatrizConfiguracionInstrumentosCanales

Versi�n: 1.1.1.8
Notas
1. Se modifica 3.01 pPLDevaluacionDeRiesgo, agregando la validaci�n de la existencia de campos libres para los datos transaccionales, y en consecuencia se use uno u otro m�todo para llenar esa informaci�n.
2. Se modifica 3.02 pCnPLDmatrizEvaluacionNivelDeRiesgo agregando ordenamiento a las consultas resumen y detalle
3. Se agrega 0.23 Parametro Modulo para registrar el par�metro que se usar� para determinar si se usa el m�todo original o el estandar para la evaculaci�n del nivel de riesgo desde erprise en las pantallas de ingreso t 5c's
4. Se agrega 3.07 pPLDevaluacionDeRiesgoDesdeErprise que, evalua el nivel de riesgo del socio con el m�todo estandar y genera el bloque del mismo cuando es de alto riesgo, adem�s de actualizar los campos de nivel de riesgo en la tabla de socios
5. Se modifica 3.08 pPLDdeterminarNivelRiesgoSocio para agregar la evaluaci�n con el m�todo estandar o el original, dependiendo del par�metro

Versi�n 1.1.1.9
Notas
1. Se agrega la tabla 0.24 tPLDmatrizConfiguracionPagosAnticipados
2. Se agrega al c�lculo de la matriz, el n�mero de operaciones declaradas
3. Se agrega al c�lculo de la matriz, porcentaje de anticipo en los pagos de cr�dito
4. Se agrega al c�lculo de la matriz, porcentaje de anticipo en la Liquidaci�n de un cr�dito
5. Se ajustan los cat�logos de Canales de Distribuci�n, M�todos de Pago, Datos Transaccionales.
ejecutar los archivos: 
	5.01 Fix Canales Distribuci�n, 
	5.02 Fix Metodos Pago, 
	5.04 Fix Campos FechaHora tSDOtransaccionFinancieraPagoAdelantadoAnticipado, 
	5.05 Columnas Numero y Montos 2.6,
	5.06 Fix Datos Transaccionales Abiertos, 
	5.07 Fix Titulo pCnSCSoperacionesSocioaltoRiesgo
6. Consulta 3.10 pCnSCSoperacionesSocioAltoRiesgo
7. 3.01 pPLDevaluacionDeRiesgo


Versi�n 1.1.1.10
1. Se crea el 03.11 pADMeliminarConstraints, debe ejecutarse antes del fix del tama�o de los campos de puntos
2. Fix 5.08 Fix Alter Puntos 7-4 de campos de puntos o ponderaci�n, pasan de 5,2 a 7,4 a solicitud de FNG
3. Creaci�n de tabla 0.25 tPLDmatrizConfiguracionFactoresParaNivelRiesgo para controlar la aplicaci�n de factores en el c�lculo, en el mismo script se encuentran los registros de sistema
4. Funci�n 2.07 fnPLDelementoCalculoNivelRiesgoActivo para determinar si debe considerarse el elemento como parte del c�lculo OBSOLETE
5. Modificaci�n de 3.01 pPLDevaluacionDeRiesgo 
	5.1 Se carga en una variable de tabla, la configuraci�n de elementos de c�lculo
	5.2 validando en cada elemento si est� activo, se incluye en el c�lculo
6. Se crea 5.09 Agregado de columnas Categoria1 y Catagoria2 a los tPLDconfiguracion
7. Se crea 5.10 Fix paea desactivar par�metros obsoletos
8. Se crea 5.11 Nuevo par�metro para controlar si se desea excluir la transaccionalidad declarada a partir del segundo c�lculo por socio.
9. Se crea 2.08 ifPLDsociosYaEvaluados para obtener los socios con al menos una evaluaci�n
10. se Actualiza las descripciones y valorers de la tabla tPLDmatrizConfiguracionPagoAnticipado, asi como tambien se cambia el tipo de dato de los campos IdValor1 e IdValor2 de int a DECIMAL(7, 4)


