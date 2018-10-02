<?php
include 'lib/functions.php';
include 'config.php';

$filename=null;
if (isset($_GET["router"])){
	$filename=$config['routerBackup']."/".basename($_GET["router"]).".".$config['routerBackupExt'];
}

if (file_exists($filename)){
	header('Pragma: public');
	header('Expires: 0');
	header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
	header('Cache-Control: private', false); // required for certain browsers 
	header('Content-Type: application/pdf');

	header('Content-Disposition: attachment; filename="'. basename($filename) . '";');
	header('Content-Transfer-Encoding: binary');
	header('Content-Length: ' . filesize($filename));

	readfile($filename);
}