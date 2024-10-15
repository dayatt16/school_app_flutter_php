<?php

// // Konfigurasi Database
// define('DB_HOST', 'localhost');
// define('DB_USER', 'root');
// define('DB_PASS', '');
// define('DB_NAME', 'db_school');


// // Konfigurasi Database
define('DB_HOST', 'localhost');
define('DB_USER', 'praktikum_Ojan');
define('DB_PASS', 'daytt123*363#');
define('DB_NAME', 'praktikum_ti_2022_KLPK_Ojan');


function getConnection(){
    $conn =new mysqli(DB_HOST,DB_USER,DB_PASS,DB_NAME);

      if ($conn->connect_error) {
        die("Koneksi database gagal: " . $conn->connect_error);
    }
    return $conn;
}

?>