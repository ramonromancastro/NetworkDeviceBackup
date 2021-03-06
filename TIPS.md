
Install FTP server (if you doesnt have on)
------------------------------------------

```
[root@server]# yum install vsftpd ftp
[root@server]# nano /etc/vsftpd/vsftpd.conf
...
anonymous_enable=NO
ascii_upload_enable=YES
ascii_download_enable=YES
use_localtime=YES
chroot_local_user=YES
...
[root@server]# service vsftpd start
[root@server]# chkconfig vsftpd on
```

NetApp FAS (netapp.sh)
----------------------

```
### ON NetAPP:

NetApp> qtree security <volume> unix
NetApp> exportfs
...
<volume> -sec=sys,ro=<ipaddress>,root=<ipaddress>,nosuid
...

### ON rrcndb server:

[root@server]# nano /etc/ssh/ssh_config
...
# Comment all "SendEnv" lines
...
[root@server]# nano <BASEDIR>/lib/netapp.sh
...
netappVolumeName=<volume>
...
```

Enable SSH on Procurve
----------------------

[community.spiceworks.com](http://community.spiceworks.com/how_to/show/2403-configure-ssh-on-hp-procurve-switches)

```
device# config
device(config)# crypto key generate ssh
device(config)# ip ssh
device(config)# write memory
device(config)# end
```

Enable SSH on D-Link
--------------------

```
device:user#enable ssh
```

Enable SSH on 3Com
------------------

```
<switch>system-view
[switch]rsa local-key-pair create
1024
[switch]user-interface vty 0 4
[switch]authentication-mode scheme
[switch]protocol inbound ssh # or 'all' if you want telnet access too
[switch]quit
[switch]local-user <USERNAME>
[switch]password simple <PASSWORD>
[switch]service-type ssh
[switch]quit
<switch>ssh user <USERNAME> authentication-type password
<switch>save
```


Useful NFS commands
-------------------

```
showmount -e <netapp>
showmount <netapp>
exportsfs -h
exportfs -c <host> <path>
```


Enable SSH on HPE 1920s OfficeConnect 
-------------------------------------------------------

[community.hpe.com](https://community.hpe.com/t5/Web-and-Unmanaged/How-to-Enable-Telnet-and-SSH-on-HPE-1920s-OfficeConnect/m-p/7008940/highlight/true#M3852)

1. Descargar la versión de PD.02.06 de https://h10145.www1.hpe.com/downloads/DownloadSoftware.aspx?SoftwareReleaseUId=24306&ProductNumber=JL385A&lang=&cc=&prodSeriesId=&SaidNumber=.
2. Actualizar el firmware del switch mediante la interfaz Web.
3. Descargar startup-config desde la interfaz Web del switch.
4. Editar startup-config e insertar la cadena ```insert ip telnet server enable``` antes de ```configure```.
5. Subir startup-config al switch desde la interfaz Web.
6. Reiniciar el switch.
7. Conectarse mediante telnet al switch y ejecutar los siguientes comandos:

```
(HPE)> enable
(HPE)# configure
(HPE)# crypto key generate rsa
(HPE)# crypto key generate dsa
(HPE)# exit
(HPE)# ip ssh server enable
(HPE)# ip ssh protocol 2
(HPE)# write memory confirm
(HPE)# quit
```

8. Si se desea deshabilitar telnet, conectarse mediante ssh al switch y ejecutar los comandos:

```
(HPE)> enable
(HPE)# no ip telnet server enable
(HPE)# write memory confirm
(HPE)# quit
```

WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
------------------------------------------------

Add correct host key in /root/.ssh/known_hosts to get rid of this message.
