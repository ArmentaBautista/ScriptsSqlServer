


CREATE TABLE tNTFnotificaciones
(
    IdNotificacion INT PRIMARY KEY, --identificador de la tabla
    /* JCA.240528 Crear tabla tSYStiposEntidades para almacenar si es un Cliente, Proveedor, Cuenta de Gastos, Fectura, Registro Edo, Registro Efo
    adicionalmente en la tabla de Tipos de Entidades puede mapearse con tablas que actualmente usen para tener los tipos de documento o catálogos
    */
    IdTipoEntidad INT, 
    IdTipo INT, -- para establecer el tipo de la notificación, en este campo se 
    --identificaría  si corresponde a una notificación de edos y efos, vencimiento de certificado o vencimiento de timbres
    Asunto VARCHAR(200), --asunto de la notificacion
    Cuerpo VARCHAR(500), -- texto de la notificación
    IdConfiguracion INT, --identificador de la tabla de relación de configuración de notificaciones
    EstaLeida BIT, --para indicar si la notificación fue leída
    IdUsuarioAsignado INT,  -- id de usuario en caso de que la notificación sea dirigida a un usuario en especifico
    IdGrupo INT, -- Id del grupo si es una notificación para todo un grupo
    EsMasiva BIT, -- Indica si es una notificación de broadcast, para todos los usuarios del sistema 
    IdEstatus INT,
    Alta DATETIME DEFAULT GETDATE()
);

CREATE TABLE tNTFconfiguracion
(
    IdConfiguracion INT PRIMARY KEY, --identificador de la tabla
    IdNotificacion INT FOREIGN KEY REFERENCES tNTFnotificaciones (IdNotificacion),
    Descripcion VARCHAR(200), --descrripción de la configuración de la tabla
    Intervalo INT, -- identificar el intervalo de recurrencia (horas, minutos)
    Recurrencia INT, --el valor de la recurrencia, valor 1 e intervalo en horas, quiere decir que la recurrencia será de cada hora
    /* JCA.240528 crear tabla de tipos de importancia
    */
    IdTipoImportancia VARCHAR(10), --valor que identifique la importancia de la notificación (urgente, alta, media, baja)
    IdEstatus INT,
    Alta DATETIME DEFAULT GETDATE()    
);

CREATE TABLE tNTFbitacora
(
    IdBitacora INT PRIMARY KEY, --identificador de la tabla
    IdNotificacion INT FOREIGN KEY REFERENCES tNTFnotificaciones (IdNotificacion), --identificador de relación de la tabla de notificaciones
    IdUsuario INT FOREIGN KEY REFERENCES cat_usr(id_usr) , --identificador del usuario que envía notificaciones
    /* JCA.240528 Crear tabla tNTFacciones */
    IdAccion INT, -- campo para identificar si la notificación fue enviada o leída
    Alta DATETIME DEFAULT GETDATE()
);