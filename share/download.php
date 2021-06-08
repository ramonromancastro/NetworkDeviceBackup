<?php
include 'lib/functions.php';
include 'config.php';

$filename=null;
if (isset($_GET["router"])){
	$filename=$config['routerBackup']."/".basename($_GET["router"]).".".$config['routerBackupExt'];
	if (($realpath = realpath($filename)) === FALSE) die('Se ha detectado un intento de acceso no deseado al sistema de archivos.');
	if (($pos = strpos($realpath,$config['routerBackup'])) === FALSE) die('Se ha detectado un intento de acceso no deseado al sistema de archivos.');
	if ($pos) die('Se ha detectado un intento de acceso no deseado al sistema de archivos.');
}

if (file_exists($realpath)){
	header('Pragma: public');
	header('Expires: 0');
	header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
	header('Cache-Control: private', false); // required for certain browsers 
	// header('Content-Type: application/pdf');
        header('Content-Type: application/octet-stream');
	header('Content-Disposition: attachment; filename="'. basename($realpath) . '";');
	header('Content-Transfer-Encoding: binary');
	header('Content-Length: ' . filesize($realpath));

	readfile($realpath);
}
