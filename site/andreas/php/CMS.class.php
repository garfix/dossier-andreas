<?php
if (!$initialized) die();

class CMS
{	public function showUserComments($pageId, $title)
	{
		// add page information to database, if not available
		if ($GLOBALS['DB']->getCell("SELECT COUNT(*) FROM page WHERE id = '$pageId'") == 0) {
			$dbTitle = DB::escape($title);
			$GLOBALS['DB']->query("INSERT INTO page VALUES ('$pageId', '$dbTitle')");
		}
		
		$html = "";

		if ($GLOBALS['User']->isLoggedIn()) {
			$html .= "
			    <a name='yournote'></a>
			    <form action='/andreas/php/andreas.php?module=cms&action=add' method='post'>
			    <table class='section'>
			    <caption class='sectionCaption'>Your note</caption>
					<tr><td><textarea name='content' cols='80' rows='5'></textarea></td></tr>
			        <tr><td><input type='submit' value='Submit'/></td></tr>
			    </table>
			    <input type='hidden' name='page_id' value='$pageId' />

			    </form>
			";
		} else {
			$html .= "
			    <table class='section'>
			    <caption class='sectionCaption'>Your note</caption>
			        <tr><td><div class='note'>
						<a href='/andreas/php/andreas.php?module=login&amp;action=login&amp;returnPageId=$pageId'>Log in</a> to add a note.<br /><br />
			        	You need to <a href='/andreas/php/andreas.php?module=registration&amp;action=start'>register</a> (only name, e-mail address, and password) to add notes to the pages of the site.
					</div></td></tr>
			    </table>
			";
		}

		$rows = $GLOBALS['DB']->getRows(sprintf("
			SELECT
				note.id as note_id, note.created_timestamp, note.last_changed_timestamp, note.content,
				user.id as user_id, user.fullname
			FROM note
			INNER JOIN user ON user.id = note.user_id
			WHERE page_id = '%s' ORDER BY created_timestamp DESC
		", $pageId));
		if (count($rows) > 0) {

			$notes = "";
			foreach ($rows as $row) {
				$timeHTML = date("j F Y, H:i", $row["created_timestamp"]);
				if ($row['last_changed_timestamp'] != $row['created_timestamp']) {
					$timeHTML .= ";&nbsp;&nbsp;&nbsp;last edit: " . date("j F Y, H:i", $row["last_changed_timestamp"]);
				}

				if ($row['user_id'] == $GLOBALS['User']->getId()) {
					$editHTML = "&nbsp;&nbsp;<a href='/andreas/php/andreas.php?module=cms&action=edit&note_id=$row[note_id]'>Edit your note</a>";
				} else {
					$editHTML = "";
				}

				$notes .= "<a name='note_$row[note_id]'></a>";
				$notes .= "<h4>" . htmlspecialchars($row["fullname"]) . "&nbsp;&nbsp;&nbsp;($timeHTML)$editHTML</h4>";
				$notes .= "<p>" . $this->clean($row["content"]) . "</p>";
			}

			$html .= "
				<table class='section'>
			    <caption class='sectionCaption'>User contributed notes</caption>
			        <tr><td><div class='note'>
						$notes
					</div></td></tr>
			    </table>
			";
		}
		
		echo $html;
	}

	public function showNoteEditForm($noteId)
	{
		$row = $GLOBALS['DB']->getHashtable("
		    SELECT note.content
		    FROM note
		    WHERE note.id = $noteId
		");
		$content = htmlspecialchars($row['content']);
		$html = "
		    <form action='/andreas/php/andreas.php?module=cms&action=edit&note_id=$noteId' method='post'>
		    <table class='section'>
		    <caption class='sectionCaption'>Your note</caption>
				<tr><td><textarea name='content' cols='80' rows='5'>$content</textarea></td></tr>
		        <tr><td><input type='submit' name='submit' value='Submit'/></td></tr>
		    </table>
		    </form>
		";
		$GLOBALS['Output']->showPage($html);
	}

	public function showLatestNotes($personal = false)
	{
		$caption = $personal ? "Your notes" : "User contributed notes";
		$explanation = $personal ? "" :
			"A list of the latest notes made by different users on various pages of the website.&nbsp;&nbsp;
				RSS Feed: <A href='/andreas/_andreas_notes.xml' target='external'><img src='/andreas/resources/xml.gif' /></A>";

		if ($GLOBALS['User']->isLoggedIn() && !$personal) {
			$myNotesLink = "&nbsp;&nbsp;&nbsp;<a href='/andreas/php/andreas.php?module=cms&action=my_notes'>Show my notes only</a>";
		} else {
			$myNotesLink = "";
		}

		$rows = $this->getLatestNotes($personal);
		if (count($rows) > 0) {

			$notes = "";
			foreach ($rows as $row) {
				$timeHTML = date("j F Y, H:i", $row["created_timestamp"]);
				if ($row['last_changed_timestamp'] != $row['created_timestamp']) {
					$timeHTML .= ";&nbsp;&nbsp;&nbsp;last edit: " . date("j F Y, H:i", $row["last_changed_timestamp"]);
				}

				$notes .= "<h4><a href='/andreas/p1_$row[page_id].php#note_$row[note_id]'>" .
					htmlspecialchars($row["fullname"]) . " on <i>" .
					htmlspecialchars($row["title"]) . "</i>&nbsp;&nbsp;&nbsp;($timeHTML)</a></h4>";
				$notes .= "<p>" . $this->clean($row["content"]) . "</p>";
			}

		} else {
			$notes = "<b>You have not made any notes yet.</p>";
		}

		$html = "
			<table class='section'>
		    <caption class='sectionCaption'>$caption</caption>
		        <tr><td><div class='note'>
		            <p><b>
						$explanation
						$myNotesLink
					</b></p>
					$notes
				</div></td></tr>
		    </table>
		";


		echo $GLOBALS['Output']->showPage($html);
	}
	
	public function showLatestNotesPreview()
	{
		$rows = $this->getLatestNotes(false);

		$notes = "";
		$count = 0;
		foreach ($rows as $row) {
			$timeHTML = date("j F Y, H:i", $row["created_timestamp"]);

			$notes .= "<h4><a href='/andreas/p1_$row[page_id].php#note_$row[note_id]'>" .
				htmlspecialchars($row["fullname"]) . " on <i>" .
				htmlspecialchars($row["title"]) . "</i>&nbsp;&nbsp;&nbsp;($timeHTML)</a></h4>";
			$notes .= "<p>" . strip_tags($this->clean($row["content"])) . "</p>";
			
			$count++;
			if ($count == 4) {
				break;
			}
		}
			
		$notes .= "<p><a href='/andreas/php/andreas.php?module=cms&amp;action=notes' target='andreas'>Read on &raquo;</a></p>";			

		echo $notes;
	}

	protected function getLatestNotes($personal)
	{
		$personalConstraint = $personal ? ("WHERE note.user_id = " . $GLOBALS['User']->getId()) : "";

		return $GLOBALS['DB']->getRows("
			SELECT
				note.id as note_id, note.created_timestamp, note.last_changed_timestamp, note.content, note.page_id,
				user.id as user_id, user.fullname,
				page.title
			FROM note
			INNER JOIN user ON user.id = note.user_id
			INNER JOIN page ON page.id = note.page_id
			$personalConstraint
			ORDER BY created_timestamp DESC
			LIMIT 100
		");
	}

	public function clean($string)
	{
		return strip_tags($string, '<a><p><i><b><br><br/><img><font>');
	}

	public function createLastChangedXMLFeed()
	{
		$xml = '<?xml version="1.0" encoding="iso-8859-1"?>
			<feed xmlns="http://www.w3.org/2005/Atom">
			<title type="text">Dossier Andreas - notes</title>
			<link href="http://www.dossier-andreas.net/" rel="alternate" title="Dossier Andreas" type="text/html"/>
			<author><name>Patrick van Bergen</name></author>';

		foreach ($this->getLatestNotes(false) as $row) {
			$created = date("c", $row['created_timestamp']);
			$modified = date("c", $row['last_changed_timestamp']);
			$title = htmlspecialchars($row['fullname'] . ' on ' . $row['title']);
			$content = htmlspecialchars($row['content']);
			$xml .= "
			<entry>
			    <id>tag:dossier-andreas.net/note/$row[note_id]</id>
			    <created>$created</created>
				<modified>$modified</modified>
				<title type='text'>$title</title>
				<content type='html' xml:space='preserve'>
					$content
				</content>
				<link href='http://www.dossier-andreas.net/' rel='alternate' type='text/html' />
			</entry>";
		}

		$xml .= '</feed>';

		$file = dirname(__FILE__) . '/../_andreas_notes.xml';
		file_put_contents($file, $xml);
	}
}

$GLOBALS['CMS'] = new CMS();
