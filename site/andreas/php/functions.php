<?php
if (!$initialized) die();

function gotoPage($pageId, $hash = null)
{
	$hash = $hash ? "#$hash" : "";
	header("Location: /andreas/p1_$pageId.php$hash");
}

/**
 * The server uses magic_quotes_gpc, and this corrupts the input.
 */
function sanitize_input()
{
	if (get_magic_quotes_gpc()) {
		$_REQUEST = array_map('stripslashes', $_REQUEST);
	}
}