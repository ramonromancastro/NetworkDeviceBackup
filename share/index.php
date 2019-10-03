<?php
	include 'lib/functions.php';
	include 'config.php';
	setlocale(LC_ALL,$config['locale']);

	loadFiles();
	
	$summary["ok"]=0;
	$summary["disabled"]=0;
	$summary["skipped"]=0;
	$summary["error"]=0;
	$summary["nd"]=0;
	$total=0;
	$lastBackupDate=(file_exists($config['routerStatus']))?filemtime($config['routerStatus']):null;

	foreach ($routerConfig as $router) {
		$pos = strpos($router, "#");
		if (($pos === false) || ($pos)){
			$total++;
			$items=explode(":",$router);
			$device=$items[0];
			$enabled=$items[2];
			if ($enabled != "disabled"){
				if (array_key_exists($device,$routerStatus))
					$summary[$routerStatus[$device]['status']]++;
				else
					$summary["nd"]++;
			}
			else
				$summary["disabled"]++;
		}
	}
?>
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<!-- OpenGraph $ more -->
	<meta name="author" content="info@rrc2software.com">
	<meta name="description" content="Copias de seguridad de dispositivos de red." />
	<meta property="og:title" content="rrc2software @ rrcNetworkDeviceBackup" />
	<meta property="og:type" content="website" />
	<meta property="og:image" content="<?php echo url_AbsoluteUrl("images/header.jpeg"); ?>" />
	<meta property="og:url" content="<?php echo url_AbsoluteUrl(); ?>" />
	<meta property="og:description" content="Copias de seguridad de dispositivos de red." />
	<meta property="og:locale" content="es_ES" />
	<meta property="og:site_name" content="rrc2software @ rrcNetworkDeviceBackup" />
	<title>rrc2software @ rrcNetworkDeviceBackup</title>

	<!--[if IE]><link rel="shortcut icon" href="favicon.ico"><![endif]-->
	<!-- W3.CSS -->
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> 
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Oswald">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open Sans">
	
	<!-- Font Awesome -->
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
	
	<!-- favicon.ico -->
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
	<link rel="icon" href="favicon.ico" type="image/x-icon">
	
	<!-- Custom Styles -->
	<link rel="stylesheet" href="css/custom.css"> 
</head>
<body class="w3-light-grey">
	<div class="w3-bar w3-black w3-hide-small">
	  <a href="http://www.rrc2software.com" class="w3-bar-item w3-button" title="www.rrc2software.com"><i class="fas fa-link"></i></a>
	  <span class="w3-bar-item w3-right">Desarrollado por rrc2software</span>
	</div>
	<div class="w3-content" style="max-width:1600px">
		<header class="w3-container w3-center w3-padding-48 w3-white">
			<h1 class="w3-xxxlarge"><b>Network Device Backup</b></h1>
			<h6>Copias de seguridad de dispositivos de red por <a href="http://www.rrc2software.com"><span class="w3-tag">rrc2software</span></a></h6>
		</header>
		<header class="w3-display-container w3-wide" id="home">
			<img class="w3-image" src="images/header.jpeg" alt="" width="1600" height="1067">
			<div class="w3-display-left w3-padding-large">
				<h1 class="w3-text-white">rrc2software's</h1>
				<h1 class="w3-jumbo w3-text-white w3-hide-small"><b>Network Device Backup</b></h1>
				<h6>
					<a href="#informe" class="w3-button w3-white w3-padding-large w3-large w3-opacity w3-hover-opacity-off">Informe de estado<?php if (file_exists($config['routerPID'])) echo "<br/><span class='w3-small w3-text-gray'>Ejecución en curso...<span>"; fi ?></a>
					
				</h6>
			</div>
		</header>
		<div class="w3-row w3-padding w3-border">
			<div class="w3-col l8 s12">
