<?php

set_time_limit(600);

$years = array();
$pages = array();
$agents = array();
$users = array();

if (!$handle = fopen('../cgi-bin/hit.txt', 'r')) {
	die('unable to open hit.txt');
}
$i = 0;
while (!feof($handle)) {
	$line = fgets($handle, 4096);
	list($id, $remote_host, $page, $datetime, $useragent, $app) = explode("\t", $line);
	list($mday, $month, $year, $hour, $min) = sscanf($datetime, '%d/%d/%d %d %d');
	
	// page counts
	/*if (!isset($pages[$page])) {
		$pages[$page] = 0;
	}
	$pages[$page]++;

	if (!isset($items[$year][$month])) {
		$items[$year][$month] = array();
		$month = &$items[$year][$month];
		$month[''];
	}
	
	
	// user agents
	if (!isset($agents[$useragent])) {
		$agents[$useragent] = 0;
	}
	$agents[$useragent]++;
*/
	// users
	if (!isset($users[$id])) {
		$users[$id] = 0;
	}
	$users[$id]++;

	//echo $mday . '-' . $year . '<br/>';
	if ($i++ == 100000) break;
}
fclose($handle);

/*
echo "<table border='1'>";
foreach ($pages as $name => $count) {
	echo '<tr><td>' . $name . '</td><td>' . $count . '</td></tr>';
}
echo "</table>";

echo "<table border='1'>";
foreach ($agents as $name => $count) {
	echo '<tr><td>' . $name . '</td><td>' . $count . '</td></tr>';
}
echo "</table>";
*/
echo "<table border='1'>";
foreach ($users as $name => $count) {
	echo '<tr><td>' . $name . '</td><td>' . $count . '</td></tr>';
}
echo "</table>";
?>