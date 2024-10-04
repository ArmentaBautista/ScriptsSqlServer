
Version: 1.1.1.4
Notas
1. Se crea el script [0.17 ADD COLUMN Tipo ConfiguracionEdades] para agregar la columna [Tipo] en el órden correcto de la tabla.
2. Se modifica el script [3.01 pPLDevaluacionDeRiesgo] agregando a la evaluación de Edad, la condición del Tipo, basado en el campo [EsMoral] se filtra uno u otro tipo.
3. Se modifica [pPLDf3] para agregar filtro de socios válidos y/o menores y descartar todas las demas personas en el F3 de Socios.
	3.1 Se agregan campos [EsSocioValido], [EsPersonaMoral]
4. Modificación del script [C INSERT DUMMY GEOGRAFÍA]. Se agrega variable de tabla para los asentamientos de socios activos, y se reuse en los llenados posteriores. 
	4.1 Se eliminarn los [GO] entre cursores para dar visiblidad a la variable de tabla.
	4.2 Se cambian los nombres de las variables del último cursor para evitar conflicto con las anteriores, dado el nuevo scope del script
	4.3 Se agrega validación de existencia en los insertados.
5. [2.02 fnPLDobtenerUltimoPerfilSocios]


Version: 1.1.1.5
Notas
1. Crear tabla [0.18 tPLDmatrizConfiguracionTransaccionalidadNumeroOperaciones]
2. Ejecutar M. INSERT DUMMY TRANSACCIONALIDAD NUMERO DE OPERACIONES
3. Actualizar [3.01 pPLDevaluacionDeRiesgo]
	3.1 Se agrego la sección para evaluar el número de transacciones del mes, para menores, mayores y morales.
	3.2 Se modifica la variable de tabla de Financieras para incluir la sucursal.
	3.3 Se agrega una tabla para los EstatusActual de los domicilios, ya que se consultan vearias veces y esa tabla en particular es pesada
	3.4 Se agregan las secciones de Origen y Destino de depósitos y retiros ligados al domicilio de la sucursal de las transacciones. No requiere tabla de configuración.
	3.5 Ejecutar las secciones de país y nacionalidad del archivo [C INSERT DUMMY GEOGRAFÍA.sql] para llenar los catálogos
	3.6 Se agrega IdPaisNacimiento a [@socios y @sociosGeneral], y en las inserciones.
	3.7 Se agrega evaluación de la nacionalidad basandose en aquellas que esten indicadas como GAFI
	3.8 Se agrega la evaludación del número de operaciones, de depósito y de retiro para el total de las cuentas del socios en el mes calendario.
	3.9 Se condiciona el grabado en Bd a que tengan valor las 3 tablas de calificaciones, pues se estaban generando encabezados sin detalle.
4. Se modifica el script [0.07 tPLDmatrizConfiguracionNivelesRiesgo] para que las columnas de valor sea decimales, pero validando que si la tabla ya tiene configuraciones las vuelva a colocar en la tabla.

Versión: 1.1.1.6
Notas
1. Se agrega función 2.03 fnPLDultimaEvaluacionPorSocio para obtener el nivel de riesgo de uno o todos los socios dependiendo de su última evaluación.
2. Se crea índice 0.19 IX_tSDOtransaccionesFinancieras_INC_IdOperacion_IdCuenta
3. Se agrega consulta 3.06 pCnPLDoperacionesMetodoPago
4. Se agrega 2.04 fnPLDemailsCCC para obtener correos del CCC para envío de correos
5. Se agrega 4.01 trAlertasOficialCumplimiento para detectar alertamientos del oficial de cumplimiento y mandar correo a los miembros del CCC
6. Actualización 0.21 ALTER COLUMN VALOR 230111 Modificación del tamaño del campo Valor de tPLDmatrizEvaluacionesRiesgoCalificaciones, anteriormente estaba en 10, 
pero empezó a generar un error de desbordamiento cuando se insertaban cantidades muy grandes. No requiere compilación

