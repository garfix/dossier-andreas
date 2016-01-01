<?php
if (!$initialized) die();

class Output
{
	public function error($text)
	{
		$this->showPage("
			<div class='error'>$text</div><br />
			<a href='javascript:history.back();'>&laquo; Back</a>
		");
	}
	public function notify($text)
	{
		$this->showPage("
			<div class='success'>$text</div><br />
			<a onclick='window.top.location.href=\"/\"; return false' href=''>Continue &raquo;</a>
		");
	}

	public function showPage($body)
	{
		$dir = '../resources';
		echo "
		    <HTML>
			<HEAD>
			<LINK href='$dir/stylesheet.css' type='text/css' rel='stylesheet' />
			<TITLE>Dossier Andreas</TITLE>
			</HEAD>
			<BODY link='#004080' alink='#400000' vlink='#D9CEBC'>
			<table width='100%' height='100%' class='text'>
			    <tr><td valign='top' align='center'>$body</td></tr>
			</table>
			</BODY>
			</HTML>
		";
	}
}

$GLOBALS['Output'] = new Output();