rrc2software @ NetworkDeviceBackup
==================================

Basado en RANCID (http://www.shrubbery.net/rancid/)

Esta aplicación está destinada a realizar copias de seguridad de dispositivos de red. Además dispone de una interfaz Web con las cual podemos ver en todo momento el resultado de la última copia de seguridad y descargar las copias de seguridad en cualquer lugar.

Tecnología utilizada
--------------------

Para poder realizar las acciones necesarias, se ha hecho uso de las siguientes aplicaciones:

- Apache HTTP Server y PHP, para la interfaz Web.
- Shell, para la aplicación principal.
- Shell y Expect, para los módulos de copia de seguridad.

Instrucciones de instalación
----------------------------

> **IMPORTANTE**: El instalador setup.sh sólo se ha probado con las distribuciones CentOS 6.x/7.x y RHEL 6.x/7.x.

```
cd /path/to/source
sh setup.sh -a prerequisites
sh setup.sh -a install -p /user/local/rrcndb
systemctl restart httpd
```

Archivos de configuracion
-------------------------

### etc/rrcndb.conf

Este archivo incluye la configuración del binario rrcndb.sh. El archivo que se instala automaticamente con la instalación describe cada uno de las variables y los valores de configuración posibles.

### etc/router.db

Este archivo incluye el listado de todos los dispositivos de los cuales se quiee realizar una copia de seguridad. El formato se describe dentro del propio archivo de configuración instalado 

> Para comentar una linea en este archivo, hay que añadir # al inicio de la misma.

### etc/.cloginrc

Este archivo incluye el listado de usuario y contraseñas que se deben utilizar para poder conectarse a los dispositivos de red. El formato del archivo es el siguiente:

```
add (user|password) DISPOSITIVO VALOR
```

* (user|password) se utiliza para indicar que la estamos indicando un usuario o una contraseña.
* DISPOSITIVO es el dispositivo al cual corresponde esta información. Si se utiliza el valor *, es válido para todos los dispositivos.
* VALOR indica el valor de usuario o contraseña.

> Si utilizamos * como DISPOSITIVO, esta debe ser la última línea de configuración del archivo.


### etc/config

Archivo de configuración utilizado por los script shell.


### etc/config.exp

Archivo de configuración utilizado por los script expect.