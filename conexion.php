<?php

class Conexion extends PDO
{
    private $hostDB = 'localhost';
    private $nameDB = 'hospital';
    private $userDB = 'root';
    private $passDB = 'Ortuno1!*';

    public function __construct()
    {
        try {
            parent::__construct('mysql:host=' . $this->hostDB . ';dbname=' . $this->nameDB, $this->userDB, $this->passDB, array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
        } catch (PDOException $e) {
            echo 'Error: ' . $e->getMessage();
            exit();
        }
    }
}

?>
