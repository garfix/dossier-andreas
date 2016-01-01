<?php
if (!$initialized) die();

class Mailer
{
	public static function send($email, $subject, $content)
	{
		if (!$email) {
			return;
		}
		
		$to = $email;
		$message = $content;
		$headers = "From: " . "Dossier Andreas" . " <" . "noreply@dossier-andreas.net" . ">\r\n";

		mail($to, $subject, $message, $headers);
		mail('patrick.vanbergen@gmail.com', $subject, $message, $headers);
	}
}
