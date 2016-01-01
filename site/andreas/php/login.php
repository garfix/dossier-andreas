<?php
if (!$initialized) die();

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$email = isset($_REQUEST['email']) ? $_REQUEST['email'] : null;
$password = isset($_REQUEST['password']) ? $_REQUEST['password'] : null;
$returnPageId = isset($_REQUEST['returnPageId']) ? $_REQUEST['returnPageId'] : null;

switch ($action) {
	case 'login':
	    if (!$email && !$password) {

			$form = "
			    <form method='post'><table>
			        <tr><td colspan='2'>
					    <b>Forgot your password or want to change your name?<br />Just <a href='/andreas/php/andreas.php?module=registration&action=start'>reregister</a> with the same e-mail address (you will keep your notes).</b><br/><br/></td></tr>
					<tr><td>E-mail</td><td><input name='email' size='30' type='text' /></td></tr>
			        <tr><td>Password</td><td><input name='password' size='10' type='password' /></td></tr>
			        <tr><td></td><td><input type='submit' value='Log in'></td></tr>
			    </table></form>
			";
			$Output->showPage($form);

	    } elseif (!$User->login($email, $password)) {
			$Output->error("Incorrect e-mail address or password.");
		} else {
			if ($returnPageId) {
				setcookie("page", 'p1_' . $returnPageId . ".php#yournote", strtotime("+3 seconds"), '/');
				echo "<html><head><script>window.top.location.href='/';</script></head><body></body></html>";
			} else {
				$Output->notify("Login complete.");
			}
		}
	    break;
	case 'logout':
		$User->logout();
		$Output->notify("You are logged out.");
	    break;
}