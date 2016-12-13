<?php
if (!$initialized) die();

include('Mailer.class.php');

class User
{
	protected $id = null;
	protected $fullname = null;
	protected $email = null;

	public function __construct()
	{
		@session_start();

		if (!empty($_SESSION['user_id'])) {
			$this->id = $_SESSION['user_id'];
			$this->loadUserData();
		}
	}

	public function getId()
	{
		return $this->id;
	}

	public function setId($id)
	{
		$this->id = $id;
		$_SESSION['user_id'] = $id;
	}

	public function isLoggedIn()
	{
		return (bool)$this->id;
	}

	public function getFullname()
	{
		return $this->fullname;
	}

	public function getEmail()
	{
		return $this->email;
	}

	protected function loadUserData()
	{
		if (!$this->id) {
			return;
		}

		$data = $GLOBALS['DB']->getHashtable("
		    SELECT * from user WHERE id = $this->id
		");
		$this->fullname = $data['fullname'];
		$this->email = $data['email'];
	}

	public function login($email, $password)
	{
		$userId = $GLOBALS['DB']->getCell("
		    SELECT id FROM user WHERE email = '$email' AND password = '$password'
		");
		if ($userId) {
			$this->id = $userId;
			$this->loadUserData();
		}

		$_SESSION['user_id'] = $userId;

		return ($userId ? $userId : false);
	}

	public function logout()
	{
		$_SESSION['user_id'] = 0;
	}

	public function showRegistrationForm()
	{
        $html = "
			    <form action='/andreas/php/andreas.php?module=registration&action=new' method='post'>
			    <table class='section' style='width:500px !important'>
			    <caption class='sectionCaption'>Registration</caption>
					<tr><td colspan='2'>
					    <b>Registration allows you to add notes to any page of the website.</b><br/><br/></td></tr>
					<tr><td>Name</td><td><input type='text' name='fullname' size='50' /></td></tr>
					<tr><td>Password</td><td><input type='password' name='password' size='10' /></td></tr>
					<tr><td>E-mail address</td><td><input type='text' name='email' size='30' /></td></tr>
			        <tr><td><input type='submit' value='Submit'/></td></tr>
			    </table>
			    </form>
			";
		$GLOBALS['Output']->showPage($html);
	}

	public function createRegistration($email, $fullname, $password)
	{
		$code = sha1(rand(0, PHP_INT_MAX));
		$start = time();
		$dbEmail = $GLOBALS['DB']->escape($email);
		$dbFullname = $GLOBALS['DB']->escape($fullname);
		$dbPassword = $GLOBALS['DB']->escape($password);
		$GLOBALS['DB']->query("
		    INSERT INTO registration VALUES (0, '$code', $start, '$dbEmail', '$dbPassword', '$dbFullname');
		");
		return $code;
	}

	public function getRegistrationId($code)
	{
		$dbCode = $GLOBALS['DB']->escape($code);
		return $GLOBALS['DB']->getCell("SELECT id FROM registration WHERE code = '$dbCode'");
	}

	public function sendInvitationEmail($fullname, $email, $password, $code)
	{
		$subject = 'Dossier Andreas - registration';
		$link = "http://www.dossier-andreas.net/andreas/php/andreas.php?module=registration&action=acknowledge&code=$code";
		$content = "Hello $fullname,\n\n" .
			"This mail is sent to you to confirm that you want to register with Dossier Andreas. " .
			"Click this link to complete your registration.\n\n" .

			"$link \n\n" .

			"Your password is: $password (save this password, you need it later)\n\n" .

			"Welcome!\n\n" .

			"Webmaster Dossier Andreas,\n" .
			"Patrick van Bergen";
		Mailer::send($email, $subject, $content);
	}

	public function removeOutdatedRegistrations()
	{
		$time = strtotime('-1 week');
		$GLOBALS['DB']->query("
		    DELETE FROM registration WHERE start_timestamp < $time
		");
	}

	public function createFromRegistration($registrationId)
	{
		$data = $GLOBALS['DB']->getHashtable("
		    SELECT * FROM registration WHERE id = $registrationId
		");

		// if the e-mail address already existed, username and password will be updated
		$userId = $GLOBALS['DB']->getCell("
		    SELECT id FROM user WHERE email = '$data[email]'
		");

		if ($userId) {
			// update
			$GLOBALS['DB']->query("
			    UPDATE user
				SET fullname = '$data[fullname]', password = '$data[password]'
				WHERE id = $userId
			");
		} else {
			// new
			$GLOBALS['DB']->query("
			    INSERT INTO user
				VALUES (0, '$data[email]', '$data[fullname]', '$data[password]')
			");
			$userId = $GLOBALS['DB']->getCell("SELECT last_insert_id()");
		}

		$this->setId($userId);

		return $userId;
	}

	public function removeRegistration($registrationId)
	{
		$GLOBALS['DB']->query("
		    DELETE FROM registration WHERE id = $registrationId
		");
	}

	public function showStatus()
	{
		if ($this->id) {
			$html = "<font color='red'>" . htmlspecialchars($this->fullname) .
			"</font> Log out <a href='php/andreas.php?module=login&action=logout' target='andreas'>
				<img width='18' height='18' border='0' src='resources/key.gif' /></a>";
		} else {
			$html = "Log in <a href='php/andreas.php?module=login&action=login' target='andreas'>
				<img width='18' height='18' border='0' src='resources/key.gif' /></a>";
		}
		echo $html;
	}
}

$GLOBALS['User'] = new User();
