<?php

class DB
{
	public function __construct($host, $dbname, $username, $password)
	{
        $result = mysql_connect($host, $username, $password);
        if (!$result) {
			die('Cannot connect to MySQL');
        }
        $result = mysql_select_db($dbname);
        if (!$result) {
			die('Cannot select database');
        }
        if (!$this->tableExists("registration")) {
			$this->query("
			    CREATE TABLE IF NOT EXISTS registration (
					id INT NOT NULL auto_increment,
					code VARCHAR(255) NOT NULL,
					start_timestamp INT,
					email VARCHAR(255),
					password VARCHAR(255),
					fullname VARCHAR(255),
					PRIMARY KEY (id)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
			");
        }
        if (!$this->tableExists("user")) {
			$this->query("
			    CREATE TABLE IF NOT EXISTS user (
					id INT NOT NULL auto_increment,
					email VARCHAR(255),
					fullname VARCHAR(255),
					password VARCHAR(255),
					PRIMARY KEY (id)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
			");
        }
        if (!$this->tableExists("note")) {
			$this->query("
			    CREATE TABLE IF NOT EXISTS note (
					id INT NOT NULL auto_increment,
					user_id INT NOT NULL,
					page_id varchar(255) NOT NULL,
					created_timestamp INT NOT NULL,
					last_changed_timestamp INT NOT NULL,
					content text,
					PRIMARY KEY (id)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
			");
        }
		if (!$this->tableExists("page")) {
			$this->query("
			    CREATE TABLE IF NOT EXISTS page (
					id varchar(255) NOT NULL,
					title varchar(1024) NOT NULL,
					PRIMARY KEY (id)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
			");
//			$this->fillGuestbook();
        }
	}

/*	private function fillGuestbook()
	{
		$messages = $this->readMessages();
		foreach ($messages as $message) {
			$name = $message['name'];
			$date = strtotime($message['date']);
			$content = $message['message'];

			$userId = $this->getCell("SELECT id FROM user WHERE fullname = '" . DB::escape($name) . "'");
			if (!$userId) {
				$this->query("INSERT INTO user VALUES (0, '', '" . DB::escape($name) . "', '')");
				$userId = $this->getCell("SELECT latest_insert_id()");
			}
			$dbContent = DB::escape($content);
			$this->query("INSERT INTO note VALUES (0, $userId, 'art_guestbook', $date, $date, '$dbContent')");
		}
	}

function readMessages()
{
	$lines = file(dirname(__FILE__) . '/../../cgi-bin/wall.txt', FILE_IGNORE_NEW_LINES);
	$entries = array();

	foreach ($lines as $line) {
		switch ($line) {
			case '@>NAME':
				$attribute = 'name';
				if (!empty($entry)) {
					// add previous message to the list of messages
					$entries[] = $entry;
				}
				$entry = array();
				break;
			case '@>DATE':
				$attribute = 'date';
				break;
			case '@>IP':
				$attribute = 'ip';
				break;
			case '@>MESSAGE':
				$attribute = 'message';
				break;
			case '@>END_MESSAGE':
				$attribute = 'message';
				break;
			default:
				if (isset($entry)) {
					if (empty($entry[$attribute])) {
						$entry[$attribute] = $line;
					} else {
						$entry[$attribute] .= "\n" . $line;
					}
				}
			break;
		}
	}

	// add the last message
	if (!empty($entry)) {
		$entries[] = $entry;
	}

	return $entries;
}*/

	public static function escape($string)
	{
		return mysql_real_escape_string($string);
	}

	public function tableExists($tableName)
	{
        return count($this->getColumn("SHOW TABLES LIKE '$tableName'")) > 0;
	}

	public function query($query)
	{
		$connectionQuery = $GLOBALS['Connection_UTF8'] ? utf8_encode($query) : $query;
		return mysql_query($connectionQuery);
	}

	public function getColumn($query)
	{
		$column = array();
		$result = $this->query($query);
		while ($row = mysql_fetch_array($result)) {
			$cell = $GLOBALS['Connection_UTF8'] ? utf8_decode($row[0]) : $row[0];
			$column[] = $cell;
		}
		mysql_free_result($result);
		return $column;
	}

	public function getCell($query)
	{
		$column = $this->getColumn($query);
		if (count($column) == 0) {
			return false;
		} else {
			return $column[0];
		}
	}

	public function getRows($query)
	{
		$rows = array();
		$result = $this->query($query);
		while ($row = mysql_fetch_assoc($result)) {
			$convertedRow = $row;
			foreach ($convertedRow as $key => &$value) {
                $value = $GLOBALS['Connection_UTF8'] ? utf8_decode($value) : $value;
			}
			$rows[] = $convertedRow;
		}
		mysql_free_result($result);
		return $rows;
	}

	public function getHashtable($query)
	{
		$rows = $this->getRows($query);
		return reset($rows);
	}
}
