<?php
if (!$initialized) die();

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$content = isset($_REQUEST['content']) ? $_REQUEST['content'] : null;
$pageId = isset($_REQUEST['page_id']) ? $_REQUEST['page_id'] : null;
$noteId = isset($_REQUEST['note_id']) ? (int)$_REQUEST['note_id'] : null;
$submit = isset($_REQUEST['submit']) ? $_REQUEST['submit'] : null;

switch ($action) {
	case 'add':
	    if (!$User->isLoggedIn()) {
			$Output->error("You cannot add a note, because you are not logged in.");
	    } else {
			$now = time();
			$query = sprintf("INSERT INTO note VALUES (0, %s, '%s', %s, %s, '%s')",
					$User->getId(), $GLOBALS['DB']->escape($pageId), $now, $now, $GLOBALS['DB']->escape($content));
			$DB->query($query);
			$CMS->createLastChangedXMLFeed();
	    }
	    gotoPage($pageId, 'yournote');
		break;

	case 'edit':
		if (!$User->isLoggedIn()) {
			$Output->error("You cannot edit a note, because you are not logged in.");
	    } else {
			if ($submit) {
				$content = $GLOBALS['DB']->escape($content);
				$userId = $User->getId();
				$now = time();
				// the "user_id" clause ensures that a person may only edit his own notes
				$DB->query("
				    UPDATE note SET content = '$content', last_changed_timestamp = $now WHERE id = $noteId AND user_id = $userId
				");
				$CMS->createLastChangedXMLFeed();
				$pageId = $DB->getCell("SELECT page_id FROM note WHERE id = $noteId");
				gotoPage($pageId, "note_$noteId");
			} else {
                $CMS->showNoteEditForm($noteId);
			}
	    }
		break;

	case 'notes':
	case 'my_notes':
		$CMS->showLatestNotes($action == 'my_notes');
	    break;

}
