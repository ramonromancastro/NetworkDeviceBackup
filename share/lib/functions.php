<?php
$config=array();
$routerStatus=array();
$routerConfig=array();

function loadFiles(){
	global $config,$routerStatus,$routerConfig;
	
	if (!file_exists($config['routerConfig'])){
		echo "router.db file not found!";
		exit(1);
	}
	else{
		$routerConfig=file($config['routerConfig'],FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
		sort($routerConfig);
	}
	if (file_exists($config['routerStatus'])){
		$routerStatusTmp=file($config['routerStatus'], FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
		foreach ($routerStatusTmp as $router){
			$tmp = explode(":",$router);
			$routerStatus[$tmp[0]]['status']=$tmp[1];
			$routerStatus[$tmp[0]]['model']=$tmp[2];
		}
		asort($routerStatus);
	}
}

function status2Text($status){
	switch ($status) {
		case "enabled":
			return "Activado";
			break;
		case "disabled":
			return "Desactivado";
			break;
		case "ok":
			return "Ok";
			break;
		case "error":
			return "Error";
			break;
		case "skipped":
			return "Ignorado";
			break;
		case "nd":
			return "N/D";
			break;
		default:
			return "N/D";
	}
}

function status2FontAwesome($status){
	switch ($status) {
		case "enabled":
			return "fa-play-circle";
			break;
		case "disabled":
			return "fa-pause-circle";
			break;
		case "ok":
			return "fa-check-circle";
			break;
		case "error":
			return "fa-times-circle";
			break;
		case "skipped":
			return "fa-dot-circle";
			break;
		case "nd":
			return "fa-question-circle";
			break;
		default:
			return "fa-question-circle";
	}
}

function url_AbsoluteUrl($url=''){
	# Scheme
	$scheme = ((isset($_SERVER['HTTPS'])) && ($_SERVER['HTTPS']=='on'))?'https':'http';
	if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') $scheme = 'https';
	if (isset($_SERVER['FORWARDED']) && preg_match('/proto=([^;]+)/',$_SERVER['FORWARDED'],$matches)) $scheme = $matches[1];
	
	# Host
	$host = $_SERVER['HTTP_HOST'];
	if (isset($_SERVER['HTTP_X_FORWARDED_HOST'])) $host = $_SERVER['HTTP_X_FORWARDED_HOST'];
	if (isset($_SERVER['FORWARDED']) && preg_match('/host=([^;: ]*):?([^; ]*)/',$_SERVER['FORWARDED'],$matches)) $host = $matches[1];
	
	# Port
	if (isset($_SERVER['SERVER_PORT'])) $port = $_SERVER['SERVER_PORT'];
	if (isset($_SERVER['HTTP_X_FORWARDED_PORT'])) $port = $_SERVER['HTTP_X_FORWARDED_PORT'];
	if (isset($_SERVER['FORWARDED']) && preg_match('/host=([^;: ]*):?([^; ]*)/',$_SERVER['FORWARDED'],$matches)) $port = $matches[2];
	$port = ((($scheme == 'http') && ($port != 80)) || (($scheme == 'https') && ($port != 443)))?$port:null;

	return $scheme . '://' . $host . (isset($port)?":$port":'') . $_SERVER['REQUEST_URI'] . $url;
}
?>
