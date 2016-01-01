<?php
if (!$initialized) die();

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$email = isset($_REQUEST['email']) ? $_REQUEST['email'] : null;
$fullname = isset($_REQUEST['fullname']) ? $_REQUEST['fullname'] : null;
$password = isset($_REQUEST['password']) ? $_REQUEST['password'] : null;
$code = isset($_REQUEST['code']) ? $_REQUEST['code'] : null;

switch ($action) {
	case 'start':
		$User->showRegistrationForm();
	    break;
	case 'new':
		$code = $User->createRegistration($email, $fullname, $password);
		$User->sendInvitationEmail($fullname, $email, $password, $code);
		$Output->notify("Within a few minutes, you will be sent an e-mail that contains a link back to this website.
			Click the link to complete the registration.");
		break;
	case 'acknowledge':
		$registrationId = $User->getRegistrationId($code);
		if ($registrationId) {
			$userId = $User->createFromRegistration($registrationId);
			$User->removeRegistration($registrationId);
			$Output->notify("Registration complete.");
		} else {
			die('Registration failed. Please notify the webmaster.');
		}
		break;
	case 'lost':
		break;
}

$User->removeOutdatedRegistrations();
