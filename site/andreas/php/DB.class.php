<?php

class DB
{
    private $link;

	public function __construct($host, $dbname, $username, $password)
	{
        $this->link = mysqli_connect($host, $username, $password, $dbname);
        if (!$this->link) {
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
        }
	}

	public function escape($string)
	{
		return mysqli_real_escape_string($this->link, $string);
	}

	public function tableExists($tableName)
	{
        return count($this->getColumn("SHOW TABLES LIKE '$tableName'")) > 0;
	}

	public function query($query)
	{
		$connectionQuery = $GLOBALS['Connection_UTF8'] ? utf8_encode($query) : $query;
		return mysqli_query($this->link, $connectionQuery);
	}

	public function getColumn($query)
	{
		$column = array();
        $stmt = mysqli_prepare($this->link, $query);
        mysqli_stmt_execute($stmt);
		while ($row = mysqli_stmt_fetch($stmt)) {
			$cell = $GLOBALS['Connection_UTF8'] ? utf8_decode($row[0]) : $row[0];
			$column[] = $cell;
		}
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
		while ($row = mysqli_fetch_assoc($result)) {
			$convertedRow = $row;
			foreach ($convertedRow as $key => &$value) {
                $value = $GLOBALS['Connection_UTF8'] ? utf8_decode($value) : $value;
			}
			$rows[] = $convertedRow;
		}
		mysqli_free_result($result);
		return $rows;
	}

	public function getHashtable($query)
	{
		$rows = $this->getRows($query);
		return reset($rows);
	}
}
