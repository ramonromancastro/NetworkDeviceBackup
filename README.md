![Logo](http://www.rrc2software.com/site/files/rrcnetworkdevicebackup.jpg)

rrc2software @ NetworkDeviceBackup
==================================

Esta aplicación está destinada a realizar copias de seguridad de dispositivos de red. Además dispone de una interfaz Web con las cual podemos ver en todo momento el resultado de la última copia de seguridad y descargar las copias de seguridad en cualquer lugar.

Licencia
--------

NetworkDeviceBackup está publicado bajo la licencia GPLv2.

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

Plugins
-------

- 3com.2800.sh
  - 3Com Baseline 2800-SFP Plus
- 3com.exp
  - 3Com SuperStack 4 Switch 5500G-EI 48-Port (3CR17255-91)
  - 3Com Switch 4200G 24-Port (3CR17661-91)
  - 3Com Switch 4200G 48-Port (3CR17662-91)
- 3com.superstack.exp
  - 3Com SuperStack 3 Switch 4200 Series (3C17300)
- allnet.sh
  - ALLNET 6700
- cisco.exp
  - Cisco Catalyst 2960-S (WS-C2960S-24PS-L)
- cisco.mds.exp
  - Cisco MDS 9148S 16G Multilayer Fabric
- dgs.exp
  - DGS-3120-24PC
  - DGS-3120-24SC
- eternusdx.exp
  - ETERNUS DX80 S2
- fortigate.exp
  - FortiGate 60B (FGT-60B)
  - FortiGate 60C (FGT-60C)
  - FortiGate 200D (FGT-200D)
- fortimanager.exp
  - FortiManager VM64 (FMG-VM64)
- fujitsu.py.cb.eth
  - PY CB Eth Switch/IBP 1Gb 36/12 (A3C40096531)
- fujitsu.py.cb.fc
  - PY CB FC Switch 8Gb 18/8 14 (A3C40106562)
- hh3c.exp
  - HP V1910-24G-PoE (365W) Switch (JE007A)
- hp.exp
  - HP 2530-24G Switch (J9776A)
- hp.officeconnect.ssh.sh
  - HPE OfficeConnect 1920S Switch Series
- hp.officeconnect.web.sh
  - HPE OfficeConnect 1920S Switch Series
- hpp2000.exp
  - HP StorageWorks P2000 G3 iSCSI
- netapp.sh
  - NetApp FAS 2050
- procurve.exp
  - HP ProCurve Switch 2510G-48 (J9280A)
- unifi.controller.api.sh
  - UniFi Network Controller 5.x
  - UniFi Network Controller 6.x