<?php
if (file_exists($config['routerPID'])){ ?>
				<div class="w3-container w3-orange w3-margin w3-padding-large">
					<div class="w3-center">
						<h3>PROCESO DE COPIA DE SEGURIDAD EN CURSO</h3>
						<h5>El proceso de copia de seguridad de los dispositivos de red se encuentra actualmente en ejecución con el identificador de proceso (PID) <?php echo file_get_contents($config['routerPID']); ?></h5>
					</div>
				</div>
<?php } ?>
				<div class="w3-container w3-white w3-margin w3-padding-large">
					<div class="w3-center">
						<h3>RESUMEN DE ESTADO</h3>
						<h5>Resumen del estado de la última ejecución del script de copias de seguridad</h5>
					</div>
					<div class="w3-row-padding my-summary">
						<div class="w3-col l2"><div class="w3-card w3-container w3-center"><span class="w3-small">Total</span><br/><span class="w3-xxlarge"><?php echo $total; ?></span></div></div>
						<div class="w3-col l2"><div class="w3-card w3-green w3-container w3-center"><span class="w3-small">Ok</span><br/><span class="w3-xxlarge"><?php echo $summary["ok"]; ?></span></div></div>
						<div class="w3-col l2"><div class="w3-card w3-red w3-container w3-center"><span class="w3-small">Error</span><br/><span class="w3-xxlarge"><?php echo $summary["error"]; ?></span></div></div>
						<div class="w3-col l2"><div class="w3-card w3-gray w3-container w3-center"><span class="w3-small">Desactivado</span><br/><span class="w3-xxlarge"><?php echo $summary["disabled"]; ?></span></div></div>
						<div class="w3-col l2"><div class="w3-card w3-blue w3-container w3-center"><span class="w3-small">Ignorado</span><br/><span class="w3-xxlarge"><?php echo $summary["skipped"]; ?></span></div></div>
						<div class="w3-col l2"><div class="w3-card w3-orange w3-container w3-center"><span class="w3-small">N/D</span><br/><span class="w3-xxlarge"><?php echo $summary["nd"]; ?></span></div></div>
					</div>
				</div>
				<div class="w3-container w3-white w3-margin w3-padding-large">
					<div class="w3-center">
						<a id="informe"></a>
						<h3>INFORME DE ESTADO</h3>
						<h5>Informe de estado de la última ejecución del script de copias de seguridad, el día <span class="w3-opacity"><?php echo ($lastBackupDate)?strftime($config['strftime'],$lastBackupDate):"Desconocido";?></span>.</h5>
					</div>
					<div>
						<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Buscar por dispositivo.." title="Escribe un nombre">
						<table id="myTable" class="w3-table w3-striped w3-border w3-bordered">
							<thead>
								<th class="w3-black">Dispositivo</th>
								<th class="w3-black">Configuración</th>
								<th class="w3-black">Backup</th>
								<th class="w3-black">Copia de seguridad disponible</th>
								<th class="w3-black">Acciones</th>
							</thead>
							<tbody>
<?php foreach ($routerConfig as $router) {
		$pos = strpos($router, "#");
		if (($pos === false) || ($pos)){
			$items=explode(":",$router);
			$enable=$items[2];
			if (array_key_exists($items[0],$routerStatus)){
				$status=$routerStatus[$items[0]]['status'];
			}
			else
				$status="nd";
			if ($enable == 'down') $status="disabled";
			
			if (file_exists($config['routerBackup']."/".$items[0].".".$config['routerBackupExt']))
				$lastBackup=date($config['dateFormat'],filemtime($config['routerBackup']."/".$items[0].".".$config['routerBackupExt']));
			else
				$lastBackup="";	
?>
				
				<tr class="<?php echo ($status=='error')?'w3-pale-red':''; ?>">
					<td>
						<i class="fas fa-cube fa-fw" aria-hidden="true"></i> <?php echo $items[0]; ?>
						<?php if (!empty($items[3])){?><span class="w3-tiny w3-text-gray"> (<?php echo $items[3]; ?>)</span><?php } ?>
						<?php if (!empty($routerStatus[$items[0]]['model'])){?><br/><span class="w3-tiny w3-text-gray"><?php echo $routerStatus[$items[0]]['model']; ?></span><?php } ?>
					</td>
					<td class="text-center"><i class="fa fa-2x <?php echo status2FontAwesome($enable); ?> fa-fw" aria-hidden="true"></i><span class="sr-only"><?php echo status2Text($enable); ?></span></td>
					<td class="text-center"><i class="fa fa-2x <?php echo status2FontAwesome($status); ?> fa-fw" aria-hidden="true"></i><span class="sr-only"><?php echo status2Text($status); ?></span></td>
					<td><?php echo $lastBackup; ?></td>
					<td>
					<?php if ($lastBackup != '') { ?>
						<a href="download.php?router=<?php echo urlencode($items[0]); ?>" title="Descargar">
							<i class="fas fa-cloud-download-alt fa-2x fa-fw" aria-hidden="true"></i><span class="sr-only">Descargar</span>
						</a>
					<?php } ?>
					</td>
				</tr>
<?php 
			}
		}
