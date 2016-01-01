<?php
$initialized = true;

include(dirname(__FILE__) . '/functions.php');

sanitize_input($_REQUEST);

$module = isset($_REQUEST['module']) ? $_REQUEST['module'] : null;

include('settings.php');
include('DB.class.php');

$GLOBALS['DB'] = new DB($GLOBALS['DB_server'], $GLOBALS['DB_database'], $GLOBALS['DB_user'], $GLOBALS['DB_password']);

include('User.class.php');
include('Output.class.php');
include('CMS.class.php');

switch ($module) {
	case 'registration':
	    include('registration.php');
	    break;
	case 'login':
	    include('login.php');
	    break;
	case 'cms':
	    include('cms.php');
	    break;
}
