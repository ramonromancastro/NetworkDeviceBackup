<?php
include 'lib/functions.php';
include 'config.php';

loadFiles();

$query = $_GET['query'];

$json = array(
				"result" => array(
					'cgi' => 'json.php',
					'query_time' => date_timestamp_get(date_create()),
					'query' => $query,
					'result_code' => 0,
					'message' => '',
				),
				'data' => array()
				);

switch ($query){
	case 'status':
		$json['result']['result_code'] = 0;
		$json['result']['message'] = '';
		$json['data']['Ok'] = 0;
		$json['data']['Disabled'] = 0;
		$json['data']['N/A'] = 0;
		$json['data']['Error'] = 0;

		foreach ($routerConfig as $router) {
			$pos = strpos($router, "#");
			if (($pos === false) || ($pos)){
				$items=explode(":",$router);
				if (array_key_exists($items[0],$routerStatus)){
					$json['data'][status2Text($routerStatus[$items[0]]['status'])]++;
				}
				else
					$json['data']['N/A']++;
			}
		}
		break;
	default:
		$json['result']['result_code'] = 1;
		$json['result']['message'] = 'Query not implemented';
}
header('Content-Type: application/json');
echo json_encode($json);
?>