?>
							<tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="w3-col l4">
				<!-- About Card -->
				<div class="w3-white w3-margin my-slide">
					<img src="images/ramon.jpg" alt="Ramón Román Castro" class="w3-image w3-grayscale-max">
					<div class="w3-container w3-black" style="min-height:250px;">
						<h4>Ramón Román Castro</h4>
						<p>Llevo más de 15 años dedicándome al mundo de la informática. Desde los últimos 10 años me he dedicado a la administración de sistemas, creando herramientas Web para facilitar mi trabajo diario.</p>
						<p>
							<a href="https://github.com/ramonromancastro" class="w3-bar-item w3-button" title="GitHub"><i class="fab fa-github"></i></a>
							<a href="https://es.linkedin.com/in/ramonromancastro" class="w3-bar-item w3-button" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
							<a href="http://www.rrc2software.com" class="w3-bar-item w3-button" title="www.rrc2software.com"><i class="fas fa-link"></i></a>
						</p>
					</div>
				</div>
				<div class="w3-white w3-margin my-slide">
					<img src="images/about.jpg" alt="Rodrigo Román Castro" class="w3-image w3-grayscale-max">
					<div class="w3-container w3-black" style="min-height:250px;">
						<h4>Rodrigo Román Castro</h4>
						<p>Estoy especializado en seguridad, sensores y en Internet de las cosas (IoT). En mis ratos libres me dedico a hacer mis pinitos en el mundo de los videojuegos para consolas móviles.</p>
						<p>
							<a href="https://github.com/rrc2soft" class="w3-bar-item w3-button" title="GitHub"><i class="fab fa-github"></i></a>
							<a href="https://es.linkedin.com/in/rodrigoromancastro/es" class="w3-bar-item w3-button" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
							<a href="https://itunes.apple.com/us/developer/rodrigo-roman/id1240952240" class="w3-bar-item w3-button" title="App Store"><i class="fab fa-app-store-ios"></i></a>
							<a href="http://www.rodrigoroman.com" class="w3-bar-item w3-button" title="www.rodrigoroman.com"><i class="fas fa-link"></i></a>
							<a href="http://www.rrc2soft.com" class="w3-bar-item w3-button" title="www.rrc2soft.com"><i class="fas fa-link"></i></a>
						</p>
					</div>
				</div>
				<hr/>
				<div class="w3-white w3-margin">
					<div class="w3-container w3-padding w3-black">
						<h4>Leyenda</h4>
					</div>
					<ul class="w3-ul w3-white">
						<li class="w3-padding-16"><i class="w3-left w3-margin-right fas fa-play-circle fa-2x fa-fw"></i><span class="w3-large">Activado</span><br/>Dispositivo activado</li>
						<li class="w3-padding-16"><i class="w3-left w3-margin-right fas fa-pause-circle fa-2x fa-fw"></i><span class="w3-large">Desactivado</span><br/>Dispositivo desactivado</li>
						<li class="w3-padding-16"><i class="w3-left w3-margin-right fas fa-check-circle fa-2x fa-fw"></i><span class="w3-large">Ok</span><br/>Copia de seguridad sin errores</li>
						<li class="w3-padding-16"><i class="w3-left w3-margin-right fas fa-times-circle fa-2x fa-fw"></i><span class="w3-large">Error</span><br/>Errores en la copia de seguridad</li>
						<li class="w3-padding-16"><i class="w3-left w3-margin-right fas fa-dot-circle fa-2x fa-fw"></i><span class="w3-large">Ignorado</span><br/>Copia de seguridad ignorada</li>
						<li class="w3-padding-16"><i class="w3-left w3-margin-right fas fa-question-circle fa-2x fa-fw"></i><span class="w3-large">N/D</span><br/>Estado desconocido</li>
					</ul>
				</div>
			</div>
		</div>
    </div>
	<!-- Footer -->
	<footer class="w3-container w3-dark-grey w3-small" style="padding:32px">
		<div class="w3-row-padding">
			<div class="w3-third">
				<strong>Licencias</strong>
				<ul class="w3-ul my-ul">
					<li>NetworkDeviceBackup está publicado bajo la licencia <a rel="license" href="https://www.gnu.org/licenses/old-licenses/gpl-2.0.html" title="GNU General Public License, version 2">GPLv2</a>.</li>
				</ul>
			</div>
			<div class="w3-third">
				<strong>Versión</strong>
				<ul class="w3-ul my-ul">
					<li>rrc2software @ rrcNetworkDeviceBackup GUI</li>
					<li>v1.0.3</li>
				</ul>
				<strong>Más información</strong>
				<ul class="w3-ul my-ul">
					<li>Para más información, visite nuestra página web <a href="http://www.rrc2software.com">www.rrc2software.com</a>.</li>
				</ul>
			</div>
			<div class="w3-third">
				<strong>Agradecimientos</strong>
				<ul class="w3-ul my-ul">
					<li>Imagen de cabecera por <a href="https://pixabay.com/en/users/Martinelle-495565/">Martinelle</a>.</li>
					<li>Powered by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank">w3.css</a>.</li>
				</p>
			</div>
		</div>
	</footer>
	<script type="text/javascript" src="js/functions.js"></script>
	<script>
	carousel();
	</script>
	<a href="#" id="myBtn" onclick="topFunction()" class="w3-button w3-black w3-padding-large w3-margin-bottom w3-small w3-opacity w3-hover-opacity-off"><i class="fa fa-arrow-up w3-margin-right"></i>Ir al inicio</a>
</body>
</html>