Versión: 1.1.1.7
Notas
1. Se agrega tabla 0.22 tPLDmatrizConfiguracionOrigenDestinoRecursos con los valores iniciales de acuerdo a los dados ded alta en el sistema
2. Se agregan las funciones 2.05 fnPLDorigenesRecursosSocios y 2.06 fnPLDdestinosRecursosSocios que devuelven como filas, las fuentes de ingresos y egresos de los socios. Se acota a que el analisis crediticio pertenezca un un socio y que no sea cero y que el monto en la fuente sea mayor a cero
3. Se agrega la evaluación de la fuentes de ingreso egreso al cálculo del nivel de riesgo en 3.01 pPLDevaluacionDeRiesgo
4. Se agrega N INSERT DUMMY CANALES con los valores para el tipo 2 de la tabla tPLDmatrizConfiguracionInstrumentosCanales

Versión: 1.1.1.8
Notas
1. Se modifica 3.01 pPLDevaluacionDeRiesgo, agregando la validación de la existencia de campos libres para los datos transaccionales, y en consecuencia se use uno u otro método para llenar esa información.
2. Se modifica 3.02 pCnPLDmatrizEvaluacionNivelDeRiesgo agregando ordenamiento a las consultas resumen y detalle
3. Se agrega 0.23 Parametro Modulo para registrar el parámetro que se usará para determinar si se usa el método original o el estandar para la evaculación del nivel de riesgo desde erprise en las pantallas de ingreso t 5c's
4. Se agrega 3.07 pPLDevaluacionDeRiesgoDesdeErprise que, evalua el nivel de riesgo del socio con el método estandar y genera el bloque del mismo cuando es de alto riesgo, además de actualizar los campos de nivel de riesgo en la tabla de socios
5. Se modifica 3.08 pPLDdeterminarNivelRiesgoSocio para agregar la evaluación con el método estandar o el original, dependiendo del parámetro

Versión 1.1.1.9
Notas
1. Se agrega la tabla 0.24 tPLDmatrizConfiguracionPagosAnticipados
2. Se agrega al cálculo de la matriz, el número de operaciones declaradas
3. Se agrega al cálculo de la matriz, porcentaje de anticipo en los pagos de crédito
4. Se agrega al cálculo de la matriz, porcentaje de anticipo en la Liquidación de un crédito
5. Se ajustan los catálogos de Canales de Distribución, Métodos de Pago, Datos Transaccionales.
ejecutar los archivos: 
	5.01 Fix Canales Distribución, 
	5.02 Fix Metodos Pago, 
	5.04 Fix Campos FechaHora tSDOtransaccionFinancieraPagoAdelantadoAnticipado, 
	5.05 Columnas Numero y Montos 2.6,
	5.06 Fix Datos Transaccionales Abiertos, 
	5.07 Fix Titulo pCnSCSoperacionesSocioaltoRiesgo
6. Consulta 3.10 pCnSCSoperacionesSocioAltoRiesgo
7. 3.01 pPLDevaluacionDeRiesgo


Versión 1.1.1.10
1. Se crea el 03.11 pADMeliminarConstraints, debe ejecutarse antes del fix del tamaño de los campos de puntos
2. Fix 5.08 Fix Alter Puntos 7-4 de campos de puntos o ponderación, pasan de 5,2 a 7,4 a solicitud de FNG
3. Creación de tabla 0.25 tPLDmatrizConfiguracionFactoresParaNivelRiesgo para controlar la aplicación de factores en el cálculo, en el mismo script se encuentran los registros de sistema
4. Función 2.07 fnPLDelementoCalculoNivelRiesgoActivo para determinar si debe considerarse el elemento como parte del cálculo OBSOLETE
5. Modificación de 3.01 pPLDevaluacionDeRiesgo 
	5.1 Se carga en una variable de tabla, la configuración de elementos de cálculo
	5.2 validando en cada elemento si está activo, se incluye en el cálculo
6. Se crea 5.09 Agregado de columnas Categoria1 y Catagoria2 a los tPLDconfiguracion
7. Se crea 5.10 Fix paea desactivar parámetros obsoletos
8. Se crea 5.11 Nuevo parámetro para controlar si se desea excluir la transaccionalidad declarada a partir del segundo cálculo por socio.
9. Se crea 2.08 ifPLDsociosYaEvaluados para obtener los socios con al menos una evaluación




